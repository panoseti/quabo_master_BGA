`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2018 11:21:37 AM
// Design Name: 
// Module Name: ph_state_machine
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


module ph_state_machine(
    input clk,
    input reset,
    input trig,
    input inhibit_write,
    input [6:0] stop_chan,
    input adc_frame,
    input [9:0] fifo_data_count,
    output tvalid,
    output tlast,
    input tready,
    output CK_R,
    output RSTB_R,
    output reg D_R,
    output reset_hold,
    output reset_cc_fifo,
    output write_ET
    );

//Make a pulse from the rising edge of the frame signal
reg adc_frame_d1;
always @ (posedge clk) adc_frame_d1 <= adc_frame;
wire frame_pulse = adc_frame && !adc_frame_d1;

//A counter so we can wait the 6 cycles of latency of the ADC
//reg [3:0] wait_count = 0;
//wire inc_wait_count, rst_wait_count;
//always @ (posedge clk) begin
//    if (rst_wait_count) wait_count <= 0;
//    else if (inc_wait_count && frame_pulse) wait_count <= wait_count + 1;
//end

//A counter to count through the counters being read out
reg [7:0] chan_count = 0;
wire inc_chan_count, rst_chan_count;
always @ (posedge clk) begin
    if (rst_chan_count) chan_count <= 0;
    else if (inc_chan_count) chan_count <= chan_count + 1;
end

parameter HOLD_WAIT = 6;
parameter MAX_FIFO_LEVEL_TO_START = 128;
parameter IDLE = 10'h001;
parameter SPARE = 10'h002;
parameter WAITFORFRAME1 = 10'h004;
parameter WAITFORFRAME2 = 10'h008;
parameter WAITFORFRAME3 = 10'h010;
parameter WAITFORFIFO1 = 10'h020;
parameter WAITFORFIFO2 = 10'h040;
parameter WAITFORFIFO3 = 10'h080;
parameter WAITFORFIFO4 = 10'h100;
parameter DONE          = 10'h200;

(*KEEP = "TRUE"*) wire PH_go = inhibit_write ? trig : trig && (fifo_data_count < MAX_FIFO_LEVEL_TO_START);

   reg [9:0] state = IDLE;

   always @(posedge clk)
      if (reset)
         state <= IDLE;
      else
         case (state)
            IDLE : begin
               if (PH_go)
                  state <= WAITFORFRAME1;
               else
                  state <= IDLE;
            end
            WAITFORFRAME1 : begin
               if (frame_pulse)
                  state <= WAITFORFRAME2;
               else
                  state <= WAITFORFRAME1;
            end
            WAITFORFRAME2 : begin
               if (frame_pulse)
                  state <= WAITFORFRAME3;
               else
                  state <= WAITFORFRAME2;
            end
            WAITFORFRAME3 : begin
               if (frame_pulse)
                  state <= WAITFORFIFO1;
               else
                  state <= WAITFORFRAME3;
            end
            WAITFORFIFO1 : begin
               if (!tready)
                  state <= WAITFORFIFO1;
               else
                  state <= WAITFORFIFO2;
            end
            WAITFORFIFO2 : begin
               if (!tready)
                  state <= WAITFORFIFO2;
               else
                  state <= WAITFORFIFO3;
            end
            WAITFORFIFO3 : begin
               if (!tready)
                  state <= WAITFORFIFO3;
               else
                  state <= WAITFORFIFO4;
            end
            WAITFORFIFO4 : begin
               if (!tready)
                  state <= WAITFORFIFO4;
               else if (tready && (chan_count < stop_chan))
                  state <= WAITFORFRAME2;
               else
                  state <= DONE;
            end
            DONE : begin
               if (!tready)
                state <= DONE;
               else
                  state <= IDLE;
            end
            default : begin  // Fault Recovery
               state <= IDLE;
            end
         endcase

   assign tvalid = !inhibit_write && ((state == WAITFORFIFO1) || 
                                        (state == WAITFORFIFO2) ||
                                        (state == WAITFORFIFO3) ||
                                        (state == WAITFORFIFO4) ||
                                        (state == DONE)
                                        );
//   assign tlast = !inhibit_write && (state == WAITFORFIFO4) && (tready && (chan_count == stop_chan));
   assign tlast = !inhibit_write && (state == DONE) && tready;
 // assign rst_wait_count = (state == WAITFORFIFO4);
  // assign inc_wait_count = (state == WAITFORLATENCY) && tready;
   assign rst_chan_count = (state == IDLE);
   assign inc_chan_count = (state == WAITFORFIFO2) && tready;
   assign CK_R = (state == WAITFORFRAME3);
   assign RSTB_R = (state == WAITFORFRAME1);
   wire D_R_wire = ((state == WAITFORFRAME2) || (state == WAITFORFRAME3)) && (chan_count == 0);
   assign reset_hold = (state == DONE);
   assign reset_cc_fifo = (state == IDLE);
   assign write_ET = (state == DONE);
//Register the D_R signal to insure no glitches 
always @(posedge clk)D_R <= D_R_wire;

//For chipscope
 (*KEEP = "TRUE"*) wire [9:0] debug_PH_state = state;
 //(*KEEP = "TRUE"*) wire [3:0] PH_wait_count = wait_count;
 (*KEEP = "TRUE"*) wire [7:0] PH_chan_count = chan_count;
 (*KEEP = "TRUE"*) wire  PH_adc_frame_d1 = adc_frame_d1;

endmodule
