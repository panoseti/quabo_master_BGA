################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name BIT_CLK_P -period 16.667 [get_ports BIT_CLK_P]
create_clock -name BIT_CLK_N -period 16.667 [get_ports BIT_CLK_N]
create_clock -name sysclkin_p -period 10 [get_ports sysclkin_p]
create_clock -name mgt_clk_0_clk_p -period 10 [get_ports mgt_clk_0_clk_p]

################################################################################