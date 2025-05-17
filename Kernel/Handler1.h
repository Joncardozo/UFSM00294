#ifndef HANDLER1_H
#define HANDLER1_H

#define PERIPH_BASE 0x80000000
#define IO_PORT_ADDR (PERIPH_BASE + 0b000000000000)
#define IO_PORT_CONFIG_ADDR (IO_PORT_ADDR + 0b010000)
#define IO_PORT_ENABLE_ADDR  (IO_PORT_ADDR + 0x000000)
#define IO_PORT_DATA_ADDR (IO_PORT_ADDR + 0b100000)

#define IO_PORT_ENABLE 0b0111111111111111
#define IO_PORT_CONFIG 0b0000000000000111

#define DISP_0 0b00111111
#define DISP_1 0b00000110
#define DISP_2 0b01011011
#define DISP_3 0b01001111
#define DISP_4 0b01100110
#define DISP_5 0b01101101
#define DISP_6 0b01111101
#define DISP_7 0b00000111
#define DISP_8 0b01111111
#define DISP_9 0b01101111
#define DISP_A 0b01110111
#define DISP_B 0b01111100
#define DISP_C 0b00111001
#define DISP_D 0b01011110
#define DISP_E 0b01111001
#define DISP_F 0b01110001

extern volatile int counter;

void setup_io();
void counter2seg(int number, char* display_hex);
void delay(int delay_1, int delay_2);
int read_button();
void print_display(int disp_index, char disp_num);

#endif // HANDLER1_H


