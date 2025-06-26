
.text
.set noreorder
.globl PrintString
.globl WriteDataPortIO
.globl EnablePortIOBits
.globl ConfigPortIOBitsDirection
.globl ReadDataPortIO

PrintString:
    addiu $v0, $zero, 0
    syscall
    jr $ra

WriteDataPortIO:
    addiu $v0, $zero, 1
    lui  $a1, 0x8000
    ori  $a1, 0x0020
    syscall
    jr $ra

EnablePortIOBits:
    addiu $v0, $zero, 1
    lui  $a1, 0x8000
    ori  $a1, 0x0000
    syscall
    jr $ra

ConfigPortIOBitsDirection:
    addiu $v0, $zero, 1
    lui  $a1, 0x8000
    ori  $a1, 0x0010
    syscall
    jr $ra

ReadDataPortIO:
    addiu $v0, $zero, 2
    lui  $a1, 0x8000
    ori  $a1, 0x0020
    syscall
    jr $ra
