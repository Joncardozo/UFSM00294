`default_nettype none

//`define PERIPH_BASE_ADDR        32'h8000_0000
// peripheral addresses
`define PORTIO_ADDR             (`PERIPH_BASE_ADDR + 32'h000)
`define TIMER_ADDR              (`PERIPH_BASE_ADDR + 32'h100)
`define INTR_CTRL_ADDR          (`PERIPH_BASE_ADDR + 32'h200)
`define UART_TX_ADDR            (`PERIPH_BASE_ADDR + 32'h300)
`define DMA_UART_ADDR           (`PERIPH_BASE_ADDR + 32'h400)

// portio reg addresses
`define PORTIO_EN_ADDR          (`PORTIO_ADDR + 32'h00)
`define PORTIO_CFG_ADDR         (`PORTIO_ADDR + 32'h10)
`define PORTIO_DAT_ADDR         (`PORTIO_ADDR + 32'h20)
`define PORTIO_INTR_ADDR        (`PORTIO_ADDR + 32'h30)

// interrupt controller reg addresses
`define INTR_CTRL_ID_ADDR       (`INTR_CTRL_ADDR + 32'h00)
`define INTR_CTRL_MASK_ADDR     (`INTR_CTRL_ADDR + 32'h10)
`define INTR_CTRL_ACK_ADDR      (`INTR_CTRL_ADDR + 32'h20)

// uart tx registers
//`define UART_TX_DATA_ADDR       (`UART_TX_ADDR + 32'h00)
//`define UART_TX_STATUS_ADDR     (`UART_TX_ADDR + 32'h20)

module interconnect_fabric #(
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 32
)(
    // mips interface
    // input wire                      rst,
    // input wire                      clk,
    input wire [DATA_WIDTH-1:0]     mips_data_out,
    input wire [ADDR_WIDTH-1:0]     mips_data_address,
    input wire [3:0]                mips_wbe,
    input wire                      mips_ce,
    output reg [DATA_WIDTH-1:0]    mips_data_in,

    // dma interface
    output reg [DATA_WIDTH-1:0]    dma_data_i,
    input wire [7:0]                dma_data_o,
    output reg                     dma_proc_mem_data,
    output reg                     dma_ce,
    input wire [ADDR_WIDTH-1:0]     dma_address,
    input wire                      dma_io,
    output reg                     dma_ready,
    input wire                      dma_write,
    input wire                      dma_mode,

    // data memory interface
    input wire [DATA_WIDTH-1:0]     mem_data_out,
    output reg [DATA_WIDTH-1:0]    mem_data_in,
    output reg                     mem_ce,
    output reg [ADDR_WIDTH-1:0]    mem_data_address,
    output reg [3:0]               mem_wbe,

    // peripheral controller interface
    input wire[DATA_WIDTH-1:0]      pctrl_data_out,
    output reg[DATA_WIDTH-1:0]     pctrl_data_in,
    output reg[3:0]                pctrl_reg_addr,
    output reg[3:0]                pctrl_periph_addr,
    output reg                     pctrl_ce,
    output reg                     pctrl_rw,
    output reg                     pctrl_uart_data_av,
    input wire                      pctrl_uart_ready
);

    // Bus arbitrer: dma or mips write to/read from data memory
    wire [ADDR_WIDTH-1:0] bus_addr;
    wire [DATA_WIDTH-1:0] bus_data;
    wire                  bus_ce;
    wire                  bus_rw;
    wire                  sel_controller_dma;
    wire                  sel_controller_mips;
    bus_arbitrer bus_arbitrer_instance (
        .mips_ce        (mips_ce),
        .mips_rw        ((|mips_wbe)),
        .dma_io         (dma_io),
        .dma_write      (dma_write),
        .mips_data_out  (mips_data_out),
        .mem_data_out   (mem_data_out),
        .dma_address    (dma_address),
        .mips_data_address (mips_data_address),
        .bus_addr       (bus_addr),
        .bus_data       (bus_data),
        .sel_controller_dma        (sel_controller_dma),
        .sel_controller_mips       (sel_controller_mips)
    );

    // Decoder: address decoding
    wire sel_peripheral_pctrl;
    wire sel_peripheral_mem;
    wire sel_peripheral_dma;
    address_decoder addr_decoder_instance (
        .data_address              (mips_data_address),
        .sel_peripheral_mem        (sel_peripheral_mem),
        .sel_peripheral_pctrl      (sel_peripheral_pctrl),
        .sel_peripheral_dma        (sel_peripheral_dma)
    );

    // Multiplexers: data flow control
	 wire [ADDR_WIDTH-1:0] uart_tx_addr_slice;
		assign uart_tx_addr_slice = `UART_TX_ADDR;
	 wire [DATA_WIDTH-1:0] uart_tx_data_addr_slice;
		assign uart_tx_data_addr_slice= `UART_TX_DATA_ADDR;
    always @* begin
        // mips data control
        mips_data_in =  (sel_peripheral_mem) ? mem_data_out :
                        (sel_peripheral_pctrl) ? pctrl_data_out :
                        (sel_peripheral_dma) ? {31'b0, dma_mode} : 32'b0;

        // data memory control
        mem_data_in = bus_data;
        mem_data_address =  bus_addr;
        mem_ce = (sel_peripheral_mem && (sel_controller_mips || sel_controller_dma)) ? 1'b1 : 1'b0;
        mem_wbe = (sel_controller_mips) ? mips_wbe : 4'b0;

        // dma data control
        dma_data_i = bus_data;
        dma_proc_mem_data = (sel_controller_mips && sel_peripheral_mem) ? 1'b1 : 1'b0;
        dma_ce = (sel_controller_mips && sel_peripheral_dma) ? 1'b1 : 1'b0;
        dma_ready = pctrl_uart_ready;

        // peripheral controller data control
        pctrl_data_in = (sel_controller_mips) ? mips_data_out :
                        (sel_controller_dma) ? dma_data_o : 32'b0;

        pctrl_periph_addr = (sel_controller_mips) ? mips_data_address[11:8] :
                            (sel_controller_dma) ? uart_tx_addr_slice[11:8] : 4'b0;
        pctrl_reg_addr =    (sel_controller_mips) ? mips_data_address[7:4] :
                            (sel_controller_dma) ? uart_tx_data_addr_slice[7:4] : 4'b0;
        pctrl_rw =  (sel_controller_mips) ? (|mips_wbe) :
                    (sel_controller_dma) ? dma_write : 1'b0;
        pctrl_ce =  (sel_peripheral_pctrl && (sel_controller_mips || sel_controller_dma)) ? 1'b1 : 1'b0;
        pctrl_uart_data_av = (sel_controller_mips && pctrl_rw && mips_data_address == `UART_TX_ADDR) ? 1'b1 : 1'b0;
    end


endmodule
