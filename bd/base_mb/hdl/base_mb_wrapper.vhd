--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
--Date        : Thu Sep 27 11:57:24 2018
--Host        : RIXLAB2018 running 64-bit major release  (build 9200)
--Command     : generate_target base_mb_wrapper.bd
--Design      : base_mb_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity base_mb_wrapper is
  port (
    ADC_DIN_N : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ADC_DIN_P : in STD_LOGIC_VECTOR ( 3 downto 0 );
    BIT_CLK_N : in STD_LOGIC_VECTOR ( 0 to 0 );
    BIT_CLK_P : in STD_LOGIC_VECTOR ( 0 to 0 );
    CK_R : out STD_LOGIC_VECTOR ( 3 downto 0 );
    D_R : out STD_LOGIC_VECTOR ( 3 downto 0 );
    FRM_CLK_N : in STD_LOGIC_VECTOR ( 0 to 0 );
    FRM_CLK_P : in STD_LOGIC_VECTOR ( 0 to 0 );
    MISO : in STD_LOGIC;
    MOSI : out STD_LOGIC;
    RSTB_R : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SC_CLK : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SC_DIN_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    SC_DOUT : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SC_RSTb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SPI_CK : out STD_LOGIC;
    SPI_SS : out STD_LOGIC_VECTOR ( 5 downto 0 );
    adc_clk_out : out STD_LOGIC;
    ext_trig_0 : in STD_LOGIC;
    hold1 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    hold2 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    iic_main_scl_io : inout STD_LOGIC;
    iic_main_sda_io : inout STD_LOGIC;
    led_8bits_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    maroc_trig0_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    maroc_trig1_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    maroc_trig2_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    maroc_trig3_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    mgt_clk_0_clk_n : in STD_LOGIC;
    mgt_clk_0_clk_p : in STD_LOGIC;
    or_trig0_0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    or_trig1_0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    or_trig2_0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    or_trig3_0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    rs232_uart_rxd : in STD_LOGIC;
    rs232_uart_txd : out STD_LOGIC;
    sfp_0_rxn : in STD_LOGIC;
    sfp_0_rxp : in STD_LOGIC;
    sfp_0_txn : out STD_LOGIC;
    sfp_0_txp : out STD_LOGIC;
    sys_diff_clock_clk_n : in STD_LOGIC;
    sys_diff_clock_clk_p : in STD_LOGIC
  );
end base_mb_wrapper;

