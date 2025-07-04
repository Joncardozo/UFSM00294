#include "sprintf.h"
#include "peripheral_api.h"
#include "user_handler.h"


char display_out[] = {DISP_0, DISP_1, DISP_2, DISP_3, DISP_4, DISP_5, DISP_6, DISP_7, DISP_8, DISP_9, DISP_A, DISP_B, DISP_C, DISP_D, DISP_E, DISP_F};


// faz debounce do botão da porta e/s
void debounce(int* button_value){
    int portio_data;
    ReadDataPortIO(&portio_data);
    int button_zero = (portio_data & 0b1);
    int button_down = (portio_data >> 1) & 0b1;
    int button_up = (portio_data >> 2) & 0b1;
    for (int i = 0; i < 16; i++){
       ReadDataPortIO(&portio_data);
       button_zero = (portio_data & 0b1) & button_zero;
       button_down = ((portio_data >> 1) & 0b1) & button_down;
       button_up = ((portio_data >> 2) & 0b1) & button_up;
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
    static int disp_counter = 0;           // contador do display

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
}
