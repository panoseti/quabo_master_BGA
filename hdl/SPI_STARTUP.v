`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2019 02:55:27 PM
// Design Name: 
// Module Name: SPI_STARTUP
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


module SPI_STARTUP(
   input clk,
   input rst_n,
   //from MB
   input mb_mosi_i,
   output mb_miso_o,
   input mb_sck_i,
   input mb_ss_i,
   output mb_eos,
   //from WR
   input wr_mosi_i,
   output wr_miso_o,
   input wr_sck_i,
   input wr_ss_i,
   //from MB for spi selection
   input spi_sel,
   
   //output to flash chip
   output mosi_o,
   input  miso_i,
   output ss_o
    );
wire rst;
assign rst = ~rst_n;
wire preq_int,pack_int;
reg pipe_signal0, pipe_signal1, pipe_signal2, pipe_signal3, pipe_signal4, pipe_signal5, pipe_signal6, pipe_signal7;
always @(posedge clk)
    begin
        if(rst)
            pipe_signal0 <= 0;
        else if(preq_int == 1)
            pipe_signal0 <= 1;
    end

always @(posedge clk)
    begin
        if(rst)
            begin
                pipe_signal1 <= 0;
                pipe_signal2 <= 0;
                pipe_signal3 <= 0;
                pipe_signal4 <= 0;
                pipe_signal5 <= 0;
                pipe_signal6 <= 0;
                pipe_signal7 <= 0;
            end
        else
            begin
                pipe_signal1 <= pipe_signal0;
                pipe_signal2 <= pipe_signal1;
                pipe_signal3 <= pipe_signal2;
                pipe_signal4 <= pipe_signal3;
                pipe_signal5 <= pipe_signal4;
                pipe_signal6 <= pipe_signal5;
                pipe_signal7 <= pipe_signal6;
            end
    end
    
assign pack_int = pipe_signal7;

wire sck;
STARTUPE2 #(
      .PROG_USR("FALSE"),  // Activate program event security feature. Requires encrypted bitstreams.
      .SIM_CCLK_FREQ(0.0)  // Set the Configuration Clock Frequency(ns) for simulation.
   )
   STARTUPE2_inst (
      .CFGCLK(),       // 1-bit output: Configuration main clock output
      .CFGMCLK(),     // 1-bit output: Configuration internal oscillator clock output
      .EOS(mb_eos),             // 1-bit output: Active high output signal indicating the End Of Startup.
      .PREQ(preq_int),           // 1-bit output: PROGRAM request to fabric output
      .CLK(0),             // 1-bit input: User start-up clock input
      .GSR(0),             // 1-bit input: Global Set/Reset input (GSR cannot be used for the port name)
      .GTS(0),             // 1-bit input: Global 3-state input (GTS cannot be used for the port name)
      .KEYCLEARB(0), // 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
      .PACK(pack_int),           // 1-bit input: PROGRAM acknowledge input ?
      .USRCCLKO(sck),   // 1-bit input: User CCLK input
                             // For Zynq-7000 devices, this input must be tied to GND
      .USRCCLKTS(0), // 1-bit input: User CCLK 3-state enable input
                             // For Zynq-7000 devices, this input must be tied to VCC
      .USRDONEO(1),   // 1-bit input: User DONE pin output control
      .USRDONETS(0)  // 1-bit input: User DONE 3-state enable output
   );
   
//if spi_sel = 1, use mb_spi
assign sck      =   spi_sel?    wr_sck_i    : mb_sck_i;
assign mosi_o   =   spi_sel?    wr_mosi_i   : mb_mosi_i;
//assign miso_i   =   spi_sel?    wr_miso_o   : mb_miso  ;
assign wr_miso_o = miso_i;
assign mb_miso_o= miso_i;
assign ss_o     =   spi_sel?    wr_ss_i     : mb_ss_i  ;
endmodule
