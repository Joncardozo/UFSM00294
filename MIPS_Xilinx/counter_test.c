#define PERIPH_BASE 0x80000000
#define IO_PORT_ADDR (PERIPH_BASE + 0b000000000000)
#define IO_PORT_CONFIG_ADDR (IO_PORT_ADDR + 0b010000)
#define IO_PORT_ENABLE_ADDR  (IO_PORT_ADDR + 0x000000)
#define IO_PORT_DATA_ADDR (IO_PORT_ADDR + 0b100000)

#define IO_PORT_ENABLE 0b0111111111111111
#define IO_PORT_CONFIG 0b0000000000000111

#define DISP_0 0b00111111  // a b c d e f
#define DISP_1 0b00000110  // b c
#define DISP_2 0b01011011  // a b d e g
#define DISP_3 0b01001111  // a b c d g
#define DISP_4 0b01100110  // b c f g
#define DISP_5 0b01101101  // a c d f g
#define DISP_6 0b01111101  // a c d e f g
#define DISP_7 0b00000111  // a b c
#define DISP_8 0b01111111  // all segments
#define DISP_9 0b01101111  // a b c d f g

#define DISP_A 0b01110111  // a b c e f g
#define DISP_B 0b01111100  // c d e f g
#define DISP_C 0b00111001  // a d e f
#define DISP_D 0b01011110  // b c d e g
#define DISP_E 0b01111001  // a d e f g
#define DISP_F 0b01110001  // a e f g

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
	// if (reset)
	// {
	// 	counter = 0;
	// }
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
		*data = (0b0101 << 11) | (DISP_1 << 3);
        for (int i = 0; i < 0xFFFF; i++){
            for (int j = 0; j < 50; j++) {
                volatile int k = 1;
            }
        }
        *data = (0b0101 << 11) | (DISP_F << 3);
        for (int i = 0; i < 0xFFFF; i++){
            for (int j = 0; j < 50; j++) {
                volatile int k = 1;
            }
        }
        read_button();
        *data = (0b1010 << 11) | (counter << 3);
        for (int i = 0; i < 0xFFFF; i++){
            for (int j = 0; j < 50; j++) {
                volatile int k = 1;
            }
        }
	}
	return 0;
}