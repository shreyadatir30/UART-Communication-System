`timescale 1ns / 1ps

module receiver #(
    parameter integer CLKS_PER_BIT = 1736
) (
    input  wire       i_Clock,
    input  wire       i_Rst_n,
    input  wire       i_Rx_Serial,
    output reg        o_Rx_DV,
    output reg [7:0]  o_Rx_Byte
);

  // State encoding
  localparam [2:0]
    S_IDLE          = 3'b000,
    S_RX_START_BIT  = 3'b001,
    S_RX_DATA_BITS  = 3'b010,
    S_RX_STOP_BIT   = 3'b011,
    S_CLEANUP       = 3'b100;

  reg [2:0]  state;
  reg [15:0] r_Clock_Count;
  reg [2:0]  r_Bit_Index;
  reg        r_Rx_Data_R;
  reg        r_Rx_Data;

  // Double-register stage
  always @(posedge i_Clock) begin
    if (!i_Rst_n) begin
      r_Rx_Data_R <= 1'b1;
      r_Rx_Data   <= 1'b1;
    end else begin
      r_Rx_Data_R <= i_Rx_Serial;
      r_Rx_Data   <= r_Rx_Data_R;
    end
  end

  // Main FSM
  always @(posedge i_Clock) begin
    if (!i_Rst_n) begin
      state        <= S_IDLE;
      o_Rx_DV      <= 1'b0;
      o_Rx_Byte    <= 8'd0;
      r_Clock_Count<= 0;
      r_Bit_Index  <= 0;
    end else begin
      case (state)
        S_IDLE: begin
          o_Rx_DV       <= 1'b0;
          r_Clock_Count <= 0;
          r_Bit_Index   <= 0;
          if (r_Rx_Data == 1'b0)
            state <= S_RX_START_BIT;
        end
        S_RX_START_BIT: begin
          if (r_Clock_Count == (CLKS_PER_BIT-1)/2) begin
            if (r_Rx_Data == 1'b0) begin
              r_Clock_Count <= 0;
              state         <= S_RX_DATA_BITS;
            end else
              state <= S_IDLE;
          end else begin
            r_Clock_Count <= r_Clock_Count + 1;
          end
        end
        S_RX_DATA_BITS: begin
          if (r_Clock_Count < CLKS_PER_BIT-1) begin
            r_Clock_Count <= r_Clock_Count + 1;
          end else begin
            r_Clock_Count        <= 0;
            o_Rx_Byte[r_Bit_Index]<= r_Rx_Data;
            if (r_Bit_Index < 7)
              r_Bit_Index <= r_Bit_Index + 1;
            else begin
              r_Bit_Index <= 0;
              state       <= S_RX_STOP_BIT;
            end
          end
        end
        S_RX_STOP_BIT: begin
          if (r_Clock_Count < CLKS_PER_BIT-1) begin
            r_Clock_Count <= r_Clock_Count + 1;
          end else begin
            o_Rx_DV       <= 1'b1;
            r_Clock_Count <= 0;
            state         <= S_CLEANUP;
          end
        end
        S_CLEANUP: begin
          state   <= S_IDLE;
          o_Rx_DV <= 1'b0;
        end
      endcase
    end
  end

endmodule