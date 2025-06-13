`default_nettype none

// endereços dos periféricos

`define PERIPH_1_ADDR           4'h0       // bidirectional port
`define PERIPH_2_ADDR           4'h1       // timer
`define PERIPH_3_ADDR           4'h2       // interrupt controller
`define PERIPH_4_ADDR           4'h3       // uart tx
`define PERIPH_5_ADDR           4'h4       // dma uart tx

// endereços dos registradores da porta de E/S
`define PORT_ENABLE_ADDR        4'h0
`define PORT_CONFIG_ADDR        4'h1
`define PORT_DATA_ADDR          4'h2
`define PORT_INTERRUPT_ADDR     4'h3

// endereço dos registradores do controlador de interrupções
`define IRQ_ID_ADDR             2'b00
`define MASK_ADDR               2'b01
`define INT_ACK_ADDR            2'b10

// endereço dos registradores da uart tx
//`define UART_TX_DATA_ADDR       2'b00
//`define UART_TX_STATUS_ADDR     2'b01

module peripheral_controller (
    input wire clk,
    input wire rst,
	input wire [3:0] periph_address,
	input wire [3:0] reg_address,
	input wire rw,
	input wire ce,
	input wire [31:0] data_in,
	input wire uart_data_av,
	output wire uart_ready,
	output reg [31:0] data_out,
	output wire intr,
	output wire [31:0] portio_bus,
	output wire uart_tx
);

    // sinais de controle dos periféricos
   	wire [31:0] data_periph;
    reg [15:0] ce_out;
	reg [15:0] rw_out;
	wire [31:0] data_to_periph;
	wire [31:0] data_from_periph;
	wire [7:0] irq;

	// sinais intermediários
	wire peripheral_path;

	assign peripheral_path 	= ce;

	assign data_periph =        (peripheral_path && rw && ce) ? data_in :
							    32'bz;
	assign data_from_periph =   (peripheral_path && ~rw && ce) ? data_periph :
	                            32'bz;

	always @* begin
		ce_out = 16'b0;
		rw_out = 16'b0;
		data_out = 32'bz;

		if (peripheral_path && ce) begin
			case (periph_address)
				`PERIPH_1_ADDR: begin
					ce_out = 16'b0000_0000_0000_0001;
					rw_out = (rw) ? 16'b0000_0000_0000_0001 : 16'b0;
					if (!rw)
						data_out = data_from_periph;
				end
				`PERIPH_2_ADDR: begin
					ce_out = 16'b0000_0000_0000_0010;
					rw_out = (rw) ? 16'b0000_0000_0000_0010 : 16'b0;
					if (!rw)
						data_out = data_from_periph;
				end
				`PERIPH_3_ADDR: begin
					ce_out = 16'b0000_0000_0000_0100;
					rw_out = (rw) ? 16'b0000_0000_0000_0100 : 16'b0;
					if (!rw)
						data_out = {24'b0, data_from_periph[7:0]};
				end
				`PERIPH_4_ADDR : begin
					ce_out = 16'b0000_0000_0000_1000;
					rw_out = (rw) ? 16'b0000_0000_0000_1000 : 16'b0;
                  	if (!rw)
					    data_out = {31'b0, uart_ready};
				end
				`PERIPH_5_ADDR : begin
				    ce_out = 16'b0000_0000_0001_0000;
				end
				default: begin
				end
			endcase
		end
	end

 BidirectionalPort #(
        .DATA_WIDTH(32),
        .PORT_DATA_ADDR(`PORT_DATA_ADDR),
        .PORT_CONFIG_ADDR(`PORT_CONFIG_ADDR),
        .PORT_ENABLE_ADDR(`PORT_ENABLE_ADDR),
        .PORT_INTERRUPT_ADDR(`PORT_INTERRUPT_ADDR)
    ) port_io_instance (
        .clk      (clk),
        .rst      (rst),
        .data     (data_periph),
        .address  (reg_address),
        .rw       (rw_out[0]),
        .ce       (ce_out[0]),
        .irq      (irq[7:4]),
        .port_io  (portio_bus)
    );

    Timer #(
        .DATA_WIDTH(32)
    ) timer_instance (
        .clk      (clk),
        .rst      (rst),
        .data     (data_periph),
        .rw       (rw_out[1]),
        .ce       (ce_out[1]),
        .time_out (irq[0])
    );

    InterruptController #(
        .IRQ_ID_ADDR   (`IRQ_ID_ADDR),
        .MASK_ADDR     (`MASK_ADDR),
        .INT_ACK_ADDR  (`INT_ACK_ADDR)
    ) PIC (
        .clk    (clk),
        .rst    (rst),
        .data   (data_periph[7:0]),
        .address(reg_address[1:0]),
        .rw     (rw_out[2]),
        .ce     (ce_out[2]),
        .intr   (intr),
        .irq    (irq)
    );

    UART_TX #(
        .RATE_FREQ_BAUD(434) // 50MHz clock, 115200 bps
    ) uart_tx_instance (
        .clk      (clk),
        .rst      (rst),
        .tx       (uart_tx),
        .data_in  (data_in[7:0]),
        .data_av  (uart_data_av),
        .ready    (uart_ready)
    );


endmodule
