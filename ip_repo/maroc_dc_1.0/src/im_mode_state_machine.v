`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2018 02:01:22 PM
// Design Name: 
// Module Name: im_mode_state_machine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module im_mode_state_machine(
    input clk,
    input [15:0] frame_int,
    input frame_reset,
    output first_word,
    output hold,
    output [7:0] word_sel,
    output tvalid,
    output tlast,
    input tready,
    input [9:0] data_count
    );

//A counter to define a frame repetition interval
//If AXI clock is 10ns, count to 99 gives 1us pulse rate
parameter clk_div = 99;
reg [15:0]frame_count1;
reg [15:0]frame_count2;
wire frame_pulse = (frame_count1 == clk_div);
//(*DONT_TOUCH="{true}"*) wire frame_pulse = (frame_count1 == (clk_div-1));
wire frame_go = (frame_count2 == frame_int) && frame_pulse;
     
always @ (posedge clk) begin
        if (frame_reset) begin
            frame_count1 <= 0;
            frame_count2 <= 0;
        end
        else begin
            if (frame_pulse) begin
                frame_count1 <= 0;
                if (frame_go) frame_count2 <= 0;
                else frame_count2 <= frame_count2 + 1;
            end
            else begin
                frame_count1 <= frame_count1 + 1;
            end
        end 
end

//A counter to sequence through the mux channels
reg[7:0] word_count = 0;
wire word_count_rst;
wire word_count_inc;
always @ (posedge clk) begin
    if (word_count_rst) word_count <= 0;
    else if (word_count_inc) word_count <= word_count+1;
end
    //Don't start up the state machine unless there's enough space in the FIFO
    parameter MAX_FIFO_LEVEL_TO_START = 255;
    
   parameter IDLE = 8'b00000001;
   parameter ASSERT_HOLD1 = 8'b00000010;
   parameter ASSERT_HOLD2 = 8'b00000100;
   parameter SEQ_SELECT = 8'b00001000;
   parameter DONE = 8'b00010000;
   parameter WAIT = 8'b00100000;
   parameter SPARE2 = 8'b01000000;
   parameter SPARE3 = 8'b10000000;
   

   reg [7:0] state = IDLE;

   always @(posedge clk)
      if (frame_reset)
         state <= IDLE;
      else
         case (state)
            IDLE : begin
               if (frame_go && (data_count < MAX_FIFO_LEVEL_TO_START))
                  state <= ASSERT_HOLD1;
               else
                  state <= IDLE;
            end
            ASSERT_HOLD1 : begin
                  state <= ASSERT_HOLD2;
            end
            ASSERT_HOLD2 : begin
                 state <= WAIT;
            end
            WAIT: begin
                 state <= SEQ_SELECT;
            end   
            SEQ_SELECT : begin
               if ((word_count == 255) && tready)
                  state <= DONE;
               else
                  state <= WAIT;
            end
            DONE : begin
                  state <= IDLE;
            end
            default : begin  // Fault Recovery
               state <= IDLE;
            end
         endcase

   assign word_count_rst = !((state == SEQ_SELECT) || (state == WAIT));
   assign word_count_inc = tready && (state == SEQ_SELECT);
   assign hold = (state != IDLE);
   assign first_word = (state == SEQ_SELECT) && (word_count == 0);
   assign word_sel = word_count;
   assign tvalid = (state == SEQ_SELECT);
   assign tlast = (state == SEQ_SELECT) && (word_count == 255) && tready;
endmodule
