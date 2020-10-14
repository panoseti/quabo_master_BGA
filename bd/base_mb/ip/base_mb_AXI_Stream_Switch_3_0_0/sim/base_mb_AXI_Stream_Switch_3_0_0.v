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


// IP VLNV: user.org:user:AXI_Stream_Switch_3:1.2
// IP Revision: 1

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module base_mb_AXI_Stream_Switch_3_0_0 (
  aclk,
  aresetn,
  s0_axis_tdata,
  s0_axis_tkeep,
  s0_axis_tlast,
  s0_axis_tvalid,
  s0_axis_tready,
  s2_axis_tdata,
  s2_axis_tkeep,
  s2_axis_tlast,
  s2_axis_tvalid,
  m_axis_tvalid,
  m_axis_tdata,
  m_axis_tkeep,
  m_axis_tlast,
  m_axis_tready,
  s2_axis_tready,
  s1_axis_tdata,
  s1_axis_tkeep,
  s1_axis_tlast,
  s1_axis_tvalid,
  s1_axis_tready
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF S0_AXIS:S1_AXIS:S2_AXIS:M0_AXIS, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
input wire aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
input wire aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S0_AXIS TDATA" *)
input wire [31 : 0] s0_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S0_AXIS TKEEP" *)
input wire [3 : 0] s0_axis_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S0_AXIS TLAST" *)
input wire s0_axis_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S0_AXIS TVALID" *)
input wire s0_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S0_AXIS, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S0_AXIS TREADY" *)
output wire s0_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S2_AXIS TDATA" *)
input wire [31 : 0] s2_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S2_AXIS TKEEP" *)
input wire [3 : 0] s2_axis_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S2_AXIS TLAST" *)
input wire s2_axis_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S2_AXIS TVALID" *)
input wire s2_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M0_AXIS TVALID" *)
output wire m_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M0_AXIS TDATA" *)
output wire [31 : 0] m_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M0_AXIS TKEEP" *)
output wire [3 : 0] m_axis_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M0_AXIS TLAST" *)
output wire m_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M0_AXIS, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M0_AXIS TREADY" *)
input wire m_axis_tready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S2_AXIS, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S2_AXIS TREADY" *)
output wire s2_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S1_AXIS TDATA" *)
input wire [31 : 0] s1_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S1_AXIS TKEEP" *)
input wire [3 : 0] s1_axis_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S1_AXIS TLAST" *)
input wire s1_axis_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S1_AXIS TVALID" *)
input wire s1_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S1_AXIS, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S1_AXIS TREADY" *)
output wire s1_axis_tready;

  AXI_Stream_Switch_3_v1_0 #(
    .C_M0_AXIS_TDATA_WIDTH(32),  // Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
    .C_M0_AXIS_START_COUNT(32),  // Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
    .C_S0_AXIS_TDATA_WIDTH(32),  // AXI4Stream sink: Data Width
    .C_S2_AXIS_TDATA_WIDTH(32),  // AXI4Stream sink: Data Width
    .C_S1_AXIS_TDATA_WIDTH(32)  // AXI4Stream sink: Data Width
  ) inst (
    .aclk(aclk),
    .aresetn(aresetn),
    .s0_axis_tdata(s0_axis_tdata),
    .s0_axis_tkeep(s0_axis_tkeep),
    .s0_axis_tlast(s0_axis_tlast),
    .s0_axis_tvalid(s0_axis_tvalid),
    .s0_axis_tready(s0_axis_tready),
    .s2_axis_tdata(s2_axis_tdata),
    .s2_axis_tkeep(s2_axis_tkeep),
    .s2_axis_tlast(s2_axis_tlast),
    .s2_axis_tvalid(s2_axis_tvalid),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tkeep(m_axis_tkeep),
    .m_axis_tlast(m_axis_tlast),
    .m_axis_tready(m_axis_tready),
    .s2_axis_tready(s2_axis_tready),
    .s1_axis_tdata(s1_axis_tdata),
    .s1_axis_tkeep(s1_axis_tkeep),
    .s1_axis_tlast(s1_axis_tlast),
    .s1_axis_tvalid(s1_axis_tvalid),
    .s1_axis_tready(s1_axis_tready)
  );
endmodule
