#include "display_7_seg.h"

volatile unsigned int* data_display = (volatile unsigned int*) IO_PORT_DATA_ADDR;
volatile unsigned int* config_display = (volatile unsigned int*) IO_PORT_CONFIG_ADDR;
volatile unsigned int* enable_display = (volatile unsigned int*) IO_PORT_ENABLE_ADDR;

const char display_pattern[16] = {DISP_0, DISP_1, DISP_2, DISP_3, DISP_4, DISP_5, DISP_6, DISP_7, DISP_8, DISP_9, DISP_A, DISP_B, DISP_C, DISP_D, DISP_E, DISP_F};

static int counter = 0;

const int up_mask = 0b100;
const int down_mask = 0b010;
const int reset_mask = 0b001;
const int disp_en_mask_inversor = 0b0001100000000000;
const int data_keep_mask = 0b11111111110000000000111;


void setup_io_display() {
    *enable_display = (volatile unsigned int) IO_PORT_ENABLE;
    *config_display = (volatile unsigned int) IO_PORT_CONFIG;
    *data_display = 0;
}

void counter2seg(char* display_hex) {
    char num[2];
	num[0] = (counter & 0xF);
	num[1] = ((counter >> 4) & 0xF);
	for (int i = 0; i <= 1; i++)
	{
		display_hex[i] = display_pattern[num[i]];
	}
}

void delay(int delay_1, int delay_2) {
    for (int i = 0; i < delay_1; i++) {
        for (int j = 0; j < delay_2; j++) {
            volatile int x = 1;
        }
    }
}

int debounce() {
	static int button_up_pressed = 0;
	static int button_down_pressed = 0;
	static int button_restart_pressed = 0;

	button_up_pressed = (((*data_display & up_mask) >> 2) | ((button_up_pressed << 1) & ~0x1));
	button_down_pressed = (((*data_display & down_mask) >> 1) | ((button_down_pressed << 1) & ~0x1));
	button_restart_pressed = ((*data_display & reset_mask) | ((button_restart_pressed << 1) & ~0x1));

	int button_value = (button_up_pressed == 0xFFFF) - (button_down_pressed == 0xFFFF);
	int button_restart = (button_restart_pressed == 0xFFFF);

	if (button_restart) {
		return 2;
	}
	return button_value;
}


int read_button() {
	for (int i = 0; i < 32; i++) {
		char button_value = debounce();
	}

	if (button_value == 2) {
		counter = 0;
		return 1;
	}
	else if (button_value != 0) {
		if (counter == 0xFF && button_value == 1) {
			counter == 0xFF;
			return 1;
		}
		else if (counter == 0 && button_value == -1) {
			counter = 0;
			return 1;
		} 
		counter += button_value;
		return 1;
	}
	// se nenhum botao foi pressionado, retorna 0
	return 0;
}

void print_display(int disp_index, char disp_num) {
	int display_enable_seg = ((int)*data_display & disp_en_mask_inversor) >> 11;
    if (disp_index == 0) {
        *data_display = (0b1111 << 11) | (*data_display & data_keep_mask);
        *data_display = (0b1110 << 11) | (disp_num << 3) | (*data_display & data_keep_mask);
    }
    else if (disp_index == 1) {
		if (disp_num == DISP_0) {
			*data_display = (0b1111 << 11) | (*data_display & data_keep_mask);
		}
		else {
			*data_display = (0b1111 << 11) | (*data_display & data_keep_mask);
			*data_display = (0b1101 << 11) | (disp_num << 3) | (*data_display & data_keep_mask);
		}
    }
}

void refresh() {
	// get which segment
    int segment = (*data_display & disp_en_mask_inversor) >> 11;
	//change segment
	segment ^= 0b11;
	int disp_index;
	    switch (segment) {
        case 1: disp_index = 1; break;
        case 2: disp_index = 0; break;
    }
	// save current segment
	*data_display = (segment << 11) | (*data_display & data_keep_mask);
	// integer to display pattern
	char seg_pattern[2];
	counter2seg(seg_pattern);
	// print new segment
	print_display(disp_index, seg_pattern[disp_index]);
}