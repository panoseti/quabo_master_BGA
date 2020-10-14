-- (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: user.org:user:wrc_board_quabo_Light:1.2
-- IP Revision: 2

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY base_mb_wrc_board_quabo_Light_0_2 IS
  PORT (
    clk_20m_vcxo_i : IN STD_LOGIC;
    clk_125m_gtx_n_i : IN STD_LOGIC;
    clk_125m_gtx_p_i : IN STD_LOGIC;
    plldac_sclk_o : OUT STD_LOGIC;
    plldac_din_o : OUT STD_LOGIC;
    pll25dac_cs_n_o : OUT STD_LOGIC;
    pll20dac_cs_n_o : OUT STD_LOGIC;
    sfp_txp_o : OUT STD_LOGIC;
    sfp_txn_o : OUT STD_LOGIC;
    sfp_rxp_i : IN STD_LOGIC;
    sfp_rxn_i : IN STD_LOGIC;
    sfp_mod_def0_i : IN STD_LOGIC;
    sfp_mod_def1_b : INOUT STD_LOGIC;
    sfp_mod_def2_b : INOUT STD_LOGIC;
    sfp_rate_select_o : OUT STD_LOGIC;
    sfp_tx_fault_i : IN STD_LOGIC;
    sfp_tx_disable_o : OUT STD_LOGIC;
    sfp_los_i : IN STD_LOGIC;
    onewire_b : INOUT STD_LOGIC;
    uart_rxd_i : IN STD_LOGIC;
    uart_txd_o : OUT STD_LOGIC;
    spi_sclk_o : OUT STD_LOGIC;
    spi_ncs_o : OUT STD_LOGIC;
    spi_mosi_o : OUT STD_LOGIC;
    spi_miso_i : IN STD_LOGIC;
    reset_i : IN STD_LOGIC;
    clk_ext_10m : IN STD_LOGIC;
    pps_o : OUT STD_LOGIC;
    clk_sys_o : OUT STD_LOGIC
  );
END base_mb_wrc_board_quabo_Light_0_2;

ARCHITECTURE base_mb_wrc_board_quabo_Light_0_2_arch OF base_mb_wrc_board_quabo_Light_0_2 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF base_mb_wrc_board_quabo_Light_0_2_arch: ARCHITECTURE IS "yes";
  COMPONENT wrc_board_quabo IS
    GENERIC (
      g_dpram_initf : STRING;
      g_simulation : INTEGER
    );
    PORT (
      clk_20m_vcxo_i : IN STD_LOGIC;
      clk_125m_gtx_n_i : IN STD_LOGIC;
      clk_125m_gtx_p_i : IN STD_LOGIC;
      plldac_sclk_o : OUT STD_LOGIC;
      plldac_din_o : OUT STD_LOGIC;
      pll25dac_cs_n_o : OUT STD_LOGIC;
      pll20dac_cs_n_o : OUT STD_LOGIC;
      sfp_txp_o : OUT STD_LOGIC;
      sfp_txn_o : OUT STD_LOGIC;
      sfp_rxp_i : IN STD_LOGIC;
      sfp_rxn_i : IN STD_LOGIC;
      sfp_mod_def0_i : IN STD_LOGIC;
      sfp_mod_def1_b : INOUT STD_LOGIC;
      sfp_mod_def2_b : INOUT STD_LOGIC;
      sfp_rate_select_o : OUT STD_LOGIC;
      sfp_tx_fault_i : IN STD_LOGIC;
      sfp_tx_disable_o : OUT STD_LOGIC;
      sfp_los_i : IN STD_LOGIC;
      onewire_b : INOUT STD_LOGIC;
      uart_rxd_i : IN STD_LOGIC;
      uart_txd_o : OUT STD_LOGIC;
      spi_sclk_o : OUT STD_LOGIC;
      spi_ncs_o : OUT STD_LOGIC;
      spi_mosi_o : OUT STD_LOGIC;
      spi_miso_i : IN STD_LOGIC;
      reset_i : IN STD_LOGIC;
      clk_ext_10m : IN STD_LOGIC;
      pps_o : OUT STD_LOGIC;
      clk_sys_o : OUT STD_LOGIC
    );
  END COMPONENT wrc_board_quabo;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF base_mb_wrc_board_quabo_Light_0_2_arch: ARCHITECTURE IS "wrc_board_quabo,Vivado 2018.3.1_AR71948";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF base_mb_wrc_board_quabo_Light_0_2_arch : ARCHITECTURE IS "base_mb_wrc_board_quabo_Light_0_2,wrc_board_quabo,{}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF base_mb_wrc_board_quabo_Light_0_2_arch: ARCHITECTURE IS "package_project";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF reset_i: SIGNAL IS "XIL_INTERFACENAME reset_i, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF reset_i: SIGNAL IS "xilinx.com:signal:reset:1.0 reset_i RST";
  ATTRIBUTE X_INTERFACE_INFO OF spi_miso_i: SIGNAL IS "user:user:flash_spi:1.0 flash_spi spi_miso_i";
  ATTRIBUTE X_INTERFACE_INFO OF spi_mosi_o: SIGNAL IS "user:user:flash_spi:1.0 flash_spi spi_mosi_o";
  ATTRIBUTE X_INTERFACE_INFO OF spi_ncs_o: SIGNAL IS "user:user:flash_spi:1.0 flash_spi spi_ncs_o";
  ATTRIBUTE X_INTERFACE_INFO OF spi_sclk_o: SIGNAL IS "user:user:flash_spi:1.0 flash_spi spi_sclk_o";
  ATTRIBUTE X_INTERFACE_INFO OF uart_txd_o: SIGNAL IS "user.org:user:uart:1.0 uart uart_txd_o";
  ATTRIBUTE X_INTERFACE_INFO OF uart_rxd_i: SIGNAL IS "user.org:user:uart:1.0 uart uart_rxd_i";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_los_i: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_los_i";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_tx_disable_o: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_tx_disable_o";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_tx_fault_i: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_tx_fault_i";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_rate_select_o: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_rate_select_o";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_mod_def2_b: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_mod_def2_b";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_mod_def1_b: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_mod_def1_b";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_mod_def0_i: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_mod_def0_i";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_rxn_i: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_rxn_i";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_rxp_i: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_rxp_i";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_txn_o: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_txn_o";
  ATTRIBUTE X_INTERFACE_INFO OF sfp_txp_o: SIGNAL IS "user.org:user:sfp:1.0 sfp sfp_txp_o";
BEGIN
  U0 : wrc_board_quabo
    GENERIC MAP (
      g_dpram_initf => "../../../../quabo_master/ip_repo/wr-cores-Quabo/ram_init/wrc_phy16_sdb.bram",
      g_simulation => 0
    )
    PORT MAP (
      clk_20m_vcxo_i => clk_20m_vcxo_i,
      clk_125m_gtx_n_i => clk_125m_gtx_n_i,
      clk_125m_gtx_p_i => clk_125m_gtx_p_i,
      plldac_sclk_o => plldac_sclk_o,
      plldac_din_o => plldac_din_o,
      pll25dac_cs_n_o => pll25dac_cs_n_o,
      pll20dac_cs_n_o => pll20dac_cs_n_o,
      sfp_txp_o => sfp_txp_o,
      sfp_txn_o => sfp_txn_o,
      sfp_rxp_i => sfp_rxp_i,
      sfp_rxn_i => sfp_rxn_i,
      sfp_mod_def0_i => sfp_mod_def0_i,
      sfp_mod_def1_b => sfp_mod_def1_b,
      sfp_mod_def2_b => sfp_mod_def2_b,
      sfp_rate_select_o => sfp_rate_select_o,
      sfp_tx_fault_i => sfp_tx_fault_i,
      sfp_tx_disable_o => sfp_tx_disable_o,
      sfp_los_i => sfp_los_i,
      onewire_b => onewire_b,
      uart_rxd_i => uart_rxd_i,
      uart_txd_o => uart_txd_o,
      spi_sclk_o => spi_sclk_o,
      spi_ncs_o => spi_ncs_o,
      spi_mosi_o => spi_mosi_o,
      spi_miso_i => spi_miso_i,
      reset_i => reset_i,
      clk_ext_10m => clk_ext_10m,
      pps_o => pps_o,
      clk_sys_o => clk_sys_o
    );
END base_mb_wrc_board_quabo_Light_0_2_arch;
