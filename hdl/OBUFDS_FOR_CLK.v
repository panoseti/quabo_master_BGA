`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2019 03:29:12 PM
// Design Name: 
// Module Name: OBUFGDS
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


module OBUFDS_FOR_CLK(
    input I,
    output O,
    output OB
    );
OBUFDS #(
    .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
     .SLEW("SLOW")           // Specify the output slew rate
  ) OBUFDS_INST (
      .O(O),     // Diff_p output (connect directly to top-level port)
      .OB(OB),   // Diff_n output (connect directly to top-level port)
      .I(I)      // Buffer input
   );
endmodule
