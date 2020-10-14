// (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: user.org:user:HighSpeed_IM_v2_9:2.9
// IP Revision: 5

(* X_CORE_INFO = "HighSpeed_IM_v1_0,Vivado 2018.3.1_AR71948" *)
(* CHECK_LICENSE_TYPE = "base_mb_HighSpeed_IM_v1_0_0_0,HighSpeed_IM_v1_0,{}" *)
(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module base_mb_HighSpeed_IM_v1_0_0_0 (
  elapsed_time,
  aclk,
  aresetn,
  s_axi_packetheader_awaddr,
  s_axi_packetheader_awprot,
  s_axi_packetheader_awvalid,
  s_axi_packetheader_awready,
  s_axi_packetheader_wdata,
  s_axi_packetheader_wstrb,
  s_axi_packetheader_wvalid,
  s_axi_packetheader_wready,
  s_axi_packetheader_bresp,
  s_axi_packetheader_bvalid,
  s_axi_packetheader_bready,
  s_axi_packetheader_araddr,
  s_axi_packetheader_arprot,
  s_axi_packetheader_arvalid,
  s_axi_packetheader_arready,
  s_axi_packetheader_rdata,
  s_axi_packetheader_rresp,
  s_axi_packetheader_rvalid,
  s_axi_packetheader_rready,
  m_axis_tvalid,
  m_axis_tdata,
  m_axis_tkeep,
  m_axis_tlast,
  m_axis_tready,
  rdata_to_user,
  ready_to_read,
  start_to_read,
  arst_for_imfifo
);

input wire [28 : 0] elapsed_time;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF m_axis:m_axi_im_config:s_axi_im_config:s_axi_packetheader, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
input wire aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
input wire aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader AWADDR" *)
input wire [31 : 0] s_axi_packetheader_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader AWPROT" *)
input wire [2 : 0] s_axi_packetheader_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader AWVALID" *)
input wire s_axi_packetheader_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader AWREADY" *)
output wire s_axi_packetheader_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader WDATA" *)
input wire [31 : 0] s_axi_packetheader_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader WSTRB" *)
input wire [3 : 0] s_axi_packetheader_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader WVALID" *)
input wire s_axi_packetheader_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader WREADY" *)
output wire s_axi_packetheader_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader BRESP" *)
output wire [1 : 0] s_axi_packetheader_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader BVALID" *)
output wire s_axi_packetheader_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader BREADY" *)
input wire s_axi_packetheader_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader ARADDR" *)
input wire [31 : 0] s_axi_packetheader_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader ARPROT" *)
input wire [2 : 0] s_axi_packetheader_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader ARVALID" *)
input wire s_axi_packetheader_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader ARREADY" *)
output wire s_axi_packetheader_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader RDATA" *)
output wire [31 : 0] s_axi_packetheader_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader RRESP" *)
output wire [1 : 0] s_axi_packetheader_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader RVALID" *)
output wire s_axi_packetheader_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_packetheader, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, NUM_READ_THREADS 1\
, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_packetheader RREADY" *)
input wire s_axi_packetheader_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *)
output wire m_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *)
output wire [31 : 0] m_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TKEEP" *)
output wire [3 : 0] m_axis_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TLAST" *)
output wire m_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TREADY" *)
input wire m_axis_tready;
input wire [31 : 0] rdata_to_user;
input wire ready_to_read;
output wire start_to_read;
output wire arst_for_imfifo;

  HighSpeed_IM_v1_0 #(
    .C_S_AXI_IM_Config_DATA_WIDTH(32),
    .C_S_AXI_IM_Config_ADDR_WIDTH(32),
    .C_S_AXI_PacketHeader_DATA_WIDTH(32),
    .C_S_AXI_PacketHeader_ADDR_WIDTH(32),
    .C_M_AXI_IM_Config_ADDR_WIDTH(32),
    .C_M_AXI_IM_Config_DATA_WIDTH(32),
    .C_M_AXI_IM_Config_TRANSACTIONS_NUM(4),
    .C_M_AXIS_TDATA_WIDTH(32),
    .C_M_AXIS_START_COUNT(32)
  ) inst (
    .elapsed_time(elapsed_time),
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axi_packetheader_awaddr(s_axi_packetheader_awaddr),
    .s_axi_packetheader_awprot(s_axi_packetheader_awprot),
    .s_axi_packetheader_awvalid(s_axi_packetheader_awvalid),
    .s_axi_packetheader_awready(s_axi_packetheader_awready),
    .s_axi_packetheader_wdata(s_axi_packetheader_wdata),
    .s_axi_packetheader_wstrb(s_axi_packetheader_wstrb),
    .s_axi_packetheader_wvalid(s_axi_packetheader_wvalid),
    .s_axi_packetheader_wready(s_axi_packetheader_wready),
    .s_axi_packetheader_bresp(s_axi_packetheader_bresp),
    .s_axi_packetheader_bvalid(s_axi_packetheader_bvalid),
    .s_axi_packetheader_bready(s_axi_packetheader_bready),
    .s_axi_packetheader_araddr(s_axi_packetheader_araddr),
    .s_axi_packetheader_arprot(s_axi_packetheader_arprot),
    .s_axi_packetheader_arvalid(s_axi_packetheader_arvalid),
    .s_axi_packetheader_arready(s_axi_packetheader_arready),
    .s_axi_packetheader_rdata(s_axi_packetheader_rdata),
    .s_axi_packetheader_rresp(s_axi_packetheader_rresp),
    .s_axi_packetheader_rvalid(s_axi_packetheader_rvalid),
    .s_axi_packetheader_rready(s_axi_packetheader_rready),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tkeep(m_axis_tkeep),
    .m_axis_tlast(m_axis_tlast),
    .m_axis_tready(m_axis_tready),
    .rdata_to_user(rdata_to_user),
    .ready_to_read(ready_to_read),
    .start_to_read(start_to_read),
    .arst_for_imfifo(arst_for_imfifo)
  );
endmodule
