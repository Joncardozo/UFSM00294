#include "peripheral_api.h"
#include "user_handler.h"

// INICIO DEBUG - ACESSO DIRETO A MEMORIA DA PORTIO
// volatile char* send_uart_ptr_debug = (volatile char*) 0x80000300;
// volatile char* check_uart_ptr_debug = (volatile char*) 0x80000310;

// int* portio_en = (int*) 0x80000000;
// int* portio_cfg = (int*) 0x80000010;
// int* portio_data = (int*) 0x80000020;

// void PrintUART_debug(char *string) {
//     while (*string) {
//         while (*check_uart_ptr_debug == 0);
//         *send_uart_ptr_debug = *string++;
//     }
//     return;
// }
// FIM DEBUG

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

#define TIMER_COUNTER 0x0005FFFF


// configura a porta de e/s
void portio_setup(){
    EnablePortIOBits(PORTIO_ENABLE);
    ConfigPortIOBitsDirection(PORTIO_CONFIG);
    int data_out = ((unsigned char)DISP_0 << 3) | PORTIO_SEG_DF;
    WriteDataPortIO(data_out);
    SetTimerCounter(TIMER_COUNTER);
    return;
}


int main() {
    portio_setup();
    SetHandler(0, refresh);
    SetHandler(1, button_handler);
    volatile int i = 0;
    for (i = 0;i == 0;i = 0);
    return 0;
}
