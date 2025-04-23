`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:29:57 04/22/2025 
// Design Name: 
// Module Name:    mips_uC_tb 
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
module mips_uC_tb(
	input clk, rst
    );

	mips_uC controlador(
		.clk(clk),
		.rst(rst)
	);


endmodule
