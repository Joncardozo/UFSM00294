`default_nettype none

module MIPS_uC(
    input wire          sys_clk,
    input wire          rst_sync,
    inout wire [31:0]   port_io,
    output wire         tx              // Adicionada saída serial TX
);

    //////////////////////////////////////////////////////////////////////
    // parameters
    // offset das memorias

    parameter MARS_INSTRUCTION_OFFSET  = 32'h00000000;
    parameter MARS_DATA_OFFSET         = 32'h00000000;

    // largura de dados e memória
    parameter DATA_WIDTH               = 32;
    parameter ADDR_WIDTH               = 32;

    //////////////////////////////////////////////////////////////////////
    // interface wires
    //
    // mips interface
    wire [DATA_WIDTH-1:0]       mips_data_out;
    wire [ADDR_WIDTH-1:0]       mips_data_address;
    wire [3:0]                  mips_wbe;
    wire                        mips_ce;
    wire [DATA_WIDTH-1:0]       mips_data_in;
    wire [ADDR_WIDTH-1:0]       mips_instruction_address;
    wire [DATA_WIDTH-1:0]       mips_instruction;
    wire                        mips_intr;

    // dma interface
    wire [ADDR_WIDTH-1:0]       dma_data_i;
    wire [DATA_WIDTH-1:0]       dma_data_out;
    wire                        dma_proc_mem_data;
    wire                        dma_ce;

    // data memory interface
    wire [DATA_WIDTH-1:0]       mem_data_out;
    wire [DATA_WIDTH-1:0]       mem_data_in;
    wire                        mem_ce;
    wire [ADDR_WIDTH-1:0]       mem_data_address;
    wire [3:0]                  mem_wbe;

    // peripheral controller interface
    wire [DATA_WIDTH-1:0]       pctrl_data_out;
    wire [DATA_WIDTH-1:0]       pctrl_data_in;
    wire [3:0]                  pctrl_periph_addr;
    wire [3:0]                  pctrl_reg_addr;
    wire                        pctrl_ce;
    wire                        pctrl_rw;

    // falling edge clock
    wire           sys_clk_n;
    assign sys_clk_n = ~sys_clk;

    //////////////////////////////////////////////////////////////////////
    // modules instantiation

    MIPS_monocycle #(
        .PC_START_ADDRESS(MARS_INSTRUCTION_OFFSET)
    ) mips_instance (
        .clk                (sys_clk),
        .rst                (rst_sync),
        .intr               (mips_intr),
        .instructionAddress (mips_instruction_address),
        .instruction        (mips_instruction),
        .dataAddress        (mips_data_address),
        .data_in            (mips_data_in),
        .data_out           (mips_data_out),
        .ce                 (mips_ce),
        .wbe                (mips_wbe)
    );

    Memory #(
        .SIZE(2048), .ADDR_WIDTH(30), .COL_WIDTH(8), .NB_COL(4),
        .OFFSET(MARS_INSTRUCTION_OFFSET), .imageFileName("code.txt")
    ) instruction_memory (
        .data_out  (mips_instruction),
        .address   (mips_instruction_address[31:2]),
        .clk       (sys_clk),
        .ce        (1'b1),
        .wbe       (4'b0000),
        .data_in   (32'b0)
    );

    Memory #(
        .SIZE(8192), .ADDR_WIDTH(30), .COL_WIDTH(8), .NB_COL(4),
        .OFFSET(MARS_DATA_OFFSET), .imageFileName("data.txt")
    ) data_memory (
        .data_out (mem_data_out),
        .address  (mem_data_address[31:2]),
        .clk      (sys_clk_n),
        .ce       (mem_ce),
        .wbe      (mem_wbe),
        .data_in  (mem_data_in)
    );

    interconnect_fabric #(
        .DATA_WIDTH         (32),
        .ADDR_WIDTH         (32)
    ) interconnect_instance (
        //.clk                (sys_clk),
        //.rst                (rst_sync),

        // mips interface
        .mips_data_out      (mips_data_out),
        .mips_data_in       (mips_data_in),
        .mips_data_address  (mips_data_address),
        .mips_wbe           (mips_wbe),
        .mips_ce            (mips_ce),

        // dma interface
        .dma_data_i         (dma_data_i),
        .dma_data_out       (dma_data_out),
        .dma_proc_mem_data  (dma_proc_mem_data),
        .dma_ce             (dma_ce),
        .dma_io             (dma_io),
        .dma_address        (dma_address),
        .dma_ready          (dma_ready),
        .dma_write          (dma_write),
        .dma_mode           (dma_mode),

        // data memory interface
        .mem_data_out       (mem_data_out),
        .mem_data_in        (mem_data_in),
        .mem_ce             (mem_ce),
        .mem_data_address   (mem_data_address),
        .mem_wbe            (mem_wbe),

        // peripheral controller interface
        .pctrl_data_out     (pctrl_data_out),
        .pctrl_data_in      (pctrl_data_in)
        .pctrl_reg_addr     (pctrl_reg_addr),
        .pctrl_periph_addr  (pctrl_periph_addr),
        .pctrl_ce           (pctrl_ce),
        .pctrl_rw           (pctrl_rw)
    );

    peripheral_controller peripheral_controller_instance (
        .clk              (sys_clk_n),
        .rst              (rst_sync),
        .rw               (rw_ctrl),
        .ce               (ce),
        .address          (data_address),
        .address_reg      (address_reg),
        .data_in          (data_out),
        .data_out         (data_out_ctrl),
        .intr             (mips_intr),
        .portio_bus       (port_io),
        .uart_tx          (tx)
    );

    DMA_UART_TX dma_instance (
        .rst        (rst_sync),
        .clk        (sys_clk),
        .ce         (dma_ce),
        .data_i     (dma_data_i),
        .mode       (dma_mode),
        .proc_mem_data  (dma_proc_mem_data),
        .eot        (),
        .address    (dma_address),
        .io         (dma_io),
        .ready      (dma_ready),
        .data_o     (dma_data_out),
        .ready      (dma_ready),
        .write      (dma_write)
    );

endmodule
