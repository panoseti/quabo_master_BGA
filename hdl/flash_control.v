`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2019 03:54:07 PM
// Design Name: 
// Module Name: flash_control
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


module flash_control(
    input hs_clk,
    input clk,
    input one_pps,
    input [3:0] width,
    input [4:0] level,
    input [2:0] rate,
    output flash_dac,
    output pulse_p,
    output pulse_n
    );
 //Sync the 1PPS to the hs_clk- it is already so, but an extra reg is good for speed
 reg one_pps_reg;
 reg one_pps_reg1;
 always @ (posedge hs_clk)one_pps_reg <= one_pps;
 always @ (posedge hs_clk) one_pps_reg1 <= one_pps_reg;
 //We'll use the low-speed clk for most of the stuff, and the hs_clk
 //  only for making the pulse
 //If clk is 100MHz, divide by 2^^12 to get about 96 Hz minimum rep rate
parameter clk_div = 20'h2000;
reg [19:0] clk_count = 0;
 //Seven bit reg to generate rates in power-of-2 steps
 reg [6:0] rate_count = 0;
 //Five-bit register to make a pwm signal for the level
 reg [4:0] flash_dac_reg = 0;
 
 always @ (posedge clk) begin
    if (clk_count[4:0] == level)flash_dac_reg <= 0;
    else if (clk_count[4:0] == 0) flash_dac_reg <= 1;    
    if (clk_count == clk_div) begin
        clk_count <= 0;
        rate_count <= rate_count + 1;
    end
    else clk_count <= clk_count + 1;
 end
 
 //The rising edge of rate_gen will be used to trigger the flash
 reg rate_gen;
    always @(rate, rate_count, one_pps_reg1)
      case (rate)
         3'h0: rate_gen = one_pps_reg1;
         3'h1: rate_gen = rate_count[6];
         3'h2: rate_gen = rate_count[5];
         3'h3: rate_gen = rate_count[4];
         3'h4: rate_gen = rate_count[3];
         3'h5: rate_gen = rate_count[2];
         3'h6: rate_gen = rate_count[1];
         3'h7: rate_gen = rate_count[0];
      endcase

//Sync the rate_gen output to the hs_clk, and make a pulse to start a counter`
reg rate_gen_d1;
reg rate_gen_d2;
wire rate_pulse = rate_gen_d1 && !rate_gen_d2;
reg [3:0] hs_count = 0;
always @ (posedge hs_clk) begin
    rate_gen_d1 <= rate_gen;
    rate_gen_d2 <= rate_gen_d1;
    if (rate_pulse) begin
        hs_count <= 0;
    end
    else begin
        //hs_count will count to 8 and stop
        if (hs_count < 8) hs_count <= hs_count + 1;
    end
end
//Use the count value to enable the inputs to an ODDR
 wire pulse_r = hs_count <= {1'b0,width[3:1]};
 wire pulse_f = width[0] ? (hs_count <= {1'b0,width[3:1]}) : (hs_count < {1'b0,width[3:1]});
 wire pulse;
      ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) ODDR_FLASH (
      .Q(pulse),   // 1-bit DDR output
      .C(hs_clk),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(pulse_r), // 1-bit data input (positive edge)
      .D2(pulse_f), // 1-bit data input (negative edge)
      .R(1'b0),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
 
   OBUFDS #(
      .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
      .SLEW("FAST")           // Specify the output slew rate
   ) OBUFDS_FLASH (
      .O(pulse_p),     // Diff_p output (connect directly to top-level port)
      .OB(pulse_n),   // Diff_n output (connect directly to top-level port)
      .I(pulse)      // Buffer input
   );

assign flash_dac = flash_dac_reg;   
endmodule
