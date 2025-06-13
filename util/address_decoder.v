`default_nettype none

`define PERIPH_BASE_ADDR        32'h80000000
// peripheral addresses
`define PORTIO_ADDR             (`PERIPH_BASE_ADDR + 32'h000)
`define TIMER_ADDR              (`PERIPH_BASE_ADDR + 32'h100)
`define INTR_CTRL_ADDR          (`PERIPH_BASE_ADDR + 32'h200)
`define UART_TX_ADDR            (`PERIPH_BASE_ADDR + 32'h300)
`define DMA_UART_ADDR           (`PERIPH_BASE_ADDR + 32'h400)

// dma register address
`define UART_TX_DATA_ADDR       (`UART_TX_ADDR + 32'h00)
`define UART_TX_STATUS_ADDR     (`UART_TX_ADDR + 32'h20)

module address_decoder #(
	parameter ADDR_WIDTH	=	32,
	parameter DATA_WIDTH = 32
) (
    input wire [ADDR_WIDTH-1:0] data_address,
    output reg                 sel_peripheral_dma,
    output reg                 sel_peripheral_mem,
    output reg                 sel_peripheral_pctrl
);

    wire [31:0] portio_addr_slice = `PORTIO_ADDR;
    wire [31:0] timer_addr_slice = `TIMER_ADDR;
    wire [31:0] intr_ctrl_addr_slice = `INTR_CTRL_ADDR;
    wire [31:0] uart_tx_addr_slice = `UART_TX_ADDR;
    wire [31:0] dma_uart_addr_slice = `DMA_UART_ADDR;

	always @* begin

		sel_peripheral_dma = 1'b0;
		sel_peripheral_mem = 1'b0;
		sel_peripheral_pctrl = 1'b0;

		 case (data_address[11:8])
           dma_uart_addr_slice[11:8]: sel_peripheral_dma = data_address[31] ? 1'b1 : 1'b0;
			  portio_addr_slice[11:8]: sel_peripheral_pctrl = data_address[31] ? 1'b1 : 1'b0;
			  timer_addr_slice[11:8]: sel_peripheral_pctrl = data_address[31] ? 1'b1 : 1'b0;
			  intr_ctrl_addr_slice[11:8]: sel_peripheral_pctrl = data_address[31] ? 1'b1 : 1'b0;
			  uart_tx_addr_slice[11:8]: sel_peripheral_pctrl = data_address[31] ? 1'b1 : 1'b0;
			  default: sel_peripheral_mem = 1'b1;
		 endcase
	end

endmodule
