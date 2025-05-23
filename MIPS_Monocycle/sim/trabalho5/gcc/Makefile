TOOLCHAIN 		= /home/jon/code/trabalho4/mips-img-elf/2019.02-04/bin
TRAB5_ASM_SRC 	= /home/jon/code/trabalho5/UFSM00294/MIPS_Monocycle/src/asm/trabalho5
TRAB5_C_SRC 	= /home/jon/code/trabalho5/UFSM00294/MIPS_Monocycle/src/C/trabalho5

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
   
    
CFLAGS = -EL -msoft-float -Wall -march=mips1  -fno-delayed-branch -mno-gpopt -std=c99 -O2 -fno-zero-initialized-in-bss
ASMFLAGS = -EL -msoft-float -mips32

%: 
	@echo
	@echo "******************************************************************************"
	@echo Assembling boot.asm...
	$(AS_MIPS) $(ASMFLAGS) $(TRAB5_ASM_SRC)/boot.asm -o boot.o
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Assembling kernel.asm...
	$(AS_MIPS) $(ASMFLAGS) $(TRAB5_ASM_SRC)/kernel.asm -o kernel.o
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Compiling display_7_seg.c...
	$(CC_MIPS) $(CFLAGS) -c $(TRAB5_C_SRC)/display_7_seg.c -o display_7_seg.o
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Compiling interrupt_controller_driver.c...
	$(CC_MIPS) $(CFLAGS) -c $(TRAB5_C_SRC)/interrupt_controller_driver.c -o interrupt_controller_driver.o
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Compiling handlers.c...
	$(CC_MIPS) $(CFLAGS) -c $(TRAB5_C_SRC)/handlers.c -o handlers.o
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Compiling $(addsuffix .c, $@)...
	$(CC_MIPS) $(CFLAGS) -c $(TRAB5_C_SRC)/$(addsuffix .c, $@) -o $(addsuffix .o, $@)
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Linking executable...
	$(LD_MIPS) -e entry_point -EL -T ld_script.ld -o $(addsuffix .elf, $@) boot.o kernel.o display_7_seg.o interrupt_controller_driver.o handlers.o $(addsuffix .o, $@) -M > $(addsuffix .map, $@)
	$(SIZE_MIPS) -A -x $(addsuffix .elf, $@)
	$(NM_MIPS) -t x -S --size-sort $(addsuffix .elf, $@)
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Generating $(addsuffix _elf.lst, $@)...
	$(DUMP_MIPS) --disassemble-all $(addsuffix .elf, $@) > $(addsuffix _elf.lst, $@)
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Generating instruction memory image...
	$(OBJCOPY_MIPS) --dump-section .text=code.bin $(addsuffix .elf, $@)
    # The following backslashes (\) may need to be replaced by backslashes depending in the OS
	./tools/bin2hex code.bin > code.txt
#	copy code.txt ../../../sim
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Generating data memory image...
	$(OBJCOPY_MIPS) --dump-section .data=data.bin $(addsuffix .elf, $@)
	./tools/bin2hex data.bin > data.txt
#	copy data.txt ../../../sim
	@echo "******************************************************************************"


.PHONY: clean
clean:
	rm -f *.elf *.o *.lst *.map *.bin *.txt
