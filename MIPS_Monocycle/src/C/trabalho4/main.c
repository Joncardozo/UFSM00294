#define PERIPH_BASE 0x80000000
#define IO_PORT_ADDR (PERIPH_BASE + 0b000000000000)
#define IO_PORT_CONFIG_ADDR (IO_PORT_ADDR + 0b010000)
#define IO_PORT_ENABLE_ADDR  (IO_PORT_ADDR + 0x000000)
#define IO_PORT_DATA_ADDR (IO_PORT_ADDR + 0b100000)
#define IO_PORT_INTERRUPT_ADDR (IO_PORT_ADDR + 0b110000)
#define IO_PORT_COUNTER (IO_PORT_ADDR + 0b01000000)

#define TIMER_ADDR (PERIPH_BASE + 0b000100000000)

#define IO_PORT_ENABLE 0b11111111111111111111111
#define IO_PORT_CONFIG 0b00000000000000000000111
#define IO_PORT_INTERR 0b00000000000000000000111

#define LED_0 0b10000000
#define LED_1 0b11000000
#define LED_2 0b11100000
#define LED_3 0b11110000
#define LED_4 0b11111000
#define LED_5 0b11111100
#define LED_6 0b11111110
#define LED_7 0b11111111
#define LED_8 0b01111111
#define LED_9 0b00111111
#define LED_A 0b00011111
#define LED_B 0b00001111
#define LED_C 0b00000111
#define LED_D 0b00000011
#define LED_E 0b00000001
#define LED_F 0b00000000

#define START_COUNTER_TIMER 0x61A80
// #define START_COUNTER_TIMER 0x200

int data_disp_mask = 0b00000000111111111111111;
int data_led_mask = 0b11111111000000000000000;

void setup_io(int* port_io_data) {
	unsigned int* config = (volatile unsigned int*) IO_PORT_CONFIG_ADDR;
	unsigned int* enable = (volatile unsigned int*) IO_PORT_ENABLE_ADDR;
	unsigned int* interr = (volatile unsigned int*) IO_PORT_INTERRUPT_ADDR;
    *enable = (volatile unsigned int) IO_PORT_ENABLE;
    *config = (volatile unsigned int) IO_PORT_CONFIG;
	*port_io_data = 0;
	*interr = (volatile unsigned int) IO_PORT_INTERR;
}

void set_timer(int time) {
	unsigned int* data_timer = TIMER_ADDR;
	*data_timer = time;
}

void counter2led(int number, int* display) {
	switch (number) {
		case 0: *display = (int) LED_0; break;
		case 1: *display = (int) LED_1; break;
		case 2: *display = (int) LED_2; break;
		case 3: *display = (int) LED_3; break;
		case 4: *display = (int) LED_4; break;
		case 5: *display = (int) LED_5; break;
		case 6: *display = (int) LED_6; break;
		case 7: *display = (int) LED_7; break;
		case 8: *display = (int) LED_8; break;
		case 9: *display = (int) LED_9; break;
		case 10: *display = (int) LED_A; break;
		case 11: *display = (int) LED_B; break;
		case 12: *display = (int) LED_C; break;
		case 13: *display = (int) LED_D; break;
		case 14: *display = (int) LED_E; break;
		case 15: *display = (int) LED_F; break;
	}
}


int main() {
	unsigned int* data = (volatile unsigned int*) IO_PORT_DATA_ADDR;
	setup_io(data);
	set_timer(START_COUNTER_TIMER);
	int display = 0;
	int timer_counter = 1;
	while(1) {
		counter2led(timer_counter, &display);
		*data = (display << 15) | (*data & data_disp_mask);
		delay(0xFFFF, 0x200);
		// delay(0x1, 0x1);
		timer_counter++;
		if (timer_counter == 16) {
			timer_counter = 0;
		}
	}
	return 0;
}