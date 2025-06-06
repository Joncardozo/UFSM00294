`timescale 1ns / 1ps

module MIPS_uC_tb;

  reg rst;
  reg clk;
  wire [31:0] port_io;
  reg [3:0] buttons;

  // UART RX wires
  wire [7:0] rx_data_out;
  wire       rx_data_av;
  wire       tx;           // saída do MIPS_uC
  wire       rx;           // entrada para o UART_RX

  assign rx = tx; // conecta saída do MIPS à entrada do RX

  // instancia microcontrolador
  MIPS_uC uut (
    .rst_sync(rst),
    .sys_clk(clk),
    .port_io(port_io),
    .tx(tx)                // saída conectada para UART RX
  );

  // instancia UART RX
  UART_RX #(
    .RATE_FREQ_BAUD(434)   // para 20MHz e 115200 bps
  ) uart_rx_inst (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .data_out(rx_data_out),
    .data_av(rx_data_av)
  );

	// gera clock
	initial begin
	  clk = 0;
	  forever #10 clk = ~clk; // 50 MHz clock (20ns período)
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
  end

  assign port_io[3:0] = buttons;
  assign port_io[31:4] = 29'bz;

endmodule

