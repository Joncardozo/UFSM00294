#define PERIPH_BASE 0x80000000
#define IO_PORT_ADDR (PERIPH_BASE + 0b000000000000)
#define IO_PORT_CONFIG_ADDR (IO_PORT_ADDR + 0b010000)
#define IO_PORT_ENABLE_ADDR  (IO_PORT_ADDR + 0x000000)
#define IO_PORT_DATA_ADDR (IO_PORT_ADDR + 0b100000)

#define IO_PORT_ENABLE 0b0111111111111111
#define IO_PORT_CONFIG 0b0000000000000111

#define DISP_0 0b00111111
#define DISP_1 0b00000110
#define DISP_2 0b01011011
#define DISP_3 0b01001111
#define DISP_4 0b01100110
#define DISP_5 0b01101101
#define DISP_6 0b01111101
#define DISP_7 0b00000111
#define DISP_8 0b01111111
#define DISP_9 0b01101111
#define DISP_A 0b01110111
#define DISP_B 0b01111100
#define DISP_C 0b00111001
#define DISP_D 0b01011110
#define DISP_E 0b01111001
#define DISP_F 0b01110001

volatile unsigned int* data = (volatile unsigned int*) IO_PORT_DATA_ADDR;
volatile unsigned int* config = (volatile unsigned int*) IO_PORT_CONFIG_ADDR;
volatile unsigned int* enable = (volatile unsigned int*) IO_PORT_ENABLE_ADDR;

volatile int counter = 0;

const int up_mask = 0b100;
const int down_mask = 0b010;
const int reset_mask = 0b001;
const int disp_mask = 0b11111111000;
int disp_en_mask = 0b0000100000000000;
const int disp_en_mask_inversor = 0b0001100000000000;
const int input_mask = 0b111;

void setup_io() {
    *enable = (volatile unsigned int) IO_PORT_ENABLE;
    *config = (volatile unsigned int) IO_PORT_CONFIG;
    *data = 0;
}

void counter2seg(int number, char* display_hex) {
    char num[2];
	num[0] = (number & 0xF);
	num[1] = ((number >> 4) & 0xF);
	for (int i = 0; i < 2; i++)
	{
		switch (num[i]) {
			case 0: display_hex[i] = (char) DISP_0; break;
			case 1: display_hex[i] = (char) DISP_1; break;
			case 2: display_hex[i] = (char) DISP_2; break;
			case 3: display_hex[i] = (char) DISP_3; break;
			case 4: display_hex[i] = (char) DISP_4; break;
			case 5: display_hex[i] = (char) DISP_5; break;
			case 6: display_hex[i] = (char) DISP_6; break;
			case 7: display_hex[i] = (char) DISP_7; break;
			case 8: display_hex[i] = (char) DISP_8; break;
			case 9: display_hex[i] = (char) DISP_9; break;
			case 10: display_hex[i] = (char) DISP_A; break;
			case 11: display_hex[i] = (char) DISP_B; break;
			case 12: display_hex[i] = (char) DISP_C; break;
			case 13: display_hex[i] = (char) DISP_D; break;
			case 14: display_hex[i] = (char) DISP_E; break;
			case 15: display_hex[i] = (char) DISP_F; break;
		}
	}
}

void delay(int delay_1, int delay_2) {
    for (int i = 0; i < delay_1; i++) {
        for (int j = 0; j < delay_2; j++) {
            volatile int x = 1;
        }
    }
}

int read_button() {

    volatile int up_pool = (*data & up_mask) >> 2;
	volatile int down_pool = (*data & down_mask) >> 1;
	volatile int reset_pool = *data & reset_mask;
	int up = 0;
	int down = 0;
	int reset = 0;

    int flag = 1;

	if (up_pool == 1 || down_pool == 1 || reset_pool == 1)
	{
		for(int i = 0; i <= 20; i++)
		{
            volatile int up_pool = (*data & up_mask) >> 2;
            volatile int down_pool = (*data & down_mask) >> 1;
            volatile int reset_pool = *data & reset_mask;
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
	counter += (up - down);
	if (reset)
	{
		counter = 0;
	}
	if (counter > 0xFF || counter < 0x00)
	{
		counter = 0;
	}
    return flag;
}

void print_display(int disp_index, char disp_num) {
    if (disp_index == 0) {
        *data = (0b0000 << 11) | (*data & input_mask);
        delay(1, 0);
        *data = (0b0001 << 11) | (disp_num << 3) | (*data & input_mask);
    }
    else if (disp_index == 1) {
            if (disp_num == DISP_0) {
                *data = (0b0000 << 11) | (*data & input_mask);
            }
            else {
                *data = (0b0000 << 11) | (*data & input_mask);
                delay(1, 0);
                *data = (0b0010 << 11) | (disp_num << 3) | (*data & input_mask);
            }
            
    }
}

int main()
{
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
        for (int i = 0; i < 4; i++) {
            counter2seg(counter, num);
            print_display(display_enable, num[display_enable]);
            display_enable ^= (char) 0b1;
        }
        if (was_pressed > 1024) {
            was_pressed = 0;
        }
        else if (was_pressed) {
            was_pressed++;
        }
	}
	return 0;
}