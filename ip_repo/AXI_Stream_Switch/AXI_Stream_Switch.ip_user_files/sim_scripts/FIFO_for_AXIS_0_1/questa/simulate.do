onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib FIFO_for_AXIS_0_opt

do {wave.do}

view wave
view structure
view signals

do {FIFO_for_AXIS_0.udo}

run -all

quit -force
