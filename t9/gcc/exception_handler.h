#ifndef HANDLER_H
#define HANDLER_H

// enderecos UART
#define UART_TX_ADDR            0x80000300
#define UART_READY_ADDR         0x80000310

// enderecos da DMA
#define DMA_DATA_ADDR           0x80000400
#define DMA_MODE_ADDR           0x80000410
#define DMA_EOT                 0x80000420

// endereços da porta e/s
#define PORTIO_DATA_ADDR        0x80000020
#define PORTIO_EN_ADDR          0x80000000
#define PORTIO_CONFIG_ADDR      0x80000010

#define TIMER_ADDR              0x80000100

void PrintUART(char* str);
void WriteDeviceRegister(int value, int reg_addr);
void ReadDeviceRegister(int* value, int reg_addr);
void SetSysCall(int n, void* handler);

#endif
