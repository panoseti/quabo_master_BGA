`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//This takes 4 inputs and produces four outputs, limiting
// the pulsewidth of the outputs to about 10ms, to prevent overheating
// in event of a software problem
module step_drive(
    input clk,
    input [3:0]drive_in,
    //input inA,
    //input inB,
    //input inC,
    //input inD,
    output [3:0] drive_out
    //output outA,
    //output outB,
    //output outC,
    //output outD
    );
    wire inA = drive_in[0];
    wire inB = drive_in[1];
    wire inC = drive_in[2];
    wire inD = drive_in[3];
    //With 100MHz clock, count to 2^20 to get about 10 ms max
    reg [19:0] timer = 0;
    wire timer_reset;
    //Register the timeout so no glitches are produced
    reg running;
    assign drive_out[0] = inA && running;
    assign drive_out[1] = inB && running;
    assign drive_out[2] = inC && running;
    assign drive_out[3] = inD && running;
    //Edge-detect each input and reset the timer with the OR of all
    reg inA_d1;
    reg inB_d1;
    reg inC_d1;
    reg inD_d1;
    wire in_edge = (inA && !inA_d1) || (inB && !inB_d1) || (inC && !inC_d1) || (inD && !inD_d1);
    always @ (posedge clk) begin
        inA_d1 <= inA;
        inB_d1 <= inB;
        inC_d1 <= inC;
        inD_d1 <= inD;
        if (in_edge) begin
            timer <= 0;
            running <= 1;
        end
        else if (timer == 20'hfffff) running <= 0;
        else timer <= timer + 1;
    end
        
endmodule