architecture STRUCTURE of base_mb_wrapper is
  component base_mb is
  port (
    rs232_uart_rxd : in STD_LOGIC;
    rs232_uart_txd : out STD_LOGIC;
    led_8bits_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    sys_diff_clock_clk_p : in STD_LOGIC;
    sys_diff_clock_clk_n : in STD_LOGIC;
    mgt_clk_0_clk_n : in STD_LOGIC;
    mgt_clk_0_clk_p : in STD_LOGIC;
    iic_main_scl_i : in STD_LOGIC;
    iic_main_scl_o : out STD_LOGIC;
    iic_main_scl_t : out STD_LOGIC;
    iic_main_sda_i : in STD_LOGIC;
    iic_main_sda_o : out STD_LOGIC;
    iic_main_sda_t : out STD_LOGIC;
    sfp_0_rxn : in STD_LOGIC;
    sfp_0_rxp : in STD_LOGIC;
    sfp_0_txn : out STD_LOGIC;
    sfp_0_txp : out STD_LOGIC;
    MISO : in STD_LOGIC;
    MOSI : out STD_LOGIC;
    SPI_SS : out STD_LOGIC_VECTOR ( 5 downto 0 );
    SPI_CK : out STD_LOGIC;
    SC_RSTb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SC_DOUT : out STD_LOGIC_VECTOR ( 3 downto 0 );
    SC_CLK : out STD_LOGIC_VECTOR ( 3 downto 0 );
    hold1 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    hold2 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    CK_R : out STD_LOGIC_VECTOR ( 3 downto 0 );
    RSTB_R : out STD_LOGIC_VECTOR ( 3 downto 0 );
    D_R : out STD_LOGIC_VECTOR ( 3 downto 0 );
    adc_clk_out : out STD_LOGIC;
    SC_DIN_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    maroc_trig0_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    maroc_trig1_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    maroc_trig2_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    maroc_trig3_0 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    or_trig0_0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    or_trig1_0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    or_trig2_0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    or_trig3_0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    ext_trig_0 : in STD_LOGIC;
    ADC_DIN_N : in STD_LOGIC_VECTOR ( 3 downto 0 );
    FRM_CLK_P : in STD_LOGIC_VECTOR ( 0 to 0 );
    BIT_CLK_N : in STD_LOGIC_VECTOR ( 0 to 0 );
    BIT_CLK_P : in STD_LOGIC_VECTOR ( 0 to 0 );
    ADC_DIN_P : in STD_LOGIC_VECTOR ( 3 downto 0 );
    FRM_CLK_N : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component base_mb;
  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;
  signal iic_main_scl_i : STD_LOGIC;
  signal iic_main_scl_o : STD_LOGIC;
  signal iic_main_scl_t : STD_LOGIC;
  signal iic_main_sda_i : STD_LOGIC;
  signal iic_main_sda_o : STD_LOGIC;
  signal iic_main_sda_t : STD_LOGIC;
begin
base_mb_i: component base_mb
     port map (
      ADC_DIN_N(3 downto 0) => ADC_DIN_N(3 downto 0),
      ADC_DIN_P(3 downto 0) => ADC_DIN_P(3 downto 0),
      BIT_CLK_N(0) => BIT_CLK_N(0),
      BIT_CLK_P(0) => BIT_CLK_P(0),
      CK_R(3 downto 0) => CK_R(3 downto 0),
      D_R(3 downto 0) => D_R(3 downto 0),
      FRM_CLK_N(0) => FRM_CLK_N(0),
      FRM_CLK_P(0) => FRM_CLK_P(0),
      MISO => MISO,
      MOSI => MOSI,
      RSTB_R(3 downto 0) => RSTB_R(3 downto 0),
      SC_CLK(3 downto 0) => SC_CLK(3 downto 0),
      SC_DIN_0(3 downto 0) => SC_DIN_0(3 downto 0),
      SC_DOUT(3 downto 0) => SC_DOUT(3 downto 0),
      SC_RSTb(3 downto 0) => SC_RSTb(3 downto 0),
      SPI_CK => SPI_CK,
      SPI_SS(5 downto 0) => SPI_SS(5 downto 0),
      adc_clk_out => adc_clk_out,
      ext_trig_0 => ext_trig_0,
      hold1(3 downto 0) => hold1(3 downto 0),
      hold2(3 downto 0) => hold2(3 downto 0),
      iic_main_scl_i => iic_main_scl_i,
      iic_main_scl_o => iic_main_scl_o,
      iic_main_scl_t => iic_main_scl_t,
      iic_main_sda_i => iic_main_sda_i,
      iic_main_sda_o => iic_main_sda_o,
      iic_main_sda_t => iic_main_sda_t,
      led_8bits_tri_o(7 downto 0) => led_8bits_tri_o(7 downto 0),
      maroc_trig0_0(63 downto 0) => maroc_trig0_0(63 downto 0),
      maroc_trig1_0(63 downto 0) => maroc_trig1_0(63 downto 0),
      maroc_trig2_0(63 downto 0) => maroc_trig2_0(63 downto 0),
      maroc_trig3_0(63 downto 0) => maroc_trig3_0(63 downto 0),
      mgt_clk_0_clk_n => mgt_clk_0_clk_n,
      mgt_clk_0_clk_p => mgt_clk_0_clk_p,
      or_trig0_0(1 downto 0) => or_trig0_0(1 downto 0),
      or_trig1_0(1 downto 0) => or_trig1_0(1 downto 0),
      or_trig2_0(1 downto 0) => or_trig2_0(1 downto 0),
      or_trig3_0(1 downto 0) => or_trig3_0(1 downto 0),
      rs232_uart_rxd => rs232_uart_rxd,
      rs232_uart_txd => rs232_uart_txd,
      sfp_0_rxn => sfp_0_rxn,
      sfp_0_rxp => sfp_0_rxp,
      sfp_0_txn => sfp_0_txn,
      sfp_0_txp => sfp_0_txp,
      sys_diff_clock_clk_n => sys_diff_clock_clk_n,
      sys_diff_clock_clk_p => sys_diff_clock_clk_p
    );
iic_main_scl_iobuf: component IOBUF
     port map (
      I => iic_main_scl_o,
      IO => iic_main_scl_io,
      O => iic_main_scl_i,
      T => iic_main_scl_t
    );
iic_main_sda_iobuf: component IOBUF
     port map (
      I => iic_main_sda_o,
      IO => iic_main_sda_io,
      O => iic_main_sda_i,
      T => iic_main_sda_t
    );
end STRUCTURE;
