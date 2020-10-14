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


// IP VLNV: xilinx.com:module_ref:elapsed_time_gen:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module base_mb_elapsed_time_gen_0_0 (
  clk_250,
  clk_250_1,
  clk_250_2,
  clk_250_3,
  clk_62m5,
  one_pps,
  elapsed_time0,
  elapsed_time1,
  elapsed_time2,
  elapsed_time3
);

input wire clk_250;
input wire clk_250_1;
input wire clk_250_2;
input wire clk_250_3;
input wire clk_62m5;
input wire one_pps;
output wire [28 : 0] elapsed_time0;
output wire [28 : 0] elapsed_time1;
output wire [28 : 0] elapsed_time2;
output wire [28 : 0] elapsed_time3;

  elapsed_time_gen inst (
    .clk_250(clk_250),
    .clk_250_1(clk_250_1),
    .clk_250_2(clk_250_2),
    .clk_250_3(clk_250_3),
    .clk_62m5(clk_62m5),
    .one_pps(one_pps),
    .elapsed_time0(elapsed_time0),
    .elapsed_time1(elapsed_time1),
    .elapsed_time2(elapsed_time2),
    .elapsed_time3(elapsed_time3)
  );
endmodule
