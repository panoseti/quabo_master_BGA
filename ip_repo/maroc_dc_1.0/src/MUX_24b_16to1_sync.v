`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2018 01:30:09 PM
// Design Name: 
// Module Name: MUX_24b_16to1_sync
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


module MUX_24b_16to1_sync(
    input clk,
    input [23:0] din0,
    input [23:0] din1,
    input [23:0] din2,
    input [23:0] din3,
    input [23:0] din4,
    input [23:0] din5,
    input [23:0] din6,
    input [23:0] din7,
    input [23:0] din8,
    input [23:0] din9,
    input [23:0] din10,
    input [23:0] din11,
    input [23:0] din12,
    input [23:0] din13,
    input [23:0] din14,
    input [23:0] din15,
    input [3:0] sel,
    output reg [23:0] dout
    );
    
   always @(posedge clk)
       case (sel)
          4'd0: dout <= din0;
          4'd1: dout <= din1;
          4'd2: dout <= din2;
          4'd3: dout <= din3;
          4'd4: dout <= din4;
          4'd5: dout <= din5;
          4'd6: dout <= din6;
          4'd7: dout <= din7;
          4'd8: dout <= din8;
          4'd9: dout <= din9;
          4'd10: dout <= din10;
          4'd11: dout <= din11;
          4'd12: dout <= din12;
          4'd13: dout <= din13;
          4'd14: dout <= din14;
          4'd15: dout <= din15;
       endcase

endmodule
