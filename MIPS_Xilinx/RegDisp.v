module RegDisp (
	input [15:0] d,
	input ce, clk,
	output reg [15:0] q
);

	always @(posedge clk) begin
		if (ce) begin
			q <= d;
		end
	end

endmodule