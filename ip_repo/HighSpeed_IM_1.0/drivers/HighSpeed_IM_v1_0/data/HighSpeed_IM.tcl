

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "HighSpeed_IM" "NUM_INSTANCES" "DEVICE_ID"  "C_S_AXI_IM_Config_BASEADDR" "C_S_AXI_IM_Config_HIGHADDR" "C_S_AXI_PacketHeader_BASEADDR" "C_S_AXI_PacketHeader_HIGHADDR"
}
