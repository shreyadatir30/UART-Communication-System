`timescale 1ns / 1ps

module uart_top #(
    // System clock freq (Hz) and UART baud rate
    parameter integer CLOCK_FREQ = 100_000_000,
    parameter integer BAUD_RATE  = 115200
) (
    input  wire clk_p,
   // input  wire clk_n,
    input  wire rst_n,
    // UART serial I/O
    input  wire i_Rx_Serial,
    output wire o_Tx_Serial
);

  // Calculating clocks-per-bit
  localparam integer CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

  wire i_Clk = clk_p;
//  IBUFDS #(
//    .DIFF_TERM("TRUE"),
//    .IOSTANDARD("LVDS_25")
//  ) clk_ibuf (
//    .I  (clk_p),
//   // .IB (clk_n),
//    .O  (i_Clk)
//  );

  // Internal nets
  wire        rx_dv;
  wire [7:0]  rx_byte;
  wire        tx_dv   = rx_dv;
  wire [7:0]  tx_byte = ~rx_byte;

  receiver #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
  ) u_rx (
    .i_Clock    (i_Clk),
    .i_Rst_n    (rst_n),
    .i_Rx_Serial(i_Rx_Serial),
    .o_Rx_DV    (rx_dv),
    .o_Rx_Byte  (rx_byte)
  );

  transmitter #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
  ) u_tx (
    .i_Clock    (i_Clk),
    .i_Rst_n    (rst_n),
    .i_Tx_DV    (tx_dv),
    .i_Tx_Byte  (tx_byte),
    .o_Tx_Serial(o_Tx_Serial),
    .o_Tx_Active(),
    .o_Tx_Done  ()
  );

endmodule