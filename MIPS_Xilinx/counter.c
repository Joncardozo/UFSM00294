#define PERIPH_BASE 0x80000000
#define IO_PORT_ADDR (PERIPH_BASE + 0x0000)
#define IO_PORT_CONFIG_ADDR (IO_PORT_ADDR + 0b01)
#define IO_PORT_ENABLE_ADDR  (IO_PORT_ADDR + 0x00)
#define IO_PORT_DATA_ADDR (IO_PORT_ADDR + 0b10)

#define IO_PORT_ENABLE 0b0111111111111111
#define IO_PORT_CONFIG 0b0000000000000111

#define DISP_0 0b01111110
#define DISP_1 0b00110000
#define DISP_2 0b01101101
#define DISP_3 0b01111001
#define DISP_4 0b00110011
#define DISP_5 0b01011011
#define DISP_6 0b01011111
#define DISP_7 0b01110000
#define DISP_8 0b01111111
#define DISP_9 0b01111011
#define DISP_A 0b01110111
#define DISP_B 0b00011111
#define DISP_C 0b01001110
#define DISP_D 0b00111101
#define DISP_E 0b01001111
#define DISP_F 0b01000111

volatile unsigned int* data = (volatile unsigned int*) IO_PORT_DATA_ADDR;
unsigned int* config = (unsigned int*) IO_PORT_CONFIG_ADDR;
unsigned int* enable = (unsigned int*) IO_PORT_ENABLE_ADDR;

void setup_io() {
    *config = (unsigned int) IO_PORT_CONFIG;
    *enable = (unsigned int) IO_PORT_ENABLE;
    *data = 0;
}

const int up_mask = 0b100;
const int down_mask = 0b010;
const int reset_mask = 0b001;
const int disp_mask = 0b11111111000;
int disp_en_mask = 0b0000100000000000;
const int disp_en_mask_inversor = 0b0001100000000000;
const int input_mask = 0b111;

int counter = 0;
volatile char display_hex[2];

void counter2seg() {
	char num[2];
	num[0] = (counter & 0xF);
	num[1] = ((counter >> 4) & 0xF);
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

void write_display() {
	int which_enable = (disp_en_mask >> 10);
	int display_index = 0;
	if (which_enable == 1){
		display_index = 0;
	}
	else {
		display_index = 1;
	}
	*data = ((((display_hex[display_index] << 3) & 0b11111111000)) | 
			((0b11 << 10) & disp_en_mask)) |
			(*data & input_mask);
	disp_en_mask ^= disp_en_mask_inversor; 
}

void read_button() {
	volatile int up_pool = (*data & up_mask) >> 2;
	volatile int down_pool = (*data & down_mask) >> 1;
	volatile int reset_pool = *data & reset_mask;
	int up = 0;
	int down = 0;
	int reset = 0;

	if (up_pool == 1 || down_pool == 1 || reset_pool == 1)
	{
		int flag = 1;
		for(int i = 0; i <= 50; i++)
		{
			flag &= (up || down || reset);
			if (!flag)
			{
				break;
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
}

int main()
{
    setup_io();
	while(1)
	{
		read_button();
		write_display();
	}
	return 0;
}