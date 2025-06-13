-------------------------------------------------------------------------
-- Design unit: DMA controller
-- Description: Read data from memory and send to UART
--              - Read words (4 bytes) from memory and send bytes (one-by-one)
--              - Programmed in three steps:
--                  1) Read memory address
--                  2) Number of bytes to send
--                  3) Write address (UART)
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DMA_UART_TX is
    port ( 
        clk, rst        : in std_logic;
        
        -- Programming interface
        ce                  : in std_logic;
        mode                : out std_logic; -- 0: Programming (idle), 1: transfer
        eot                 : out std_logic; -- End of transfer
        proc_mem_data       : in std_logic; -- 1: Processor accessing data memory
        
        -- Data memory interface
        address             : out std_logic_vector(31 downto 0); 
        data_i              : in  std_logic_vector(31 downto 0); -- From memory or processor 
        io                  : out std_logic; -- 0: idle, 1: read or write
        
        -- UART interface
        data_o              : out std_logic_vector(7 downto 0);
        write               : out std_logic;
        ready               : in std_logic
    );
end DMA_UART_TX;

architecture behavioral of DMA_UART_TX is
    type State is (S0, S1, S2, S3, S5, S6);
    signal currentState : State;
    
    signal readAddress, writeAddress : UNSIGNED(31 downto 0);
    signal size: UNSIGNED(31 downto 0); -- Number of bytes to transfer
    signal readData : std_logic_vector(31 downto 0); -- From data memory
begin
    
    -- Address memory or UART
    address <=  STD_LOGIC_VECTOR(writeAddress) when currentState = S5 else 
                STD_LOGIC_VECTOR(readAddress);

    -- Set the byte to send from the read word, according to read address 
    data_o <= readData(31 downto 24) when readAddress(1 downto 0) = "11" else
              readData(23 downto 16) when readAddress(1 downto 0) = "10" else
              readData(15 downto 8) when readAddress(1 downto 0) = "01" else
              readData(7 downto 0);
              
    -- Active when reading from memory or writing to UART
    io <= '1' when currentState = S3 or currentState = S5 else
          '0';
          
    mode <= '0' when currentState = S0 or currentState = S1 or currentState = S2 else
            '1';
            
    eot <= '1' when currentState = S6 and size = 0 else
           '0';
           
    write <= '1' when currentState = S5 else '0';
    
    process(clk, rst)
    begin
        if rst = '1' then
            currentState <= S0;
            
        elsif rising_edge(clk) then
            case currentState is
                -- Wait for the memory read address
                when S0 =>                    
                    if ce = '1' then
                        readAddress <= UNSIGNED(data_i);
                        currentState <= S1;
                    end if;                    
                
                -- Wait for the number of bytes to send
                when S1 =>
                    if ce = '1' then
                        size <= UNSIGNED(data_i);
                        currentState <= S2;
                    end if;
                    
                -- -- Wait for the UART address
                when S2 =>
                    if ce = '1' then
                        writeAddress <= UNSIGNED(data_i);
                        currentState <= S3;
                    end if;
                
                -- Memory read
                when S3 =>
                    if proc_mem_data = '0' then -- Processor is not accessing data memory
                        readData <= data_i;
                        currentState <= S5;
                    end if;
                
                -- Write addressing    
                when S5 =>
                    if ready = '1' then -- Wait until UART is ready to send
                        currentState <= S6;
                        size <= size - 1;
                        readAddress <= readAddress + 1;
                    end if;                                        
                    
                when S6 =>
                    -- Verify if all bytes were sent
                    if size = 0 then
                        currentState <= S0;
                    
                    -- Verify if all bytes from the current word were sent
                    elsif readAddress(1 downto 0) = "00" then
                        currentState <= S3;
                        
                    else
                        currentState <= S5;
                    end if;
                
            end case;
        end if;
    end process;

end behavioral;