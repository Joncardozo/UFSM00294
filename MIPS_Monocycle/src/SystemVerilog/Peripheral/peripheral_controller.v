module peripheral_controller #(
	parameter 				PERIPH_1_ADDR,
	parameter				PERIPH_2_ADDR,
	parameter				PERIPH_3_ADDR
) (
	input wire[31:0]	address,
	input wire			rw,
	input wire			ce,
	input reg[31:0]		data_from_periph,
	input reg[31:0]		data_from_mips,
	output reg[15:0]	ce_out,
	output reg[15:0]	rw_out,
	output reg[31:0]	data_to_periph,
	output reg[31:0]	data_to_mips,
	output wire[3:0]	address_reg
);

	// sinais intermediarios
	wire peripheral_path;
	wire [3:0] address_wb;

	assign peripheral_path 	= address[31];
	assign address_wb		= address[11:8];
	assign address_reg		= address[7:4];

	assign data_to_periph	= (peripheral_path && rw) ? data_from_mips : 32'bz;
	// assign data_to_mips		= (peripheral_path && ~rw) ? data_from_periph : 32'bz;

	always_comb begin
		ce_out = 16'b0;
		rw_out = 16'b0;
		if (peripheral_path && ce) begin
			case (address_wb)
				PERIPH_1_ADDR: begin
					ce_out = 16'b0001;
					rw_out = (rw) ? 16'b0001 : 16'b0;
					data_to_mips		= (peripheral_path && ~rw) ? data_from_periph : 32'bz;
				end
				PERIPH_2_ADDR: begin
					ce_out = 16'b0010;
					rw_out = (rw) ? 16'b0010 : 16'b0;
					data_to_mips		= (peripheral_path && ~rw) ? data_from_periph : 32'bz;
				end
				PERIPH_3_ADDR: begin
					ce_out = 16'b0100;
					rw_out = (rw) ? 16'b0100 : 16'b0;
					data_to_mips		= (peripheral_path && ~rw) ? {24'b0, data_from_periph[7:0]} : 32'bz;
				end
				default: begin
					ce_out = 16'b0;
					rw_out = 16'b0;
				end
			endcase
		end
		else begin
			data_to_mips = 32'bz;
			
		end
	end

endmodule
