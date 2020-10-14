`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2018 03:09:30 PM
// Design Name: 
// Module Name: in_buf_ds_1bit
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


module in_buf_ds_1bit(
    input in_p,
    input in_n,
    output outp
    );
    IBUFDS #(
         .DIFF_TERM("TRUE"),       // Differential Termination
         .IBUF_LOW_PWR("FALSE"),     // Low power="TRUE", Highest performance="FALSE" 
         .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
      ) IBUFDS_inst (
         .O(outp),  // Buffer output
         .I(in_p),  // Diff_p buffer input (connect directly to top-level port)
         .IB(in_n) // Diff_n buffer input (connect directly to top-level port)
      );
   
    
endmodule
