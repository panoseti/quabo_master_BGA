`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2019 12:02:01 PM
// Design Name: 
// Module Name: SPI_access
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
// This module accepts an ARM and a GO input; on the rising edge of GO when ARM is high,
//   the int output is asserted for one cycle
//////////////////////////////////////////////////////////////////////////////////


//module SPI_access(
//    input clk,
//    input arm,
//    input go,
//    output int_out
//    );
//    reg go_d1;
//    always @ (posedge clk) begin
//        go_d1 <= go;
//    end
//    assign int_out = go && !go_d1 && arm;
    
//endmodule

module SPI_access(
    input clk,
    input arm,
    input go,
    output reg int_out
    );
reg go_d1;
reg arm_d1;
always @ (posedge clk) 
    begin
        go_d1 <= go;
        arm_d1 <= arm;
    end

reg [16: 0]counter;
reg count_en;
always @(posedge clk)
    begin
        if(arm && !arm_d1)
            count_en <= 1;
        else if((counter==100000) || (go && !go_d1 && arm)) //100MHz, we want to delay 1ms
            count_en <= 0;
        else 
            count_en <= count_en;
    end
    
 always @(posedge clk)
    begin
        if((arm && !arm_d1) || (counter == 100000) || (go && !go_d1 && arm))
            counter <= 0;
        else if(count_en)
            counter <= counter + 1;
        else
            counter <= counter;
    
    end
    
always @(posedge clk)
    begin
     if((go && !go_d1 && arm) || (counter == 100000))
        int_out <= 1;
     else if(arm == 0)
        int_out <= 0;
     else
        int_out <= int_out;
    end
    
endmodule