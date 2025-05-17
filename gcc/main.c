#define PERIPH_BASE 0x80000000
#define IO_PORT_ADDR (PERIPH_BASE + 0b001000000000)
#define IO_PORT_CONFIG_ADDR (IO_PORT_ADDR + 0b010000)
#define IO_PORT_ENABLE_ADDR  (IO_PORT_ADDR + 0x000000)
#define IO_PORT_DATA_ADDR (IO_PORT_ADDR + 0b100000)
#define PORT_INTERRUPT_ADDR (IO_PORT_ADDR + 0b110000)

#define IO_PORT_ENABLE 0b11111111
#define IO_PORT_CONFIG 0b00000000

#define DISP_0 0b10000000
#define DISP_1 0b11000000
#define DISP_2 0b11100000
#define DISP_3 0b11110000
#define DISP_4 0b11111000
#define DISP_5 0b11111100
#define DISP_6 0b11111110
#define DISP_7 0b11111111
#define DISP_8 0b01111111
#define DISP_9 0b00111111
#define DISP_A 0b00011111
#define DISP_B 0b00001111
#define DISP_C 0b00000111
#define DISP_D 0b00000011
#define DISP_E 0b00000001
#define DISP_F 0b00000000

volatile unsigned int* data = (volatile unsigned int*) IO_PORT_DATA_ADDR;
volatile unsigned int* config = (volatile unsigned int*) IO_PORT_CONFIG_ADDR;
volatile unsigned int* enable = (volatile unsigned int*) IO_PORT_ENABLE_ADDR;

volatile int counter = 0;

void setup_io() {
    *enable = (volatile unsigned int) IO_PORT_ENABLE;
    *config = (volatile unsigned int) IO_PORT_CONFIG;
    *data = 0;
}

void delay(int delay_1, int delay_2) {
    for (int i = 0; i < delay_1; i++) {
        for (int j = 0; j < delay_2; j++) {
            volatile int x = 1;
        }
    }
}

void counter2led(int number, char* display) {
	switch (number) {
		case 0: display[0] = (char) DISP_0; break;
		case 1: display[0] = (char) DISP_1; break;
		case 2: display[0] = (char) DISP_2; break;
		case 3: display[0] = (char) DISP_3; break;
		case 4: display[0] = (char) DISP_4; break;
		case 5: display[0] = (char) DISP_5; break;
		case 6: display[0] = (char) DISP_6; break;
		case 7: display[0] = (char) DISP_7; break;
		case 8: display[0] = (char) DISP_8; break;
		case 9: display[0] = (char) DISP_9; break;
		case 10: display[0] = (char) DISP_A; break;
		case 11: display[0] = (char) DISP_B; break;
		case 12: display[0] = (char) DISP_C; break;
		case 13: display[0] = (char) DISP_D; break;
		case 14: display[0] = (char) DISP_E; break;
		case 15: display[0] = (char) DISP_F; break;
	}
}


int main() {
	char display = 0;
	while(1) {
		counter2led(counter, &display);
		*data = display;
		delay(0xFFFF, 0x30);
	
		counter++;
		if (counter == 16) {
			counter = 0;
		}
	}
	return 0;
}