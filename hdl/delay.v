`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2020 02:46:05 PM
// Design Name: 
// Module Name: delay
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


module delay(
    input clk,
    input din,
    output dout
    );

FDRE #(
      .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
   ) FDRE_inst (
      .Q(dout),      // 1-bit Data output
      .C(clk),      // 1-bit Clock input
      .CE(1),    // 1-bit Clock enable input
      .R(0),      // 1-bit Synchronous reset input
      .D(din)       // 1-bit Data input
   );
endmodule
