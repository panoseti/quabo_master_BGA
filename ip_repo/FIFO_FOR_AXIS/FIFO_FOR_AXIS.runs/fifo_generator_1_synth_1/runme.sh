#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/wei/Software/Vivado/install/SDK/2018.3/bin:/home/wei/Software/Vivado/install/Vivado/2018.3/ids_lite/ISE/bin/lin64:/home/wei/Software/Vivado/install/Vivado/2018.3/bin
else
  PATH=/home/wei/Software/Vivado/install/SDK/2018.3/bin:/home/wei/Software/Vivado/install/Vivado/2018.3/ids_lite/ISE/bin/lin64:/home/wei/Software/Vivado/install/Vivado/2018.3/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/home/wei/Software/Vivado/install/Vivado/2018.3/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/home/wei/Software/Vivado/install/Vivado/2018.3/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/media/wei/DATA/LW/Project/Vivado_Project/IP_Cores_PanoSETI/FIFO_FOR_AXIS/FIFO_FOR_AXIS.runs/fifo_generator_1_synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log fifo_generator_1.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source fifo_generator_1.tcl
