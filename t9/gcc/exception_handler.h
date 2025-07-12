#ifndef HANDLER_H
#define HANDLER_H

// enderecos UART
#define UART_TX_ADDR            (volatile unsigned int) 0x80000300
#define UART_READY_ADDR         (volatile unsigned int) 0x80000310

// enderecos da DMA
#define DMA_DATA_ADDR           (volatile unsigned int) 0x80000400
#define DMA_MODE_ADDR           (volatile unsigned int) 0x80000410
#define DMA_EOT                 (volatile unsigned int) 0x80000420

// endereços da porta e/s
#define PORTIO_DATA_ADDR        (volatile unsigned int) 0x80000020
#define PORTIO_EN_ADDR          (volatile unsigned int) 0x80000000
#define PORTIO_CONFIG_ADDR      (volatile unsigned int) 0x80000010
#define PORTIO_INTR_ADDR        (volatile unsigned int) 0x80000030

#define TIMER_ADDR              (volatile unsigned int) 0x80000100

#define INTR_CTRL_MASK_ADDR     (volatile unsigned int) 0x80000210

void PrintUART(char* str);
void WriteDeviceRegister(unsigned int value, unsigned int reg_addr);
void ReadDeviceRegister(unsigned int* value, unsigned int reg_addr);

#endif
