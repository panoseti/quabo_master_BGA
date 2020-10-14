//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3_AR71948 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Wed Sep 23 15:23:40 2020
//Host        : RIXLAB2018 running 64-bit major release  (build 9200)
//Command     : generate_target base_mb_wrapper.bd
//Design      : base_mb_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module base_mb_wrapper
   (ADC_DIN_N,
    ADC_DIN_P,
    BIT_CLK_N,
    BIT_CLK_P,
    CK_R,
    D_R,
    FRM_CLK_N,
    FRM_CLK_P,
    HV_RSTb,
    J3pin1,
    J3pin3,
    J3pin4,
    J3pin5,
    J3pin6,
    MISO,
    MOSI,
    PCBrev_n,
    RSTB_R,
    SC_CLK,
    SC_DIN,
    SC_DOUT,
    SC_RSTb,
    SMA_J1,
    SPI_CK,
    SPI_SS,
    adc_clk_out,
    board_loc,
    clk_125m_gtx_n_i_0,
    clk_125m_gtx_p_i_0,
    clk_20m_vcxo_i_0,
    flash_dac,
    flash_led_n,
    flash_led_p,
    focus_down_lim,
    focus_limits_on,
    focus_up_lim,
    hold1,
    hold2,
    iic_main_scl_io,
    iic_main_sda_io,
    maroc_trig0_0,
    maroc_trig1_0,
    maroc_trig2_0,
    maroc_trig3_0,
    mgt_clk_0_clk_n,
    mgt_clk_0_clk_p,
    miso_i_0,
    mosi_o_0,
    onewire_b_0,
    or_trig0_0,
    or_trig1_0,
    or_trig2_0,
    or_trig3_0,
    pll20dac_cs_n_o_0,
    pll25dac_cs_n_o_0,
    pps_inout_0,
    sd0_sc,
    sd1_ss,
    sd2_spare,
    sd3_lss,
    sfp_0_rxn,
    sfp_0_rxp,
    sfp_0_txn,
    sfp_0_txp,
    sfp_1_rxn,
    sfp_1_rxp,
    sfp_1_txn,
    sfp_1_txp,
    shutter_down_lim,
    shutter_up_lim,
    ss_o_0,
    stim_dac,
    stim_drive,
    sysclkin_n,
    sysclkin_p,
    sysclkout_n,
    sysclkout_p,
    user_sfp_0_sfp_los_i,
    user_sfp_0_sfp_mod_def1_b,
    user_sfp_0_sfp_mod_def2_b,
    user_sfp_0_sfp_rxn_i,
    user_sfp_0_sfp_rxp_i,
    user_sfp_0_sfp_txn_o,
    user_sfp_0_sfp_txp_o);
  input [3:0]ADC_DIN_N;
  input [3:0]ADC_DIN_P;
  input [0:0]BIT_CLK_N;
  input [0:0]BIT_CLK_P;
  output [3:0]CK_R;
  output [3:0]D_R;
  input FRM_CLK_N;
  input FRM_CLK_P;
  output [0:0]HV_RSTb;
  output [0:0]J3pin1;
  input J3pin3;
  output J3pin4;
  input J3pin5;
  output J3pin6;
  input MISO;
  output MOSI;
  input [0:0]PCBrev_n;
  output [3:0]RSTB_R;
  output [3:0]SC_CLK;
  input [3:0]SC_DIN;
  output [3:0]SC_DOUT;
  output [3:0]SC_RSTb;
  output SMA_J1;
  output SPI_CK;
  output [3:0]SPI_SS;
  output adc_clk_out;
  input [9:0]board_loc;
  input clk_125m_gtx_n_i_0;
  input clk_125m_gtx_p_i_0;
  input clk_20m_vcxo_i_0;
  output flash_dac;
  output flash_led_n;
  output flash_led_p;
  input [0:0]focus_down_lim;
  output [0:0]focus_limits_on;
  input [0:0]focus_up_lim;
  output [3:0]hold1;
  output [3:0]hold2;
  inout iic_main_scl_io;
  inout iic_main_sda_io;
  input [63:0]maroc_trig0_0;
  input [63:0]maroc_trig1_0;
  input [63:0]maroc_trig2_0;
  input [63:0]maroc_trig3_0;
  input mgt_clk_0_clk_n;
  input mgt_clk_0_clk_p;
  input miso_i_0;
  output mosi_o_0;
  inout onewire_b_0;
  input [1:0]or_trig0_0;
  input [1:0]or_trig1_0;
  input [1:0]or_trig2_0;
  input [1:0]or_trig3_0;
  output pll20dac_cs_n_o_0;
  output pll25dac_cs_n_o_0;
  inout pps_inout_0;
  output sd0_sc;
  inout sd1_ss;
  output sd2_spare;
  inout sd3_lss;
  input sfp_0_rxn;
  input sfp_0_rxp;
  output sfp_0_txn;
  output sfp_0_txp;
  input sfp_1_rxn;
  input sfp_1_rxp;
  output sfp_1_txn;
  output sfp_1_txp;
  input [0:0]shutter_down_lim;
  input [0:0]shutter_up_lim;
  output ss_o_0;
  output stim_dac;
  output stim_drive;
  input sysclkin_n;
  input sysclkin_p;
  output sysclkout_n;
  output sysclkout_p;
  input user_sfp_0_sfp_los_i;
  inout user_sfp_0_sfp_mod_def1_b;
  inout user_sfp_0_sfp_mod_def2_b;
  input user_sfp_0_sfp_rxn_i;
  input user_sfp_0_sfp_rxp_i;
  output user_sfp_0_sfp_txn_o;
  output user_sfp_0_sfp_txp_o;

  wire [3:0]ADC_DIN_N;
  wire [3:0]ADC_DIN_P;
  wire [0:0]BIT_CLK_N;
  wire [0:0]BIT_CLK_P;
  wire [3:0]CK_R;
  wire [3:0]D_R;
  wire FRM_CLK_N;
  wire FRM_CLK_P;
  wire [0:0]HV_RSTb;
  wire [0:0]J3pin1;
  wire J3pin3;
  wire J3pin4;
  wire J3pin5;
  wire J3pin6;
  wire MISO;
  wire MOSI;
  wire [0:0]PCBrev_n;
  wire [3:0]RSTB_R;
  wire [3:0]SC_CLK;
  wire [3:0]SC_DIN;
  wire [3:0]SC_DOUT;
  wire [3:0]SC_RSTb;
  wire SMA_J1;
  wire SPI_CK;
  wire [3:0]SPI_SS;
  wire adc_clk_out;
  wire [9:0]board_loc;
  wire clk_125m_gtx_n_i_0;
  wire clk_125m_gtx_p_i_0;
  wire clk_20m_vcxo_i_0;
  wire flash_dac;
  wire flash_led_n;
  wire flash_led_p;
  wire [0:0]focus_down_lim;
  wire [0:0]focus_limits_on;
  wire [0:0]focus_up_lim;
  wire [3:0]hold1;
  wire [3:0]hold2;
  wire iic_main_scl_i;
  wire iic_main_scl_io;
  wire iic_main_scl_o;
  wire iic_main_scl_t;
  wire iic_main_sda_i;
  wire iic_main_sda_io;
  wire iic_main_sda_o;
  wire iic_main_sda_t;
  wire [63:0]maroc_trig0_0;
  wire [63:0]maroc_trig1_0;
  wire [63:0]maroc_trig2_0;
  wire [63:0]maroc_trig3_0;
  wire mgt_clk_0_clk_n;
  wire mgt_clk_0_clk_p;
  wire miso_i_0;
  wire mosi_o_0;
  wire onewire_b_0;
  wire [1:0]or_trig0_0;
  wire [1:0]or_trig1_0;
  wire [1:0]or_trig2_0;
  wire [1:0]or_trig3_0;
  wire pll20dac_cs_n_o_0;
  wire pll25dac_cs_n_o_0;
  wire pps_inout_0;
  wire sd0_sc;
  wire sd1_ss;
  wire sd2_spare;
  wire sd3_lss;
  wire sfp_0_rxn;
  wire sfp_0_rxp;
  wire sfp_0_txn;
  wire sfp_0_txp;
  wire sfp_1_rxn;
  wire sfp_1_rxp;
  wire sfp_1_txn;
  wire sfp_1_txp;
  wire [0:0]shutter_down_lim;
  wire [0:0]shutter_up_lim;
  wire ss_o_0;
  wire stim_dac;
  wire stim_drive;
  wire sysclkin_n;
  wire sysclkin_p;
  wire sysclkout_n;
  wire sysclkout_p;
  wire user_sfp_0_sfp_los_i;
  wire user_sfp_0_sfp_mod_def1_b;
  wire user_sfp_0_sfp_mod_def2_b;
  wire user_sfp_0_sfp_rxn_i;
  wire user_sfp_0_sfp_rxp_i;
  wire user_sfp_0_sfp_txn_o;
  wire user_sfp_0_sfp_txp_o;

  base_mb base_mb_i
       (.ADC_DIN_N(ADC_DIN_N),
        .ADC_DIN_P(ADC_DIN_P),
        .BIT_CLK_N(BIT_CLK_N),
        .BIT_CLK_P(BIT_CLK_P),
        .CK_R(CK_R),
        .D_R(D_R),
        .FRM_CLK_N(FRM_CLK_N),
        .FRM_CLK_P(FRM_CLK_P),
        .HV_RSTb(HV_RSTb),
        .J3pin1(J3pin1),
        .J3pin3(J3pin3),
        .J3pin4(J3pin4),
        .J3pin5(J3pin5),
        .J3pin6(J3pin6),
        .MISO(MISO),
        .MOSI(MOSI),
        .PCBrev_n(PCBrev_n),
        .RSTB_R(RSTB_R),
        .SC_CLK(SC_CLK),
        .SC_DIN(SC_DIN),
        .SC_DOUT(SC_DOUT),
        .SC_RSTb(SC_RSTb),
        .SMA_J1(SMA_J1),
        .SPI_CK(SPI_CK),
        .SPI_SS(SPI_SS),
        .adc_clk_out(adc_clk_out),
        .board_loc(board_loc),
        .clk_125m_gtx_n_i_0(clk_125m_gtx_n_i_0),
        .clk_125m_gtx_p_i_0(clk_125m_gtx_p_i_0),
        .clk_20m_vcxo_i_0(clk_20m_vcxo_i_0),
        .flash_dac(flash_dac),
        .flash_led_n(flash_led_n),
        .flash_led_p(flash_led_p),
        .focus_down_lim(focus_down_lim),
        .focus_limits_on(focus_limits_on),
        .focus_up_lim(focus_up_lim),
        .hold1(hold1),
        .hold2(hold2),
        .iic_main_scl_i(iic_main_scl_i),
        .iic_main_scl_o(iic_main_scl_o),
        .iic_main_scl_t(iic_main_scl_t),
        .iic_main_sda_i(iic_main_sda_i),
        .iic_main_sda_o(iic_main_sda_o),
        .iic_main_sda_t(iic_main_sda_t),
        .maroc_trig0_0(maroc_trig0_0),
        .maroc_trig1_0(maroc_trig1_0),
        .maroc_trig2_0(maroc_trig2_0),
        .maroc_trig3_0(maroc_trig3_0),
        .mgt_clk_0_clk_n(mgt_clk_0_clk_n),
        .mgt_clk_0_clk_p(mgt_clk_0_clk_p),
        .miso_i_0(miso_i_0),
        .mosi_o_0(mosi_o_0),
        .onewire_b_0(onewire_b_0),
        .or_trig0_0(or_trig0_0),
        .or_trig1_0(or_trig1_0),
        .or_trig2_0(or_trig2_0),
        .or_trig3_0(or_trig3_0),
        .pll20dac_cs_n_o_0(pll20dac_cs_n_o_0),
        .pll25dac_cs_n_o_0(pll25dac_cs_n_o_0),
        .pps_inout_0(pps_inout_0),
        .sd0_sc(sd0_sc),
        .sd1_ss(sd1_ss),
        .sd2_spare(sd2_spare),
        .sd3_lss(sd3_lss),
        .sfp_0_rxn(sfp_0_rxn),
        .sfp_0_rxp(sfp_0_rxp),
        .sfp_0_txn(sfp_0_txn),
        .sfp_0_txp(sfp_0_txp),
        .sfp_1_rxn(sfp_1_rxn),
        .sfp_1_rxp(sfp_1_rxp),
        .sfp_1_txn(sfp_1_txn),
        .sfp_1_txp(sfp_1_txp),
        .shutter_down_lim(shutter_down_lim),
        .shutter_up_lim(shutter_up_lim),
        .ss_o_0(ss_o_0),
        .stim_dac(stim_dac),
        .stim_drive(stim_drive),
        .sysclkin_n(sysclkin_n),
        .sysclkin_p(sysclkin_p),
        .sysclkout_n(sysclkout_n),
        .sysclkout_p(sysclkout_p),
        .user_sfp_0_sfp_los_i(user_sfp_0_sfp_los_i),
        .user_sfp_0_sfp_mod_def1_b(user_sfp_0_sfp_mod_def1_b),
        .user_sfp_0_sfp_mod_def2_b(user_sfp_0_sfp_mod_def2_b),
        .user_sfp_0_sfp_rxn_i(user_sfp_0_sfp_rxn_i),
        .user_sfp_0_sfp_rxp_i(user_sfp_0_sfp_rxp_i),
        .user_sfp_0_sfp_txn_o(user_sfp_0_sfp_txn_o),
        .user_sfp_0_sfp_txp_o(user_sfp_0_sfp_txp_o));
  IOBUF iic_main_scl_iobuf
       (.I(iic_main_scl_o),
        .IO(iic_main_scl_io),
        .O(iic_main_scl_i),
        .T(iic_main_scl_t));
  IOBUF iic_main_sda_iobuf
       (.I(iic_main_sda_o),
        .IO(iic_main_sda_io),
        .O(iic_main_sda_i),
        .T(iic_main_sda_t));
endmodule
