`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 11:24:35 AM
// Design Name: 
// Module Name: pinout_three_state
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


module pinout_three_state(
    input pos0,
    input pos1,
    input d_in,
    output d_io
    );
wire sel;
assign sel = pos0 | pos1;

IOBUF #(
    .DRIVE(12), // Specify the output drive strength
    .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
    .IOSTANDARD("DEFAULT"), // Specify the I/O standard
    .SLEW("SLOW") // Specify the output slew rateIOBUF_PPS(
)IOBUF_PPS(
.I(d_in),
.O(),
.T(sel), //high-input; low-output
.IO(d_io)
);

endmodule
