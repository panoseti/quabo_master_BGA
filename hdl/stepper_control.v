`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2019 12:37:57 PM
// Design Name: 
// Module Name: stepper_control
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


module stepper_control(
    input clk,
    input [15:0] num_steps,
    input go,
    input up_lim,
    input down_lim,
    output [3:0] step_drive
    );
    
    //Need to decimate the clock to get the desired pulse widths
    //100MHz clock, 2^^18 counts is 2.62ms
    reg [19:0] clock_dec = 0;
    parameter clk_dec_value = 20'h40000;
    
    reg go_d1;
    reg running = 0;
    //Step_count is one bit larger than max num_steps because we have an OFF step in between ON steps
    reg [16:0] step_count = 0;
    //Register the commanded # stpes, to prevent hardware doing something funny if SW changes value during execution
    reg [15:0] num_steps_reg;
    //num_steps is a 16b signed value.  Take abs value
    wire direction = num_steps_reg[15];
    wire [15:0] abs_num_steps = direction ? ~({1'b1,num_steps_reg[14:0]}) + 1 : num_steps_reg;
    always @ (posedge clk) begin
        go_d1 <= go;
        if (go && !go_d1) begin
            running <= 1;
            step_count <= 0;
            num_steps_reg <= num_steps;
            clock_dec <= 0;
        end
        else begin
            if (running)
                if (clock_dec == clk_dec_value) begin 
                    clock_dec <= 0;
                    step_count <= step_count + 1;
                    if (step_count[16:1] == abs_num_steps) running <= 0;
                end
            else clock_dec <= clock_dec + 1;
        end
    end
    
    //Now assign the output drive signals
    //The LSB of step_count is used as an enable for all the windings, so a 50% duty ratio
    //Bits 1 and 2 of step-count are used to sequence the windings
    //Assume the limit inputs are high when the mechanism is within limits
    assign step_drive[0] = running && step_count[0] && up_lim && down_lim && ((step_count[2:1] == 2'b00) || (step_count[2:1] == 2'b11));
    assign step_drive[1] = running && step_count[0] && up_lim && down_lim && 
                                (direction ? ((step_count[2:1] == 2'b00) || (step_count[2:1] == 2'b01)) : 
                                ((step_count[2:1] == 2'b10) || (step_count[2:1] == 2'b11)));
    assign step_drive[2] = running && step_count[0] && up_lim && down_lim && ((step_count[2:1] == 2'b10) || (step_count[2:1] == 2'b01));
    assign step_drive[3] = running && step_count[0] && up_lim && down_lim && 
                                (direction ? ((step_count[2:1] == 2'b10) || (step_count[2:1] == 2'b11)) : 
                                ((step_count[2:1] == 2'b00) || (step_count[2:1] == 2'b01)));
    
    
endmodule
