library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MIPS_uC is
    port(
        rst     : in std_logic;
        clk     : in std_logic;
        port_io : inout std_logic_vector (15 downto 0);
        Led    :  inout std_logic_vector (7 downto 0)
    );
end MIPS_uC;

architecture structural of MIPS_uC is

    -- Sinais do testbench
    signal sys_clk, rst_sync : std_logic;
    signal ce, sys_clk_n: std_logic;
    signal ce_mem, ce_io: std_logic;
    signal wbe: std_logic_vector(3 downto 0);
    signal instructionAddress, dataAddress, instruction, data_in, data_out: std_logic_vector(31 downto 0);
    signal data_mem_out, data_io_out: std_logic_vector(31 downto 0);

    signal ce_data_mem : std_logic;
    signal rw_decoder : std_logic;
    signal ce_decoder : std_logic;
    signal data_timer : std_logic_vector(31 downto 0);
    signal data_portio : std_logic_vector(15 downto 0);
    signal data_leds : std_logic_vector(7 downto 0);
    signal data_decoder : std_logic_vector(3 downto 0);
    signal data_in_periph : std_logic_vector(31 downto 0);
    signal data_in_mips : std_logic_vector(31 downto 0);
	 
	 signal wire_led : std_logic_vector(7 downto 0);

    -- interface do decoder
    signal ack : std_logic;
    signal irq_dec : std_logic;
    signal ce_out : std_logic_vector(3 downto 0);
    signal irq_source : std_logic_vector(3 downto 0);
    signal rw_out : std_logic_vector(3 downto 0);

    constant MARS_INSTRUCTION_OFFSET : UNSIGNED(31 downto 0) := x"00400000";
    constant MARS_DATA_OFFSET        : UNSIGNED(31 downto 0) := x"10010000";
    constant IO_OFFSET               : UNSIGNED(31 downto 0) := x"00000000";

    -- Parâmetros para o BidirectionalPort
    constant DATA_WIDTH : integer := 32;  
    constant PORT_DATA_ADDR : std_logic_vector(1 downto 0) := "00";  
    constant PORT_CONFIG_ADDR : std_logic_vector(1 downto 0) := "01";  
    constant PORT_ENABLE_ADDR : std_logic_vector(1 downto 0) := "10";  
    constant PORT_INTERRUPT_ADDR : std_logic_vector(1 downto 0) := "11";  
	 
	 -- saida 7 segmentos
	 signal portio_bus : std_logic_vector (15 downto 0);

