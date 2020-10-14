`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2018 02:58:12 PM
// Design Name: 
// Module Name: in_buf_ds_5bit
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


module in_buf_ds_4bit(
    input [3:0] in_p,
    input [3:0] in_n,
    output [3:0] outp
    );
genvar gg;
  generate
    for (gg=0; gg < 4; gg=gg+1)
    begin: ADC_IBUF
   IBUFDS #(
        .DIFF_TERM("TRUE"),       // Differential Termination
        .IBUF_LOW_PWR("FALSE"),     // Low power="TRUE", Highest performance="FALSE" 
        .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
     ) IBUFDS_inst (
        .O(outp[gg]),  // Buffer output
        .I(in_p[gg]),  // Diff_p buffer input (connect directly to top-level port)
        .IB(in_n[gg]) // Diff_n buffer input (connect directly to top-level port)
     );
    end
 endgenerate
   
   
endmodule
