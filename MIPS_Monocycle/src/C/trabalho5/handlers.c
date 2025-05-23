#include "display_7_seg.h"
#include "interrupt_controller_driver.h"

// periferico 0 : porta de entrada e saida
// periferico 1 : timer

// #define START_COUNTER_TIMER_A 0x6FFF
#define START_COUNTER_TIMER_A 0xFFF

#define PERIPH_BASE 0x80000000
#define TIMER_ADDR (PERIPH_BASE + 0b000100000000)

const char mask_buttons = 0b111 << 5;


void irq0_handler();
void irq1_handler();
void irq2_handler();
void irq3_handler();
void irq4_handler();
void irq5_handler();
void irq6_handler();
void irq7_handler();

(*irq_handlers[])() = {irq0_handler, irq1_handler, irq2_handler, irq3_handler, irq4_handler, irq5_handler, irq6_handler, irq7_handler};

void irq0_handler() {
    // unset mask button if 0x6FF timer interruptions have ocurred
    static int mask_button_counter = 0xF;
    mask_button_counter--;
    if (mask_button_counter == 0) {
        unset_mask(mask_buttons);
        mask_button_counter = 0xF;
    }
    // refreshes display
    refresh();
    // restart the counter
    unsigned int* data_timer = TIMER_ADDR;
    *data_timer = START_COUNTER_TIMER_A;
}


void irq1_handler() {
    return;
}


void irq2_handler() {
    return;
}

void irq3_handler() {
    return;
}

void irq4_handler() {
    return;
}

void irq5_handler() {
    // set counter
    read_button();
    // print segment
    // refresh();
    // mask the button pressing
    set_mask(mask_buttons);
}

void irq6_handler() {
    // set counter
    read_button();
    // print segment
    // refresh();
    // mask the button pressing
    set_mask(mask_buttons);
}

void irq7_handler() {
    // set counter
    read_button();
    // print segment
    // refresh();
    // mask the button pressing
    set_mask(mask_buttons);
}

