library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BidirectionalPort  is
    generic (
        DATA_WIDTH          : integer;    -- Port width in bits
        PORT_DATA_ADDR      : std_logic_vector(1 downto 0);     -- NÃO ALTERAR!
        PORT_CONFIG_ADDR    : std_logic_vector(1 downto 0);     -- NÃO ALTERAR! 
        PORT_ENABLE_ADDR    : std_logic_vector(1 downto 0);     -- NÃO ALTERAR!
		PORT_INTERRUPT_ADDR	: std_logic_vector(1 downto 0)
    );
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        
        -- Processor interface
        data_in     : in std_logic_vector (DATA_WIDTH-1 downto 0);
        data_out    : out std_logic_vector (DATA_WIDTH-1 downto 0);
        address     : in std_logic_vector (1 downto 0);     -- NÃO ALTERAR!
        rw          : in std_logic; -- 0: read; 1: write
        ce          : in std_logic;
		  irq			: out std_logic;
        
        -- External interface
        port_io     : inout std_logic_vector (DATA_WIDTH-1 downto 0)
    );
end BidirectionalPort ;


architecture Behavioral of BidirectionalPort  is

	signal io_config 	: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal io_enable 	: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal reg_data 	: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal irq_config 	: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal irq_i		: std_logic_vector (DATA_WIDTH-1 downto 0);
 
begin

	process(clk, rst)
	begin
		 if rst = '1' then
			  reg_data  <= (others => '0');
			  io_config <= (others => '0');
			  io_enable <= (others => '0');
			  irq_config <= (others => '0');
		 elsif falling_edge(clk) then
			  if ce = '1' then
					if rw = '1' then
						if address = PORT_CONFIG_ADDR then
							io_config <= data_in;
						elsif address = PORT_ENABLE_ADDR then
							io_enable <= data_in;
						elsif address = PORT_INTERRUPT_ADDR then
							irq_config <= data_in;
						elsif address = PORT_DATA_ADDR then
							  for i in 0 to DATA_WIDTH-1 loop
									if io_enable(i) = '1' and io_config(i) = '0' then
										 reg_data(i) <= data_in(i);
									end if;
							  end loop;
						end if;
					end if;
				else
						 if address = PORT_DATA_ADDR then
							  for i in 0 to DATA_WIDTH-1 loop
									if io_enable(i) = '1' and io_config(i) = '1' then
										 reg_data(i) <= port_io(i);
									end if;
							  end loop;
						 end if;
			  end if;

		 end if;
	end process;

	-- porta para registrador
	gen_io: for i in 0 to DATA_WIDTH-1 generate
		 port_io(i) <= not reg_data(i) when io_enable(i) = '1' and io_config(i) = '0' else 'Z';
	end generate;

	-- data out para processador
	process(address, reg_data, io_config, io_enable)
	begin
		case address is
			when "00" => data_out <= reg_data;
			when "01" => data_out <= io_config;
			when "10" => data_out <= io_enable;
			when others => data_out <= (others => '0');
		end case;
	end process;

	-- pedido de interrupção para o processador
	gen_irq: for i in 0 to DATA_WIDTH-1 generate
		irq_i(i) <= not reg_data(i) when irq_config(i) = '1' and io_enable(i) = '1' else '0';
	end generate;

	irq <= '1' when unsigned(irq_i) /= to_unsigned(0, irq_i'length) else '0'; 

end Behavioral;
