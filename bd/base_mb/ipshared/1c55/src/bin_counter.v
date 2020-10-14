`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2018 01:09:51 PM
// Design Name: 
// Module Name: bin_counter
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
module bin_counter(
    input pulse_in,
    input reset,
    input hold,
    input clk,
    output reg [15:0] count_out
    );
    
 /*   always @ (posedge clk) begin
        if (reset) count_out <= 0;
        else if (pulse_in && !hold) count_out <= count_out + 1;
    end
 */
 
 /*
  reg [15:0] counter;
    always @ (posedge clk) begin
        if (reset) begin 
           count_out <= counter;
           counter <= 0;
      end
        else if (pulse_in) counter <= counter + 1;
    end*/
 reg hold_d1;
 always @(posedge clk)
    begin
        if(reset)
            hold_d1 <= 0;
        else
            hold_d1 <= hold;
    end  
wire hold_reset = hold && !hold_d1;
 
 reg [15:0] counter;
    always @ (posedge clk) begin
        if (reset) begin 
           //count_out <= counter;
           counter <= 0;
      end
        else if(hold_reset)
            counter <= 0;
        else if (pulse_in) 
            counter <= counter + 1;
        else
            counter <= counter;
    end
    
 always @(posedge clk)
    begin
        if(reset)
            count_out <= 0;
        else if(hold_reset)
            count_out <= counter;  
        else
            count_out <= count_out;        
    end 
endmodule
