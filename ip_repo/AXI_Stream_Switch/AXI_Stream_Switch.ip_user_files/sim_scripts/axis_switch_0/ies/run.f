-makelib ies_lib/xil_defaultlib -sv \
  "/home/wei/Software/Vivado/install/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/home/wei/Software/Vivado/install/Vivado/2018.3/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "/home/wei/Software/Vivado/install/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/home/wei/Software/Vivado/install/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/axis_infrastructure_v1_1_0 \
  "../../../ipstatic/hdl/axis_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axis_register_slice_v1_1_18 \
  "../../../ipstatic/hdl/axis_register_slice_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axis_switch_v1_1_18 \
  "../../../ipstatic/hdl/axis_switch_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../AXI_Stream_Switch.srcs/sources_1/ip/axis_switch_0/sim/axis_switch_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

