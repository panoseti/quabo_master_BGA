// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3_AR71948 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Sun Oct 13 16:29:47 2019
// Host        : Wei-Berkeley running 64-bit Ubuntu 18.04.3 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ FIFO_for_AXIS_0_stub.v
// Design      : FIFO_for_AXIS_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tfbg676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "FIFO_for_AXIS,Vivado 2018.3_AR71948" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, rst, s_axis_tdata, s_axis_tkeep, 
  s_axis_tvalid, s_axis_tlast, s_axis_tready, m_axis_tdata, m_axis_tkeep, m_axis_tvalid, 
  m_axis_tlast, m_axis_tready)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,s_axis_tdata[31:0],s_axis_tkeep[3:0],s_axis_tvalid,s_axis_tlast,s_axis_tready,m_axis_tdata[31:0],m_axis_tkeep[3:0],m_axis_tvalid,m_axis_tlast,m_axis_tready" */;
  input clk;
  input rst;
  input [31:0]s_axis_tdata;
  input [3:0]s_axis_tkeep;
  input s_axis_tvalid;
  input s_axis_tlast;
  output s_axis_tready;
  output [31:0]m_axis_tdata;
  output [3:0]m_axis_tkeep;
  output m_axis_tvalid;
  output m_axis_tlast;
  input m_axis_tready;
endmodule
