library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decoder is   
    generic (
        DATA_WIDTH       : integer;
        DATA_WIDTH_MIPS  : integer
    );
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        address     : in std_logic_vector(3 downto 0);
        data_out    : out std_logic_vector(3 downto 0);
        rw          : in std_logic; -- Read = 0; Write = 1
        ce          : in std_logic;
        ce_out      : out std_logic_vector(15 downto 0);
        rw_out      : out std_logic_vector(15 downto 0);
        irq         : out std_logic;
        irq_source  : in std_logic_vector(15 downto 0);
        ack         : in std_logic
    );
end Decoder;

architecture Behavioral of Decoder is
    signal handling      : std_logic;
    signal irq_in       : std_logic;
    signal irq_addr     : std_logic_vector(3 downto 0); -- priority encoded address
begin
    -- reducao or
    irq_in <= '1' when irq_source /= "ZZZZZZZZZZZZZZ00" else '0';

    -- Priority encoder: outputs the lowest index set in irq_source
    process(irq_source)
    begin
        if irq_source(0) = '1' then
            irq_addr <= "0000";
        elsif irq_source(1) = '1' then
            irq_addr <= "0001";
        elsif irq_source(2) = '1' then
            irq_addr <= "0010";
        elsif irq_source(3) = '1' then
            irq_addr <= "0011";
        else
            irq_addr <= "1111";
        end if;
    end process;

    process(clk, rst)
    begin
        if rst = '1' then
            irq <= '0';
            handling <= '0';
            ce_out <= (others => '0');
            rw_out <= (others => '0');
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            ce_out <= (others => '0');
            rw_out <= (others => '0');
            data_out <= irq_addr;
            if ce = '1' and address = "1111" then
                rw_out(15) <= '1';
            end if;

            if handling = '0' and irq_in = '0' and ce = '1' then
                case to_integer(unsigned(address)) is
                    when 0 =>
                        ce_out(0) <= '1';
                        rw_out(0) <= rw;
                    when 1 =>
                        ce_out(1) <= '1';
                        rw_out(1) <= rw;
					when 2 =>
                        ce_out(2) <= '1';
                        rw_out(2) <= rw;
                    when 15 =>
                        rw_out(15) <= '1';
                    when others =>
                        null;
                end case;

            elsif irq_in = '1' and ce = '0' and handling = '0' then
                irq <= '1';
                handling <= '1';

            elsif handling = '1' and ack = '1' then
                handling <= '0';
                irq <= '0';
            end if;
        end if;
    end process;
end Behavioral;
