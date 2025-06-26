#include "exception_handler.h"

void (*system_calls[])() = {PrintUART, WriteDeviceRegister, ReadDeviceRegister};// , ReadBidirectionalPort};

volatile char* send_uart_ptr = (volatile char*) UART_TX_ADDR;
volatile char* check_uart_ptr = (volatile char*) UART_READY_ADDR;

volatile int* portio_data_ptr = (volatile int*) PORTIO_DATA_ADDR;
volatile int* portio_en_ptr = (volatile int*) PORTIO_EN_ADDR;
volatile int* portio_config_ptr = (volatile int*) PORTIO_CONFIG_ADDR;


void PrintUART(char *string) {
    while (*string) {
        while (*check_uart_ptr == 0);
        *send_uart_ptr = *string++;
    }
}

void WriteDeviceRegister(int value, int reg_addr) {
    if (reg_addr == PORTIO_DATA_ADDR) {
        *portio_data_ptr = value;
    } else if (reg_addr == PORTIO_EN_ADDR) {
        *portio_en_ptr = value;
    } else if (reg_addr == PORTIO_CONFIG_ADDR) {
        *portio_config_ptr = value;
    }
}

void ReadDeviceRegister(int* read_data, int reg_addr) {
    if (reg_addr == PORTIO_DATA_ADDR) {
        *read_data = *portio_data_ptr;
    } else if (reg_addr == PORTIO_EN_ADDR) {
        *read_data = *portio_en_ptr;
    } else if (reg_addr == PORTIO_CONFIG_ADDR) {
        *read_data = *portio_config_ptr;
    }
}

// void ReadBidirectionalPort(int* read_data){
//     *read_data = *portio_data_ptr;
//     return;
// }
