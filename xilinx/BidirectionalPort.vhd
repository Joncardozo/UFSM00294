library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BidirectionalPort  is
    generic (
        DATA_WIDTH          : integer;    -- Port width in bits
        PORT_DATA_ADDR      : std_logic_vector(3 downto 0);     -- NÃO ALTERAR!
        PORT_CONFIG_ADDR    : std_logic_vector(3 downto 0);     -- NÃO ALTERAR! 
        PORT_ENABLE_ADDR    : std_logic_vector(3 downto 0);     -- NÃO ALTERAR!
		PORT_INTERRUPT_ADDR	: std_logic_vector(3 downto 0);
		PORT_COUNTER_ADDR	: std_logic_vector(3 downto 0)
    );
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        
        -- Processor interface
        address     : in std_logic_vector (3 downto 0);     -- NÃO ALTERAR!
        rw          : in std_logic; -- 0: read; 1: write
        ce          : in std_logic;
		irq			: out std_logic_vector (2 downto 0);
		data		: inout std_logic_vector (DATA_WIDTH-1 downto 0);
        
        -- External interface
        port_io     : inout std_logic_vector (DATA_WIDTH-1 downto 0)
    );
end BidirectionalPort ;


architecture Behavioral of BidirectionalPort  is

	signal data_out     : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal data_in      : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal io_config 	: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal io_enable 	: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal reg_data 	: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal irq_config 	: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal counter		: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal stability_reg_1 : std_logic_vector (DATA_WIDTH-1 downto 0);
	signal stability_reg_2 : std_logic_vector (DATA_WIDTH-1 downto 0);
 
begin

	process(clk, rst)
	begin
		if rst = '1' then
			reg_data  <= (others => '0');
			io_config <= (others => '0');
			io_enable <= (others => '0');
			irq_config <= (others => '0');
			counter   <= (others => '0');
			elsif rising_edge(clk) then
				if ce = '1' then
			  		-- escreve nos registradores
					if rw = '1' then
						if address = PORT_CONFIG_ADDR then
							io_config <= data_in;
						elsif address = PORT_ENABLE_ADDR then
							io_enable <= data_in;
						elsif address = PORT_INTERRUPT_ADDR then
							irq_config <= data_in;
						elsif address = PORT_COUNTER_ADDR then
							counter <= data_in;
						elsif address = PORT_DATA_ADDR then
							  for i in 0 to DATA_WIDTH-1 loop
									if io_enable(i) = '1' and io_config(i) = '0' then
										 reg_data(i) <= data_in(i);
									end if;
							  end loop;
						end if;
					end if;
				else
				-- recebe sinal da porta para registradores de estabilidade e escreve no registrador de dados
				for i in 0 to DATA_WIDTH-1 loop
					if io_enable(i) = '1' and io_config(i) = '1' then
						stability_reg_1(i) <= port_io(i);
						stability_reg_2(i) <= stability_reg_1(i);
						reg_data(i) <= stability_reg_2(i);
					end if;
				end loop;
			end if;
		end if;
	end process;

	-- registrador para porta e porta para registrador
	gen_io: for i in 0 to DATA_WIDTH-1 generate
		port_io(i) <= reg_data(i) when io_enable(i) = '1' and io_config(i) = '0' else 'Z';
	end generate;

	-- registrador data out
	process(address, reg_data, io_config, io_enable, irq_config, counter)
	begin
		if address = PORT_DATA_ADDR then
			data_out <= reg_data;
		elsif address = PORT_CONFIG_ADDR then
			data_out <= io_config;
		elsif address = PORT_ENABLE_ADDR then
			data_out <= io_enable;
		elsif address = PORT_INTERRUPT_ADDR then
			data_out <= irq_config;
		elsif address = PORT_COUNTER_ADDR then
			data_out <= counter;
		else
			data_out <= (others => '0');
		end if;
	end process;

	-- pedido de interrupção para o PIC
	gen_irq: for i in 0 to 2 generate
		irq(i) <= reg_data(i) when irq_config(i) = '1' and io_enable(i) = '1' else '0';
	end generate;

	-- data out para bus do controlador de perifericos
	data <= data_out when ((rw = '0') and (ce = '1')) else (others => 'Z');

	-- data in do controlador de perifericos
	data_in <= data;

end Behavioral;
