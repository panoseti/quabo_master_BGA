`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2020 12:32:23 PM
// Design Name: 
// Module Name: firmware_ID_ROM
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


module firmware_ID_ROM(
    input [5:0] addr,
    output data_out
    );
    
      ROM64X1 #(
      .INIT(64'h1234deadbeef5678) // Contents of ROM
   ) ROM64X1_FWID (
      .O(data_out),   // ROM output
      .A0(addr[0]), // ROM address[0]
      .A1(addr[1]), // ROM address[1]
      .A2(addr[2]), // ROM address[2]
      .A3(addr[3]), // ROM address[3]
      .A4(addr[4]), // ROM address[4]
      .A5(addr[5])  // ROM address[5]
   );

endmodule
