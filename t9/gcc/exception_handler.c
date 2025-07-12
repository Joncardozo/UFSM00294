#include "exception_handler.h"

void (*system_calls[])() = {PrintUART, WriteDeviceRegister, ReadDeviceRegister};

volatile char* send_uart_ptr = (volatile char*) UART_TX_ADDR;
volatile char* check_uart_ptr = (volatile char*) UART_READY_ADDR;

volatile unsigned int* portio_data_ptr = (volatile unsigned int*) PORTIO_DATA_ADDR;
volatile unsigned* portio_en_ptr = (volatile unsigned*) PORTIO_EN_ADDR;
volatile unsigned* portio_config_ptr = (volatile unsigned*) PORTIO_CONFIG_ADDR;
volatile unsigned* portio_intr_ptr = (volatile unsigned*) PORTIO_INTR_ADDR;

volatile unsigned* timer_ptr = (volatile unsigned*) TIMER_ADDR;

volatile unsigned* intr_ctrl_mask_ptr = (volatile unsigned*) INTR_CTRL_MASK_ADDR;


void PrintUART(char *string) {
    while (*string) {
        while (*check_uart_ptr == 0);
        *send_uart_ptr = *string++;
    }
}

void WriteDeviceRegister(unsigned int value, unsigned int reg_addr) {
    switch (reg_addr) {
        case PORTIO_DATA_ADDR: *portio_data_ptr = value; break;
        case PORTIO_EN_ADDR: *portio_en_ptr = value; break;
        case PORTIO_CONFIG_ADDR: *portio_config_ptr = value; break;
        case PORTIO_INTR_ADDR: *portio_intr_ptr = value; break;
        case INTR_CTRL_MASK_ADDR: *intr_ctrl_mask_ptr = value; break;
        case TIMER_ADDR: *timer_ptr = value; break;
        default: return;
    }
}

void ReadDeviceRegister(unsigned int* read_data, unsigned int reg_addr) {
    switch (reg_addr) {
        case PORTIO_DATA_ADDR: *read_data = *portio_data_ptr; break;
        case PORTIO_EN_ADDR: *read_data = *portio_en_ptr; break;
        case PORTIO_CONFIG_ADDR: *read_data = *portio_config_ptr; break;
    }
}
