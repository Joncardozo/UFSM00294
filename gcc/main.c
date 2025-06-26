#include "sprintf.h"
#include "peripheral_api.h"


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

// Definição de valores padrão para habilitação, configuração e dados da porta E/S
#define PORTIO_ENABLE 0x00007FFF    // pinos habilitados e/s
// #define PORTIO_CONFIG 0x00000003    // pinos configurados saída = 0, entrada = 1
#define PORTIO_CONFIG 0x00000007
#define PORTIO_BUTTON 0x00000007    // identifica os pinos dos botões
#define PORTIO_EN_SEG 0x00007800    // identifica os pinos de habilitação dos displays
#define PORTIO_EN_MSK 0x00001800    // máscara com os pinos do display a receberem refresh
#define PORTIO_DISP_M 0x000007F8
#define PORTIO_SEG_DF 0x00007000    // valor padrão de habilitação dos displays (display 0 ligado, valor 0)
#define PORTIO_OVERWR 0xFFFF8007

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


// configura a porta de e/s
void portio_setup(){
    EnablePortIOBits(PORTIO_ENABLE);
    ConfigPortIOBitsDirection(PORTIO_CONFIG);
    int data_out = display_out[1] << 3 | PORTIO_SEG_DF;
    WriteDataPortIO(data_out);
    return;
}


// faz debounce do botão da porta e/s
void debounce(int* button_value){
    int portio_data;
    ReadDataPortIO(&portio_data);
    int button_zero = ~portio_data & 0b1;
    int button_down = ~portio_data >> 1 & 0b1;
    int button_up = ~portio_data >> 2 & 0b1;
    for (int i = 0; i < 16; i++){
       ReadDataPortIO(&portio_data);
       button_zero = (~portio_data & 0b1) & button_zero;
       button_down = ((~portio_data >> 1) & 0b1) & button_zero;
       button_up = ((~portio_data >> 2) & 0b1) & button_up;
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


// refresh dos displays de 7 segmentos
void refresh(int counter){
    // lê qual dos displays de 7 segmentos está habilitado
    int portio_data;
    ReadDataPortIO(&portio_data);
    char enabled_display = (portio_data & PORTIO_EN_MSK) >> 11;   // se 1: display 1, se 2: display 0
    char display_num[] = {0, 0};
    // converte o valor do contador para 2 caracteres hexadecimais ASCII
    integer_to_hex(counter, display_num);
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


int main() {

    char buffer[128];
    portio_setup();

    int button_value = 0;
    int refresh_timeout = 1000;
    int disp_counter = 0;           // contador do display
    int refresh_flag = 1;

    // loop infinito do programa principal
    while (1) {
        button_value = 0;

        // imprimir novo valor do display no terminal serial e gerar delay
        if (refresh_flag) {
            refresh(disp_counter);
            char display_hex[2] = {'\0', '\0'};
            integer_to_hex(disp_counter, display_hex);
            hex_to_ascii(display_hex, buffer);
            PrintUART_debug("contador: ");
            PrintUART_debug(buffer);
            PrintUART_debug("\r\n");
            for (int i = 0; i < 1000000; i++){
                refresh_timeout--;
                if (refresh_timeout == 0){
                    refresh(disp_counter);
                    refresh_timeout = 1000;
                }
            }
            refresh_flag = 0;
        }

        // pooling dos botoes
        while (!button_value) {
            ReadDataPortIO(&button_value);
            button_value = button_value & PORTIO_BUTTON;
            refresh_timeout--;
            if (refresh_timeout == 0){
                refresh(disp_counter);
                refresh_timeout = 1000;
            }
        }

        // incrementar/decrementar o display se botoes forem apertados
        debounce(&button_value);

        switch (button_value) {
            case 1 : {
                if (disp_counter > 0) {
                    disp_counter--;
                    refresh_flag = 1;
                } else {
                    disp_counter = 0;
                }
                break;
            }
            case 0 : {
                disp_counter = 0;
                refresh_flag = 1;
                break;
            }
            case 2 : {
                if (disp_counter == 0xFF) {
                    disp_counter = 0xFF;
                } else {
                    disp_counter++;
                    refresh_flag = 1;
                }
                break;
            }
            default : break;
        }
    }
    return 0;
}
