`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2018 08:17:07 AM
// Design Name: 
// Module Name: elapsed_time_gen
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


module elapsed_time_gen(
    input clk_250,
    input clk_250_1,
    input clk_250_2,
    input clk_250_3,
    input clk_62m5,
    input one_pps,
    output [28:0] elapsed_time0,
    output [28:0] elapsed_time1,
    output [28:0] elapsed_time2,
    output [28:0] elapsed_time3
    );
    
//Register the one_pps signal with the 62.5MHz then the 250MHz
reg one_pps_sync62m5;
always @ (posedge clk_62m5) one_pps_sync62m5 <= one_pps;

//Implement four counters with four phases
//PHASE 0
reg one_pps_sync250_0;
reg one_pps_sync250_0_d1;
wire counter_reset_0 = one_pps_sync250_0 && !one_pps_sync250_0_d1;
always @ (posedge clk_250) begin
    one_pps_sync250_0 <= one_pps_sync62m5;
    one_pps_sync250_0_d1 <= one_pps_sync250_0;
end
//Counter- 29 bits at 500MHz gives a wrap time > 1sec
reg [28:0] ET0_counter = 0;
reg [28:0] ET0_reg = 0;
always @ (posedge clk_250) begin
    if (counter_reset_0) ET0_counter <= 0;
    else ET0_counter <= ET0_counter + 1;
    ET0_reg <= ET0_counter;
end

//PHASE 1
reg one_pps_sync250_1;
reg one_pps_sync250_1_d1;
wire counter_reset_1 = one_pps_sync250_1 && !one_pps_sync250_1_d1;
always @ (posedge clk_250_1) begin
    one_pps_sync250_1 <= one_pps_sync62m5;
    one_pps_sync250_1_d1 <= one_pps_sync250_1;
end
//Counter- 29 bits at 500MHz gives a wrap time > 1sec
reg [28:0] ET1_counter = 0;
reg [28:0] ET1_reg = 0;
always @ (posedge clk_250_1) begin
    if (counter_reset_1) ET1_counter <= 0;
    else ET1_counter <= ET1_counter + 1;
    ET1_reg <= ET1_counter;
end
//PHASE 2
reg one_pps_sync250_2;
reg one_pps_sync250_2_d1;
wire counter_reset_2 = one_pps_sync250_2 && !one_pps_sync250_2_d1;
always @ (posedge clk_250_2) begin
    one_pps_sync250_2 <= one_pps_sync62m5;
    one_pps_sync250_2_d1 <= one_pps_sync250_2;
end
//Counter- 29 bits at 500MHz gives a wrap time > 1sec
reg [28:0] ET2_counter = 0;
reg [28:0] ET2_reg = 0;
always @ (posedge clk_250_2) begin
    if (counter_reset_2) ET2_counter <= 0;
    else ET2_counter <= ET2_counter + 1;
    ET2_reg <= ET2_counter;
end
//PHASE 3
reg one_pps_sync250_3;
reg one_pps_sync250_3_d1;
wire counter_reset_3 = one_pps_sync250_3 && !one_pps_sync250_3_d1;
always @ (posedge clk_250_3) begin
    one_pps_sync250_3 <= one_pps_sync62m5;
    one_pps_sync250_3_d1 <= one_pps_sync250_3;
end
//Counter- 29 bits at 500MHz gives a wrap time > 1sec
reg [28:0] ET3_counter = 0;
reg [28:0] ET3_reg = 0;
always @ (posedge clk_250_3) begin
    if (counter_reset_3) ET3_counter <= 0;
    else ET3_counter <= ET3_counter + 1;
    ET3_reg <= ET3_counter;
end

assign elapsed_time0 = ET0_reg;
assign elapsed_time1 = ET1_reg;
assign elapsed_time2 = ET2_reg;
assign elapsed_time3 = ET3_reg;

endmodule
