#include "display_7_seg.h"

volatile unsigned int* data_display = (volatile unsigned int*) IO_PORT_DATA_ADDR;
volatile unsigned int* config_display = (volatile unsigned int*) IO_PORT_CONFIG_ADDR;
volatile unsigned int* enable_display = (volatile unsigned int*) IO_PORT_ENABLE_ADDR;
volatile unsigned int *counter_reg = (volatile unsigned int*) IO_PORT_COUNTER_ADDR;

const char display_pattern[16] = {DISP_0, DISP_1, DISP_2, DISP_3, DISP_4, DISP_5, DISP_6, DISP_7, DISP_8, DISP_9, DISP_A, DISP_B, DISP_C, DISP_D, DISP_E, DISP_F};

const int up_mask = 0b100;
const int down_mask = 0b010;
const int reset_mask = 0b001;
const int disp_en_mask = 0x00001800;
const int data_disp_keep = 0xfffff807;
const int data_disp_mask = 0x000007f8;
const int data_en_keep = 0xffffe7ff;


void setup_io_display() {
    *enable_display = (volatile unsigned int) IO_PORT_ENABLE;
    *config_display = (volatile unsigned int) IO_PORT_CONFIG;
    *data_display = 0;
}

void counter2seg(char* display_hex) {
    char num[2];
	num[0] = (*counter_reg & 0xF);
	num[1] = ((*counter_reg >> 4) & 0xF);
	for (int i = 0; i <= 1; i++)
	{
		display_hex[i] = display_pattern[num[i]];
	}
}


int read_button() {
    volatile int up_pool = (*data_display & up_mask) >> 2;
	volatile int down_pool = (*data_display & down_mask) >> 1;
	volatile int reset_pool = *data_display & reset_mask;
	int up = 0;
	int down = 0;
	int reset = 0;

    int flag = 1;

	if (up_pool == 1 || down_pool == 1 || reset_pool == 1)
	{
		for(int i = 0; i <= 15; i++)
		{
            volatile int up_pool = (*data_display & up_mask) >> 2;
            volatile int down_pool = (*data_display & down_mask) >> 1;
            volatile int reset_pool = *data_display & reset_mask;
			flag &= (up_pool || down_pool || reset_pool);
			if (!flag)
			{
				return flag;
			}
		}
		if (flag)
		{
			up = up_pool;
			down = down_pool;
			reset = reset_pool;
		}
	}
	*counter_reg += (up - down);
	if (reset)
	{
		*counter_reg = 0;
	}
	if (*counter_reg > 0xFF || *counter_reg < 0x00)
	{
		*counter_reg = 0;
	}
    return flag;
}

void print_display(int disp_index, char disp_num) {
	int display_enable_seg = ((int)*data_display & disp_en_mask) >> 11;
    if (disp_index == 0) {
        *data_display = (0b1111 << 11) | (*data_display & data_en_keep);
        *data_display = (0b1110 << 11) | (disp_num << 3) | (*data_display & (data_en_keep & data_disp_keep));
    }
    else if (disp_index == 1) {
		if (disp_num == DISP_0) {
			*data_display = (0b1111 << 11) | (*data_display & data_en_keep);
		}
		else {
			*data_display = (0b1111 << 11) | (*data_display & data_en_keep);
			*data_display = (0b1101 << 11) | (disp_num << 3) | (*data_display & (data_en_keep & data_disp_keep));
		}
    }
}

void refresh() {
	// get which segment
    int segment = (*data_display & disp_en_mask) >> 11;
	//change segment
	segment = segment ^ 0b11;
	int disp_index;
	    switch (segment) {
        case 1: disp_index = 1; break;
        case 2: disp_index = 0; break;
    }
	// save current segment
	*data_display = (segment << 11) | (*data_display & data_en_keep);
	// integer to display pattern
	char seg_pattern[2];
	counter2seg(seg_pattern);
	// print new segment
	print_display(disp_index, seg_pattern[disp_index]);
}