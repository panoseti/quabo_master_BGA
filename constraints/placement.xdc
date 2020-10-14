#The following pblock definition was useful to get rid of timing violations associated with the fast reset
#  nets between the Elapsed Time counters (4-phase counters at 250MHz, thus 1ns reset paths).  
#  When the triggers were remapped for the BGA version, these caused a placement problem.  But no timing errors cropped up.
#  If timing errors come back, we may need to revisit these
#create_pblock pblock_ctr_reset
#add_cells_to_pblock [get_pblocks pblock_ctr_reset] [get_cells -quiet [list base_mb_i/elapsed_time_gen_0/inst/counter_reset_1_reg base_mb_i/elapsed_time_gen_0/inst/counter_reset_2_reg base_mb_i/elapsed_time_gen_0/inst/counter_reset_3_reg]]
#resize_pblock [get_pblocks pblock_ctr_reset] -add {SLICE_X30Y39:SLICE_X31Y40}

#These constraints prevent some critical warnings from being issued during implementation
set_property IOB FALSE [get_cells base_mb_i/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/LOGIC_FOR_MD_0_GEN.SPI_MODULE_I/RATIO_NOT_EQUAL_4_GENERATE.SCK_O_NQ_4_NO_STARTUP_USED.SCK_O_NE_4_FDRE_INST]
set_property IOB FALSE [get_cells base_mb_i/axi_quad_spi_1/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/LOGIC_FOR_MD_0_GEN.SPI_MODULE_I/RATIO_NOT_EQUAL_4_GENERATE.SCK_O_NQ_4_NO_STARTUP_USED.SCK_O_NE_4_FDRE_INST]
