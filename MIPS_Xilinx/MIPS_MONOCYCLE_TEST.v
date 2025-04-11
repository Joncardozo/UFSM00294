module MIPS_FPGA_TEST(
	input clk, rst,
	output [3:0] an,
	output [7:0] seg 
);

	localparam [31:0] MARS_INSTRUCTION_OFFSET = 32'h00400000;
   localparam [31:0] MARS_DATA_OFFSET = 32'h10010000;

	wire ce_data, ce_regdisp, rst_out, sys_clk, ce_MIPS, rst_n;
	wire [31:0] data_address, instruction_address, instruction, data_in, data_out;
	wire [15:0] q;
	wire [3:0] wbe_MIPS;
	wire [7:0] disp0_out, disp1_out, disp2_out, disp3_out;

	assign ce_data = ce_MIPS && ~data_address[31];
	assign ce_regdisp = data_address[31] && (|wbe_MIPS) && ce_MIPS; 

	wire sys_clk_n;
	assign sys_clk_n = ~sys_clk;
	
	ResetSynchonizer rst_sync(
		.rst_in(rst),
		.rst_out(rst_out),
		.clk(sys_clk)
	);

	ClockManager clk_mgr(
		.clk_100MHz(clk),
		.clk_25MHz(sys_clk)
	);
	
	RegDisp reg_disp(
		.ce(ce_regdisp),
		.d(data_out[15:0]),
		.q(q), 
		.clk(sys_clk)
	);

	BCD7Seg disp0 (
		.num(q[3:0]),
		.code(disp0_out)
	);

	BCD7Seg disp1 (
		.num(q[7:4]),
		.code(disp1_out)
	);

	BCD7Seg disp2 (
		.num(q[11:8]),
		.code(disp2_out)
	);

	BCD7Seg disp3 (
		.num(q[15:12]),
		.code(disp3_out)
	);

	DisplayCtrl display (
		.clk(sys_clk),
		.rst(rst_out),
		.display0(disp0_out),
		.display1(disp1_out),
		.display2(disp2_out),
		.display3(disp3_out),
		.segments(seg),
		.display_en_n(an)
	);

	MIPS_monocycle #(
		.PC_START_ADDRESS(MARS_INSTRUCTION_OFFSET)
	) PROCESSOR (
		.clk(sys_clk),
		.rst(rst_out),       
		
		// Instruction memory interface   
		.instruction(instruction),
		.instructionAddress(instruction_address), 
		
		// Data memory interface  
		.dataAddress(data_address), 
		.data_in(data_in),
		.data_out(data_out),
		.ce(ce_MIPS),
		.wbe(wbe_MIPS)
	);

	// Instruction memory
	Memory #(
		.SIZE(64),  // Memory depth in words
		.ADDR_WIDTH(30),
		.COL_WIDTH(8),
		.NB_COL(4),
		.OFFSET(MARS_INSTRUCTION_OFFSET),
		.imageFileName("code.txt")        
	) INSTRUCTION_MEMORY (
		.clk(sys_clk),        
		.ce(1'b1),
		.wbe(4'b0000),
		.data_in(),
		.data_out(instruction),
		.address(instruction_address[31:2]) // Converts byte address to word address
	);

	// Data memory operates in clk falling edges 
	// in order to support monocycle execution by MIPS
	Memory #(
		.SIZE(1024),  // Memory depth in words 
		.ADDR_WIDTH(30),
		.COL_WIDTH(8),
		.NB_COL(4),
		.OFFSET(MARS_DATA_OFFSET),
		.imageFileName("data.txt")         
	) DATA_MEMORY (
		.clk(sys_clk_n),        
		.ce(ce),
		.wbe(wbe),
		.data_in(data_out),
		.data_out(data_in),
		.address(data_address[31:2]) // Converts byte address to word address
	);

endmodule