begin

    -- sinais intermediários
    ce_data_mem <= not dataAddress(31) and ce;
    -- rw_decoder <= or wbe;
    rw_decoder <= '1' when unsigned(wbe) /= to_unsigned(0, wbe'length) else '0'; 
    ce_decoder <= ce and dataAddress(31);
    data_in_periph <= (31 downto 4 => '0') & data_decoder when ce = '1' else
                        (31 downto 16 => '0') & data_portio;
    data_in_mips <= data_in_periph when dataAddress(31) = '1' else data_mem_out;
    data_timer <= data_out when rw_out(1) = '1' else (others => 'Z');
    sys_clk_n <= not sys_clk;
    data_leds <= data_out(7 downto 0);
	Led <= wire_led;
	portio_bus <= port_io;
	 

    CLK_MGR: entity work.ClockManager
    port map (
        clk_100MHz => clk,
        clk_25MHz => sys_clk
    );

    RST_S: entity work.ResetSynchonizer
    port map (
        clk => sys_clk,
        rst_in => rst,
        rst_out => rst_sync
    );

    -- Instância do MIPS monocycle
    MIPS_MONOCYCLE: entity work.MIPS_monocycle(behavioral) 
        generic map (
            PC_START_ADDRESS => MARS_INSTRUCTION_OFFSET
        )
        port map (
            clk                 => sys_clk,
            rst                 => rst_sync,
            intr                => irq_dec,  -- Interrupção controlada
            instructionAddress  => instructionAddress,    
            instruction         => instruction,        
            dataAddress         => dataAddress,
            data_in             => data_in_mips,
            data_out            => data_out,
            ce                  => ce,
            wbe                 => wbe,
				ack						=> ack
        );

    -- Instância da memória de instrução
    INSTRUCTION_MEMORY: entity work.Memory(behavioral)
        generic map (
            SIZE            => 1024,
            ADDR_WIDTH      => 30,
            COL_WIDTH       => 8,
            NB_COL          => 4,
            OFFSET          => MARS_INSTRUCTION_OFFSET,
            imageFileName   => "code.txt"
        )
        port map (
            clk         => sys_clk,
            ce          => '1',
            wbe         => "0000",
            address     => instructionAddress(31 downto 2),
            data_in     => (others=>'0'),
            data_out    => instruction
        );

    -- Instância da memória de dados
    DATA_MEMORY: entity work.Memory(behavioral)
        generic map (
            SIZE            => 1024,
            ADDR_WIDTH      => 30,
            COL_WIDTH       => 8,
            NB_COL          => 4,
            OFFSET          => MARS_DATA_OFFSET,
            imageFileName   => "data.txt"
        )
        port map (
            clk         => sys_clk_n,
            wbe         => wbe,
            ce          => ce_data_mem,
            address     => dataAddress(31 downto 2),
            data_in     => data_out,
            data_out    => data_mem_out
        );

    -- Instância do BidirectionalPort
    IO_DEVICE: entity work.BidirectionalPort
    generic map (
        DATA_WIDTH         => 16,
        PORT_DATA_ADDR     => PORT_DATA_ADDR,
        PORT_CONFIG_ADDR   => PORT_CONFIG_ADDR,
        PORT_ENABLE_ADDR   => PORT_ENABLE_ADDR,
        PORT_INTERRUPT_ADDR => PORT_INTERRUPT_ADDR
    )
    port map (
        clk             => sys_clk_n,
        rst             => rst_sync,
        data_in         => data_out(15 downto 0),
        data_out        => data_portio,
        address         => dataAddress(5 downto 4),
        rw              => rw_out(0),
        ce              => ce_out(0),
        irq             => irq_source(0),   
        port_io         => port_io
    );

    IO_DEVICE_LEDS : entity work.BidirectionalPort
    generic map (
        DATA_WIDTH => 8,
        PORT_DATA_ADDR     => PORT_DATA_ADDR,
        PORT_CONFIG_ADDR   => PORT_CONFIG_ADDR,
        PORT_ENABLE_ADDR   => PORT_ENABLE_ADDR,
        PORT_INTERRUPT_ADDR => PORT_INTERRUPT_ADDR
    )
    port map (
    clk             => sys_clk_n,
    rst             => rst_sync,
    data_in         => data_leds,
    --data_out        => data_portio,
    address         => dataAddress(5 downto 4),
    rw              => rw_out(2),
    ce              => ce_out(2),
    irq             => irq_source(2),   
    port_io         => wire_led
    );

    DECODIFICADOR: entity work.Decoder
    generic map (
        DATA_WIDTH => 16,
        DATA_WIDTH_MIPS => 32
    )
    port map (
        clk => sys_clk_n,
        rst => rst_sync,
        address => dataAddress(11 downto 8),
        data_out => data_decoder,
        rw => rw_decoder,
        ce => ce_decoder,
        ce_out => ce_out,
        rw_out => rw_out,
        irq => irq_dec,
        irq_source => irq_source,
        ack => ack
    );

    TIMER: entity work.Timer
    generic map (
        DATA_WIDTH => 32
    )
    port map (
        clk => sys_clk_n,
        rst => rst_sync,
        data => data_timer,
        rw => rw_out(1),
        ce => ce_out(1),
        time_out => irq_source(1)
    );
	 
	irq_source(3) <= '0';

end structural;
