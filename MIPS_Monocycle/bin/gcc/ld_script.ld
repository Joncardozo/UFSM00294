MEMORY
{
  INSTRUCTION_MEMORY : ORIGIN = 0x00400000, LENGTH = 128 * 4   /* LENGTH in bytes */
  DATA_MEMORY        : ORIGIN = 0x10010000, LENGTH = 128 * 4
}


/* Executable object file sections */
SECTIONS 
{    
    .text : {               /* Output elf section */        
        *(.text)           /* The code order depends on the objects order passed to linker */
        *(.text.*)
    } > INSTRUCTION_MEMORY
       
    .data : {               /* Output elf section */
        *(.sdata)          /* This section holds initialized small data that contribute to the program memory image */
        *(.sdata.*)
        *(.data)           /* Input object files section */
        *(.data.*)
        *(.rdata)
        *(.rodata)         /* .rodata, .rodata.str1.4 */
        *(.rodata.*)
    } > DATA_MEMORY AT > INSTRUCTION_MEMORY
    
    .bss : {                /* Output elf section */
        *(.sbss)
        *(.sbss.*)
        *(.bss)            /* Input object files section */
        *(.bss.*)
        *(.scommon)
        *(COMMON)      
    } > DATA_MEMORY
    
    . = ORIGIN(DATA_MEMORY) + LENGTH(DATA_MEMORY) - 4;
    . = ALIGN(4);           /* Ensure the _stack_ptr alignment upward to a 4 byte boundary */
    _stack_ptr = .;         /* Set the stack pointer address */    
}