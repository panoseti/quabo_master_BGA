-makelib ies_lib/xil_defaultlib -sv \
  "/home/wei/Software/Vivado/install/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/home/wei/Software/Vivado/install/Vivado/2018.3/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "/home/wei/Software/Vivado/install/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/home/wei/Software/Vivado/install/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_3 \
  "../../../ipstatic/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_3 \
  "../../../ipstatic/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_3 \
  "../../../ipstatic/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../AXI_Stream_Switch.srcs/sources_1/ip/FIFO_for_AXIS_0_3/ip/fifo_generator_0/sim/fifo_generator_0.v" \
  "../../../../AXI_Stream_Switch.srcs/sources_1/ip/FIFO_for_AXIS_0_3/new/FIFO_for_AXIS.v" \
  "../../../../AXI_Stream_Switch.srcs/sources_1/ip/FIFO_for_AXIS_0_3/sim/FIFO_for_AXIS_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

