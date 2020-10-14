files = [
  "gtp_bitslide.vhd",
];

if (syn_device[0:4].upper()=="XC6S"): # Spartan6
	files.extend(["spartan6/wr_gtp_phy_spartan6.vhd",
                "spartan6/whiterabbitgtp_wrapper_tile_spartan6.vhd",
                "spartan6/gtp_phase_align.vhd"])
elif (syn_device[0:4].upper()=="XC6V"): # Virtex6
	files.extend(["virtex6/wr_gtx_phy_virtex6.vhd",
                "virtex6/whiterabbitgtx_wrapper_gtx.vhd",
                "virtex6/gtp_phase_align_virtex6.vhd",
                "virtex6/gtx_reset.vhd"])
elif (syn_device[0:4].upper()=="XC7A"): # Family 7 GTP (Artix7)
	files.extend(["family7-gtp/wr_gtp_phy_family7.vhd",
                "family7-gtp/whiterabbit_gtpe2_channel_wrapper.vhd",
                "family7-gtp/whiterabbit_gtpe2_channel_wrapper_gt.vhd",
                "family7-gtp/whiterabbit_gtpe2_channel_wrapper_gtrxreset_seq.vhd" ]);
elif (syn_device[0:4].upper()=="XC7K" or # Family 7 GTX (Kintex7 and Virtex7 585, 2000, X485)
      syn_device[0:7].upper()=="XC7V585" or
      syn_device[0:8].upper()=="XC7V2000" or
      syn_device[0:8].upper()=="XC7VX485"):
	files.extend(["family7-gtx/wr_gtx_phy_family7.vhd",
                "family7-gtx/whiterabbit_gtxe2_channel_wrapper_gt.vhd"]);
elif (syn_device[0:4].upper()=="XC7V"): # Family 7 GTH (other Virtex7 devices)
	files.extend(["family7-gth/wr_gth_phy_family7.vhd",
                "whiterabbit_gthe2_channel_wrapper_gt.vhd",
                "whiterabbit_gthe2_channel_wrapper_gtrxreset_seq.vhd",
                "whiterabbit_gthe2_channel_wrapper_sync_block.vhd" ]);
                