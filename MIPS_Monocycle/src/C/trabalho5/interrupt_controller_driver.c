#include "interrupt_controller_driver.h"

volatile unsigned char* mask_reg = (volatile unsigned char*)INTR_CTRL_MASK_ADDR;

void set_mask(char irq_id) {
	for (int i; i < 8; i++) {
		if (irq_id == i) {
			mask_reg[i] = 0;
		}
	}
}

void unset_mask(char irq_id) {
	for (int i; i < 8; i++) {
		if (irq_id == i) {
			mask_reg[i] = 1;
		}
	}
}

