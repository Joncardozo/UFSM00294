#include "Handler1.h"

// periferico 0 : porta de entrada e saida
// periferico 1 : timer

#define START_COUNTER_TIMER 0x61A80

#define PERIPH_BASE 0x80000000
#define TIMER_ADDR (PERIPH_BASE + 0b000100000000)


void Periferico1Handler();
void Periferico2Handler();

static char display_enable = 0;
static char num[2] = {0, 0};


void InterruptionRequest(int per) {
	if (per == 0) {
		Periferico1Handler();
	}
	else if (per == 1) {
		Periferico2Handler();
	}
}


void Periferico1Handler() {
    char num[2];
    int was_pressed = 0;
	while(1)
	{
        // programa completo
        for (int i = 0; i < 4096 && !was_pressed; i++){
            was_pressed = read_button();
        }
        for (int i = 0; i < 40; i++) {
            counter2seg(counter, num);
            print_display(display_enable, num[display_enable]);
            display_enable ^= (char) 0b1;
        }
        if (was_pressed > 512) {
            was_pressed = 0;
        }
        else if (was_pressed) {
            was_pressed++;
        }
	}
}


void Periferico2Handler() {
    // refresh 7 segment display
	print_display(display_enable, num[display_enable]);
    display_enable ^= (char) 0b1;
    // restart the counter
    unsigned int* data_timer = TIMER_ADDR;
    *data_timer = START_COUNTER_TIMER;
}