#include <stdio.h>

void BubbleSort(int *array, int size) {

    int i, j;
    int temp;
    int swap = 1;

    while (swap == 1) {

        swap = 0;

        for(i = 0, j = 1; j < size; i++, j++)
            if ( array[i] > array[j] ) {
                /* XOR swap */
                array[i] = array[i] ^ array[j];
                array[j] = array[i] ^ array[j];
                array[i] = array[i] ^ array[j];
                swap = 1;
            }
    }
}

int main() {

    int array[] = {33, 123, 21, 2345, 5};
    int size = 5;
    int i;
    
    PrintString("Array inicial: ");
    for(i = 0; i < size; i++)
        PrintString("%d ",array[i]);
    PrintString("\n");

    BubbleSort(array, size);

    PrintString("Array final: ");
    for(i = 0; i < size; i++)
        PrintString("%d ",array[i]);
    PrintString("\n");


    return 0;
}
