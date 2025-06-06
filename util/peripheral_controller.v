module peripheral_controller #(
	parameter PERIPH_1_ADDR = 4'h0,
	parameter PERIPH_2_ADDR = 4'h1,
	parameter PERIPH_3_ADDR = 4'h2
) (
	input wire [31:0] address,
	input wire rw,
	input wire ce,
	input wire [31:0] data_from_periph,
	input wire [31:0] data_from_mips,
	output reg [15:0] ce_out,
	output reg [15:0] rw_out,
	output wire [31:0] data_to_periph,
	output reg [31:0] data_to_mips,
	output wire [3:0] address_reg
);

	// sinais intermedi\C3\A1rios
	wire peripheral_path;
	wire [3:0] address_wb;

	assign peripheral_path 	= address[31];
	assign address_wb		= address[11:8];
	assign address_reg		= address[7:4];

	assign data_to_periph = (peripheral_path && rw) ? data_from_mips : 32'bz;

	always @(*) begin
		ce_out = 16'b0;
		rw_out = 16'b0;
		data_to_mips = 32'bz;

		if (peripheral_path && ce) begin
			case (address_wb)
				PERIPH_1_ADDR: begin
					ce_out = 16'b0000_0000_0000_0001;
					rw_out = (rw) ? 16'b0000_0000_0000_0001 : 16'b0;
					if (!rw)
						data_to_mips = data_from_periph;
				end
				PERIPH_2_ADDR: begin
					ce_out = 16'b0000_0000_0000_0010;
					rw_out = (rw) ? 16'b0000_0000_0000_0010 : 16'b0;
					if (!rw)
						data_to_mips = data_from_periph;
				end
				PERIPH_3_ADDR: begin
					ce_out = 16'b0000_0000_0000_0100;
					rw_out = (rw) ? 16'b0000_0000_0000_0100 : 16'b0;
					if (!rw)
						data_to_mips = {24'b0, data_from_periph[7:0]};
				end
				default: begin
					// j\C3\A1 est\C3\A1 inicializado com zeros e high-impedance
				end
			endcase
		end
	end

endmodule
