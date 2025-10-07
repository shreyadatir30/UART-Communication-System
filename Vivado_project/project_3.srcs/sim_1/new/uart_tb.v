`timescale 1ns / 1ps

//module uart_tb;

//  //-------------------------------------------------------------------------
//  // Parameters
//  //-------------------------------------------------------------------------
//  parameter CLKS_PER_BIT = 4;     
//  parameter CLK_PERIOD    = 5;   // 10 ns → 100 MHz clock

//  //-------------------------------------------------------------------------
//  // Testbench signals
//  //-------------------------------------------------------------------------
//  reg         clk;
//  //reg         reset;
//  reg         rx_serial;       // drives the top’s i_Rx_Serial
//  wire        tx_serial;       // observes the top’s o_Tx_Serial
//// Internal nets
//  wire        rx_dv;
//  wire [7:0]  rx_byte;
//  wire        tx_dv    = rx_dv;
//  wire [7:0]  tx_byte  = rx_byte;

//  // Instantiate receiver core
//  receiver #(
//    .CLKS_PER_BIT(CLKS_PER_BIT)
//  ) u_rx (
//    .i_Clock    (clk),
//    .i_Rx_Serial(rx_serial),
//    .o_Rx_DV    (rx_dv),
//    .o_Rx_Byte  (rx_byte)
//  );

//  // Instantiate transmitter core
//  transmitter #(
//    .CLKS_PER_BIT(CLKS_PER_BIT)
//  ) u_tx (
//    .i_Clock    (clk),
//    .i_Tx_DV    (tx_dv),
//    .i_Tx_Byte  (tx_byte),
//    .o_Tx_Serial(tx_serial),
//    .o_Tx_Active(),
//    .o_Tx_Done  ()
//  );

//  // Clock generator for CLK (200 MHz)
//  initial begin
//    clk = 0;
//    forever #(CLK_PERIOD/2) clk = ~clk;
//  end


//  //-------------------------------------------------------------------------
//  // Main test sequence
//  //-------------------------------------------------------------------------
//  initial begin
//    // 1) Idle the line high for a while
//    rx_serial = 1'b1;
//    repeat (10) @(posedge clk);

//    // 2) Send a test byte, e.g. 0xA5
//    send_byte(8'hA5); //10100101

//    // 3) Wait a bit to let the TX finish shifting out
//    repeat (CLKS_PER_BIT*12) @(posedge clk);

//    // 4) Send another test byte, e.g. ASCII 'U' (0x55)
//    send_byte(8'h55); //01010101

//    // 5) Wait again
//    repeat (CLKS_PER_BIT*12) @(posedge clk);

//    $display("** Simulation complete **");
//    $finish;
//  end

//  //-------------------------------------------------------------------------
//  // Task: send_byte
//  //
//  // Drives rx_serial low for one start bit, then the 8 data bits (LSB first),
//  // then one stop bit (high).  Each bit is held for exactly CLKS_PER_BIT
//  // clock cycles (because the receiver samples at that rate).
//  //-------------------------------------------------------------------------
//  task send_byte(input [7:0] data);
//    integer i;
//    begin
//      // Start bit (LOW)
//      rx_serial = 1'b0;
//      repeat (CLKS_PER_BIT) @(posedge clk);

//      // Data bits (LSB first)
//      for (i = 0; i < 8; i = i + 1) begin
//        rx_serial = data[i];
//        repeat (CLKS_PER_BIT) @(posedge clk);
//      end

//      // Stop bit (HIGH)
//      rx_serial = 1'b1;
//      repeat (CLKS_PER_BIT) @(posedge clk);

//      // Leave a little idle time before next byte
//      rx_serial = 1'b1;
//      repeat (CLKS_PER_BIT) @(posedge clk);
//    end
//  endtask

//  //-------------------------------------------------------------------------
//  // Optional: Monitor TX waveform transitions to console
//  //-------------------------------------------------------------------------
//  initial begin
//    // Display every time tx_serial changes:
//    $display("   Time(ns) | tx_serial");
//    $monitor("%12t | %b", $time, tx_serial);
//  end

//endmodule

module uart_tb;

  // ───────────────────────────────────────────────
  // Parameters (adjustable)
  // ───────────────────────────────────────────────
  localparam integer CLOCK_FREQ   = 100_000_000;     // 100 MHz
  localparam integer BAUD_RATE    = 115_200;         // 115200 bps

  // Derived constants
  localparam integer CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;           // 868
  localparam real    CLK_PERIOD   = 1_000_000_000.0 / CLOCK_FREQ;     // 10.0 ns

  // Testbench signals
  reg         clk        = 0;
  reg         rst_n      = 0;          // active-low reset
  reg         rx_serial  = 1'b1;       // UART RX line (idle high)
  wire        tx_serial;               // UART TX line from DUT
  
  wire clk_n = ~clk;

  // Instantiate DUT
  uart_top #(
    .CLOCK_FREQ(CLOCK_FREQ),
    .BAUD_RATE (BAUD_RATE)
  ) dut (
    .clk_p       (clk),       // single-ended test clock on clk_p
    .clk_n       (clk_n),          // unused in TB
    .rst_n       (rst_n),
    .i_Rx_Serial (rx_serial),
    .o_Tx_Serial (tx_serial)
  );

  // ───────────────────────────────────────────────
  // Clock generation
  // ───────────────────────────────────────────────
  always #(CLK_PERIOD/2) clk = ~clk;

  // Synchronous reset release
  initial begin
    rst_n = 0;
    repeat (20) @(posedge clk);
    rst_n = 1;
  end

  // ───────────────────────────────────────────────
  // Self-check scoreboard
  // ───────────────────────────────────────────────
  integer pass_cnt = 0, fail_cnt = 0;
  reg [7:0] last_sent;
  wire tx_done = dut.u_tx.o_Tx_Done;

  always @(posedge clk) begin
    if (tx_done) begin
      // compare echoed data
      if (dut.u_tx.r_Tx_Data == last_sent)
        pass_cnt <= pass_cnt + 1;
      else
        fail_cnt <= fail_cnt + 1;
    end
  end

  // ───────────────────────────────────────────────
  // Test procedure
  // ───────────────────────────────────────────────
  initial begin
    // wait for reset release
    wait (rst_n);

    // send two bytes
    send_byte(8'hA5);
    send_byte(8'h55);

    // allow time for echoes
    repeat (CLKS_PER_BIT * 12) @(posedge clk);
    
    repeat(CLKS_PER_BIT*200) @(posedge clk);

    // report results
    $display("PASS = %0d, FAIL = %0d", pass_cnt, fail_cnt);
    if (fail_cnt == 0)
      $display("** TB PASSED **");
    else
      $display("** TB FAILED **");
      

    $stop;
  end

  // ───────────────────────────────────────────────
  // send_byte task: frames a byte LSB-first
  // ───────────────────────────────────────────────
  task send_byte(input [7:0] data);
    integer i;
    begin
      last_sent = data;

      // start bit (0)
      rx_serial = 1'b0;
      repeat (CLKS_PER_BIT) @(posedge clk);

      // data bits
      for (i = 0; i < 8; i = i + 1) begin
        rx_serial = data[i];
        repeat (CLKS_PER_BIT) @(posedge clk);
      end

      // stop bit (1)
      rx_serial = 1'b1;
      repeat (CLKS_PER_BIT) @(posedge clk);

      // idle
      repeat (CLKS_PER_BIT) @(posedge clk);
    end
  endtask

endmodule






