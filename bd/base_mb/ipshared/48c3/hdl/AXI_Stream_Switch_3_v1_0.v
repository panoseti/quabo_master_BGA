
`timescale 1 ns / 1 ps

	module AXI_Stream_Switch_3_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S0_AXIS
		parameter integer C_S0_AXIS_TDATA_WIDTH	= 32,

		// Parameters of Axi Slave Bus Interface S1_AXIS
		parameter integer C_S1_AXIS_TDATA_WIDTH	= 32,

		// Parameters of Axi Slave Bus Interface S2_AXIS
		parameter integer C_S2_AXIS_TDATA_WIDTH	= 32,

		// Parameters of Axi Master Bus Interface M0_AXIS
		parameter integer C_M0_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M0_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line

        input wire  aclk,
		input wire  aresetn,
		// Ports of Axi Slave Bus Interface S0_AXIS
		//output wire  s0_axis_tready,
		output reg s0_axis_tready,
		input wire [C_S0_AXIS_TDATA_WIDTH-1 : 0] s0_axis_tdata,
		input wire [(C_S0_AXIS_TDATA_WIDTH/8)-1 : 0] s0_axis_tkeep,
		input wire  s0_axis_tlast,
		input wire  s0_axis_tvalid,

		// Ports of Axi Slave Bus Interface S1_AXIS
		//output wire  s1_axis_tready,
		output reg s1_axis_tready,
		input wire [C_S1_AXIS_TDATA_WIDTH-1 : 0] s1_axis_tdata,
		input wire [(C_S1_AXIS_TDATA_WIDTH/8)-1 : 0] s1_axis_tkeep,
		input wire  s1_axis_tlast,
		input wire  s1_axis_tvalid,

		// Ports of Axi Slave Bus Interface S2_AXIS
		//output wire  s2_axis_tready,
		output reg s2_axis_tready,
		input wire [C_S2_AXIS_TDATA_WIDTH-1 : 0] s2_axis_tdata,
		input wire [(C_S2_AXIS_TDATA_WIDTH/8)-1 : 0] s2_axis_tkeep,
		input wire  s2_axis_tlast,
		input wire  s2_axis_tvalid,

		// Ports of Axi Master Bus Interface M0_AXIS
		/*output wire  m_axis_tvalid,
		output wire [C_M0_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata,
		output wire [(C_M0_AXIS_TDATA_WIDTH/8)-1 : 0] m_axis_tkeep,
		output wire  m_axis_tlast,
		*/
		output reg  m_axis_tvalid,
		output reg [C_M0_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata,
		output reg [(C_M0_AXIS_TDATA_WIDTH/8)-1 : 0] m_axis_tkeep,
		output reg  m_axis_tlast,
		input wire  m_axis_tready
	);

wire [2:0] s_axis_tvalid;
assign s_axis_tvalid = {s2_axis_tvalid, s1_axis_tvalid, s0_axis_tvalid};

/*
wire [2:0] s_axis_tready;
assign s2_axis_tready = s_axis_tready[2:2];
assign s1_axis_tready = s_axis_tready[1:1];
assign s0_axis_tready = s_axis_tready[0:0];
*/

wire [95:0] s_axis_tdata;
assign s_axis_tdata = {s2_axis_tdata, s1_axis_tdata, s0_axis_tdata};

wire [11:0] s_axis_tkeep;
assign s_axis_tkeep = {s2_axis_tkeep, s1_axis_tkeep, s0_axis_tkeep};

wire [2:0] s_axis_tlast;
assign s_axis_tlast = {s2_axis_tlast, s1_axis_tlast, s0_axis_tlast};

reg [2:0] s_req_suppress;
wire [2:0] s_decode_err;

/*

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
  .s_decode_err(s_decode_err)      // output wire [2 : 0] s_decode_err
);
*/
reg s0_sending;
reg s1_sending;
reg s2_sending;

always @(posedge aclk)
    begin
        if(~aresetn)
            s0_sending <= 0;
        else if((~s1_sending) && (~s2_sending) && (s0_axis_tvalid) && (~s0_axis_tlast))
            s0_sending <= 1;
        else if((s0_axis_tvalid) && (s0_axis_tlast)) 
            s0_sending <= 0;
        else
            s0_sending <= s0_sending;
    end
 
 always @(posedge aclk)
    begin
        if(~aresetn)
            s1_sending <= 0;
        else if((~s0_sending) && (~s2_sending) && (~s0_axis_tvalid) && (s1_axis_tvalid) && (~s1_axis_tlast))
            s1_sending <= 1;
        else if((s1_axis_tvalid) && (s1_axis_tlast))
            s1_sending <= 0;
        else
            s1_sending <= s1_sending;
    end

always @(posedge aclk)
    begin
        if(~aresetn)
            s2_sending <= 0;
        else if((~s0_sending) && (~s1_sending) && (~s0_axis_tvalid) && (~s1_axis_tvalid) && (s2_axis_tvalid) && (~s2_axis_tlast))
            s2_sending <= 1;
        else if((s2_axis_tvalid) && (s2_axis_tlast))
            s2_sending <= 2;
        else
            s2_sending <= s2_sending;
    end

always @(posedge aclk)
    begin
        if(~aresetn)
            s_req_suppress <= 3'b111;
        else if(s0_sending)
            s_req_suppress <= 3'b110;
        else if(s1_sending)
            s_req_suppress <= 3'b101;
        else if(s2_sending)
            s_req_suppress <= 3'b011;
        else
            s_req_suppress <= 3'b111;
    end
    
parameter [2:0] IDLE        = 3'b111,
                S0_SENDING  = 3'b110,
                S1_SENDING  = 3'b101,
                S2_SENDING  = 3'b011;

              
always @(s_req_suppress or aresetn)
    begin
        if(~aresetn)
            begin
                m_axis_tdata    = 32'b0;
                m_axis_tvalid   = 1'b0;
                m_axis_tkeep    = 4'b0;
                m_axis_tlast    = 1'b0;     
                s0_axis_tready  = 1'b0;
                s1_axis_tready  = 1'b0;
                s2_axis_tready  = 1'b0;
            end
        case(s_req_suppress)
            IDLE:
                begin
                    m_axis_tdata    = 32'b0;
                    m_axis_tvalid   = 1'b0;
                    m_axis_tkeep    = 4'b0;
                    m_axis_tlast    = 1'b0;
                    s0_axis_tready  = 1'b0;
                    s1_axis_tready  = 1'b0;
                    s2_axis_tready  = 1'b0; 
                end 
            S0_SENDING:
                begin
                    m_axis_tdata    = s0_axis_tdata;
                    m_axis_tvalid   = s0_axis_tvalid;
                    m_axis_tkeep    = s0_axis_tkeep;
                    m_axis_tlast    = s0_axis_tlast;
                    s0_axis_tready  = m_axis_tready;
                    s1_axis_tready  = 1'b0;
                    s2_axis_tready  = 1'b0;
                end
            S1_SENDING:
                begin
                    m_axis_tdata    = s1_axis_tdata;
                    m_axis_tvalid   = s1_axis_tvalid;
                    m_axis_tkeep    = s1_axis_tkeep;
                    m_axis_tlast    = s1_axis_tlast;
                    s0_axis_tready  = 1'b0;
                    s1_axis_tready  = m_axis_tready;
                    s2_axis_tready  = 1'b0;
                end
            S2_SENDING:
                begin
                    m_axis_tdata    = s2_axis_tdata;
                    m_axis_tvalid   = s2_axis_tvalid;
                    m_axis_tkeep    = s2_axis_tkeep;
                    m_axis_tlast    = s2_axis_tlast;
                    s0_axis_tready  = 1'b0;
                    s1_axis_tready  = 1'b0;
                    s2_axis_tready  = m_axis_tready;
                end
            default:
                begin
                    m_axis_tdata    = 32'b0;
                    m_axis_tvalid   = 1'b0;
                    m_axis_tkeep    = 4'b0;
                    m_axis_tlast    = 1'b0; 
                    s0_axis_tready  = 1'b0;
                    s1_axis_tready  = 1'b0;
                    s2_axis_tready  = 1'b0;
                end        
        endcase
    end
	endmodule
