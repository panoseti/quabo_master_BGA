`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2019 09:15:17 AM
// Design Name: 
// Module Name: PPS_IO
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


module PPS_IO(
    input clk,
    input rst,
    input io_ctrl0,
    input io_ctrl1,
    input pps_inside_in,
    output pps_inside_out,
    inout pps_inout
    );
 
 
 wire io_ctrl;
 assign io_ctrl = io_ctrl0 | io_ctrl1;
 
 wire pps_inside_out_tmp;
 IOBUF #(
    .DRIVE(12), // Specify the output drive strength
    .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
    .IOSTANDARD("DEFAULT"), // Specify the I/O standard
    .SLEW("SLOW") // Specify the output slew rateIOBUF_PPS(
)IOBUF_PPS(
.I(pps_inside_in),
.O(pps_inside_out_tmp),
.T(io_ctrl), //high-input; low-output
.IO(pps_inout)
);

assign pps_inside_out = io_ctrl? pps_inside_out_tmp:pps_inside_in;

endmodule
