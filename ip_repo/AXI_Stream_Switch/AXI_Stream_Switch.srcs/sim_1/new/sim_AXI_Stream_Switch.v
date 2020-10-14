`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2019 09:58:50 PM
// Design Name: 
// Module Name: sim_AXI_Stream_Switch
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


module sim_AXI_Stream_Switch();


/*************************************************************/
//Two data types will come to this IP core, so we need to simulate both of the data types
parameter sim_type = 0;           
/*************************************************************/
parameter data_start_time = 200;
parameter data_len = 16;
reg clk, rst;
reg [9:0] cnt;
reg start;
reg [31:0]  s0_axis_tdata;
reg [3:0]   s0_axis_tkeep;
reg         s0_axis_tvalid;
reg         s0_axis_tlast;
wire        s0_axis_tready;

wire [31:0] m_axis_tdata;
wire [3:0]  m_axis_tkeep;
wire        m_axis_tvalid;
wire        m_axis_tlast;
reg         m_axis_tready;

initial
    begin
        rst = 0;
        clk = 0;
        #10;
        rst = 1;
        clk = 1;
        #10;
        rst = 0;
        clk = 0;
        forever #5 clk = ~clk;
    end
    
always @(posedge clk)
    begin
        if(rst)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end
        
always @(posedge clk)
    begin
        if(rst)
            start <= 0;
        else if(cnt == data_start_time)
            start <= 1;
        else
            start <= 0;
    end 
 /************************************************************/
 //valid
 always @(posedge clk)
    begin
        if(rst)
            s0_axis_tvalid <= 0;
        else if(start == 1)
            s0_axis_tvalid <= 1;
        else if((s0_axis_tready == 1) && (s0_axis_tlast == 1))
            s0_axis_tvalid <= 0;
        else
            s0_axis_tvalid <= s0_axis_tvalid;
    end
 //last
 always @(posedge clk)
    begin
        if(rst)
            s0_axis_tlast <= 0;
        else if(s0_axis_tdata == data_len - 2)
            s0_axis_tlast <= 1;
        else if(s0_axis_tvalid == 1)
            s0_axis_tlast <= 0;
        else
            s0_axis_tlast <= s0_axis_tlast;
    end
 //data
 always @(posedge clk)
    begin
        if(rst)
            s0_axis_tdata <= 0;
        else if(s0_axis_tlast == 1)
            s0_axis_tdata <= 0;
        else if(s0_axis_tready == 1)
            s0_axis_tdata <= s0_axis_tdata + 1;
        else
            s0_axis_tdata <= s0_axis_tdata;
    end
//keep
 always @(posedge clk)
    begin
        if(rst)
            s0_axis_tkeep <= 0;
        else if(s0_axis_tready == 1)
            s0_axis_tkeep <= 4'b1111;
        else if(s0_axis_tlast == 1)
            s0_axis_tkeep <= 0;
        else
            s0_axis_tkeep <= s0_axis_tkeep;
    end
 
/*************************************************************/



wire [31:0]fifo_tdata;
wire [3:0] fifo_tkeep;
wire fifo_tlast;
wire fifo_tvalid;
wire fifo_tready;
FIFO_for_AXIS_0 your_instance_name (
  .clk(clk),                      // input wire clk
  .rst(~rst),                      // input wire rst
  .s_axis_tdata(s0_axis_tdata),    // input wire [31 : 0] s_axis_tdata
  .s_axis_tkeep(s0_axis_tkeep),    // input wire [3 : 0] s_axis_tkeep
  .s_axis_tvalid(s0_axis_tvalid),  // input wire s_axis_tvalid
  .s_axis_tlast(s0_axis_tlast),    // input wire s_axis_tlast
  .s_axis_tready(s0_axis_tready),  // output wire s_axis_tready
  .m_axis_tdata(fifo_tdata),    // output wire [31 : 0] m_axis_tdata
  .m_axis_tkeep(fifo_tkeep),    // output wire [3 : 0] m_axis_tkeep
  .m_axis_tvalid(fifo_tvalid),  // output wire m_axis_tvalid
  .m_axis_tlast(fifo_tlast),    // output wire m_axis_tlast
  .m_axis_tready(fifo_tready)  // input wire m_axis_tready
);

AXI_Stream_Switch switch(
    .clk(clk),
    .rst(~rst),
    /*
    .s0_axis_tdata(s0_axis_tdata),
    .s0_axis_tkeep(s0_axis_tkeep),
    .s0_axis_tlast(s0_axis_tlast),
    .s0_axis_tvalid(s0_axis_tvalid),
    .s0_axis_tready(s0_axis_tready),
    */
    .s0_axis_tdata(fifo_tdata),
    .s0_axis_tkeep(fifo_tkeep),
    .s0_axis_tlast(fifo_tlast),
    .s0_axis_tvalid(fifo_tvalid),
    .s0_axis_tready(fifo_tready),
    
    .s1_axis_tdata(s1_axis_tdata),
    .s1_axis_tkeep(s1_axis_tkeep),
    .s1_axis_tlast(s1_axis_tlast),
    .s1_axis_tvalid(s1_axis_tvalid),
    .s1_axis_tready(s1_axis_tready),

    .m_axis_tdata(m_axis_tdata),
    .m_axis_tkeep(m_axis_tkeep),
    .m_axis_tlast(m_axis_tlast),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(1)
    );
    
endmodule
