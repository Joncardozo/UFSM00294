#include "sprintf.h"

// Definições da UART
#define UART_TX     (*((volatile char *) 0xFFFFFF10))
#define UART_READY  (*((volatile char *) 0xFFFFFF14))

// Envia um caractere
void PrintChar(char c) {
    while (UART_READY == 0); // Espera UART ficar pronta
    UART_TX = c;             // Envia caractere
}

// Envia uma string
void PrintString(char *string) {
    while (*string) {
        PrintChar(*string);
        string++;
    }
}

// Bubble Sort normal
void BubbleSort(int *array, int size) {
    int i, j;
    int temp;
    int swap = 1;

    while (swap == 1) {
        swap = 0;

        for (i = 0, j = 1; j < size; i++, j++) {
            if (array[i] > array[j]) {
                // XOR swap
                array[i] = array[i] ^ array[j];
                array[j] = array[i] ^ array[j];
                array[i] = array[i] ^ array[j];
                swap = 1;
            }
        }
    }
}

int main() {
    int array[] = {33, 123, 21, 2345, 5};
    int size = 5;
    char buffer[16];

    PrintString("Array inicial: ");
    for (int i = 0; i < size; i++) {
        IntegerToString(array[i], buffer);
        PrintString(buffer);
        PrintChar(' ');
    }
    PrintChar('\n');

    BubbleSort(array, size);

    PrintString("Array final: ");
    for (int i = 0; i < size; i++) {
        IntegerToString(array[i], buffer);
        PrintString(buffer);
        PrintChar(' ');
    }
    PrintChar('\n');

    return 0;
}

