`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:29:36 04/22/2025 
// Design Name: 
// Module Name:    mips_uC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mips_uC(
	input clk, rst,
	output [15:0] port_io
);

	localparam [31:0] MARS_INSTRUCTION_OFFSET = 32'h00400000;
	localparam [31:0] MARS_DATA_OFFSET = 32'h10010000;

	wire ce_data, ce_regdisp, rst_out, sys_clk, ce_MIPS, rst_n;
	wire [31:0] data_address, instruction_address, instruction, data_in, data_out;
	wire [15:0] q;
	wire [3:0] wbe_MIPS;
	wire [15:0] port_io;

	assign ce_data = ce_MIPS && ~data_address[31];
	assign ce_port_io = data_address[31] && (|wbe_MIPS) && ce_MIPS && data_address[11:8] == 4'b0000; 

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
	
	// I/O port
	BidirectionalPort #(
		.DATA_WIDTH(16),
		.PORT_DATA_ADDR(0'b0010),
		.PORT_CONFIG_ADDR(0'b0001),
		.PORT_ENABLE_ADDR(0'b0000)
	) PORT_IO (
		.clk(sys_clk),
        .rst(rst_out),
        // Processor interface
        .data_in(data_out),
        .data_out(data_in),
        .address(data_address[7:4]),
        .rw(instruction[29]),
        .ce(ce_port_io),
        // External interface
        .port_io(port_io)
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