`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2019 01:50:36 PM
// Design Name: 
// Module Name: SPI_MUX
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


module SPI_MUX(
    input sel,
    input spi_ck0,
    input spi_ck1,
    input spi_mosi0,
    input spi_mosi1,
    output spi_ck,
    output spi_mosi
    );
    
 assign spi_ck = sel ? spi_ck1 : spi_ck0;
 assign spi_mosi = sel ? spi_mosi1 : spi_mosi0;

endmodule
