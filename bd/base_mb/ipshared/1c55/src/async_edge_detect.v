`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2018 12:50:44 PM
// Design Name: 
// Module Name: async_edge_detect
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


module async_edge_detect(
    input clk,
    input trig_in,
    output trig_out
    );

wire Q1, Q2, Q3;    
    FDPE #(
       .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
    ) FDPE_ED0 (
       .Q(Q1),      // 1-bit Data output
       .C(clk),      // 1-bit Clock input
       .CE(1'b1),    // 1-bit Clock enable input
       .PRE(trig_in),  // 1-bit Asynchronous set input
       .D(1'b0)       // 1-bit Data input
    );
    FDPE #(
       .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
    ) FDPE_ED1 (
       .Q(Q2),      // 1-bit Data output
       .C(clk),      // 1-bit Clock input
       .CE(1'b1),    // 1-bit Clock enable input
       .PRE(1'b0),  // 1-bit Asynchronous set input
       .D(Q1)       // 1-bit Data input
    );
    FDPE #(
       .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
    ) FDPE_ED2 (
       .Q(Q3),      // 1-bit Data output
       .C(clk),      // 1-bit Clock input
       .CE(1'b1),    // 1-bit Clock enable input
       .PRE(1'b0),  // 1-bit Asynchronous set input
       .D(Q2)       // 1-bit Data input
    );
assign trig_out = Q2 && !Q3;
endmodule
