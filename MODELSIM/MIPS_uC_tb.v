`timescale 1ns / 1ps


module MIPS_uC_tb;

  reg rst;
  reg clk;
  wire [31:0] port_io;
  reg [2:0] buttons;

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
    buttons = 3'b0;
  end

  assign port_io[2:0] = buttons;
  assign port_io[31:3] = 29'bz;

  // tempo total de simulacao
  initial begin
    #10000;
    $finish;
  end

endmodule
