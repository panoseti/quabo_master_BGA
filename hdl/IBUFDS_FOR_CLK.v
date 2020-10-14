`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2019 03:54:59 PM
// Design Name: 
// Module Name: IBUFDS_FOR_CLK
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


module IBUFDS_FOR_CLK(
    input I,
    input IB,
    output O
    );
    
IBUFDS #(
      .DIFF_TERM("FALSE"),       // Differential Termination
      .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
   ) IBUFDS_inst (
      .O(O),  // Buffer output
      .I(I),  // Diff_p buffer input (connect directly to top-level port)
      .IB(IB) // Diff_n buffer input (connect directly to top-level port)
   );
endmodule
