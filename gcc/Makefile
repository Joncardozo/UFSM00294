TOOLCHAIN = /home/jon/code/mips-img-elf/2024.10-03/bin

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


CFLAGS = -EL -msoft-float -Wall -march=mips1  -fno-delayed-branch -mno-gpopt -std=c99 -O0 -fno-zero-initialized-in-bss
ASMFLAGS = -EL -msoft-float -mips32

%:
	@echo
	@echo "******************************************************************************"
	@echo Assembling boot.asm...
	$(AS_MIPS) $(ASMFLAGS) boot.asm -o boot.o
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Assembling kernel.asm...
	$(AS_MIPS) $(ASMFLAGS) kernel.asm -o kernel.o
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Assembling peripheral_api.asm...
	$(AS_MIPS) $(ASMFLAGS) peripheral_api.asm -o peripheral_api.o
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Compiling exception_handler.c ...
	$(CC_MIPS) $(CFLAGS) -c exception_handler.c -o exception_handler.o
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Compiling sprintf.c ...
	$(CC_MIPS) $(CFLAGS) -c sprintf.c -o sprintf.o
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Compiling $(addsuffix .c, $@)...
	$(CC_MIPS) $(CFLAGS) -c $(addsuffix .c, $@) -o $(addsuffix .o, $@)
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Linking executable...
	$(LD_MIPS) -e entry_point -EL -T ld_script.ld -o $(addsuffix .elf, $@) boot.o kernel.o peripheral_api.o exception_handler.o sprintf.o $(addsuffix .o, $@) -M > $(addsuffix .map, $@)
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
#	copy code.txt ..\..\..\sim
	@echo "******************************************************************************"

	@echo
	@echo "******************************************************************************"
	@echo Generating data memory image...
	$(OBJCOPY_MIPS) --dump-section .data=data.bin $(addsuffix .elf, $@)
	./tools/bin2hex data.bin > data.txt
#	copy data.txt ..\..\..\sim
	@echo "******************************************************************************"



.PHONY: clean
clean:
	del -f *.elf *.o *.lst *.map *.bin *.txt
