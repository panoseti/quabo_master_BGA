onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+fifo_32by128 -L xil_defaultlib -L xpm -L fifo_generator_v13_2_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.fifo_32by128 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {fifo_32by128.udo}

run -all

endsim

quit -force
