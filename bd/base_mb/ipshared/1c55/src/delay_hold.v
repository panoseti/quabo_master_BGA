`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2018 02:17:33 PM
// Design Name: 
// Module Name: delay_hold
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


module delay_hold(
    input clk,
    input trig,
    input [7:0] delay_time,
    input reset_hold,
    output trig_delayed
    );
reg [7:0] delay_count = 0;
reg hold_reg = 0;

always @ (posedge clk) begin
    if (trig) delay_count <= 0;
    else if (delay_count < 255) delay_count <= delay_count + 1;
    if (reset_hold) hold_reg <= 0;
    else if (delay_count == delay_time) hold_reg <= 1;
end

assign trig_delayed = hold_reg;

endmodule
