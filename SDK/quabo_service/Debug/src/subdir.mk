################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/EthCore_Configuration.c \
../src/main.c \
../src/packet_header.c \
../src/platform.c \
../src/platform_mb.c 

OBJS += \
./src/EthCore_Configuration.o \
./src/main.o \
./src/packet_header.o \
./src/platform.o \
./src/platform_mb.o 

C_DEPS += \
./src/EthCore_Configuration.d \
./src/main.d \
./src/packet_header.d \
./src/platform.d \
./src/platform_mb.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O0 -g3 -I../../standalone_bsp_0/microblaze_0/include -c -fmessage-length=0 -MT"$@" -mxl-frequency -mxl-frequency -mxl-frequency -mxl-frequency -mxl-frequency -mxl-frequency -mxl-frequency -I../../standalone_bsp_0/microblaze_0/include -mlittle-endian -mcpu=v11.0 -mxl-soft-mul -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


