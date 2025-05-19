#ifndef HANDLER2_H
#define HANDLER2_H

#define PERIPH_BASE 0x80000000
#define TIMER_ADDR (PERIPH_BASE + 0b000100000000)

void reset_timer_counter(int start_value);

#endif // HANDLER2_H