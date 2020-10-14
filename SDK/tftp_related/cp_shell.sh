#! /bin/sh
if [ $# -gt 0 ]
then
	echo 'copy the code to: '${1}
else
	echo 'No folder, check please'
	exit
fi

cp netif.h ${1}/microblaze_0/include/lwip
cp netif.h ${1}/microblaze_0/libsrc/lwip202_v1_2/src/lwip-2.0.2/src/include/lwip

cp opt.h ${1}/microblaze_0/include/lwip
cp opt.h ${1}/microblaze_0/libsrc/lwip202_v1_2/src/lwip-2.0.2/src/include/lwip

cp cc.h ${1}/microblaze_0/libsrc/lwip202_v1_2/src/contrib/ports/xilinx/include/arch

cp xaxiemacif.c ${1}/microblaze_0/libsrc/lwip202_v1_2/src/contrib/ports/xilinx/netif
cp xaxiemacif_hw.c ${1}/microblaze_0/libsrc/lwip202_v1_2/src/contrib/ports/xilinx/netif
cp -r ./casper_include/*.h ${1}/microblaze_0/include/

cp -r ./casper_src ../quabo_service/src

cp platform.c ../quabo_service/src


