#include "peripheral_api.h"
#include "user_handler.h"
#include "sprintf.h"

#define DEBUG_SIMULATION 1

#ifdef DEBUG_SIMULATION
// INICIO DEBUG - ACESSO DIRETO A MEMORIA DA PORTIO
volatile char* send_uart_ptr_debug = (volatile char*) 0x80000300;
volatile char* check_uart_ptr_debug = (volatile char*) 0x80000310;

int* portio_en = (int*) 0x80000000;
int* portio_cfg = (int*) 0x80000010;
int* portio_data = (int*) 0x80000020;

void PrintUART_debug(char *string) {
    while (*string) {
        while (*check_uart_ptr_debug == 0);
        *send_uart_ptr_debug = *string++;
    }
    return;
}
// FIM DEBUG
#endif

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
#define PORTIO_INTERR 0x00000007
#define INTR_CTRL_MSK 0x000000E1

#ifdef DEBUG_SIMULATION
#define TIMER_COUNTER 0x000000FF
#endif
#ifndef DEBUG_SIMULATION
#define TIMER_COUNTER 0x0005FFFF
#endif


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

char display_out[] = {DISP_0, DISP_1, DISP_2, DISP_3, DISP_4, DISP_5, DISP_6, DISP_7, DISP_8, DISP_9, DISP_A, DISP_B, DISP_C, DISP_D, DISP_E, DISP_F};

// configura registradores periféricos
void portio_setup(){
    EnablePortIOBits(PORTIO_ENABLE);
    ConfigPortIOBitsDirection(PORTIO_CONFIG);
    int data_out = ((unsigned char)DISP_0 << 3) | PORTIO_SEG_DF;
    WriteDataPortIO(data_out);
    SetPortIOInterrupt(PORTIO_INTERR);
    SetPICMask(INTR_CTRL_MSK);
    SetTimerCounter(TIMER_COUNTER);
    return;
}

int set_counter(int increment) {
    static int counter = 0;
    counter += increment;
    return counter;
}

// faz debounce do botão da porta e/s
void debounce(int* button_value){
    int portio_data;
    ReadDataPortIO(&portio_data);
    int button_zero = (portio_data & 0b1);
    int button_down = (portio_data >> 1) & 0b1;
    int button_up = (portio_data >> 2) & 0b1;
#ifdef DEBUG_SIMULATION
    for (int i = 0; i < 2; i++){
#endif
#ifndef DEBUG_SIMULATION
    for (int i = 0; i < 16; i++){
#endif
       ReadDataPortIO(&portio_data);
       button_zero = (portio_data & 0b1) & button_zero;
       button_down = ((portio_data >> 1) & 0b1) & button_down;
       button_up = ((portio_data >> 2) & 0b1) & button_up;
       if (!button_up && !button_down && !button_zero) {
           *button_value = 0;
           return;
       }
    }
    if (button_zero == 1) {
        *button_value = 0;
        return;
    }
    else if (button_up == 1 && button_down == 1) {
        *button_value = 3;
        return;
    } else if (button_up == 1) {
        *button_value = 2;
        return;
    } else if (button_down == 1) {
        *button_value = 1;
        return;
    } else {
        *button_value = 3;
        return;
    }
    return;
}



void refresh(){
    // lê qual dos displays de 7 segmentos está habilitado
    int portio_data;
    ReadDataPortIO(&portio_data);
    char enabled_display = (portio_data & PORTIO_EN_MSK) >> 11;   // se 1: display 1, se 2: display 0
    char display_num[] = {0, 0};
    // converte o valor do contador para 2 caracteres hexadecimais ASCII
    int counter = set_counter(0);
    integer_to_hex(counter, display_num);
    char temp = display_num[0];
    display_num[0] = display_out[display_num[1]];
    display_num[1] = display_out[temp];
    int display_index = 0;
    enabled_display ^= 0b11;
    if (enabled_display == 1)
        display_index = 1;
    else
        display_index = 0;
    portio_data = (display_num[display_index] << 3) & PORTIO_DISP_M | (enabled_display << 11) & PORTIO_EN_MSK | portio_data & PORTIO_OVERWR;
    WriteDataPortIO(portio_data);
    return;
}

void button_handler(){

    char buffer[128];
    char display_hex[2] = {'\0', '\0'};
    int button_value = 0;
    int disp_counter = set_counter(0);

    // incrementar/decrementar o display se botoes forem apertados
    debounce(&button_value);

    switch (button_value) {
        case 1 : {
            if (disp_counter == 0) {
                disp_counter = 0;
            } else {
                disp_counter--;
                integer_to_hex(disp_counter, display_hex);
                hex_to_ascii(display_hex, buffer);
                PrintString("contador: ");
                PrintString(buffer);
                PrintString("\r\n");
            }
            break;
        }
        case 0 : {
            disp_counter = 0;
            integer_to_hex(disp_counter, display_hex);
            hex_to_ascii(display_hex, buffer);
            PrintString("contador: ");
            PrintString(buffer);
            PrintString("\r\n");
            break;
        }
        case 2 : {
            if (disp_counter == 0xFF) {
                disp_counter = 0xFF;
            } else {
                disp_counter++;
                integer_to_hex(disp_counter, display_hex);
                hex_to_ascii(display_hex, buffer);
                PrintString("contador: ");
                PrintString(buffer);
                PrintString("\r\n");
            }
            break;
        }
        default : break;
    }
    set_counter(disp_counter - set_counter(0));
}

int main() {
    SetHandler(0, refresh);
    SetHandler(5, button_handler);
    SetHandler(6, button_handler);
    SetHandler(7, button_handler);
    portio_setup();

    volatile int i = 0;
    for (i = 0;i == 0;i = 0);
    return 0;
}
