`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 10:31:22 AM
// Design Name: 
// Module Name: ETH_Tready
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


module ETH_Tready(
    input tready_in1,
    input tready_in2,
    output tready_out
    );
assign tready_out = tready_in1 & tready_in2;
endmodule
