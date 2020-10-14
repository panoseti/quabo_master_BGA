#include "xparameters.h"
#include "xgpio.h"
#include "gpio_spi_sel.h"

#define GPIO_SPI_SEL_DEVICE_ID XPAR_AXI_SPI_SEL_DEVICE_ID
#define GPIO_OUT_CHAN 1
static XGpio Gpio_sel;

int init_gpio_spi_sel()
{
	//set up gpio
	int Status;
	Status = XGpio_Initialize(&Gpio_sel, GPIO_SPI_SEL_DEVICE_ID);
	if (Status != 0)  return 1;
	//default output is high, so we select wr by default
	XGpio_SetDataDirection(&Gpio_sel, GPIO_OUT_CHAN, 0x1);
	XGpio_DiscreteWrite(&Gpio_sel, GPIO_OUT_CHAN, 0x1);
	return 0;
}

void gpio_sel_wr()
{
	XGpio_DiscreteWrite(&Gpio_sel, GPIO_OUT_CHAN, 0x1);
}

void gpio_sel_mb()
{
	XGpio_DiscreteWrite(&Gpio_sel, GPIO_OUT_CHAN, 0x0);
}
