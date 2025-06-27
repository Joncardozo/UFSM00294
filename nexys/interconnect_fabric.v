//`default_nettype none

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
    output reg [DATA_WIDTH-1:0]     mips_data_in,

    // dma interface
    output reg [DATA_WIDTH-1:0]     dma_data_i,
    input wire [7:0]                dma_data_o,
    output reg                      dma_proc_mem_data,
    output reg                      dma_ce,
    input wire [ADDR_WIDTH-1:0]     dma_address,
    input wire                      dma_io,
    output reg                      dma_ready,
    input wire                      dma_write,
    input wire                      dma_mode,
    input wire                      dma_eot,

    // data memory interface
    input wire [DATA_WIDTH-1:0]     mem_data_out,
    output reg [DATA_WIDTH-1:0]     mem_data_in,
    output reg                      mem_ce,
    output reg [ADDR_WIDTH-1:0]     mem_data_address,
    output reg [3:0]                mem_wbe,

    // peripheral controller interface
    input wire[DATA_WIDTH-1:0]      pctrl_data_out,
    output reg[DATA_WIDTH-1:0]      pctrl_data_in,
    output reg[3:0]                 pctrl_reg_addr,
    output reg[3:0]                 pctrl_periph_addr,
    output reg                      pctrl_ce,
    output reg                      pctrl_rw,

    // uart interface
    output reg[7:0]                 uart_data_in,
    output reg                      uart_data_av,
    input wire                      uart_ready
);

    // Decoder: address decoding, selects read/write receiver
    wire                            sel_peripheral_mips_to_dma;
    wire                            sel_peripheral_mips_to_pctrl;
    wire                            sel_peripheral_mips_to_uart;
    wire                            sel_peripheral_mips_to_mem;
    wire                            sel_peripheral_dma_to_mem;
    wire                            sel_peripheral_dma_to_uart;
    address_decoder addr_decoder_instance (
        .mips_data_address              (mips_data_address),
      .dma_mode                         (dma_mode),
        .dma_write                      (dma_write),
        .mips_ce                        (mips_ce),
        .sel_peripheral_mips_to_dma     (sel_peripheral_mips_to_dma),
        .sel_peripheral_mips_to_pctrl   (sel_peripheral_mips_to_pctrl),
        .sel_peripheral_mips_to_uart    (sel_peripheral_mips_to_uart),
        .sel_peripheral_mips_to_mem     (sel_peripheral_mips_to_mem),
        .sel_peripheral_dma_to_mem      (sel_peripheral_dma_to_mem),
        .sel_peripheral_dma_to_uart     (sel_peripheral_dma_to_uart)
    );

    // Multiplexers: data flow control
    always @* begin
        // mips data control
        mips_data_in =  (sel_peripheral_mips_to_pctrl) ? pctrl_data_out :
                        (sel_peripheral_mips_to_uart) ? {31'b0, uart_ready} :
                        (sel_peripheral_mips_to_dma && mips_data_address == `DMA_MODE_ADDR) ? {31'b0, dma_mode} :
                        (sel_peripheral_mips_to_dma && mips_data_address == `DMA_EOT_ADDR) ? {31'b0, dma_eot} : 
                        mem_data_out;

        // data memory control
        mem_data_in                 = mips_data_out;
        mem_data_address            = (sel_peripheral_mips_to_mem) ? mips_data_address : 
                                    (sel_peripheral_dma_to_mem) ? dma_address :
                                    32'b0;
        mem_ce                      = sel_peripheral_mips_to_mem || sel_peripheral_dma_to_mem;
        mem_wbe                     = (sel_peripheral_mips_to_mem) ? mips_wbe : 4'b0;

        // dma data control
        dma_data_i                  = (sel_peripheral_mips_to_dma) ? mips_data_out : mem_data_out;
        dma_proc_mem_data           = sel_peripheral_mips_to_mem;
        dma_ce                      = sel_peripheral_mips_to_dma && (|mips_wbe);
        dma_ready                   = uart_ready;

        // peripheral controller data control
        pctrl_data_in               = mips_data_out;
        pctrl_periph_addr           = mips_data_address[11:8];
        pctrl_reg_addr              = mips_data_address[7:4];
        pctrl_rw                    = (|mips_wbe);
        pctrl_ce                    = sel_peripheral_mips_to_pctrl;

        //uart data control
        uart_data_av                = (sel_peripheral_dma_to_uart) ? dma_write && uart_ready : 
                                    (sel_peripheral_mips_to_uart) ? (|mips_wbe) : 
                                    1'b0;
        uart_data_in                = (sel_peripheral_mips_to_uart) ? mips_data_out[7:0] : dma_data_o;
    end


endmodule
