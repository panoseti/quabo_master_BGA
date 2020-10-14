`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 02:28:33 PM
// Design Name: 
// Module Name: IM_FIFO
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


module IM_FIFO(
    input clk,
    input rst,      //rst is from axi rst
    input arst_for_imfifo,     //arst is from axt interface
    
    input wire[31:0]axi_str_rxd_tdata,
    input wire axi_str_rxd_tlast,
    input wire axi_str_rxd_tvalid,
    output wire axi_str_rxd_tready,
    
    input wire start_to_read,
    output wire [31:0]rdata_to_user,
    output wire ready_to_read
    );

wire full;
assign axi_str_rxd_tready = ~full;
imfifo imfifo0 (
  .clk(clk),      // input wire clk
  .srst((~rst)|(arst_for_imfifo)),    // input wire srst
  .din(axi_str_rxd_tdata),      // input wire [31 : 0] din
  .wr_en(axi_str_rxd_tvalid),  // input wire wr_en
  .rd_en(start_to_read),  // input wire rd_en
  .dout(rdata_to_user),    // output wire [31 : 0] dout
  .full(full),    // output wire full
  .empty()  // output wire empty
);

assign ready_to_read = full;
endmodule
