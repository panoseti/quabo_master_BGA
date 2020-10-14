`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2019 04:34:41 PM
// Design Name: 
// Module Name: FIFO_for_AXIS
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


module FIFO_for_AXIS(
    input clk,
    input rst,
    
    input [31:0]s_axis_tdata,
    input [3:0] s_axis_tkeep,
    input       s_axis_tvalid,
    input       s_axis_tlast,
    output      s_axis_tready,
    
    output [31:0]m_axis_tdata,
    output [3:0] m_axis_tkeep,
    output       m_axis_tvalid,
    output       m_axis_tlast,
    input        m_axis_tready
    );
wire rst_inv;
assign rst_inv          =   ~rst;

wire [37:0] fifo_din;
assign fifo_din = {s_axis_tvalid, s_axis_tlast, s_axis_tkeep, s_axis_tdata};

wire [37:0] fifo_dout;
wire m_axis_tvalid_tmp;

assign m_axis_tdata[31:0]       =   fifo_dout[31:0];
assign m_axis_tkeep[3:0]        =   fifo_dout[35:32];
assign m_axis_tlast             =   fifo_dout[36:36];
assign m_axis_tvalid_tmp        =   fifo_dout[37:37];


reg s_axis_tlast_reg;
always @(posedge clk)
    begin
        if(rst_inv)
            s_axis_tlast_reg <= 0;
        else
            s_axis_tlast_reg <= s_axis_tlast;
    end

reg m_axis_tlast_reg;
always @(posedge clk)
    begin
        if(rst_inv)
            m_axis_tlast_reg <= 0;
        else
            m_axis_tlast_reg <= m_axis_tlast;
    end
    
wire fifo_empty;    

assign m_axis_tvalid = m_axis_tvalid_tmp & (~fifo_empty); 

reg ready;
reg sending;
always @(posedge clk)
    begin
        if(rst_inv)
            ready <= 0;
        else if((sending == 1) && (s_axis_tvalid==1) && (s_axis_tlast == 1))
            ready <= 0;
        else if(s_axis_tvalid == 1)
            ready <= 1;
        else
            ready <= ready;
    end 
  
always @(posedge clk)
    begin
        if(rst_inv)
            sending <= 0;
        else if(ready == 1)
            sending <= 1;
        else if(ready == 0 )
            sending <= 0;
        else
            sending <= sending;
    end

wire fifo_full;
assign s_axis_tready    =   (~fifo_full) & ready;

fifo_generator_1 fifo_for_axis (
  .rst(rst_inv),        // input wire rst
  .wr_clk(clk),  // input wire wr_clk
  .rd_clk(clk),  // input wire rd_clk
  .din(fifo_din),        // input wire [37 : 0] din
  .wr_en(ready),    // input wire wr_en
  .rd_en(m_axis_tready),    // input wire rd_en
  .dout(fifo_dout),      // output wire [37 : 0] dout
  .full(fifo_full),      // output wire full
  .empty(fifo_empty)    // output wire empty
);
endmodule
