architecture structural of MIPS_monocycle_tb is

    -- Sinais do testbench
    signal clk, intr: std_logic := '0';
    signal rst, ce, clk_n: std_logic;
    signal ce_mem, ce_io: std_logic;
    signal wbe: std_logic_vector(3 downto 0);
    signal instructionAddress, dataAddress, instruction, data_in, data_out: std_logic_vector(31 downto 0);
    signal data_mem_out, data_io_out: std_logic_vector(31 downto 0);
    signal sel_io: std_logic;
	signal irq_from_io : std_logic_vector(31 downto 0);
	signal port_io_int : std_logic_vector(31 downto 0);


    constant MARS_INSTRUCTION_OFFSET : UNSIGNED(31 downto 0) := x"00400000";
    constant MARS_DATA_OFFSET        : UNSIGNED(31 downto 0) := x"10010000";
    constant IO_OFFSET               : UNSIGNED(31 downto 0) := x"FFFF0000";

    -- Parâmetros para o BidirectionalPort
    constant DATA_WIDTH : integer := 32;  
    constant PORT_DATA_ADDR : std_logic_vector(1 downto 0) := "00";  
    constant PORT_CONFIG_ADDR : std_logic_vector(1 downto 0) := "01";  
    constant PORT_ENABLE_ADDR : std_logic_vector(1 downto 0) := "10";  
    constant PORT_INTERRUPT_ADDR : std_logic_vector(1 downto 0) := "11";  

begin

    -- Geração do clock
    clk <= not clk after 5 ns;
    clk_n <= not clk;
    rst <= '1', '0' after 2 ns;

    -- Seleção de I/O
    sel_io <= '1' when unsigned(dataAddress) >= IO_OFFSET else '0';
    ce_mem <= ce and not sel_io;
    ce_io  <= ce and sel_io;

    -- Instância do MIPS monocycle
    MIPS_MONOCYCLE: entity work.MIPS_monocycle(behavioral) 
        generic map (
            PC_START_ADDRESS => MARS_INSTRUCTION_OFFSET
        )
        port map (
            clk                 => clk,
            rst                 => rst,
            intr                => intr,  -- Interrupção controlada
            instructionAddress  => instructionAddress,    
            instruction         => instruction,        
            dataAddress         => dataAddress,
            data_in             => data_in,
            data_out            => data_out,
            ce                  => ce,
            wbe                 => wbe
        );

    -- Instância da memória de instrução
    INSTRUCTION_MEMORY: entity work.Memory(behavioral)
        generic map (
            SIZE            => 135,
            ADDR_WIDTH      => 30,
            COL_WIDTH       => 8,
            NB_COL          => 4,
            OFFSET          => MARS_INSTRUCTION_OFFSET,
            imageFileName   => "code.txt"
        )
        port map (
            clk         => clk,
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
            clk         => clk_n,
            wbe         => wbe,
            ce          => ce_mem,
            address     => dataAddress(31 downto 2),
            data_in     => data_out,
            data_out    => data_mem_out
        );

    -- Instância do BidirectionalPort
    IO_DEVICE: entity work.BidirectionalPort
        generic map (
            DATA_WIDTH         => 32,
            PORT_DATA_ADDR     => PORT_DATA_ADDR,
            PORT_CONFIG_ADDR   => PORT_CONFIG_ADDR,
            PORT_ENABLE_ADDR   => PORT_ENABLE_ADDR,
            PORT_INTERRUPT_ADDR => PORT_INTERRUPT_ADDR
        )
        port map (
            clk             => clk_n,
            rst             => rst,
            data_in         => data_out,
            data_out        => data_io_out,
            address         => dataAddress(3 downto 2),
            rw              => '1',
            ce              => ce_io,
            irq             => irq_from_io,     -- Conectado a um sinal
            port_io         => port_io_int      -- Conectado a um sinal intermediário
        );


    -- Seleção do dado de entrada
    data_in <= data_io_out when sel_io = '1' else data_mem_out;

    -- -- Processo para gerar a interrupção manualmente
    -- interrupt_process: process(clk)
    -- begin
    --     if rising_edge(clk) then
    --         if now >= 748 ns and now < 758 ns then
    --             intr <= '1';
			
    --         elsif now >= 758 ns then
    --             intr <= '0';
    --         end if;
    --     end if;
    -- end process;
    
    intr <= '1' after 750 ns, 
            '0' after 770 ns, 
            '1' after 1267 ns, 
            '0' after 1277 ns, 
            '1' after 2083 ns, 
            '0' after 2093 ns,
            '1' after 2400 ns,
            '0' after 2410 ns;


end structural;
