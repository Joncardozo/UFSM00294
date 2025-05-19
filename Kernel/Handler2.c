#include "Handler2.h"


void reset_timer_counter(int start_value) {
	unsigned int* data = TIMER_ADDR;
	*data = start_value;
}