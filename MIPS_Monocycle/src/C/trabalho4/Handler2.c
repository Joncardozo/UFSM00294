#include "Handler2.h"

volatile 


void reset_timer_counter(int start_value) {
	unsigned int* data_timer = TIMER_ADDR;
	*data_timer = start_value;
}