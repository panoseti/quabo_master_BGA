
################################################################
# This is a generated script based on design: base_mb
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source base_mb_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# OBUFDS_FOR_CLK, SPI_MUX, SPI_STARTUP, SPI_access, elapsed_time_gen, flash_control, in_buf_ds_1bit, in_buf_ds_4bit, in_buf_ds_1bit, stepper_control, stim_gen

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7k160tffg676-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name base_mb

# This script was generated for a remote BD. To create a non-remote design,
# change the variable <run_remote_bd_flow> to <0>.

set run_remote_bd_flow 1
if { $run_remote_bd_flow == 1 } {
  # Set the reference directory for source file relative paths (by default 
  # the value is script directory path)
  set origin_dir ./bd

  # Use origin directory path location variable, if specified in the tcl shell
  if { [info exists ::origin_dir_loc] } {
     set origin_dir $::origin_dir_loc
  }

  set str_bd_folder [file normalize ${origin_dir}]
  set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

  # Check if remote design exists on disk
  if { [file exists $str_bd_filepath ] == 1 } {
     catch {common::send_msg_id "BD_TCL-110" "ERROR" "The remote BD file path <$str_bd_filepath> already exists!"}
     common::send_msg_id "BD_TCL-008" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0>."
     common::send_msg_id "BD_TCL-009" "INFO" "Also make sure there is no design <$design_name> existing in your current project."

     return 1
  }

  # Check if design exists in memory
  set list_existing_designs [get_bd_designs -quiet $design_name]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-111" "ERROR" "The design <$design_name> already exists in this project! Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-010" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Check if design exists on disk within project
  set list_existing_designs [get_files -quiet */${design_name}.bd]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-112" "ERROR" "The design <$design_name> already exists in this project at location:
    $list_existing_designs"}
     catch {common::send_msg_id "BD_TCL-113" "ERROR" "Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-011" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Now can create the remote BD
  # NOTE - usage of <-dir> will create <$str_bd_folder/$design_name/$design_name.bd>
  create_bd_design -dir $str_bd_folder $design_name
} else {

  # Create regular design
  if { [catch {create_bd_design $design_name} errmsg] } {
     common::send_msg_id "BD_TCL-012" "INFO" "Please set a different value to variable <design_name>."

     return 1
  }
}

current_bd_design $design_name

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set diff_clock_rtl_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 diff_clock_rtl_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $diff_clock_rtl_0
  set iic_main [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main ]
  set mgt_clk_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 mgt_clk_0 ]
  set sfp_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sfp_rtl:1.0 sfp_0 ]
  set sfp_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sfp_rtl:1.0 sfp_1 ]

  # Create ports
  set ADC_DIN_N [ create_bd_port -dir I -from 3 -to 0 ADC_DIN_N ]
  set ADC_DIN_P [ create_bd_port -dir I -from 3 -to 0 ADC_DIN_P ]
  set BIT_CLK_N [ create_bd_port -dir I -from 0 -to 0 -type clk BIT_CLK_N ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {60000000} \
 ] $BIT_CLK_N
  set BIT_CLK_P [ create_bd_port -dir I -from 0 -to 0 -type clk BIT_CLK_P ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {60000000} \
 ] $BIT_CLK_P
  set CK_R [ create_bd_port -dir O -from 3 -to 0 CK_R ]
  set D_R [ create_bd_port -dir O -from 3 -to 0 D_R ]
  set FRM_CLK_N [ create_bd_port -dir I FRM_CLK_N ]
  set FRM_CLK_P [ create_bd_port -dir I FRM_CLK_P ]
  set HV_RSTb [ create_bd_port -dir O -from 0 -to 0 HV_RSTb ]
  set J3pin1 [ create_bd_port -dir O J3pin1 ]
  set J3pin3 [ create_bd_port -dir I J3pin3 ]
  set J3pin4 [ create_bd_port -dir O J3pin4 ]
  set J3pin5 [ create_bd_port -dir I J3pin5 ]
  set J3pin6 [ create_bd_port -dir O J3pin6 ]
  set MISO [ create_bd_port -dir I MISO ]
  set MOSI [ create_bd_port -dir O MOSI ]
  set RSTB_R [ create_bd_port -dir O -from 3 -to 0 RSTB_R ]
  set SC_CLK [ create_bd_port -dir O -from 3 -to 0 -type clk SC_CLK ]
  set SC_DIN [ create_bd_port -dir I -from 3 -to 0 SC_DIN ]
  set SC_DOUT [ create_bd_port -dir O -from 3 -to 0 SC_DOUT ]
  set SC_RSTb [ create_bd_port -dir O -from 3 -to 0 SC_RSTb ]
  set SMA_J1 [ create_bd_port -dir O -from 0 -to 0 SMA_J1 ]
  set SPI_CK [ create_bd_port -dir O SPI_CK ]
  set SPI_SS [ create_bd_port -dir O -from 3 -to 0 SPI_SS ]
  set adc_clk_out [ create_bd_port -dir O adc_clk_out ]
  set board_loc [ create_bd_port -dir I -from 9 -to 0 board_loc ]
  set clk_125m_gtx_n_i_0 [ create_bd_port -dir I clk_125m_gtx_n_i_0 ]
  set clk_125m_gtx_p_i_0 [ create_bd_port -dir I clk_125m_gtx_p_i_0 ]
  set clk_20m_vcxo_i_0 [ create_bd_port -dir I clk_20m_vcxo_i_0 ]
  set flash_dac [ create_bd_port -dir O flash_dac ]
  set flash_led_n [ create_bd_port -dir O flash_led_n ]
  set flash_led_p [ create_bd_port -dir O flash_led_p ]
  set focus_down_lim [ create_bd_port -dir I -from 0 -to 0 focus_down_lim ]
  set focus_limits_on [ create_bd_port -dir O -from 0 -to 0 focus_limits_on ]
  set focus_up_lim [ create_bd_port -dir I -from 0 -to 0 focus_up_lim ]
  set hold1 [ create_bd_port -dir O -from 3 -to 0 hold1 ]
  set hold2 [ create_bd_port -dir O -from 3 -to 0 hold2 ]
  set maroc_trig0_0 [ create_bd_port -dir I -from 63 -to 0 maroc_trig0_0 ]
  set maroc_trig1_0 [ create_bd_port -dir I -from 63 -to 0 maroc_trig1_0 ]
  set maroc_trig2_0 [ create_bd_port -dir I -from 63 -to 0 maroc_trig2_0 ]
  set maroc_trig3_0 [ create_bd_port -dir I -from 63 -to 0 maroc_trig3_0 ]
  set miso_i_0 [ create_bd_port -dir I miso_i_0 ]
  set mosi_o_0 [ create_bd_port -dir O mosi_o_0 ]
  set onewire_b_0 [ create_bd_port -dir IO onewire_b_0 ]
  set or_trig0_0 [ create_bd_port -dir I -from 1 -to 0 or_trig0_0 ]
  set or_trig1_0 [ create_bd_port -dir I -from 1 -to 0 or_trig1_0 ]
  set or_trig2_0 [ create_bd_port -dir I -from 1 -to 0 or_trig2_0 ]
  set or_trig3_0 [ create_bd_port -dir I -from 1 -to 0 or_trig3_0 ]
  set pll20dac_cs_n_o_0 [ create_bd_port -dir O pll20dac_cs_n_o_0 ]
  set pll25dac_cs_n_o_0 [ create_bd_port -dir O pll25dac_cs_n_o_0 ]
  set shutter_down_lim [ create_bd_port -dir I -from 0 -to 0 shutter_down_lim ]
  set shutter_open [ create_bd_port -dir O -from 0 -to 0 shutter_open ]
  set shutter_power [ create_bd_port -dir O -from 0 -to 0 shutter_power ]
  set shutter_up_lim [ create_bd_port -dir I -from 0 -to 0 shutter_up_lim ]
  set ss_o_0 [ create_bd_port -dir O ss_o_0 ]
  set step_drive [ create_bd_port -dir O -from 3 -to 0 step_drive ]
  set stim_dac [ create_bd_port -dir O stim_dac ]
  set stim_drive [ create_bd_port -dir O stim_drive ]
  set sysclkin_n [ create_bd_port -dir I -type clk sysclkin_n ]
  set sysclkin_p [ create_bd_port -dir I -type clk sysclkin_p ]
  set sysclkout_n [ create_bd_port -dir O sysclkout_n ]
  set sysclkout_p [ create_bd_port -dir O sysclkout_p ]
  set user_sfp_0_sfp_los_i [ create_bd_port -dir I user_sfp_0_sfp_los_i ]
  set user_sfp_0_sfp_mod_def1_b [ create_bd_port -dir IO user_sfp_0_sfp_mod_def1_b ]
  set user_sfp_0_sfp_mod_def2_b [ create_bd_port -dir IO user_sfp_0_sfp_mod_def2_b ]
  set user_sfp_0_sfp_rxn_i [ create_bd_port -dir I user_sfp_0_sfp_rxn_i ]
  set user_sfp_0_sfp_rxp_i [ create_bd_port -dir I user_sfp_0_sfp_rxp_i ]
  set user_sfp_0_sfp_txn_o [ create_bd_port -dir O user_sfp_0_sfp_txn_o ]
  set user_sfp_0_sfp_txp_o [ create_bd_port -dir O user_sfp_0_sfp_txp_o ]

  # Create instance: Bit_0_0, and set properties
  set Bit_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_0_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {32} \
 ] $Bit_0_0

  # Create instance: Bit_0_15, and set properties
  set Bit_0_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_0_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {16} \
 ] $Bit_0_15

  # Create instance: Bit_10_13, and set properties
  set Bit_10_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_10_13 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {13} \
   CONFIG.DIN_TO {10} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {4} \
 ] $Bit_10_13

  # Create instance: Bit_14_14, and set properties
  set Bit_14_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_14_14 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $Bit_14_14

  # Create instance: Bit_15_15, and set properties
  set Bit_15_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_15_15 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $Bit_15_15

  # Create instance: Bit_16_16, and set properties
  set Bit_16_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_16_16 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $Bit_16_16

  # Create instance: Bit_16_18, and set properties
  set Bit_16_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_16_18 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {18} \
   CONFIG.DIN_TO {16} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {3} \
 ] $Bit_16_18

  # Create instance: Bit_19_23, and set properties
  set Bit_19_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_19_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {19} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {5} \
 ] $Bit_19_23

  # Create instance: Bit_1_1, and set properties
  set Bit_1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_1_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $Bit_1_1

  # Create instance: Bit_21_21, and set properties
  set Bit_21_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_21_21 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $Bit_21_21

  # Create instance: Bit_22_22, and set properties
  set Bit_22_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_22_22 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $Bit_22_22

  # Create instance: Bit_23_23, and set properties
  set Bit_23_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_23_23 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $Bit_23_23

  # Create instance: Bit_24_27, and set properties
  set Bit_24_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_24_27 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {24} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {4} \
 ] $Bit_24_27

  # Create instance: Bit_28_28, and set properties
  set Bit_28_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_28_28 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {1} \
 ] $Bit_28_28

  # Create instance: Bit_2_9, and set properties
  set Bit_2_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Bit_2_9 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {32} \
   CONFIG.DOUT_WIDTH {8} \
 ] $Bit_2_9

  # Create instance: GPIO, and set properties
  set GPIO [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 GPIO ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO2_WIDTH {10} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $GPIO

  # Create instance: OBUFDS_FOR_CLK_0, and set properties
  set block_name OBUFDS_FOR_CLK
  set block_cell_name OBUFDS_FOR_CLK_0
  if { [catch {set OBUFDS_FOR_CLK_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $OBUFDS_FOR_CLK_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: SPI_MUX_1, and set properties
  set block_name SPI_MUX
  set block_cell_name SPI_MUX_1
  if { [catch {set SPI_MUX_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $SPI_MUX_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: SPI_STARTUP_0, and set properties
  set block_name SPI_STARTUP
  set block_cell_name SPI_STARTUP_0
  if { [catch {set SPI_STARTUP_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $SPI_STARTUP_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: SPI_access_0, and set properties
  set block_name SPI_access
  set block_cell_name SPI_access_0
  if { [catch {set SPI_access_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $SPI_access_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_ethernet_0, and set properties
  set axi_ethernet_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet_0 ]
  set_property -dict [ list \
   CONFIG.DIFFCLK_BOARD_INTERFACE {Custom} \
   CONFIG.ETHERNET_BOARD_INTERFACE {Custom} \
   CONFIG.MDIO_BOARD_INTERFACE {Custom} \
   CONFIG.PHYRST_BOARD_INTERFACE {Custom} \
   CONFIG.PHY_TYPE {1000BaseX} \
   CONFIG.USE_BOARD_FLOW {false} \
 ] $axi_ethernet_0

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_rxd_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_rxs_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_txc_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_txd_arstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rxd:m_axis_rxs:s_axis_txc:s_axis_txd} \
   CONFIG.ASSOCIATED_RESET {axi_rxd_arstn:axi_rxs_arstn:axi_txc_arstn:axi_txd_arstn} \
 ] [get_bd_pins /axi_ethernet_0/axis_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /axi_ethernet_0/gtref_clk_buf_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /axi_ethernet_0/gtref_clk_out]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {LEVEL_HIGH} \
 ] [get_bd_pins /axi_ethernet_0/interrupt]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] [get_bd_pins /axi_ethernet_0/mac_irq]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] [get_bd_pins /axi_ethernet_0/pma_reset_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
 ] [get_bd_pins /axi_ethernet_0/ref_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /axi_ethernet_0/rxuserclk2_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /axi_ethernet_0/rxuserclk_out]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi} \
   CONFIG.ASSOCIATED_RESET {s_axi_lite_resetn} \
 ] [get_bd_pins /axi_ethernet_0/s_axi_lite_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/s_axi_lite_resetn]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /axi_ethernet_0/userclk2_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /axi_ethernet_0/userclk_out]

  # Create instance: axi_ethernet_0_fifo, and set properties
  set axi_ethernet_0_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.2 axi_ethernet_0_fifo ]
  set_property -dict [ list \
   CONFIG.C_HAS_AXIS_TKEEP {true} \
   CONFIG.C_RX_FIFO_DEPTH {4096} \
   CONFIG.C_RX_FIFO_PE_THRESHOLD {10} \
   CONFIG.C_RX_FIFO_PF_THRESHOLD {4000} \
   CONFIG.C_TX_FIFO_DEPTH {4096} \
   CONFIG.C_TX_FIFO_PE_THRESHOLD {10} \
   CONFIG.C_TX_FIFO_PF_THRESHOLD {4000} \
 ] $axi_ethernet_0_fifo

  # Create instance: axi_ethernet_1, and set properties
  set axi_ethernet_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet_1 ]
  set_property -dict [ list \
   CONFIG.PHY_TYPE {1000BaseX} \
   CONFIG.SupportLevel {0} \
 ] $axi_ethernet_1

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/axi_rxd_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/axi_rxs_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/axi_txc_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/axi_txd_arstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rxd:m_axis_rxs:s_axis_txc:s_axis_txd} \
   CONFIG.ASSOCIATED_RESET {axi_rxd_arstn:axi_rxs_arstn:axi_txc_arstn:axi_txd_arstn} \
 ] [get_bd_pins /axi_ethernet_1/axis_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /axi_ethernet_1/gtref_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /axi_ethernet_1/gtref_clk_buf]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {LEVEL_HIGH} \
 ] [get_bd_pins /axi_ethernet_1/interrupt]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] [get_bd_pins /axi_ethernet_1/mac_irq]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] [get_bd_pins /axi_ethernet_1/pma_reset]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
 ] [get_bd_pins /axi_ethernet_1/ref_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /axi_ethernet_1/rxoutclk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /axi_ethernet_1/rxuserclk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /axi_ethernet_1/rxuserclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi} \
   CONFIG.ASSOCIATED_RESET {s_axi_lite_resetn} \
 ] [get_bd_pins /axi_ethernet_1/s_axi_lite_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/s_axi_lite_resetn]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /axi_ethernet_1/txoutclk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {62500000} \
 ] [get_bd_pins /axi_ethernet_1/userclk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /axi_ethernet_1/userclk2]

  # Create instance: axi_ethernet_1_fifo, and set properties
  set axi_ethernet_1_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.2 axi_ethernet_1_fifo ]
  set_property -dict [ list \
   CONFIG.C_HAS_AXIS_TKEEP {true} \
   CONFIG.C_RX_FIFO_DEPTH {4096} \
   CONFIG.C_RX_FIFO_PE_THRESHOLD {10} \
   CONFIG.C_RX_FIFO_PF_THRESHOLD {4000} \
   CONFIG.C_TX_FIFO_DEPTH {4096} \
   CONFIG.C_TX_FIFO_PE_THRESHOLD {10} \
   CONFIG.C_TX_FIFO_PF_THRESHOLD {4000} \
 ] $axi_ethernet_1_fifo

  # Create instance: axi_fifo_mm_s_IM, and set properties
  set axi_fifo_mm_s_IM [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.2 axi_fifo_mm_s_IM ]
  set_property -dict [ list \
   CONFIG.C_RX_FIFO_DEPTH {4096} \
   CONFIG.C_RX_FIFO_PF_THRESHOLD {3840} \
   CONFIG.C_USE_TX_CTRL {0} \
   CONFIG.C_USE_TX_DATA {0} \
 ] $axi_fifo_mm_s_IM

  # Create instance: axi_fifo_mm_s_PH, and set properties
  set axi_fifo_mm_s_PH [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.2 axi_fifo_mm_s_PH ]
  set_property -dict [ list \
   CONFIG.C_RX_FIFO_DEPTH {4096} \
   CONFIG.C_RX_FIFO_PF_THRESHOLD {3840} \
   CONFIG.C_USE_TX_CTRL {0} \
   CONFIG.C_USE_TX_DATA {0} \
 ] $axi_fifo_mm_s_PH

  # Create instance: axi_gpio_mech, and set properties
  set axi_gpio_mech [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_mech ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO2_WIDTH {4} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_mech

  # Create instance: axi_hwicap_0, and set properties
  set axi_hwicap_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_hwicap:3.0 axi_hwicap_0 ]

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]
  set_property -dict [ list \
   CONFIG.IIC_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_iic_0

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {6} \
 ] $axi_interconnect_0

  # Create instance: axi_quad_spi_0, and set properties
  set axi_quad_spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0 ]
  set_property -dict [ list \
   CONFIG.C_FIFO_DEPTH {16} \
   CONFIG.C_NUM_SS_BITS {4} \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
   CONFIG.FIFO_INCLUDED {0} \
 ] $axi_quad_spi_0

  # Create instance: axi_quad_spi_1, and set properties
  set axi_quad_spi_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_1 ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
 ] $axi_quad_spi_1

  # Create instance: axi_spi_sel, and set properties
  set axi_spi_sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_spi_sel ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_DOUT_DEFAULT {0x00000001} \
   CONFIG.C_GPIO_WIDTH {1} \
 ] $axi_spi_sel

  # Create instance: axi_timebase_wdt_0, and set properties
  set axi_timebase_wdt_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timebase_wdt:3.0 axi_timebase_wdt_0 ]

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]
  set_property -dict [ list \
   CONFIG.enable_timer2 {0} \
 ] $axi_timer_0

  # Create instance: axi_timer_1, and set properties
  set axi_timer_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_1 ]

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
   CONFIG.UARTLITE_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_uartlite_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {100.000} \
   CONFIG.CLKIN1_UI_JITTER {100.000} \
   CONFIG.CLKIN2_JITTER_PS {100.000} \
   CONFIG.CLKIN2_UI_JITTER {100.000} \
   CONFIG.CLKOUT1_JITTER {121.226} \
   CONFIG.CLKOUT1_PHASE_ERROR {117.286} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250} \
   CONFIG.CLKOUT2_JITTER {157.588} \
   CONFIG.CLKOUT2_PHASE_ERROR {117.286} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {62.5000} \
   CONFIG.CLKOUT2_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {121.226} \
   CONFIG.CLKOUT3_PHASE_ERROR {117.286} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {250} \
   CONFIG.CLKOUT3_REQUESTED_PHASE {90} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_JITTER {121.226} \
   CONFIG.CLKOUT4_PHASE_ERROR {117.286} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {250} \
   CONFIG.CLKOUT4_REQUESTED_PHASE {180} \
   CONFIG.CLKOUT4_USED {true} \
   CONFIG.CLKOUT5_JITTER {121.226} \
   CONFIG.CLKOUT5_PHASE_ERROR {117.286} \
   CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {250} \
   CONFIG.CLKOUT5_REQUESTED_PHASE {270} \
   CONFIG.CLKOUT5_USED {true} \
   CONFIG.CLKOUT6_JITTER {121.226} \
   CONFIG.CLKOUT6_PHASE_ERROR {117.286} \
   CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {250} \
   CONFIG.CLKOUT6_USED {true} \
   CONFIG.CLK_OUT1_PORT {clk_250} \
   CONFIG.CLK_OUT2_PORT {clk_62m5} \
   CONFIG.CLK_OUT3_PORT {clk_out250_1} \
   CONFIG.CLK_OUT4_PORT {clk_out250_2} \
   CONFIG.CLK_OUT5_PORT {clk_out250_3} \
   CONFIG.CLK_OUT6_PORT {clk_out250_0} \
   CONFIG.JITTER_OPTIONS {PS} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {16.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {16.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {16} \
   CONFIG.MMCM_CLKOUT1_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {4} \
   CONFIG.MMCM_CLKOUT2_PHASE {90.000} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {4} \
   CONFIG.MMCM_CLKOUT3_PHASE {180.000} \
   CONFIG.MMCM_CLKOUT4_DIVIDE {4} \
   CONFIG.MMCM_CLKOUT4_PHASE {270.000} \
   CONFIG.MMCM_CLKOUT5_DIVIDE {4} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.MMCM_REF_JITTER1 {0.006} \
   CONFIG.MMCM_REF_JITTER2 {0.010} \
   CONFIG.NUM_OUT_CLKS {6} \
   CONFIG.PRIM_IN_FREQ {62.5} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.USE_INCLK_STOPPED {false} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {true} \
 ] $clk_wiz_0

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {160.0} \
   CONFIG.CLKOUT1_JITTER {146.398} \
   CONFIG.CLKOUT1_PHASE_ERROR {117.286} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT2_JITTER {128.566} \
   CONFIG.CLKOUT2_PHASE_ERROR {117.286} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {247.343} \
   CONFIG.CLKOUT3_PHASE_ERROR {117.286} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {10} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLK_OUT1_PORT {clk_100} \
   CONFIG.CLK_OUT2_PORT {clk_200} \
   CONFIG.CLK_OUT3_PORT {clk_10} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {16.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {16.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {100} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.PRIM_IN_FREQ {62.5} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_1

  # Create instance: elapsed_time_gen_0, and set properties
  set block_name elapsed_time_gen
  set block_cell_name elapsed_time_gen_0
  if { [catch {set elapsed_time_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $elapsed_time_gen_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: flash_control_0, and set properties
  set block_name flash_control
  set block_cell_name flash_control_0
  if { [catch {set flash_control_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $flash_control_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: in_buf_ds_1bit_0, and set properties
  set block_name in_buf_ds_1bit
  set block_cell_name in_buf_ds_1bit_0
  if { [catch {set in_buf_ds_1bit_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $in_buf_ds_1bit_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: in_buf_ds_4bit_0, and set properties
  set block_name in_buf_ds_4bit
  set block_cell_name in_buf_ds_4bit_0
  if { [catch {set in_buf_ds_4bit_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $in_buf_ds_4bit_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: in_buf_ds_adcbitclk, and set properties
  set block_name in_buf_ds_1bit
  set block_cell_name in_buf_ds_adcbitclk
  if { [catch {set in_buf_ds_adcbitclk [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $in_buf_ds_adcbitclk eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: maroc_dc_0, and set properties
  set maroc_dc_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:maroc_dc:1.0 maroc_dc_0 ]
  set_property -dict [ list \
   CONFIG.C_M01_AXIS_TDATA_WIDTH {32} \
 ] $maroc_dc_0

  # Create instance: maroc_slow_control_0, and set properties
  set maroc_slow_control_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:maroc_slow_control:1.0 maroc_slow_control_0 ]

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_TAG_BITS {0} \
   CONFIG.C_AREA_OPTIMIZED {2} \
   CONFIG.C_CACHE_BYTE_SIZE {8192} \
   CONFIG.C_DCACHE_ADDR_TAG {0} \
   CONFIG.C_DCACHE_BYTE_SIZE {8192} \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_AXI {1} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_USE_DCACHE {0} \
   CONFIG.C_USE_ICACHE {0} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {16} \
   CONFIG.NUM_SI {2} \
 ] $microblaze_0_axi_periph

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
   CONFIG.C_AUX_RST_WIDTH {4} \
 ] $rst_clk_wiz_1_100M

  # Create instance: rst_clk_wiz_1_100M_1, and set properties
  set rst_clk_wiz_1_100M_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M_1 ]

  # Create instance: stepper_control_0, and set properties
  set block_name stepper_control
  set block_cell_name stepper_control_0
  if { [catch {set stepper_control_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $stepper_control_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: stim_gen_0, and set properties
  set block_name stim_gen
  set block_cell_name stim_gen_0
  if { [catch {set stim_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $stim_gen_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: wrc_board_quabo_Light_0, and set properties
  set wrc_board_quabo_Light_0 [ create_bd_cell -type ip -vlnv user.org:user:wrc_board_quabo_Light:1.2 wrc_board_quabo_Light_0 ]
  set_property -dict [ list \
   CONFIG.g_dpram_initf {../../../../ip_repo/wr-cores-Quabo/ram_init/wrc_phy16_sdb.bram} \
 ] $wrc_board_quabo_Light_0

  # Create instance: xadc_wiz_0, and set properties
  set xadc_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.3 xadc_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CHANNEL_ENABLE_TEMPERATURE {true} \
   CONFIG.CHANNEL_ENABLE_VBRAM {true} \
   CONFIG.CHANNEL_ENABLE_VCCAUX {true} \
   CONFIG.CHANNEL_ENABLE_VCCINT {true} \
   CONFIG.CHANNEL_ENABLE_VP_VN {false} \
   CONFIG.ENABLE_RESET {false} \
   CONFIG.EXTERNAL_MUX_CHANNEL {VP_VN} \
   CONFIG.INTERFACE_SELECTION {Enable_AXI} \
   CONFIG.OT_ALARM {false} \
   CONFIG.SEQUENCER_MODE {Continuous} \
   CONFIG.SINGLE_CHANNEL_SELECTION {VCCINT} \
   CONFIG.USER_TEMP_ALARM {false} \
   CONFIG.VCCAUX_ALARM {false} \
   CONFIG.VCCINT_ALARM {false} \
   CONFIG.XADC_STARUP_SELECTION {channel_sequencer} \
 ] $xadc_wiz_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $xlconcat_0

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_2

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $xlconstant_4

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_5

  # Create instance: xlconstant_6, and set properties
  set xlconstant_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_6 ]

  # Create instance: xlconstant_7, and set properties
  set xlconstant_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_7 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_7

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create interface connections
  connect_bd_intf_net -intf_net axi_ethernet_0_fifo_AXI_STR_TXC [get_bd_intf_pins axi_ethernet_0/s_axis_txc] [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_TXC]
  connect_bd_intf_net -intf_net axi_ethernet_0_fifo_AXI_STR_TXD [get_bd_intf_pins axi_ethernet_0/s_axis_txd] [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_TXD]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxd [get_bd_intf_pins axi_ethernet_0/m_axis_rxd] [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_RXD]
  connect_bd_intf_net -intf_net axi_ethernet_0_sfp [get_bd_intf_ports sfp_0] [get_bd_intf_pins axi_ethernet_0/sfp]
  connect_bd_intf_net -intf_net axi_ethernet_1_fifo_AXI_STR_TXC [get_bd_intf_pins axi_ethernet_1/s_axis_txc] [get_bd_intf_pins axi_ethernet_1_fifo/AXI_STR_TXC]
  connect_bd_intf_net -intf_net axi_ethernet_1_fifo_AXI_STR_TXD [get_bd_intf_pins axi_ethernet_1/s_axis_txd] [get_bd_intf_pins axi_ethernet_1_fifo/AXI_STR_TXD]
  connect_bd_intf_net -intf_net axi_ethernet_1_m_axis_rxd [get_bd_intf_pins axi_ethernet_1/m_axis_rxd] [get_bd_intf_pins axi_ethernet_1_fifo/AXI_STR_RXD]
  connect_bd_intf_net -intf_net axi_ethernet_1_sfp [get_bd_intf_ports sfp_1] [get_bd_intf_pins axi_ethernet_1/sfp]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports iic_main] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_intc_0_interrupt [get_bd_intf_pins axi_intc_0/interrupt] [get_bd_intf_pins microblaze_0/INTERRUPT]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_quad_spi_1/AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_hwicap_0/S_AXI_LITE] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins axi_spi_sel/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins axi_timer_1/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_ethernet_1/s_axi] [get_bd_intf_pins axi_interconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_ethernet_1_fifo/S_AXI] [get_bd_intf_pins axi_interconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net maroc_dc_0_M00_AXIS [get_bd_intf_pins axi_fifo_mm_s_IM/AXI_STR_RXD] [get_bd_intf_pins maroc_dc_0/M00_AXIS]
  connect_bd_intf_net -intf_net maroc_dc_0_M01_AXIS [get_bd_intf_pins axi_fifo_mm_s_PH/AXI_STR_RXD] [get_bd_intf_pins maroc_dc_0/M01_AXIS]
  connect_bd_intf_net -intf_net mgt_clk_0_1 [get_bd_intf_ports mgt_clk_0] [get_bd_intf_pins axi_ethernet_0/mgt_clk]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IP [get_bd_intf_pins microblaze_0/M_AXI_IP] [get_bd_intf_pins microblaze_0_axi_periph/S01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins maroc_slow_control_0/S00_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins axi_ethernet_0/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins axi_ethernet_0_fifo/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins maroc_dc_0/S00_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins axi_timer_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M07_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins axi_quad_spi_0/AXI_LITE] [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M09_AXI [get_bd_intf_pins GPIO/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M10_AXI [get_bd_intf_pins microblaze_0_axi_periph/M10_AXI] [get_bd_intf_pins xadc_wiz_0/s_axi_lite]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M11_AXI [get_bd_intf_pins axi_fifo_mm_s_PH/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M12_AXI [get_bd_intf_pins axi_fifo_mm_s_IM/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M13_AXI [get_bd_intf_pins axi_timebase_wdt_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M13_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M14_AXI [get_bd_intf_pins axi_gpio_mech/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M14_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M15_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M15_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]

  # Create port connections
  connect_bd_net -net BIT_CLK_N_1 [get_bd_ports BIT_CLK_N] [get_bd_pins in_buf_ds_adcbitclk/in_n]
  connect_bd_net -net BIT_CLK_P_1 [get_bd_ports BIT_CLK_P] [get_bd_pins in_buf_ds_adcbitclk/in_p]
  connect_bd_net -net Bit_0_15_Dout [get_bd_pins Bit_0_15/Dout] [get_bd_pins stepper_control_0/num_steps]
  connect_bd_net -net Bit_16_16_Dout [get_bd_pins Bit_16_16/Dout] [get_bd_pins stepper_control_0/go]
  connect_bd_net -net Bit_16_19_Dout [get_bd_pins Bit_19_23/Dout] [get_bd_pins flash_control_0/level]
  connect_bd_net -net Bit_19_24_Dout [get_bd_pins Bit_24_27/Dout] [get_bd_pins flash_control_0/width]
  connect_bd_net -net Bit_21_21_Dout [get_bd_ports shutter_open] [get_bd_pins Bit_21_21/Dout]
  connect_bd_net -net Bit_22_22_Dout [get_bd_ports shutter_power] [get_bd_pins Bit_22_22/Dout]
  connect_bd_net -net Bit_23_23_Dout [get_bd_ports focus_limits_on] [get_bd_pins Bit_23_23/Dout]
  connect_bd_net -net Bit_28_28_Dout [get_bd_pins Bit_28_28/Dout] [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net In0_0_1 [get_bd_ports focus_down_lim] [get_bd_pins stepper_control_0/down_lim] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net In1_0_1 [get_bd_ports focus_up_lim] [get_bd_pins stepper_control_0/up_lim] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net In2_0_1 [get_bd_ports shutter_down_lim] [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net In3_0_1 [get_bd_ports shutter_up_lim] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net Net [get_bd_ports onewire_b_0] [get_bd_pins wrc_board_quabo_Light_0/onewire_b]
  connect_bd_net -net Net1 [get_bd_ports user_sfp_0_sfp_mod_def2_b] [get_bd_pins wrc_board_quabo_Light_0/sfp_mod_def2_b]
  connect_bd_net -net Net2 [get_bd_ports user_sfp_0_sfp_mod_def1_b] [get_bd_pins wrc_board_quabo_Light_0/sfp_mod_def1_b]
  connect_bd_net -net Net3 [get_bd_pins axi_timer_1/capturetrig0] [get_bd_pins axi_timer_1/capturetrig1] [get_bd_pins axi_timer_1/freeze] [get_bd_pins xlconstant_7/dout]
  connect_bd_net -net OBUFDS_FOR_CLK_0_O [get_bd_ports sysclkout_p] [get_bd_pins OBUFDS_FOR_CLK_0/O]
  connect_bd_net -net OBUFDS_FOR_CLK_0_OB [get_bd_ports sysclkout_n] [get_bd_pins OBUFDS_FOR_CLK_0/OB]
  connect_bd_net -net SC_DIN_0_1 [get_bd_ports SC_DIN] [get_bd_pins maroc_slow_control_0/SC_DIN]
  connect_bd_net -net SPI_MUX_1_spi_ck [get_bd_ports SPI_CK] [get_bd_pins SPI_MUX_1/spi_ck]
  connect_bd_net -net SPI_MUX_1_spi_mosi [get_bd_ports MOSI] [get_bd_pins SPI_MUX_1/spi_mosi]
  connect_bd_net -net SPI_STARTUP_0_mb_eos [get_bd_pins SPI_STARTUP_0/mb_eos] [get_bd_pins axi_hwicap_0/eos_in]
  connect_bd_net -net SPI_STARTUP_0_mb_miso_o [get_bd_pins SPI_STARTUP_0/mb_miso_o] [get_bd_pins axi_quad_spi_1/io1_i]
  connect_bd_net -net SPI_STARTUP_0_mosi_o [get_bd_ports mosi_o_0] [get_bd_pins SPI_STARTUP_0/mosi_o]
  connect_bd_net -net SPI_STARTUP_0_ss_o [get_bd_ports ss_o_0] [get_bd_pins SPI_STARTUP_0/ss_o]
  connect_bd_net -net SPI_STARTUP_0_wr_miso_o [get_bd_pins SPI_STARTUP_0/wr_miso_o] [get_bd_pins wrc_board_quabo_Light_0/spi_miso_i]
  connect_bd_net -net SPI_access_0_int_out [get_bd_pins SPI_access_0/int_out] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_ethernet_0_fifo_interrupt [get_bd_pins axi_ethernet_0_fifo/interrupt] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_ethernet_0_fifo_mm2s_cntrl_reset_out_n [get_bd_pins axi_ethernet_0/axi_txc_arstn] [get_bd_pins axi_ethernet_0_fifo/mm2s_cntrl_reset_out_n]
  connect_bd_net -net axi_ethernet_0_fifo_mm2s_prmry_reset_out_n [get_bd_pins axi_ethernet_0/axi_txd_arstn] [get_bd_pins axi_ethernet_0_fifo/mm2s_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_0_fifo_s2mm_prmry_reset_out_n [get_bd_pins axi_ethernet_0/axi_rxd_arstn] [get_bd_pins axi_ethernet_0/axi_rxs_arstn] [get_bd_pins axi_ethernet_0_fifo/s2mm_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_0_gt0_qplloutclk_out [get_bd_pins axi_ethernet_0/gt0_qplloutclk_out] [get_bd_pins axi_ethernet_1/gt0_qplloutclk_in]
  connect_bd_net -net axi_ethernet_0_gt0_qplloutrefclk_out [get_bd_pins axi_ethernet_0/gt0_qplloutrefclk_out] [get_bd_pins axi_ethernet_1/gt0_qplloutrefclk_in]
  connect_bd_net -net axi_ethernet_0_gtref_clk_buf_out [get_bd_pins axi_ethernet_0/gtref_clk_buf_out] [get_bd_pins axi_ethernet_1/gtref_clk_buf]
  connect_bd_net -net axi_ethernet_0_gtref_clk_out [get_bd_pins axi_ethernet_0/gtref_clk_out] [get_bd_pins axi_ethernet_1/gtref_clk]
  connect_bd_net -net axi_ethernet_0_interrupt [get_bd_pins axi_ethernet_0/interrupt] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_ethernet_0_mac_irq [get_bd_pins axi_ethernet_0/mac_irq] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_ethernet_0_mmcm_locked_out [get_bd_pins axi_ethernet_0/mmcm_locked_out] [get_bd_pins axi_ethernet_1/mmcm_locked]
  connect_bd_net -net axi_ethernet_0_pma_reset_out [get_bd_pins axi_ethernet_0/pma_reset_out] [get_bd_pins axi_ethernet_1/pma_reset]
  connect_bd_net -net axi_ethernet_0_rxuserclk2_out [get_bd_pins axi_ethernet_0/rxuserclk2_out] [get_bd_pins axi_ethernet_1/rxuserclk2]
  connect_bd_net -net axi_ethernet_0_rxuserclk_out [get_bd_pins axi_ethernet_0/rxuserclk_out] [get_bd_pins axi_ethernet_1/rxuserclk]
  connect_bd_net -net axi_ethernet_0_userclk2_out [get_bd_pins axi_ethernet_0/userclk2_out] [get_bd_pins axi_ethernet_1/userclk2]
  connect_bd_net -net axi_ethernet_0_userclk_out [get_bd_pins axi_ethernet_0/userclk_out] [get_bd_pins axi_ethernet_1/userclk]
  connect_bd_net -net axi_ethernet_1_fifo_mm2s_cntrl_reset_out_n [get_bd_pins axi_ethernet_1/axi_txc_arstn] [get_bd_pins axi_ethernet_1_fifo/mm2s_cntrl_reset_out_n]
  connect_bd_net -net axi_ethernet_1_fifo_mm2s_prmry_reset_out_n [get_bd_pins axi_ethernet_1/axi_txd_arstn] [get_bd_pins axi_ethernet_1_fifo/mm2s_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_1_fifo_s2mm_prmry_reset_out_n [get_bd_pins axi_ethernet_1/axi_rxd_arstn] [get_bd_pins axi_ethernet_1/axi_rxs_arstn] [get_bd_pins axi_ethernet_1_fifo/s2mm_prmry_reset_out_n]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins Bit_0_0/Din] [get_bd_pins Bit_10_13/Din] [get_bd_pins Bit_14_14/Din] [get_bd_pins Bit_15_15/Din] [get_bd_pins Bit_16_18/Din] [get_bd_pins Bit_19_23/Din] [get_bd_pins Bit_1_1/Din] [get_bd_pins Bit_24_27/Din] [get_bd_pins Bit_28_28/Din] [get_bd_pins Bit_2_9/Din] [get_bd_pins GPIO/gpio_io_o]
  connect_bd_net -net axi_gpio_0_gpio_io_o1 [get_bd_pins Bit_0_15/Din] [get_bd_pins Bit_16_16/Din] [get_bd_pins Bit_21_21/Din] [get_bd_pins Bit_22_22/Din] [get_bd_pins Bit_23_23/Din] [get_bd_pins axi_gpio_mech/gpio_io_o]
  connect_bd_net -net axi_gpio_0_gpio_io_o2 [get_bd_pins SPI_STARTUP_0/spi_sel] [get_bd_pins axi_spi_sel/gpio_io_o]
  connect_bd_net -net axi_hwicap_0_ip2intc_irpt [get_bd_pins axi_hwicap_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net axi_quad_spi_0_io0_o [get_bd_pins SPI_MUX_1/spi_mosi1] [get_bd_pins axi_quad_spi_0/io0_o]
  connect_bd_net -net axi_quad_spi_0_sck_o [get_bd_pins SPI_MUX_1/spi_ck1] [get_bd_pins axi_quad_spi_0/sck_o]
  connect_bd_net -net axi_quad_spi_0_ss_o [get_bd_ports SPI_SS] [get_bd_pins axi_quad_spi_0/ss_o]
  connect_bd_net -net axi_quad_spi_1_io0_o [get_bd_pins SPI_STARTUP_0/mb_mosi_i] [get_bd_pins axi_quad_spi_1/io0_o]
  connect_bd_net -net axi_quad_spi_1_sck_o [get_bd_pins SPI_STARTUP_0/mb_sck_i] [get_bd_pins axi_quad_spi_1/sck_o]
  connect_bd_net -net axi_quad_spi_1_ss_o [get_bd_pins SPI_STARTUP_0/mb_ss_i] [get_bd_pins axi_quad_spi_1/ss_o]
  connect_bd_net -net axi_timebase_wdt_0_wdt_interrupt [get_bd_pins axi_timebase_wdt_0/wdt_interrupt] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_timebase_wdt_0_wdt_reset [get_bd_pins axi_timebase_wdt_0/wdt_reset] [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net axi_timer_0_interrupt [get_bd_pins axi_timer_0/interrupt] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_timer_1_interrupt [get_bd_pins axi_timer_1/interrupt] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_ports J3pin6] [get_bd_pins axi_uartlite_0/tx]
  connect_bd_net -net clk_125m_gtx_n_i_0_1 [get_bd_ports clk_125m_gtx_n_i_0] [get_bd_pins wrc_board_quabo_Light_0/clk_125m_gtx_n_i]
  connect_bd_net -net clk_125m_gtx_p_i_0_1 [get_bd_ports clk_125m_gtx_p_i_0] [get_bd_pins wrc_board_quabo_Light_0/clk_125m_gtx_p_i]
  connect_bd_net -net clk_20m_vcxo_i_0_1 [get_bd_ports clk_20m_vcxo_i_0] [get_bd_pins wrc_board_quabo_Light_0/clk_20m_vcxo_i]
  connect_bd_net -net clk_in1_n_0_1 [get_bd_ports sysclkin_n] [get_bd_pins clk_wiz_0/clk_in1_n]
  connect_bd_net -net clk_in1_p_0_1 [get_bd_ports sysclkin_p] [get_bd_pins clk_wiz_0/clk_in1_p]
  connect_bd_net -net clk_wiz_0_clk_320 [get_bd_pins clk_wiz_0/clk_250] [get_bd_pins flash_control_0/hs_clk]
  connect_bd_net -net clk_wiz_0_clk_62m5 [get_bd_pins clk_wiz_0/clk_62m5] [get_bd_pins clk_wiz_1/clk_in1] [get_bd_pins elapsed_time_gen_0/clk_62m5]
  connect_bd_net -net clk_wiz_0_clk_out250_0 [get_bd_pins clk_wiz_0/clk_out250_0] [get_bd_pins elapsed_time_gen_0/clk_250] [get_bd_pins maroc_dc_0/ET_clk]
  connect_bd_net -net clk_wiz_0_clk_out250_1 [get_bd_pins clk_wiz_0/clk_out250_1] [get_bd_pins elapsed_time_gen_0/clk_250_1] [get_bd_pins maroc_dc_0/ET_clk_1]
  connect_bd_net -net clk_wiz_0_clk_out250_2 [get_bd_pins clk_wiz_0/clk_out250_2] [get_bd_pins elapsed_time_gen_0/clk_250_2] [get_bd_pins maroc_dc_0/ET_clk_2]
  connect_bd_net -net clk_wiz_0_clk_out250_3 [get_bd_pins clk_wiz_0/clk_out250_3] [get_bd_pins elapsed_time_gen_0/clk_250_3] [get_bd_pins maroc_dc_0/ET_clk_3]
  connect_bd_net -net clk_wiz_1_clk_out2 [get_bd_pins axi_ethernet_0/ref_clk] [get_bd_pins axi_ethernet_1/ref_clk] [get_bd_pins clk_wiz_1/clk_200] [get_bd_pins maroc_dc_0/hs_clk] [get_bd_pins maroc_dc_0/ref_clk]
  connect_bd_net -net clk_wiz_1_clk_out3 [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins clk_wiz_1/clk_10] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked] [get_bd_pins rst_clk_wiz_1_100M_1/dcm_locked]
  connect_bd_net -net elapsed_time_gen_0_elapsed_time0 [get_bd_pins elapsed_time_gen_0/elapsed_time0] [get_bd_pins maroc_dc_0/elapsed_time_0]
  connect_bd_net -net elapsed_time_gen_0_elapsed_time1 [get_bd_pins elapsed_time_gen_0/elapsed_time1] [get_bd_pins maroc_dc_0/elapsed_time_1]
  connect_bd_net -net elapsed_time_gen_0_elapsed_time2 [get_bd_pins elapsed_time_gen_0/elapsed_time2] [get_bd_pins maroc_dc_0/elapsed_time_2]
  connect_bd_net -net elapsed_time_gen_0_elapsed_time3 [get_bd_pins elapsed_time_gen_0/elapsed_time3] [get_bd_pins maroc_dc_0/elapsed_time_3]
  connect_bd_net -net flash_control_0_flash_dac [get_bd_ports flash_dac] [get_bd_pins flash_control_0/flash_dac]
  connect_bd_net -net flash_control_0_pulse_n [get_bd_ports flash_led_n] [get_bd_pins flash_control_0/pulse_n]
  connect_bd_net -net flash_control_0_pulse_p [get_bd_ports flash_led_p] [get_bd_pins flash_control_0/pulse_p]
  connect_bd_net -net gpio2_io_i_0_1 [get_bd_ports board_loc] [get_bd_pins GPIO/gpio2_io_i]
  connect_bd_net -net in_buf_ds_1bit_0_out [get_bd_pins in_buf_ds_1bit_0/outp] [get_bd_pins maroc_dc_0/frm_clk]
  connect_bd_net -net in_buf_ds_4bit_0_out [get_bd_pins in_buf_ds_4bit_0/outp] [get_bd_pins maroc_dc_0/adc_din]
  connect_bd_net -net in_buf_ds_adcbitclk_outp [get_bd_pins in_buf_ds_adcbitclk/outp] [get_bd_pins maroc_dc_0/bit_clk]
  connect_bd_net -net in_n_0_1 [get_bd_ports FRM_CLK_N] [get_bd_pins in_buf_ds_1bit_0/in_n]
  connect_bd_net -net in_n_1_1 [get_bd_ports ADC_DIN_N] [get_bd_pins in_buf_ds_4bit_0/in_n]
  connect_bd_net -net in_p_0_1 [get_bd_ports FRM_CLK_P] [get_bd_pins in_buf_ds_1bit_0/in_p]
  connect_bd_net -net in_p_1_1 [get_bd_ports ADC_DIN_P] [get_bd_pins in_buf_ds_4bit_0/in_p]
  connect_bd_net -net io0_i_0_1 [get_bd_ports MISO] [get_bd_pins axi_quad_spi_0/io1_i]
  connect_bd_net -net maroc_dc_0_CK_R [get_bd_ports CK_R] [get_bd_pins maroc_dc_0/CK_R]
  connect_bd_net -net maroc_dc_0_D_R [get_bd_ports D_R] [get_bd_pins maroc_dc_0/D_R]
  connect_bd_net -net maroc_dc_0_RSTB_R [get_bd_ports RSTB_R] [get_bd_pins maroc_dc_0/RSTB_R]
  connect_bd_net -net maroc_dc_0_adc_clk_out [get_bd_ports adc_clk_out] [get_bd_pins maroc_dc_0/adc_clk_out]
  connect_bd_net -net maroc_dc_0_hold1 [get_bd_ports hold1] [get_bd_pins maroc_dc_0/hold1]
  connect_bd_net -net maroc_dc_0_hold2 [get_bd_ports hold2] [get_bd_pins maroc_dc_0/hold2]
  connect_bd_net -net maroc_dc_0_testpoint [get_bd_pins maroc_dc_0/testpoint] [get_bd_pins xlslice_3/Din]
  connect_bd_net -net maroc_slow_control_0_SC_CLK [get_bd_ports SC_CLK] [get_bd_pins maroc_slow_control_0/SC_CLK]
  connect_bd_net -net maroc_slow_control_0_SC_DOUT [get_bd_ports SC_DOUT] [get_bd_pins maroc_slow_control_0/SC_DOUT]
  connect_bd_net -net maroc_slow_control_0_SC_RSTb [get_bd_ports SC_RSTb] [get_bd_pins maroc_slow_control_0/SC_RSTb]
  connect_bd_net -net maroc_trig0_0_1 [get_bd_ports maroc_trig0_0] [get_bd_pins maroc_dc_0/maroc_trig0]
  connect_bd_net -net maroc_trig1_0_1 [get_bd_ports maroc_trig1_0] [get_bd_pins maroc_dc_0/maroc_trig1]
  connect_bd_net -net maroc_trig2_0_1 [get_bd_ports maroc_trig2_0] [get_bd_pins maroc_dc_0/maroc_trig2]
  connect_bd_net -net maroc_trig3_0_1 [get_bd_ports maroc_trig3_0] [get_bd_pins maroc_dc_0/maroc_trig3]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins GPIO/s_axi_aclk] [get_bd_pins SPI_STARTUP_0/clk] [get_bd_pins SPI_access_0/clk] [get_bd_pins axi_ethernet_0/axis_clk] [get_bd_pins axi_ethernet_0/s_axi_lite_clk] [get_bd_pins axi_ethernet_0_fifo/s_axi_aclk] [get_bd_pins axi_ethernet_1/axis_clk] [get_bd_pins axi_ethernet_1/s_axi_lite_clk] [get_bd_pins axi_ethernet_1_fifo/s_axi_aclk] [get_bd_pins axi_fifo_mm_s_IM/s_axi_aclk] [get_bd_pins axi_fifo_mm_s_PH/s_axi_aclk] [get_bd_pins axi_gpio_mech/s_axi_aclk] [get_bd_pins axi_hwicap_0/icap_clk] [get_bd_pins axi_hwicap_0/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins axi_quad_spi_1/ext_spi_clk] [get_bd_pins axi_quad_spi_1/s_axi_aclk] [get_bd_pins axi_spi_sel/s_axi_aclk] [get_bd_pins axi_timebase_wdt_0/s_axi_aclk] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins axi_timer_1/s_axi_aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_100] [get_bd_pins flash_control_0/clk] [get_bd_pins maroc_dc_0/m00_axis_aclk] [get_bd_pins maroc_dc_0/m01_axis_aclk] [get_bd_pins maroc_dc_0/s00_axi_aclk] [get_bd_pins maroc_slow_control_0/s00_axi_aclk] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/M08_ACLK] [get_bd_pins microblaze_0_axi_periph/M09_ACLK] [get_bd_pins microblaze_0_axi_periph/M10_ACLK] [get_bd_pins microblaze_0_axi_periph/M11_ACLK] [get_bd_pins microblaze_0_axi_periph/M12_ACLK] [get_bd_pins microblaze_0_axi_periph/M13_ACLK] [get_bd_pins microblaze_0_axi_periph/M14_ACLK] [get_bd_pins microblaze_0_axi_periph/M15_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins microblaze_0_axi_periph/S01_ACLK] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins rst_clk_wiz_1_100M_1/slowest_sync_clk] [get_bd_pins stepper_control_0/clk] [get_bd_pins stim_gen_0/clk] [get_bd_pins xadc_wiz_0/s_axi_aclk]
  connect_bd_net -net miso_i_0_1 [get_bd_ports miso_i_0] [get_bd_pins SPI_STARTUP_0/miso_i]
  connect_bd_net -net or_trig0_0_1 [get_bd_ports or_trig0_0] [get_bd_pins maroc_dc_0/or_trig0]
  connect_bd_net -net or_trig1_0_1 [get_bd_ports or_trig1_0] [get_bd_pins maroc_dc_0/or_trig1]
  connect_bd_net -net or_trig2_0_1 [get_bd_ports or_trig2_0] [get_bd_pins maroc_dc_0/or_trig2]
  connect_bd_net -net or_trig3_0_1 [get_bd_ports or_trig3_0] [get_bd_pins maroc_dc_0/or_trig3]
  connect_bd_net -net rst_clk_wiz_1_100M_1_peripheral_aresetn [get_bd_pins GPIO/s_axi_aresetn] [get_bd_pins axi_fifo_mm_s_IM/s_axi_aresetn] [get_bd_pins axi_fifo_mm_s_PH/s_axi_aresetn] [get_bd_pins axi_gpio_mech/s_axi_aresetn] [get_bd_pins axi_timebase_wdt_0/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M09_ARESETN] [get_bd_pins microblaze_0_axi_periph/M10_ARESETN] [get_bd_pins microblaze_0_axi_periph/M11_ARESETN] [get_bd_pins microblaze_0_axi_periph/M12_ARESETN] [get_bd_pins microblaze_0_axi_periph/M13_ARESETN] [get_bd_pins microblaze_0_axi_periph/M14_ARESETN] [get_bd_pins microblaze_0_axi_periph/M15_ARESETN] [get_bd_pins rst_clk_wiz_1_100M_1/peripheral_aresetn] [get_bd_pins xadc_wiz_0/s_axi_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins SPI_STARTUP_0/rst_n] [get_bd_pins axi_ethernet_0/s_axi_lite_resetn] [get_bd_pins axi_ethernet_0_fifo/s_axi_aresetn] [get_bd_pins axi_ethernet_1/s_axi_lite_resetn] [get_bd_pins axi_ethernet_1_fifo/s_axi_aresetn] [get_bd_pins axi_hwicap_0/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins axi_quad_spi_1/s_axi_aresetn] [get_bd_pins axi_spi_sel/s_axi_aresetn] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins axi_timer_1/s_axi_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins maroc_dc_0/m00_axis_aresetn] [get_bd_pins maroc_dc_0/m01_axis_aresetn] [get_bd_pins maroc_dc_0/s00_axi_aresetn] [get_bd_pins maroc_slow_control_0/s00_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins microblaze_0_axi_periph/S01_ARESETN] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]
  connect_bd_net -net rx_0_1 [get_bd_ports J3pin5] [get_bd_pins axi_uartlite_0/rx]
  connect_bd_net -net sfp_los_i_0_1 [get_bd_ports user_sfp_0_sfp_los_i] [get_bd_pins wrc_board_quabo_Light_0/sfp_los_i]
  connect_bd_net -net sfp_rxn_i_0_1 [get_bd_ports user_sfp_0_sfp_rxn_i] [get_bd_pins wrc_board_quabo_Light_0/sfp_rxn_i]
  connect_bd_net -net sfp_rxp_i_0_1 [get_bd_ports user_sfp_0_sfp_rxp_i] [get_bd_pins wrc_board_quabo_Light_0/sfp_rxp_i]
  connect_bd_net -net stepper_control_0_step_drive [get_bd_ports step_drive] [get_bd_pins stepper_control_0/step_drive]
  connect_bd_net -net stim_gen_0_stim_dac [get_bd_ports stim_dac] [get_bd_pins stim_gen_0/stim_dac]
  connect_bd_net -net stim_gen_0_stim_drive [get_bd_ports stim_drive] [get_bd_pins stim_gen_0/stim_drive]
  connect_bd_net -net uart_rxd_i_0_1 [get_bd_ports J3pin3] [get_bd_pins wrc_board_quabo_Light_0/uart_rxd_i]
  connect_bd_net -net wrc_board_quabo_Light_0_clk_sys_o1 [get_bd_pins OBUFDS_FOR_CLK_0/I] [get_bd_pins wrc_board_quabo_Light_0/clk_sys_o]
  connect_bd_net -net wrc_board_quabo_Light_0_pll20dac_cs_n_o [get_bd_ports pll20dac_cs_n_o_0] [get_bd_pins SPI_access_0/go] [get_bd_pins wrc_board_quabo_Light_0/pll20dac_cs_n_o]
  connect_bd_net -net wrc_board_quabo_Light_0_pll25dac_cs_n_o [get_bd_ports pll25dac_cs_n_o_0] [get_bd_pins wrc_board_quabo_Light_0/pll25dac_cs_n_o]
  connect_bd_net -net wrc_board_quabo_Light_0_plldac_din_o [get_bd_pins SPI_MUX_1/spi_mosi0] [get_bd_pins wrc_board_quabo_Light_0/plldac_din_o]
  connect_bd_net -net wrc_board_quabo_Light_0_plldac_sclk_o [get_bd_pins SPI_MUX_1/spi_ck0] [get_bd_pins wrc_board_quabo_Light_0/plldac_sclk_o]
  connect_bd_net -net wrc_board_quabo_Light_0_pps_o1 [get_bd_ports J3pin1] [get_bd_pins elapsed_time_gen_0/one_pps] [get_bd_pins flash_control_0/one_pps] [get_bd_pins wrc_board_quabo_Light_0/pps_o]
  connect_bd_net -net wrc_board_quabo_Light_0_sfp_txn_o [get_bd_ports user_sfp_0_sfp_txn_o] [get_bd_pins wrc_board_quabo_Light_0/sfp_txn_o]
  connect_bd_net -net wrc_board_quabo_Light_0_sfp_txp_o [get_bd_ports user_sfp_0_sfp_txp_o] [get_bd_pins wrc_board_quabo_Light_0/sfp_txp_o]
  connect_bd_net -net wrc_board_quabo_Light_0_spi_mosi_o [get_bd_pins SPI_STARTUP_0/wr_mosi_i] [get_bd_pins wrc_board_quabo_Light_0/spi_mosi_o]
  connect_bd_net -net wrc_board_quabo_Light_0_spi_ncs_o [get_bd_pins SPI_STARTUP_0/wr_ss_i] [get_bd_pins wrc_board_quabo_Light_0/spi_ncs_o]
  connect_bd_net -net wrc_board_quabo_Light_0_spi_sclk_o [get_bd_pins SPI_STARTUP_0/wr_sck_i] [get_bd_pins wrc_board_quabo_Light_0/spi_sclk_o]
  connect_bd_net -net wrc_board_quabo_Light_0_uart_txd_o [get_bd_ports J3pin4] [get_bd_pins wrc_board_quabo_Light_0/uart_txd_o]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins axi_gpio_mech/gpio2_io_i] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins axi_ethernet_0/signal_detect] [get_bd_pins axi_ethernet_1/signal_detect] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins axi_timer_0/capturetrig0] [get_bd_pins axi_timer_0/capturetrig1] [get_bd_pins axi_timer_0/freeze] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins rst_clk_wiz_1_100M_1/aux_reset_in] [get_bd_pins rst_clk_wiz_1_100M_1/ext_reset_in] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins wrc_board_quabo_Light_0/clk_ext_10m] [get_bd_pins wrc_board_quabo_Light_0/reset_i] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins maroc_dc_0/ext_trig] [get_bd_pins wrc_board_quabo_Light_0/sfp_mod_def0_i] [get_bd_pins xlconstant_5/dout]
  connect_bd_net -net xlconstant_6_dout [get_bd_pins wrc_board_quabo_Light_0/sfp_tx_fault_i] [get_bd_pins xlconstant_6/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_ports HV_RSTb] [get_bd_pins Bit_0_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins Bit_1_1/Dout] [get_bd_pins stim_gen_0/enable]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins Bit_2_9/Dout] [get_bd_pins stim_gen_0/level]
  connect_bd_net -net xlslice_3_Dout [get_bd_ports SMA_J1] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins Bit_10_13/Dout] [get_bd_pins stim_gen_0/rate]
  connect_bd_net -net xlslice_5_Dout [get_bd_pins Bit_14_14/Dout] [get_bd_pins SPI_MUX_1/sel]
  connect_bd_net -net xlslice_6_Dout [get_bd_pins Bit_15_15/Dout] [get_bd_pins SPI_access_0/arm]
  connect_bd_net -net xlslice_7_Dout [get_bd_pins Bit_16_18/Dout] [get_bd_pins flash_control_0/rate]

  # Create address segments
  create_bd_addr_seg -range 0x00040000 -offset 0x40C00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] SEG_axi_ethernet_0_Reg0
  create_bd_addr_seg -range 0x00040000 -offset 0x40C00000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] SEG_axi_ethernet_0_Reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI/Mem0] SEG_axi_ethernet_0_fifo_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI/Mem0] SEG_axi_ethernet_0_fifo_Mem0
  create_bd_addr_seg -range 0x00040000 -offset 0x40C40000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_ethernet_1/s_axi/Reg0] SEG_axi_ethernet_1_Reg0
  create_bd_addr_seg -range 0x00040000 -offset 0x40C40000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_ethernet_1/s_axi/Reg0] SEG_axi_ethernet_1_Reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A80000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_ethernet_1_fifo/S_AXI/Mem0] SEG_axi_ethernet_1_fifo_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A80000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_ethernet_1_fifo/S_AXI/Mem0] SEG_axi_ethernet_1_fifo_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A50000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_fifo_mm_s_PH/S_AXI/Mem0] SEG_axi_fifo_mm_s_0_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A50000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_fifo_mm_s_PH/S_AXI/Mem0] SEG_axi_fifo_mm_s_0_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A60000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_fifo_mm_s_IM/S_AXI/Mem0] SEG_axi_fifo_mm_s_IM_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A60000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_fifo_mm_s_IM/S_AXI/Mem0] SEG_axi_fifo_mm_s_IM_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs GPIO/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs GPIO/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40010000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_gpio_mech/S_AXI/Reg] SEG_axi_gpio_0_Reg1
  create_bd_addr_seg -range 0x00010000 -offset 0x40010000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_gpio_mech/S_AXI/Reg] SEG_axi_gpio_0_Reg3
  create_bd_addr_seg -range 0x00010000 -offset 0x40200000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_hwicap_0/S_AXI_LITE/Reg] SEG_axi_hwicap_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40200000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_hwicap_0/S_AXI_LITE/Reg] SEG_axi_hwicap_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40800000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40800000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] SEG_axi_intc_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] SEG_axi_intc_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_quad_spi_1/AXI_LITE/Reg] SEG_axi_quad_spi_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_quad_spi_1/AXI_LITE/Reg] SEG_axi_quad_spi_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40020000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_spi_sel/S_AXI/Reg] SEG_axi_spi_sel_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40020000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_spi_sel/S_AXI/Reg] SEG_axi_spi_sel_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41A00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_timebase_wdt_0/S_AXI/Reg] SEG_axi_timebase_wdt_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41A00000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_timebase_wdt_0/S_AXI/Reg] SEG_axi_timebase_wdt_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] SEG_axi_timer_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C00000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] SEG_axi_timer_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_timer_1/S_AXI/Reg] SEG_axi_timer_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C10000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_timer_1/S_AXI/Reg] SEG_axi_timer_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40600000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40600000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs maroc_dc_0/S00_AXI/S00_AXI_reg] SEG_maroc_dc_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs maroc_dc_0/S00_AXI/S00_AXI_reg] SEG_maroc_dc_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A20000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs maroc_slow_control_0/S00_AXI/S00_AXI_reg] SEG_maroc_slow_control_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A20000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs maroc_slow_control_0/S00_AXI/S00_AXI_reg] SEG_maroc_slow_control_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A40000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg] SEG_xadc_wiz_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A40000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg] SEG_xadc_wiz_0_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


