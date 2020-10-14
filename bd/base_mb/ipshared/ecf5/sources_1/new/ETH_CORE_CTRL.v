module ETH_CORE_CTRL(
    input clk,
    input rst,
    
	input [31:0]s_axis_txd_tdata,
	input [3:0] s_axis_txd_tkeep,
	input s_axis_txd_tlast,
	input s_axis_txd_tvalid,
	output s_axis_txd_tready,
	
	output  [31:0]m_axis_txd_tdata,
	output  [3:0] m_axis_txd_tkeep,
	output  m_axis_txd_tlast,
	output  m_axis_txd_tvalid,
	input m_axis_txd_tready,
	
	input m_axis_txc_tready,
	output reg m_axis_txc_tvalid,
	output reg m_axis_txc_tlast,
	output [31:0]m_axis_txc_tdata,
	output [3:0]m_axis_txc_tkeep
);

wire rst_inv;
assign rst_inv              =   ~rst;

//txd
//assign m_axis_txd_tdata  = s_axis_txd_tdata;
//assign m_axis_txd_tkeep  = s_axis_txd_tkeep;
//assign m_axis_txd_tlast  = s_axis_txd_tlast;
//assign m_axis_txd_tvalid = s_axis_txd_tvalid;
//assign s_axis_txd_tready = m_axis_txd_tready;

wire [37:0] fifo_din;
assign fifo_din = {s_axis_txd_tvalid, s_axis_txd_tlast, s_axis_txd_tkeep, s_axis_txd_tdata};

wire [37:0] fifo_dout;
wire m_axis_txd_tvalid_tmp;
assign m_axis_txd_tdata[31:0]       =   fifo_dout[31:0];
assign m_axis_txd_tkeep[3:0]        =   fifo_dout[35:32];
assign m_axis_txd_tlast             =   fifo_dout[36:36];
assign m_axis_txd_tvalid_tmp        =   fifo_dout[37:37];
wire fifo_empty;
wire fifo_full;
fifo_generator_0 fifo (
  .rst(rst_inv),        // input wire rst
  .wr_clk(clk),  // input wire wr_clk
  .rd_clk(clk),  // input wire rd_clk
  .din(fifo_din),        // input wire [37 : 0] din
  .wr_en(s_axis_txd_tvalid),    // input wire wr_en
  .rd_en(m_axis_txd_tready),    // input wire rd_en
  .dout(fifo_dout),      // output wire [37 : 0] dout
  .full(fifo_full),      // output wire full
  .empty(fifo_empty)    // output wire empty
);
assign m_axis_txd_tvalid = m_axis_txd_tvalid_tmp & (~fifo_empty);
assign s_axis_txd_tready = (~fifo_full);
//txc
assign m_axis_txc_tdata     =   32'hFFFFFFFF;
assign m_axis_txc_tkeep     =   4'b1111;

reg [3:0]cnt;
always @(posedge clk)
    begin
        if(rst_inv)
            cnt <= 0;
        else if((m_axis_txc_tvalid == 1) && (m_axis_txc_tready==1))
            cnt <= cnt + 1;
        else if(m_axis_txc_tvalid == 1)
            cnt <= cnt;
        else
            cnt <= 0;
    end
 
reg s_axis_txd_tvalid_reg;
always @(posedge clk)
    begin
        if(rst_inv)
            s_axis_txd_tvalid_reg <= 0;
        else
            s_axis_txd_tvalid_reg <= s_axis_txd_tvalid;
    end

always @(posedge clk)
    begin
        if(rst_inv)
            m_axis_txc_tvalid <= 0;
        else if((s_axis_txd_tvalid_reg == 0) && (s_axis_txd_tvalid == 1))
            m_axis_txc_tvalid <= 1;
        else if(cnt == 5)
            m_axis_txc_tvalid <= 0;
        else
            m_axis_txc_tvalid <= m_axis_txc_tvalid;
    end

always @(posedge clk)
    begin
        if(rst_inv)
            m_axis_txc_tlast <= 0;
        else if(cnt == 4)
            m_axis_txc_tlast <= 1;
        else
            m_axis_txc_tlast <= 0;
    end
endmodule