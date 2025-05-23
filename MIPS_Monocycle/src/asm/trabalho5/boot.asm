# Boot.asm
.data
    .globl kernel_sp
    .globl user_sp

    stack_kernel:    .space 256
    stack_user:      .space 256

    kernel_sp:       .word 0
    user_sp:         .word 0

.text
.set noreorder
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

    # configura ISR_AD
    la      $t0, InterruptionServiceRoutine
    mtc0    $t0, $31

    # configura porta IO
    la      $t0, 0x80000000
    li      $t1, 0x007fffff
    sw      $t1, 0($t0)
    li      $t1, 0b0001
    sll     $t1, $t1, 4
    addu    $t3, $t0, $t1
    li      $t2, 0x00000007
    sw      $t2, 0($t3)
    li      $t2, 0x00000007
    li      $t1, 0b0011
    sll     $t1, $t1, 4
    addu    $t3, $t0, $t1
    sw      $t2, 0($t3)
    li      $t1, 0b0010
    sll     $t1, $t1, 4
    addu    $t3, $t0, $t1
    li      $t2, 0x6800
    sw      $t2, 0($t3)

    # configura mascara de interrupcoes
    la      $t0, 0x80000210
    li      $t1, 0b11100001
    sw      $t1, 0($t0)

    # configura timer
    la      $t0, 0x80000100
    li      $t1, 0xF
    sw      $t1, 0($t0)

    # Salta para o programa do usuário (leds)
    jal     main

end_boot:
    j end_boot     # Loop 