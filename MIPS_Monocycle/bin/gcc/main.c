#define SIZE    0x32

int array_g[SIZE];      // 0x32 * 4 = 0xC8 bytes on .bss section
int size_g = SIZE;      // 4 bytes on .sdata

/* Objects declared as volatile are omitted from optimization 
because their values can be changed by code outside the scope 
of current code at any time. */

int main() {

    volatile int array_l[SIZE];   // stack
    int size_l = SIZE;         // register
      
    int i;  // register
    
    // Fill the global array (begin of data memory)
    for (i = 0; i < size_g; i++)
        array_g[i] = i + 1;
        
    // Fill the global array (stack at data memory)
    for (i = 0; i < size_l; i++)
        array_l[i] = i + 1;
}
