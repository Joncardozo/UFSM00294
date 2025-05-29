// periferico 4 : contador 4
// periferico 5 : contador 5
// periferico 6 : contador 6
// periferico 7 : contador 7

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
    return;
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
    volatile static int count4 = 0x4000;
    for (int i = 0; i < 100; i++) {
        count4++;
    }
}

void irq5_handler() {
    volatile static int count5 = 0x5000;
    for (int i = 0; i < 100; i++) {
        count5++;
    }
}

void irq6_handler() {
    volatile static int count6 = 0x6000;
    for (int i = 0; i < 100; i++) {
        count6++;
    }
}

void irq7_handler() {
    volatile static int count7 = 0x7000;
    for (int i = 0; i < 100; i++) {
        count7++;
    }    
}

