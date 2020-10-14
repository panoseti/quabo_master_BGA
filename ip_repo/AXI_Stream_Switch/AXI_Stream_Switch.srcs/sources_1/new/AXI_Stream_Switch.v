`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2019 03:53:24 PM
// Design Name: 
// Module Name: AXI_Stream_Switch
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


module AXI_Stream_Switch(
    input clk,
    input rst,
    
    input [31:0]s0_axis_tdata,
    input [3:0] s0_axis_tkeep,
    input s0_axis_tlast,
    input s0_axis_tvalid,
    output s0_axis_tready,
    
    input [31:0]s1_axis_tdata,
    input [3:0] s1_axis_tkeep,
    input s1_axis_tlast,
    input s1_axis_tvalid,
    output s1_axis_tready,

    output [31:0]m_axis_tdata,
    output [3:0] m_axis_tkeep,
    output m_axis_tlast,
    output m_axis_tvalid,
    input m_axis_tready
    );

wire [63:0] s_axis_tdata;
assign s_axis_tdata = {s1_axis_tdata, s0_axis_tdata};

wire [7:0] s_axis_tkeep;
assign s_axis_tkeep = {s1_axis_tkeep, s0_axis_tkeep};

wire [1:0] s_axis_tlast;
assign s_axis_tlast = {s1_axis_tlast, s0_axis_tlast};

wire [1:0] s_axis_tvalid;
assign s_axis_tvalid = {s1_axis_tvalid, s0_axis_tvalid};

wire [1:0] s_axis_tready;
//assign s_axis_tready = {s1_axis_tready, s0_axis_tready};
assign s1_axis_tready = s_axis_tready[1:1];
assign s0_axis_tready = s_axis_tready[0:0];

wire [1:0] s_decode_err;

wire [1:0] s_req_suppress;
reg s_req_suppress0, s_req_suppress1;
assign s_req_suppress = {s_req_suppress1, s_req_suppress0};

reg s0_axis_tlast_reg;
always @(posedge clk)
    begin
        if(~rst)
            s0_axis_tlast_reg <= 0;
        else
            s0_axis_tlast_reg <= s0_axis_tlast;
    end
reg s1_axis_tlast_reg;
reg s1_axis_tlast_reg1;
always @(posedge clk)
    begin
        if(~rst)
            begin
                s1_axis_tlast_reg <= 0;
                s1_axis_tlast_reg1<= 0;
            end
        else
            begin
                s1_axis_tlast_reg <= s1_axis_tlast;
                s1_axis_tlast_reg1 <= s1_axis_tlast_reg;
            end
    end

//these two signals are used to confirm whether there is data sending on s0/s1
reg s0_sending; 
reg s1_sending;
always @(posedge clk)
    begin
        if(~rst)
            s0_sending <= 0;
        else if((s0_axis_tlast_reg == 0) && (s0_axis_tlast == 1))
            s0_sending <= 0;
        else if((s0_axis_tvalid == 1) && (s1_sending == 0) && (s0_axis_tlast == 0))
            s0_sending <= 1;

        else
            s0_sending <= s0_sending;
    end

always @(posedge clk)
    begin
        if(~rst)
            s1_sending <= 0;
        else if(s0_sending == 1)
            s1_sending <= 0;
        //else if((s1_axis_tlast_reg == 0) && (s1_axis_tlast ==1))
        else if((s1_axis_tlast_reg1 == 0) && (s1_axis_tlast_reg ==1)) //this is for high speed mode, because tlast keeps high for 2 clock in high speed core
            s1_sending <= 0;
        else if((s1_axis_tvalid == 1) && (s1_axis_tlast == 0))
            s1_sending <= 1;
        else
            s1_sending <= s1_sending;
    end
//s0 have high priority    
always @(posedge clk)
    begin
        if(~rst)
            begin
                s_req_suppress0 <= 1;
                s_req_suppress1 <= 1;
            end
        else if(s0_sending == 1)
            begin
                s_req_suppress0 <= 0;
                s_req_suppress1 <= 1;
            end
        else if(s1_sending == 1)
            begin
                s_req_suppress0 <= 1;
                s_req_suppress1 <= 0;
            end
        else 
            begin
                s_req_suppress0 <= 1;
                s_req_suppress1 <= 1;
            end     
    end
axis_switch_0 switch (
  .aclk(clk),                      // input wire aclk
  .aresetn(rst),                // input wire aresetn
  .s_axis_tvalid(s_axis_tvalid),    // input wire [1 : 0] s_axis_tvalid
  .s_axis_tready(s_axis_tready),    // output wire [1 : 0] s_axis_tready
  .s_axis_tdata(s_axis_tdata),      // input wire [63 : 0] s_axis_tdata
  .s_axis_tkeep(s_axis_tkeep),      // input wire [7 : 0] s_axis_tkeep
  .s_axis_tlast(s_axis_tlast),      // input wire [1 : 0] s_axis_tlast
  .m_axis_tvalid(m_axis_tvalid),    // output wire [0 : 0] m_axis_tvalid
  .m_axis_tready(m_axis_tready),    // input wire [0 : 0] m_axis_tready
  .m_axis_tdata(m_axis_tdata),      // output wire [31 : 0] m_axis_tdata
  .m_axis_tkeep(m_axis_tkeep),      // output wire [3 : 0] m_axis_tkeep
  .m_axis_tlast(m_axis_tlast),      // output wire [0 : 0] m_axis_tlast
  .s_req_suppress(s_req_suppress),  // input wire [1 : 0] s_req_suppress
  .s_decode_err(s_decode_err)      // output wire [1 : 0] s_decode_err
);
endmodule
