`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2020 07:57:07 PM
// Design Name: 
// Module Name: StepDrive_ShutterCtrl_Sel
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


module StepDrive_ShutterCtrl_Sel(
    //clk
    input clk,
    //pos information shows it's q0, q1, q2 or q3
    input pos0,
    input pos1,
    //step drive signals
    input [3:0]step_drive,
    //shutter control signals,
    input shutter_command,
    //input spare,
    output shutter_status,
    output light_sensor_status,
    //real FPGA pins
    output reg sd0_sc,      //step_drive0 shares the pin with shutter_command
    output reg sd2_spare,   //step_drive2 shares the pin with spare
    inout sd1_ss,       //step_drive1 shares the pin with shutter_status
    inout sd3_lss       //step_drive3 shares the pin with light_sensor_status
    );
parameter POS0 = 2'b00;
parameter POS1 = 2'b01;

wire [1:0] pos = {pos1, pos0};

always @(*)
    begin
        case(pos)
            POS0:
                begin
                    sd0_sc      = step_drive[0:0];
                    sd2_spare   = step_drive[2:2];
                end
            POS1:
                begin
                    sd0_sc      = shutter_command;
                    sd2_spare   = 1'b0;       
                end
            default://default status is low???
                begin
                    sd0_sc      = 1'b0; 
                    sd2_spare   = 1'b0;
                end
        endcase    
    end

wire sel = (~pos1) & (pos0); //if it's pos1(2'b01), IOBUF is running as input 
IOBUF #(
    .DRIVE(12), // Specify the output drive strength
    .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
    .IOSTANDARD("DEFAULT"), // Specify the I/O standard
    .SLEW("SLOW") // Specify the output slew rateIOBUF_PPS(
)IOBUF0(
.I(step_drive[1:1]),
.O(shutter_status),
.T(sel), //high-input; low-output
.IO(sd1_ss)
);

IOBUF #(
    .DRIVE(12), // Specify the output drive strength
    .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
    .IOSTANDARD("DEFAULT"), // Specify the I/O standard
    .SLEW("SLOW") // Specify the output slew rateIOBUF_PPS(
)IOBUF1(
.I(step_drive[3:3]),
.O(light_sensor_status),
.T(sel), //high-input; low-output
.IO(sd3_lss)
);
endmodule
