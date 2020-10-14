connect -url tcp:127.0.0.1:3121
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Platform Cable USB 0000117dd2cb01"} -index 0
rst -system
after 3000
targets -set -nocase -filter {name =~ "microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Platform Cable USB 0000117dd2cb01"} -index 0
dow /media/wei/DATA/LW/Project/Vivado_Project/Panoseti/V0103/quabo_master/SDK/quabo_service/Debug/quabo_service.elf
bpadd -addr &main
