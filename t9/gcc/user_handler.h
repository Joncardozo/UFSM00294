#ifndef USER_HANDLER_H
#define USER_HANDLER_H

// Definição de valores padrão para habilitação, configuração e dados da porta E/S
#define PORTIO_ENABLE 0x00007FFF    // pinos habilitados e/s
// #define PORTIO_CONFIG 0x00000003    // pinos configurados saída = 0, entrada = 1
#define PORTIO_CONFIG 0x00000007
#define PORTIO_BUTTON 0x00000007    // identifica os pinos dos botões
#define PORTIO_EN_SEG 0x00001800    // identifica os pinos de habilitação dos displays
#define PORTIO_EN_MSK 0x00001800    // máscara com os pinos do display a receberem refresh
#define PORTIO_DISP_M 0x000007F8
#define PORTIO_SEG_DF 0x00006800    // valor padrão de habilitação dos displays (display 0 ligado, valor 0)
#define PORTIO_OVERWR 0xFFFF6007

// Padrão de bits para o display de 7 segmentos
#define DISP_0 ~0b00111111
#define DISP_1 ~0b00000110
#define DISP_2 ~0b01011011
#define DISP_3 ~0b01001111
#define DISP_4 ~0b01100110
#define DISP_5 ~0b01101101
#define DISP_6 ~0b01111101
#define DISP_7 ~0b00000111
#define DISP_8 ~0b01111111
#define DISP_9 ~0b01101111
#define DISP_A ~0b01110111
#define DISP_B ~0b01111100
#define DISP_C ~0b00111001
#define DISP_D ~0b01011110
#define DISP_E ~0b01111001
#define DISP_F ~0b01110001

void refresh(int counter);
void button_handler();

#endif
