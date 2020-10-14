################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name s_axi_lite_clk -period 10 [get_ports s_axi_lite_clk]
create_clock -name axis_clk -period 10 [get_ports axis_clk]
create_clock -name rxuserclk -period 16 [get_ports rxuserclk]
create_clock -name rxuserclk2 -period 16 [get_ports rxuserclk2]
create_clock -name userclk -period 16 [get_ports userclk]
create_clock -name userclk2 -period 8 [get_ports userclk2]
create_clock -name gt0_qplloutclk_in -period 10 [get_ports gt0_qplloutclk_in]
create_clock -name gt0_qplloutrefclk_in -period 10 [get_ports gt0_qplloutrefclk_in]
create_clock -name gtref_clk -period 8 [get_ports gtref_clk]
create_clock -name gtref_clk_buf -period 8 [get_ports gtref_clk_buf]
create_clock -name ref_clk -period 5 [get_ports ref_clk]

################################################################################