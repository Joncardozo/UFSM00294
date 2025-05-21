#define PERIPH_BASE 0x80000000
#define IO_PORT_ADDR (PERIPH_BASE + 0b000000000000)
#define IO_PORT_DATA_ADDR (IO_PORT_ADDR + 0b100000)

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


const int led_pattern[16] = {LED_0, LED_1, LED_2, LED_3, LED_4, LED_5, LED_6, LED_7, LED_8, LED_9, LED_A, LED_B, LED_C, LED_D, LED_E, LED_F};
const int data_keep_mask = 0b00000000111111111111111;
const int data_led_mask = 0b11111111000000000000000;


void counter2led(int number, int* leds) {
	*leds = led_pattern[number];
}


void delay(int delay_1, int delay_2) {
    for (int i = 0; i < delay_1; i++) {
        for (int j = 0; j < delay_2; j++) {
            volatile int x = 1;
        }
    }
}


int main() {
	unsigned int* data = (volatile unsigned int*) IO_PORT_DATA_ADDR;
	int leds = 0;
	int counter = 0;
	while(1) {
		counter2led(counter, &leds);
		*data = (leds << 15) | (*data & data_keep_mask);
		delay(0xFFFF, 0x20);
		// delay(0x1, 0x1);
		counter++;
		if (counter == 16) {
			counter = 0;
		}
	}
	return 0;
}