# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "eth"

}

proc update_PARAM_VALUE.eth { PARAM_VALUE.eth } {
	# Procedure called to update eth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.eth { PARAM_VALUE.eth } {
	# Procedure called to validate eth
	return true
}


proc update_MODELPARAM_VALUE.eth { MODELPARAM_VALUE.eth PARAM_VALUE.eth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.eth}] ${MODELPARAM_VALUE.eth}
}

