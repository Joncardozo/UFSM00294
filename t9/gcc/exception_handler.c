#include "exception_handler.h"

void (*system_calls[])() = {PrintUART, WriteDeviceRegister, ReadDeviceRegister, SetSysCall, 0, 0};// , ReadBidirectionalPort};

volatile char* send_uart_ptr = (volatile char*) UART_TX_ADDR;
volatile char* check_uart_ptr = (volatile char*) UART_READY_ADDR;

volatile int* portio_data_ptr = (volatile int*) PORTIO_DATA_ADDR;
volatile int* portio_en_ptr = (volatile int*) PORTIO_EN_ADDR;
volatile int* portio_config_ptr = (volatile int*) PORTIO_CONFIG_ADDR;

volatile int* timer_ptr = (volatile int*) TIMER_ADDR;


void PrintUART(char *string) {
    while (*string) {
        while (*check_uart_ptr == 0);
        *send_uart_ptr = *string++;
    }
}

void WriteDeviceRegister(int value, int reg_addr) {
    switch (reg_addr) {
        case PORTIO_DATA_ADDR: *portio_data_ptr = value; break;
        case PORTIO_EN_ADDR: *portio_en_ptr = value; break;
        case PORTIO_CONFIG_ADDR: *portio_config_ptr = value; break;
        case TIMER_ADDR: *timer_ptr = value; break;
    }
}

void ReadDeviceRegister(int* read_data, int reg_addr) {
    switch (reg_addr) {
        case PORTIO_DATA_ADDR: *read_data = *portio_data_ptr; break;
        case PORTIO_EN_ADDR: *read_data = *portio_en_ptr; break;
        case PORTIO_CONFIG_ADDR: *read_data = *portio_config_ptr; break;
    }
}

void SetSysCall(int n, void* handler) {
    system_calls[4 + n] = handler;
}
