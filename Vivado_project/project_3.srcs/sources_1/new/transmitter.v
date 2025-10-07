`timescale 1ns / 1ps

module transmitter #(
    parameter integer CLKS_PER_BIT = 1736
) (
    input  wire       i_Clock,
    input  wire       i_Rst_n,
    input  wire       i_Tx_DV,
    input  wire [7:0] i_Tx_Byte,
    output reg        o_Tx_Active,
    output reg        o_Tx_Serial,
    output reg        o_Tx_Done
);

  // State encoding
  localparam [2:0]
    S_IDLE          = 3'b000,
    S_TX_START_BIT  = 3'b001,
    S_TX_DATA_BITS  = 3'b010,
    S_TX_STOP_BIT   = 3'b011,
    S_CLEANUP       = 3'b100;

  reg [2:0]  state;
  reg [15:0] r_Clock_Count;
  reg [2:0]  r_Bit_Index;
  reg [7:0]  r_Tx_Data;

  // Main FSM
  always @(posedge i_Clock) begin
    if (!i_Rst_n) begin
      o_Tx_Serial   <= 1'b1;
      o_Tx_Active   <= 1'b0;
      o_Tx_Done     <= 1'b0;
      state         <= S_IDLE;
      r_Clock_Count <= 0;
      r_Bit_Index   <= 0;
    end else begin
      case (state)
        S_IDLE: begin
          o_Tx_Serial   <= 1'b1;
          o_Tx_Done     <= 1'b0;
          r_Clock_Count <= 0;
          r_Bit_Index   <= 0;
          if (i_Tx_DV) begin
            o_Tx_Active <= 1'b1;
            r_Tx_Data   <= i_Tx_Byte;
            state       <= S_TX_START_BIT;
          end
        end
        S_TX_START_BIT: begin
          o_Tx_Serial <= 1'b0;
          if (r_Clock_Count < CLKS_PER_BIT-1)
            r_Clock_Count <= r_Clock_Count + 1;
          else begin
            r_Clock_Count <= 0;
            state         <= S_TX_DATA_BITS;
          end
        end
        S_TX_DATA_BITS: begin
          o_Tx_Serial <= r_Tx_Data[r_Bit_Index];
          if (r_Clock_Count < CLKS_PER_BIT-1)
            r_Clock_Count <= r_Clock_Count + 1;
          else begin
            r_Clock_Count <= 0;
            if (r_Bit_Index < 7)
              r_Bit_Index <= r_Bit_Index + 1;
            else begin
              r_Bit_Index <= 0;
              state       <= S_TX_STOP_BIT;
            end
          end
        end
        S_TX_STOP_BIT: begin
          o_Tx_Serial <= 1'b1;
          if (r_Clock_Count < CLKS_PER_BIT-1)
            r_Clock_Count <= r_Clock_Count + 1;
          else begin
            o_Tx_Done     <= 1'b1;
            state         <= S_CLEANUP;
            r_Clock_Count <= 0;
            o_Tx_Active   <= 1'b0;
          end
        end
        S_CLEANUP: begin
          state     <= S_IDLE;
          o_Tx_Done <= 1'b1;
        end
      endcase
    end
  end

endmodule