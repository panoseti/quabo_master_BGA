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


// IP VLNV: xilinx.com:module_ref:flash_control:1.0
// IP Revision: 1

(* X_CORE_INFO = "flash_control,Vivado 2018.3.1_AR71948" *)
(* CHECK_LICENSE_TYPE = "base_mb_flash_control_0_0,flash_control,{}" *)
(* CORE_GENERATION_INFO = "base_mb_flash_control_0_0,flash_control,{x_ipProduct=Vivado 2018.3.1_AR71948,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=flash_control,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,clk_div=0x02000}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module base_mb_flash_control_0_0 (
  hs_clk,
  clk,
  one_pps,
  width,
  level,
  rate,
  flash_dac,
  pulse_p,
  pulse_n
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME hs_clk, FREQ_HZ 250000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_0_0_clk_250, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 hs_clk CLK" *)
input wire hs_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
input wire one_pps;
input wire [3 : 0] width;
input wire [4 : 0] level;
input wire [2 : 0] rate;
output wire flash_dac;
output wire pulse_p;
output wire pulse_n;

  flash_control #(
    .clk_div(20'H02000)
  ) inst (
    .hs_clk(hs_clk),
    .clk(clk),
    .one_pps(one_pps),
    .width(width),
    .level(level),
    .rate(rate),
    .flash_dac(flash_dac),
    .pulse_p(pulse_p),
    .pulse_n(pulse_n)
  );
endmodule
