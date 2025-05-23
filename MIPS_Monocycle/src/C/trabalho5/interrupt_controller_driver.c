#include "interrupt_controller_driver.h"

volatile unsigned char* mask_reg = (volatile unsigned char*)INTR_CTRL_MASK_ADDR;
volatile unsigned char* intr_id = (volatile unsigned char*) INTR_CTRL_IRQ_ID_ADDR;

void set_mask(char irq_id) {
	*mask_reg = 0b00000001;
}

void unset_mask(char irq_id) {
	*mask_reg = 0b11100001;
}

