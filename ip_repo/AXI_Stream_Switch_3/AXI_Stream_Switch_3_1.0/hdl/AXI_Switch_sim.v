`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2020 08:29:45 PM
// Design Name: 
// Module Name: AXI_Switch_sim
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


module AXI_Switch_sim(

    );

reg aresetn;
reg aclk;

reg [2 : 0] s_axis_tvalid;
wire [2 : 0] s_axis_tready;
reg [95 : 0] s_axis_tdata;
reg [11 : 0] s_axis_tkeep;
reg [2 : 0] s_axis_tlast;

wire [0 : 0] m_axis_tvalid;
reg [0 : 0] m_axis_tready;
wire [31 : 0] m_axis_tdata;
wire [3 : 0] m_axis_tkeep;
wire [0 : 0] m_axis_tlast;

reg [2:0]s_req_suppress;

initial
    begin
        aresetn <= 0;
        aclk <= 0;
        s_axis_tvalid <= 3;
        s_axis_tdata <= 96'h111111112222222233333333 ;
        s_axis_tkeep <= 0;
        s_axis_tlast <= 0;
        
        m_axis_tready <= 1;
        
        s_req_suppress <= 5;
        #10;
        aresetn <= 1;
    end
 
 always #1 aclk <= ~aclk;

axis_switch_3 axis_switch (
  .aclk(aclk),                      // input wire aclk
  .aresetn(aresetn),                // input wire aresetn
  .s_axis_tvalid(s_axis_tvalid),    // input wire [2 : 0] s_axis_tvalid
  .s_axis_tready(s_axis_tready),    // output wire [2 : 0] s_axis_tready
  .s_axis_tdata(s_axis_tdata),      // input wire [95 : 0] s_axis_tdata
  .s_axis_tkeep(s_axis_tkeep),      // input wire [11 : 0] s_axis_tkeep
  .s_axis_tlast(s_axis_tlast),      // input wire [2 : 0] s_axis_tlast
  .m_axis_tvalid(m_axis_tvalid),    // output wire [0 : 0] m_axis_tvalid
  .m_axis_tready(m_axis_tready),    // input wire [0 : 0] m_axis_tready
  .m_axis_tdata(m_axis_tdata),      // output wire [31 : 0] m_axis_tdata
  .m_axis_tkeep(m_axis_tkeep),      // output wire [3 : 0] m_axis_tkeep
  .m_axis_tlast(m_axis_tlast),      // output wire [0 : 0] m_axis_tlast
  .s_req_suppress(s_req_suppress),  // input wire [2 : 0] s_req_suppress
  .s_decode_err()      // output wire [2 : 0] s_decode_err
);
endmodule
