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


// IP VLNV: user.org:user:ETH_CORE_CTRL:2.1
// IP Revision: 4

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module base_mb_ETH_CORE_CTRL_0_1 (
  clk,
  rst,
  s_axis_txd_tdata,
  s_axis_txd_tkeep,
  s_axis_txd_tlast,
  s_axis_txd_tvalid,
  s_axis_txd_tready,
  m_axis_txd_tdata,
  m_axis_txd_tkeep,
  m_axis_txd_tlast,
  m_axis_txd_tvalid,
  m_axis_txd_tready,
  m_axis_txc_tready,
  m_axis_txc_tvalid,
  m_axis_txc_tlast,
  m_axis_txc_tdata,
  m_axis_txc_tkeep
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF m_axis_txc:m_axis_txd:s_axis_txd, ASSOCIATED_RESET rst, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *)
input wire rst;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_txd TDATA" *)
input wire [31 : 0] s_axis_txd_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_txd TKEEP" *)
input wire [3 : 0] s_axis_txd_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_txd TLAST" *)
input wire s_axis_txd_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_txd TVALID" *)
input wire s_axis_txd_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axis_txd, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_txd TREADY" *)
output wire s_axis_txd_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_txd TDATA" *)
output wire [31 : 0] m_axis_txd_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_txd TKEEP" *)
output wire [3 : 0] m_axis_txd_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_txd TLAST" *)
output wire m_axis_txd_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_txd TVALID" *)
output wire m_axis_txd_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis_txd, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_txd TREADY" *)
input wire m_axis_txd_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_txc TREADY" *)
input wire m_axis_txc_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_txc TVALID" *)
output wire m_axis_txc_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_txc TLAST" *)
output wire m_axis_txc_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_txc TDATA" *)
output wire [31 : 0] m_axis_txc_tdata;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis_txc, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_txc TKEEP" *)
output wire [3 : 0] m_axis_txc_tkeep;

  ETH_CORE_CTRL inst (
    .clk(clk),
    .rst(rst),
    .s_axis_txd_tdata(s_axis_txd_tdata),
    .s_axis_txd_tkeep(s_axis_txd_tkeep),
    .s_axis_txd_tlast(s_axis_txd_tlast),
    .s_axis_txd_tvalid(s_axis_txd_tvalid),
    .s_axis_txd_tready(s_axis_txd_tready),
    .m_axis_txd_tdata(m_axis_txd_tdata),
    .m_axis_txd_tkeep(m_axis_txd_tkeep),
    .m_axis_txd_tlast(m_axis_txd_tlast),
    .m_axis_txd_tvalid(m_axis_txd_tvalid),
    .m_axis_txd_tready(m_axis_txd_tready),
    .m_axis_txc_tready(m_axis_txc_tready),
    .m_axis_txc_tvalid(m_axis_txc_tvalid),
    .m_axis_txc_tlast(m_axis_txc_tlast),
    .m_axis_txc_tdata(m_axis_txc_tdata),
    .m_axis_txc_tkeep(m_axis_txc_tkeep)
  );
endmodule
