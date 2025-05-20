#include "Handler1.h"

// periferico 0 : porta de entrada e saida
// periferico 1 : timer

#define START_COUNTER_TIMER_A 0xFFF
// #define START_COUNTER_TIMER_A 0x200

#define PERIPH_BASE 0x80000000
#define TIMER_ADDR (PERIPH_BASE + 0b000100000000)

void Periferico1Handler();
void Periferico2Handler();

void InterruptionRequest(int per) {
	if (per == 0) {
		Periferico1Handler();
	}
	else if (per == 1) {
		Periferico2Handler();
	}
}


void Periferico1Handler() {
    // set counter
    read_button();
    // get counter
    volatile unsigned int* counter_display = (volatile unsigned int*) IO_PORT_COUNTER_ADDR;
    unsigned int local_counter = (unsigned int) *counter_display;
    // get which segment
    volatile unsigned int* data_display = (volatile unsigned int*) IO_PORT_DATA_ADDR;
    const int disp_en_mask = 0b00000000000000000001100000000000;
    int segment = (*data_display & disp_en_mask) >> 11;
    int disp_index;
    int set_segment = 0;
    switch (segment) {
        case 1: disp_index = 1; break;
        case 2: disp_index = 0; break;
        case 3: disp_index = 0; set_segment = 1; break;
    }
    if (set_segment) {
        segment = 0b10;
        const int disp_keep_mask = 0b11111111111111111110011111111111;
        *data_display = ((segment << 11) & disp_en_mask) | (*data_display & disp_keep_mask);
    }
    // get characters
    char characters[2];
    counter2seg(local_counter, characters);
    // print segment
    print_display(disp_index, characters[disp_index]);
}


void Periferico2Handler() {
    // get counter
    volatile unsigned int* counter_display = (volatile unsigned int*) IO_PORT_COUNTER_ADDR;
    unsigned int local_counter = (unsigned int) *counter_display;
    // get which segment
    volatile unsigned int* data_display = (volatile unsigned int*) IO_PORT_DATA_ADDR;
    const int disp_en_mask = 0b00000000000000000001100000000000;
    int segment = (*data_display & disp_en_mask) >> 11;
    // get characters
    char characters[2];
    counter2seg(local_counter, characters);
    // change segment
    segment ^= (char) 0b11;
    int disp_index;
    switch (segment) {
        case 1: disp_index = 1; break;
        case 2: disp_index = 0; break;
        case 3: disp_index = 1; segment = 0b01; break;
    }
    // print segment
    print_display(disp_index, characters[disp_index]);
    // set new segment
    const int disp_keep_mask = 0b11111111111111111110011111111111;
    *data_display = ((segment << 11) & disp_en_mask) | (*data_display & disp_keep_mask);
    // restart the counter
    unsigned int* data_timer = TIMER_ADDR;
    *data_timer = START_COUNTER_TIMER_A;
}