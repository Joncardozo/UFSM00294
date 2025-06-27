//`default_nettype none

`define PERIPH_BASE_ADDR        32'h80000000
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

// uart register address
`define UART_TX_DATA_ADDR       (`UART_TX_ADDR + 32'h00)
`define UART_TX_STATUS_ADDR     (`UART_TX_ADDR + 32'h10)

// DMA register address
`define DMA_DATA_ADDR           (`DMA_UART_ADDR + 32'h00)
`define DMA_MODE_ADDR           (`DMA_UART_ADDR + 32'h10)
`define DMA_EOT_ADDR            (`DMA_UART_ADDR + 32'h20)

module address_decoder #(
	parameter ADDR_WIDTH	    =	32,
	parameter DATA_WIDTH        =   32
) (
    input wire [ADDR_WIDTH-1:0] mips_data_address,
    input wire                  dma_mode,
    input wire                  mips_ce,
    input wire                  dma_write,
    output reg                  sel_peripheral_mips_to_dma,
    output reg                  sel_peripheral_mips_to_pctrl,
    output reg                  sel_peripheral_mips_to_uart,
    output reg                  sel_peripheral_mips_to_mem,
    output reg                  sel_peripheral_dma_to_mem,
    output reg                  sel_peripheral_dma_to_uart
);

    wire sel_peripheral_path            = mips_data_address[31];
    wire [31:0] uart_slice              = `UART_TX_ADDR;
    wire [31:0] dma_slice               = `DMA_UART_ADDR;

	always @* begin

        sel_peripheral_dma_to_mem = 1'b0;
        sel_peripheral_dma_to_uart = 1'b0;
        sel_peripheral_mips_to_dma = 1'b0;
        sel_peripheral_mips_to_mem = 1'b0;
        sel_peripheral_mips_to_pctrl = 1'b0;
        sel_peripheral_mips_to_uart = 1'b0;

        // slave sel
      if (mips_ce && ~dma_mode) begin
            sel_peripheral_mips_to_dma = (sel_peripheral_path && mips_data_address[11:8] == dma_slice[11:8]);
            sel_peripheral_mips_to_mem = ~sel_peripheral_path;
            sel_peripheral_mips_to_pctrl = sel_peripheral_path && ({mips_data_address[31:8],8'b0} == `TIMER_ADDR || 
                                                                  {mips_data_address[31:8],8'b0} == `PORTIO_ADDR ||
                                                                  {mips_data_address[31:8],8'b0} == `INTR_CTRL_ADDR);
            sel_peripheral_mips_to_uart = (sel_peripheral_path && mips_data_address[11:8] == uart_slice[11:8]);
        end
      else if (mips_ce && dma_mode) begin
            if (~sel_peripheral_path) begin
                sel_peripheral_mips_to_mem = 1'b1;
                sel_peripheral_dma_to_uart = dma_write;
            end
            else begin
                sel_peripheral_mips_to_dma = (mips_data_address[11:8] == dma_slice[11:8]);
                sel_peripheral_mips_to_pctrl = sel_peripheral_path && (mips_data_address == `TIMER_ADDR || 
                                                                  mips_data_address == `PORTIO_ADDR ||
                                                                  mips_data_address == `INTR_CTRL_ADDR);
                sel_peripheral_mips_to_uart = (mips_data_address[11:8] == uart_slice[11:8]);
                sel_peripheral_dma_to_uart = dma_write;
                sel_peripheral_dma_to_mem = ~(mips_data_address[11:8] == uart_slice[11:8]);
            end
        end
      else if (~mips_ce && dma_mode) begin
            sel_peripheral_dma_to_mem = ~dma_write ? 1'b1 : 1'b0;
            sel_peripheral_dma_to_uart = dma_write ? 1'b1 : 1'b0;
        end
    end
endmodule
