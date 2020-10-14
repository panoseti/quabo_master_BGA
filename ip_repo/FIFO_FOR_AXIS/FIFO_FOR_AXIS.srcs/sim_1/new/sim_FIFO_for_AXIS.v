`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2019 03:18:21 PM
// Design Name: 
// Module Name: sim_FIFO_for_AXIS
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


module sim_FIFO_for_AXIS();
/*************************************************************/
//Two data types will come to this IP core, so we need to simulate both of the data types
parameter sim_type = 0;           
/*************************************************************/
parameter data_start_time = 200;
parameter data_len = 16;
parameter tvalid_occur_time = 20;
reg clk, rst;
reg [9:0] cnt;

reg [31:0]  s_axis_tdata;
reg [3:0]   s_axis_tkeep;
reg         s_axis_tvalid;
reg         s_axis_tlast;
wire        s_axis_tready;

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
        
reg tmp;
always @(posedge clk)
    begin
        if(rst)
            tmp <= 0;
        else
            tmp <= tmp + 1;
    end
generate
/*************************************************************/
//simulation for data type0
if( sim_type == 0)
begin
//clk

 //data   
always @(posedge clk)
    begin
        if(rst)
            s_axis_tdata <= 0;
        else if((cnt > data_start_time) && (cnt < (data_start_time + data_len)))
            s_axis_tdata <= s_axis_tdata + 1;
        else if(cnt == data_start_time + data_len)
            s_axis_tdata <= 0;
    end
 //keep
always @(posedge clk)
    begin
        if(rst)
            s_axis_tkeep <= 0;
        else if(cnt == data_start_time)
            s_axis_tkeep <= 4'hf;
        else if(cnt == data_start_time + data_len)
            s_axis_tkeep <= 0;
    end    
//valid   
always @(posedge clk)
    begin
        if(rst)
            s_axis_tvalid <= 0;
        else if(cnt == data_start_time) 
            s_axis_tvalid <= 1;
        else if(cnt == data_start_time + data_len)
            s_axis_tvalid <= 0;
    end
 //last
 always @(posedge clk)
    begin
        if(rst)
            s_axis_tlast <= 0;
        else if(cnt == data_start_time + data_len - 1)
            s_axis_tlast <= 1;
        else if(cnt == data_start_time + data_len)
            s_axis_tlast <= 0;
    end
//tready from receive side
always @(posedge clk)
    begin
        if(rst)
            m_axis_tready <= 0;
        else if(cnt == data_start_time + data_len + tvalid_occur_time)
            m_axis_tready <= 1;
        else if(cnt == data_start_time + data_len + tvalid_occur_time + data_len)
            m_axis_tready <= 0;
    end
end
/*************************************************************/
//simulation for data type1
else
begin
reg [32:0]s_axis_tdata_reg;
reg [3:0] s_axis_tkeep_reg;
reg s_axis_tlast_reg;
//data
always @(negedge tmp)
    begin
        if(rst)
            s_axis_tdata_reg <= 0;
        else if((cnt > data_start_time) && (cnt < (data_start_time + data_len*2)))
            s_axis_tdata_reg <= s_axis_tdata_reg + 1;
        else if(cnt == data_start_time + data_len*2)
            s_axis_tdata_reg <= 0;
    end
 //keep
always @(negedge tmp)
    begin
        if(rst)
            s_axis_tkeep_reg <= 0;
        else if(cnt == data_start_time)
            s_axis_tkeep_reg <= 4'hf;
        else if(cnt == data_start_time + data_len*2)
            s_axis_tkeep_reg <= 0;
    end  
     
always @(posedge clk)
    begin
        if(rst)
            begin
                s_axis_tdata <= 0;
                s_axis_tkeep <= 0;
                s_axis_tlast <= 0;
            end
        else
            begin
                s_axis_tdata <= s_axis_tdata_reg;
                s_axis_tkeep <= s_axis_tkeep_reg;
                s_axis_tlast <= s_axis_tlast_reg;
            end
    end
        
//valid   
always @(posedge clk)
    begin
        if(rst)
            s_axis_tvalid <= 0;
        else if((cnt >= data_start_time) && (cnt <= data_start_time + data_len *2)) 
            s_axis_tvalid <= tmp;
        else if((cnt > data_start_time + data_len *2))
            s_axis_tvalid <= 0;
    end
 //last
 always @(negedge tmp)
    begin
        if(rst)
            s_axis_tlast_reg <= 0;
        else if(cnt == data_start_time + (data_len - 1)*2)
            s_axis_tlast_reg <= 1;
        else if(cnt == data_start_time + data_len*2)
            s_axis_tlast_reg <= 0;
    end
//tready from receive side
always @(negedge tmp)
    begin
        if(rst)
            m_axis_tready <= 0;
        else if(cnt == data_start_time + data_len + tvalid_occur_time)
            m_axis_tready <= 1;
        else if(cnt == data_start_time + data_len + tvalid_occur_time + data_len)
            m_axis_tready <= 0;
    end
end
endgenerate

/**********************************************************************/
//IP core needed to be tested        
FIFO_for_AXIS SIM(
    .clk(clk),
    .rst(~rst),
    
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tkeep(s_axis_tkeep),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tlast(s_axis_tlast),
    .s_axis_tready(s_axis_tready),
    
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tkeep(m_axis_tkeep),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tlast(m_axis_tlast),
    .m_axis_tready(m_axis_tready)
    );
 
endmodule
