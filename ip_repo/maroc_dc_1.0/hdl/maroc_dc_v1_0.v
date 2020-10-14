
`timescale 1 ns / 1 ps

	module maroc_dc_v1_0 #
	(
		// Users to add parameters here
		parameter PCB_REV = 1,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 6,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M00_AXIS_START_COUNT	= 32,

		// Parameters of Axi Master Bus Interface M01_AXIS
		parameter integer C_M01_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M01_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here
		input hs_clk,
		//from the MAROC chips
        input [63:0] maroc_trig0,
        input [63:0] maroc_trig1,
        input [63:0] maroc_trig2,
        input [63:0] maroc_trig3,
        input [1:0] or_trig0,
        input [1:0] or_trig1,
        input [1:0] or_trig2,
        input [1:0] or_trig3,
        output [3:0] hold1,
        output [3:0] hold2,
        output [3:0] CK_R,
        output [3:0] RSTB_R,
        output [3:0] D_R,
        //from the charge ADC
        input [3:0] adc_din,
        input bit_clk,
        input frm_clk,
        input ref_clk,
        output adc_clk_out,
        //from the other quadrants
        input ext_trig,
        output [5:0] testpoint,
        //from the elapsed time module
        input ET_clk,
        input ET_clk_1,
        input ET_clk_2,
        input ET_clk_3,
        input [28:0] elapsed_time_0,
        input [28:0] elapsed_time_1,
        input [28:0] elapsed_time_2,
        input [28:0] elapsed_time_3,
        input one_pps,

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,

		// Ports of Axi Master Bus Interface M00_AXIS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
		output wire  m00_axis_tlast,
		input wire  m00_axis_tready,

		// Ports of Axi Master Bus Interface M01_AXIS
		input wire  m01_axis_aclk,
		input wire  m01_axis_aresetn,
		output wire  m01_axis_tvalid,
		output wire [C_M01_AXIS_TDATA_WIDTH-1 : 0] m01_axis_tdata,
		output wire [(C_M01_AXIS_TDATA_WIDTH/8)-1 : 0] m01_axis_tstrb,
		output wire  m01_axis_tlast,
		input wire  m01_axis_tready
	);
// Instantiation of Axi Bus Interface S00_AXI
//Bring out the slave registers to control the core
wire [31:0] slave_reg0;
wire [31:0] slave_reg1;
wire [31:0] slave_reg2;
wire [31:0] slave_reg3;
wire [31:0] slave_reg4;
wire [31:0] slave_reg5;
wire [31:0] slave_reg6;
wire [31:0] slave_reg7;
wire [31:0] slave_reg8;
wire [31:0] slave_reg9;
wire [31:0] slave_reg10;
//wire [31:0] slave_reg11;

	maroc_dc_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) maroc_dc_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
		.slave_reg0(slave_reg0),
		.slave_reg1(slave_reg1),
		.slave_reg2(slave_reg2),
		.slave_reg3(slave_reg3),
		.slave_reg4(slave_reg4),
		.slave_reg5(slave_reg5),
		.slave_reg6(slave_reg6),
		.slave_reg7(slave_reg7),
		.slave_reg8(slave_reg8),
		.slave_reg9(slave_reg9),
		.slave_reg10(slave_reg10)
		//.slave_reg11(slave_reg11)

	);

// Instantiation of Axi Bus Interface M00_AXIS
//	maroc_dc_v1_0_M00_AXIS # ( 
//		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
//		.C_M_START_COUNT(C_M00_AXIS_START_COUNT)
//	) maroc_dc_v1_0_M00_AXIS_inst (
//		.M_AXIS_ACLK(m00_axis_aclk),
//		.M_AXIS_ARESETN(m00_axis_aresetn),
//		.M_AXIS_TVALID(m00_axis_tvalid),
//		.M_AXIS_TDATA(m00_axis_tdata),
//		.M_AXIS_TSTRB(m00_axis_tstrb),
//		.M_AXIS_TLAST(m00_axis_tlast),
//		.M_AXIS_TREADY(m00_axis_tready)
//	);

// Instantiation of Axi Bus Interface M01_AXIS
//	maroc_dc_v1_0_M01_AXIS # ( 
//		.C_M_AXIS_TDATA_WIDTH(C_M01_AXIS_TDATA_WIDTH),
//		.C_M_START_COUNT(C_M01_AXIS_START_COUNT)
//	) maroc_dc_v1_0_M01_AXIS_inst (
//		.M_AXIS_ACLK(m01_axis_aclk),
//		.M_AXIS_ARESETN(m01_axis_aresetn),
//		.M_AXIS_TVALID(m01_axis_tvalid),
//		.M_AXIS_TDATA(m01_axis_tdata),
//		.M_AXIS_TSTRB(m01_axis_tstrb),
//		.M_AXIS_TLAST(m01_axis_tlast),
//		.M_AXIS_TREADY(m01_axis_tready)
//	);

	// Add user logic here
//Define the slave registers to control the core
//The mask register has 256 bits for the individual triggers, 8 for the OR triggers, and one for the external
wire inhibit_PH_write = slave_reg8[16];
wire sw_trig = slave_reg8[15];
wire [3:0] adc_clk_phase_sel =  slave_reg8[14:11];
wire [1:0] mode_enable = slave_reg8[10:9]; //00 for none, 01 for PH, 10 for IM, 11 for both
wire [264:0] trigger_mask = {slave_reg8[8:0],
                            slave_reg7,
                            slave_reg6,
                            slave_reg5,
                            slave_reg4,
                            slave_reg3,
                            slave_reg2,
                            slave_reg1,
                            slave_reg0};
//wire [7:0] frame_interval = slave_reg9[7:0];
wire [7:0] hold1_delay = slave_reg9[15:8];
wire [7:0] hold2_delay = slave_reg9[23:16];
wire [6:0] ph_stop_chan = slave_reg9[30:24];
wire counter_reset = slave_reg9[31];
wire [15:0] frame_interval = slave_reg10[15:0];

maroc_dc #(.REMAP_FOR_BGA(PCB_REV))
    USR_LOGIC(
        //System clocks and reset
       .axi_clk(s00_axi_aclk),
       .hs_clk(hs_clk),  //sync to axi_clk
       .ref_clk(ref_clk),
       .axi_areset_n(s00_axi_aresetn),
        //from the MAROC chips
       .maroc_trig({maroc_trig3, maroc_trig2, maroc_trig1, maroc_trig0}),
       .or_trig({or_trig3, or_trig2, or_trig1, or_trig0}),
       .hold1(hold1),
       .hold2(hold2),
       .CK_R(CK_R),
       .RSTB_R(RSTB_R),
       .D_R(D_R),
        
        //from the charge ADC
        .adc_din(adc_din),
        .bit_clk(bit_clk),
        .frm_clk(frm_clk),
        .adc_clk_out(adc_clk_out),
        //from the other quadrants
        .ext_trig(ext_trig),
        //To start things up in SW
        .sw_trig(sw_trig),
        //parameters from the AXI interface
        .inhibit_PH_write(inhibit_PH_write),
        .mask(trigger_mask),
        .frame_interval(frame_interval),
        .hold1_delay(hold1_delay),
        .hold2_delay(hold2_delay),
        .ph_stop_channel(ph_stop_chan),
        .counter_reset(counter_reset),
        .mode_enable(mode_enable), //00 for none, 01 for PH, 10 for IM, 11 for both
        .adc_clk_phase_sel(adc_clk_phase_sel),
        //AXI-stream data interface for image mode
        .image_m_axis_data(m00_axis_tdata),
        .image_m_axis_tvalid(m00_axis_tvalid),
        .image_m_axis_tlast(m00_axis_tlast),
        .image_m_axis_tready(m00_axis_tready),
        //AXI-stream data interface for pulsheight mode
        .ph_m_axis_data(m01_axis_tdata),
        .ph_m_axis_tvalid(m01_axis_tvalid),
        .ph_m_axis_tlast(m01_axis_tlast),
        .ph_m_axis_tready(m01_axis_tready),
        //from the elapsed time module
        .ET_clk(ET_clk),
        .ET_clk_1(ET_clk_1),
        .ET_clk_2(ET_clk_2),
        .ET_clk_3(ET_clk_3),
        .elapsed_time_0(elapsed_time_0),
        .elapsed_time_1(elapsed_time_1),
        .elapsed_time_2(elapsed_time_2),
        .elapsed_time_3(elapsed_time_3),
        .one_pps(one_pps),
        //Can connect to testpoints
        .testpoint(testpoint)
        );
        assign m00_axis_tstrb = 4'b1111;
        assign m01_axis_tstrb = 4'b1111;

	// User logic ends

	endmodule
