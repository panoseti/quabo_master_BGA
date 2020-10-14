################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/casper_src/casper_tapcp.c \
../src/casper_src/casper_tftp.c \
../src/casper_src/csl.c \
../src/casper_src/flash.c \
../src/casper_src/gpio_spi_sel.c \
../src/casper_src/icap.c \
../src/casper_src/spi.c \
../src/casper_src/tftp_server.c \
../src/casper_src/tmrctr.c 

OBJS += \
./src/casper_src/casper_tapcp.o \
./src/casper_src/casper_tftp.o \
./src/casper_src/csl.o \
./src/casper_src/flash.o \
./src/casper_src/gpio_spi_sel.o \
./src/casper_src/icap.o \
./src/casper_src/spi.o \
./src/casper_src/tftp_server.o \
./src/casper_src/tmrctr.o 

C_DEPS += \
./src/casper_src/casper_tapcp.d \
./src/casper_src/casper_tftp.d \
./src/casper_src/csl.d \
./src/casper_src/flash.d \
./src/casper_src/gpio_spi_sel.d \
./src/casper_src/icap.d \
./src/casper_src/spi.d \
./src/casper_src/tftp_server.d \
./src/casper_src/tmrctr.d 


# Each subdirectory must supply rules for building sources it contributes
src/casper_src/%.o: ../src/casper_src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O2 -c -fmessage-length=0 -MT"$@" -mxl-frequency -mxl-frequency -mxl-frequency -mxl-frequency -mxl-frequency -mxl-frequency -mxl-frequency -I../../standalone_bsp_0/microblaze_0/include -mlittle-endian -mcpu=v11.0 -mxl-soft-mul -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


