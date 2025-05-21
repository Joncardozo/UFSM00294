# Boot.asm
.data
    .globl kernel_sp
    .globl user_sp

    stack_kernel:    .space 256
    stack_user:      .space 256

    kernel_sp:       .word 0
    user_sp:         .word 0

.text
.globl boot_start
boot_start:
    # $sp do kernel 
    la      $sp, stack_kernel + 256
    la      $t0, kernel_sp
    sw      $sp, 0($t0)

    #  $sp do usuário
    la      $sp, stack_user + 256
    la      $t0, user_sp
    sw      $sp, 0($t0)

    # configura porta IO
    la      $t0, 0x80000000
    li      $t1, 0x007fffff
    sw      $t1, 0($t0)
    li      $t1, 0b0001
    sll     $t1, $t1, 4
    li      $t2, 0x00000007
    sw      $t2, $t1($t0)
    li      $t2, 0x00000007
    li      $t1, 0b0011
    sll     $t1, $t1, 4
    sw      $t2, $t1($t0)
    li      $t1, 0b0010
    sll     $t1, $t1, 4
    li      $t2, 0x6800
    sw      $t2, $t1($t0)

    # configura timer
    la      $t0, 0x80000100
    li      $t1, 0xFFF
    sw      $t1, 0($t0)

    # Salta para o programa do usuário (leds)
    jal     main

end_boot:
    j end_boot     # Loop 