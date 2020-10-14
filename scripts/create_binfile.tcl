#TCL script to generate a quabo bitstream and set the firmware version readback parameter
#source this script from the quabo_master/build directory
# source -notrace create_binfile.tcl
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}
# Set the project name- must be the same as that used in build_quabo.tcl
set _xil_proj_name_ "quabo_V0116_BGA"
# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}
# Set the directory path for the original project from where this script was exported
#set orig_proj_dir "[file normalize "$origin_dir./$_xil_proj_name_"]"
set orig_proj_dir "[file normalize "$origin_dir./../build/$_xil_proj_name_"]"
puts $orig_proj_dir

puts $orig_proj_dir/$_xil_proj_name_.xpr
#current_project $_xil_proj_name_
open_project $orig_proj_dir/$_xil_proj_name_.xpr
#open the implemented design
open_run impl_1

#Get the epoch time, in seconds, and subtract 1e9 to make it fit in 32 bits
#TCL has a funny way of saying c = a - b!
set trunc_seconds [tcl::mathop::- [clock seconds] 1000000000]
#make a hex string of the value
set trunc_seconds_hex [format %X $trunc_seconds]
puts [format "epoch time %d hex value %s" $trunc_seconds $trunc_seconds_hex]
#Ask the user for a version number
set version_string xxxx
puts  "Input a four-character version number"
gets stdin version_string
if {[string length $version_string] != 4} {set version_string xxxx}
puts [format "Version is %s" $version_string]
#Convert this into a list of ascii values
scan $version_string %c%c%c%c c0 c1 c2 c3
#TCL always returns string, so we need to convert these decimal strings to hex. Phew!
set c0_hex [format %X $c0]
set c1_hex [format %X $c1]
set c2_hex [format %X $c2]
set c3_hex [format %X $c3]
#concatenate the 4-char (32b) version number with the 32b epoch time, to make
# 64b LUT INIT value, in Verilog format
set init_string [join [list "64'h" $c0_hex $c1_hex $c2_hex $c3_hex $trunc_seconds_hex] ""]
puts [format "INIT String is %s" $init_string]

#Set the INIT value of the LUT (implemented design must be open for this to work)
set_property INIT $init_string [get_cells -hierarchical *ROM64X1_FWID*]
#Make the bitstream with the new value of FWID.  This will include the .elf file, because it is associated 
#  with the Microblaze in the hardware design
puts "Running write_bitstream, will take a couple minutes"
write_bitstream -force -quiet quabo_fwid.bit
set binfilename [join [list "quabo_" $version_string "_" $trunc_seconds_hex ".bin"] ""]
#puts "Running write_cfgmem, " $binfilename
write_cfgmem  -force -format bin -size 32 -interface SPIx1 -loadbit {up 0x00000000 "quabo_fwid.bit" } \
    -file $binfilename
    #-file "quabo_$version_string/_$trunc_seconds_hex.bin"

close_project