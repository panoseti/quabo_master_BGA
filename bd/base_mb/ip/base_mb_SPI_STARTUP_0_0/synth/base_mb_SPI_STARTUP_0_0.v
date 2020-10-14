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


// IP VLNV: xilinx.com:module_ref:SPI_STARTUP:1.0
// IP Revision: 1

(* X_CORE_INFO = "SPI_STARTUP,Vivado 2018.3.1_AR71948" *)
(* CHECK_LICENSE_TYPE = "base_mb_SPI_STARTUP_0_0,SPI_STARTUP,{}" *)
(* CORE_GENERATION_INFO = "base_mb_SPI_STARTUP_0_0,SPI_STARTUP,{x_ipProduct=Vivado 2018.3.1_AR71948,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=SPI_STARTUP,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module base_mb_SPI_STARTUP_0_0 (
  clk,
  rst_n,
  mb_mosi_i,
  mb_miso_o,
  mb_sck_i,
  mb_ss_i,
  mb_eos,
  wr_mosi_i,
  wr_miso_o,
  wr_sck_i,
  wr_ss_i,
  spi_sel,
  mosi_o,
  miso_i,
  ss_o
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN base_mb_clk_wiz_1_0_clk_100, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *)
input wire rst_n;
input wire mb_mosi_i;
output wire mb_miso_o;
input wire mb_sck_i;
input wire mb_ss_i;
output wire mb_eos;
input wire wr_mosi_i;
output wire wr_miso_o;
input wire wr_sck_i;
input wire wr_ss_i;
input wire spi_sel;
output wire mosi_o;
input wire miso_i;
output wire ss_o;

  SPI_STARTUP inst (
    .clk(clk),
    .rst_n(rst_n),
    .mb_mosi_i(mb_mosi_i),
    .mb_miso_o(mb_miso_o),
    .mb_sck_i(mb_sck_i),
    .mb_ss_i(mb_ss_i),
    .mb_eos(mb_eos),
    .wr_mosi_i(wr_mosi_i),
    .wr_miso_o(wr_miso_o),
    .wr_sck_i(wr_sck_i),
    .wr_ss_i(wr_ss_i),
    .spi_sel(spi_sel),
    .mosi_o(mosi_o),
    .miso_i(miso_i),
    .ss_o(ss_o)
  );
endmodule
