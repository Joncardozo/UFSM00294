#include "Handler1.h"

static char display_enable = 0;
static char num[2] = {0, 0};

void InterruptionRequest(int per) {
	if (per == 0) {
		Periferico1Handler();
	}
	else {
		Periferico2Handler();
	}
}


void Periferico1Handler() {
    char num[2];
    setup_io();
    char display_enable = 0;
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
	print_display(display_enable, num[display_enable]);
    display_enable ^= (char) 0b1;
}