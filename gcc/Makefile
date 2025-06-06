TOOLCHAIN = /home/jon/code/mips-img-elf/2024.10-03/bin
ASM_SRC = /home/jon/code/t6/UFSM00294/util
C_SRC = /home/jon/code/t6/UFSM00294/util

CC_MIPS         = $(TOOLCHAIN)/mips-img-elf-gcc
CPP_MIPS        = $(TOOLCHAIN)/mips-img-elf-g++
DUMP_MIPS       = $(TOOLCHAIN)/mips-img-elf-objdump
OBJCOPY_MIPS    = $(TOOLCHAIN)/mips-img-elf-objcopy
LD_MIPS         = $(TOOLCHAIN)/mips-img-elf-ld
AS_MIPS         = $(TOOLCHAIN)/mips-img-elf-as
SIZE_MIPS       = $(TOOLCHAIN)/mips-img-elf-size
NM_MIPS         = $(TOOLCHAIN)/mips-img-elf-nm

# Compiler/Assembler options
#   -mips1: corresponds to the R2000 and R3000 processors
#   -mips32: support to 'eret' instruction
#   -EL: Generate little-endian code
#   -msoft-float: Do not use floating-point coprocessor instructions. Implement floating-point calculations using library calls instead.
#   -fno-delayed-branch: Do not use branch delay slot
#   -mno-gpopt: Do not use GP-relative accesses for symbols that are known to be in a small data section (.sdata)
#   -std=c99: C language version (1999)
#   -fno-zero-initialized-in-bss: Ensures zero initialized variables (global/static) are allocated in .data section

# Linker options
#   -e: Specifies the symbol for beginning execution of your program
#   -T: Read link commands from the linker script file
#   -M: Print a link map

# Object dump options
#   --disassemble: Display the assembler mnemonics for the machine instructions

# Object copy options 
#   --dump-section: Extracts the contents of a section to a file
   
    
CFLAGS = -EL -msoft-float -Wall -march=mips1  -fno-delayed-branch -mno-gpopt -std=c99 -O1 -fno-zero-initialized-in-bss
ASMFLAGS = -EL -msoft-float -mips32

%: 


	@echo
	@echo "******************************************************************************"
	@echo Compiling uart_utils.c...
	$(CC_MIPS) $(CFLAGS) -c $(C_SRC)/uart_utils.c -o uart_utils.o
	@echo "******************************************************************************"


	@echo
	@echo "******************************************************************************"
	@echo Compiling BubbleSort.c...
	$(CC_MIPS) $(CFLAGS) -c $(C_SRC)/BubbleSort.c -o BubbleSort.o
	@echo "******************************************************************************"


	@echo
	@echo "******************************************************************************"
	@echo Linking executable...
	$(LD_MIPS) -e entry_point -EL -T ld_script.ld -o main.elf uart_utils.o BubbleSort.o -M > main.map
	$(SIZE_MIPS) -A -x main.elf
	$(NM_MIPS) -t x -S --size-sort main.elf
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Generating main_elf.lst
	$(DUMP_MIPS) --disassemble-all main.elf > main_elf.lst
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Generating instruction memory image...
	$(OBJCOPY_MIPS) --dump-section .text=code.bin main.elf
    # The following backslashes (\) may need to be replaced by backslashes depending in the OS
	./tools/bin2hex code.bin > code.txt
#	copy code.txt ../../../sim
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Generating data memory image...
	$(OBJCOPY_MIPS) --dump-section .data=data.bin main.elf
	./tools/bin2hex data.bin > data.txt
#	copy data.txt ../../../sim
	@echo "******************************************************************************"


.PHONY: clean
clean:
	rm -f *.elf *.o *.lst *.map *.bin *.txt
