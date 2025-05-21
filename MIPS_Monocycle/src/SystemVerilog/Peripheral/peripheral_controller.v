module peripheral_controller #(
	parameter 				PORT_IO_ADDR,
	parameter				PIC_ADDR,
	parameter				TIMER_ADDR,
	parameter				PCTRL_ADDR
) (
	input logic[31:0]	address,
	input logic			rw,
	input logic			ce,
	output logic[3:0]	data_out,
	output logic[15:0]	ce_out,
	output logic[15:0]	rw_out
);

	wire peripheral_path;
	assign peripheral_path 	= address[31];
	assign data_out			= address[11:8];

	always_comb begin
		if (peripheral_path) begin
			ce_out 	=	(address == PORT_IO_ADDR) 	? 16'b0001 :
						(address == TIMER_ADDR) 	? 16'b0010 :
						(address == PIC_ADDR)		? 16'b0100 :
						16'b0000;
			rw_out 	=	(address == PORT_IO_ADDR) 	? 16'b0001 :
						(address == TIMER_ADDR) 	? 16'b0010 :
						(address == PIC_ADDR)		? 16'b0100 :
						16'b0000;
		end else begin
			ce_out	=	16'b0000;
			rw_out	=	16'b0000;
		end
	end


endmodule
