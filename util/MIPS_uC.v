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

    // endereços dos registradores da porta de E/S
    parameter PORT_ENABLE_ADDR         = 4'b0000;
    parameter PORT_CONFIG_ADDR         = 4'b0001;
    parameter PORT_DATA_ADDR           = 4'b0010;
    parameter PORT_INTERRUPT_ADDR      = 4'b0011;
    parameter PORT_COUNTER_ADDR        = 4'b0100;

    // endereço dos registradores do controlador de interrupções
    parameter IRQ_ID_ADDR              = 2'b00;
    parameter MASK_ADDR                = 2'b01;
    parameter INT_ACK_ADDR             = 2'b10;

    // endereço dos periféricos
    parameter PORTIO_ADDR              = 4'b0000;
    parameter TIMER_ADDR               = 4'b0001;
    parameter INTR_CTRL_ADDR           = 4'b0010;
    // parameter UART_TX_ADDR             = 4'b0011;

    // endereço UART (fora do peripheral_controller)
    parameter UART_TX_ADDR             = 32'hFFFF_FF10;
    parameter UART_STATUS_ADDR         = 32'hFFFF_FF14;

    //////////////////////////////////////////////////////////////////////
    // interface wires

    wire [31:0]    data_address;
    wire [31:0]    data_out;
    reg  [31:0]    data_in;
    wire           ce;
    wire [3:0]     wbe;
    wire [31:0]    instruction;
    wire [31:0]    instruction_address;
    wire           intr;

    wire           ce_mem;
    wire [31:0]    data_out_mem;

    wire           rw_ctrl;
    wire [15:0]    rw_out;
    wire [15:0]    ce_out;
    wire [31:0]    data_periph;
    wire [3:0]     address_reg;
    wire [31:0]    data_out_ctrl;

    wire [7:0]     irq;

    wire           sys_clk_n;

    // UART TX interface
    wire [7:0]     uart_tx_data;
    reg            uart_tx_valid_reg;
    wire           uart_tx_ready;

    assign sys_clk_n = ~sys_clk;

    //////////////////////////////////////////////////////////////////////
    // UART data_in e controle
    assign uart_tx_data  = data_out[7:0];
    wire uart_tx_valid = uart_tx_valid_reg;

    // Pulso de 1 ciclo em uart_tx_valid_reg
    always @(*) begin
        if (rst_sync)
            uart_tx_valid_reg <= 1'b0;
        else if (ce && rw_ctrl && data_address == UART_TX_ADDR)
            uart_tx_valid_reg <= 1'b1;
        else
            uart_tx_valid_reg <= 1'b0;
    end

    // Lógica de data_in com prioridade:
    always @(*) begin
        if (data_address == UART_STATUS_ADDR)
            data_in = {31'b0, uart_tx_ready};
        else if (data_address[31])
            data_in = data_out_ctrl;
        else
            data_in = data_out_mem;
    end

    assign rw_ctrl = (|wbe);
    assign ce_mem  = ce && ~data_address[31];

    //////////////////////////////////////////////////////////////////////
    // modules instantiation

    MIPS_monocycle #(
        .PC_START_ADDRESS(MARS_INSTRUCTION_OFFSET)
    ) mips_instance (
        .clk                (sys_clk),
        .rst                (rst_sync),
        .intr               (intr),
        .instructionAddress (instruction_address),
        .instruction        (instruction),
        .dataAddress        (data_address),
        .data_in            (data_in),
        .data_out           (data_out),
        .ce                 (ce),
        .wbe                (wbe)
    );

    Memory #(
        .SIZE(2048), .ADDR_WIDTH(30), .COL_WIDTH(8), .NB_COL(4),
        .OFFSET(MARS_INSTRUCTION_OFFSET), .imageFileName("code.txt")
    ) instruction_memory (
        .data_out  (instruction),
        .address   (instruction_address[31:2]),
        .clk       (sys_clk),
        .ce        (1'b1),
        .wbe       (4'b0000),
        .data_in   (32'b0)
    );

    Memory #(
        .SIZE(8192), .ADDR_WIDTH(30), .COL_WIDTH(8), .NB_COL(4),
        .OFFSET(MARS_DATA_OFFSET), .imageFileName("data.txt")
    ) data_memory (
        .data_out (data_out_mem),
        .address  (data_address[31:2]),
        .clk      (sys_clk_n),
        .ce       (ce_mem),
        .wbe      (wbe),
        .data_in  (data_out)
    );

    peripheral_controller #(
        .PERIPH_1_ADDR (PORTIO_ADDR),
        .PERIPH_2_ADDR (TIMER_ADDR),
        .PERIPH_3_ADDR (INTR_CTRL_ADDR),
        .PERIPH_4_ADDR (UART_TX_ADDR)
    ) peripheral_controller_instance (
        .address          (data_address),
        .rw               (rw_ctrl),
        .ce               (ce),
        .data_from_periph (data_periph),
        .data_from_mips   (data_out),
        .ce_out           (ce_out),
        .rw_out           (rw_out),
        .data_to_periph   (data_periph),
        .data_to_mips     (data_out_ctrl),
        .address_reg      (address_reg)
    );

    BidirectionalPort #(
        .DATA_WIDTH(32),
        .PORT_DATA_ADDR(PORT_DATA_ADDR),
        .PORT_CONFIG_ADDR(PORT_CONFIG_ADDR),
        .PORT_ENABLE_ADDR(PORT_ENABLE_ADDR),
        .PORT_INTERRUPT_ADDR(PORT_INTERRUPT_ADDR),
        .PORT_COUNTER_ADDR(PORT_COUNTER_ADDR)
    ) port_io_instance (
        .clk      (sys_clk_n),
        .rst      (rst_sync),
        .data     (data_periph),
        .address  (address_reg),
        .rw       (rw_out[0]),
        .ce       (ce_out[0]),
        .irq      (irq[7:4]),
        .port_io  (port_io)
    );

    Timer #(
        .DATA_WIDTH(32)
    ) timer_instance (
        .clk      (sys_clk_n),
        .rst      (rst_sync),
        .data     (data_periph),
        .rw       (rw_out[1]),
        .ce       (ce_out[1]),
        .time_out (irq[0])
    );

    InterruptController #(
        .IRQ_ID_ADDR   (IRQ_ID_ADDR),
        .MASK_ADDR     (MASK_ADDR),
        .INT_ACK_ADDR  (INT_ACK_ADDR)
    ) PIC (
        .clk    (sys_clk_n),
        .rst    (rst_sync),
        .data   (data_periph[7:0]),
        .address(address_reg[1:0]),
        .rw     (rw_out[2]),
        .ce     (ce_out[2]),
        .intr   (intr),
        .irq    (irq)
    );

    UART_TX #(
        .RATE_FREQ_BAUD(434) // 50MHz clock, 115200 bps
    ) uart_tx_instance (
        .clk      (sys_clk_n),
        .rst      (rst_sync),
        .tx       (tx),
        .data_in  (uart_tx_data),
        .data_av  (uart_tx_valid),
        .ready    (uart_tx_ready)
    );

endmodule


