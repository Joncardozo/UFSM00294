`timescale 1ns / 1ps

module MIPS_uC_tb;

  reg rst;
  reg clk;
  wire [31:0] port_io;
  reg [3:0] buttons;

  // instancia microcontrolador
  MIPS_uC uut (
    .rst_sync(rst),
    .sys_clk(clk),
    .port_io(port_io)
  );

  // gera clock
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // reseta o sistema
  initial begin
    rst = 1;
    #50;
    rst = 0;
  end

  // estimulo de botoes
  initial begin
    buttons = 4'b0000;
    #1000
    buttons = 4'b1000;
    #100
    buttons = 4'b0000;
    #3000
    buttons = 4'b0100;
    #100
    buttons = 4'b0000;
    #3000
    buttons = 4'b0010;
    #100
    buttons = 4'b0000;
    #3000
    buttons = 4'b0001;
    #100
    buttons = 4'b0000;
  end

  assign port_io[3:0] = buttons;
  assign port_io[31:4] = 29'bz;

endmodule
