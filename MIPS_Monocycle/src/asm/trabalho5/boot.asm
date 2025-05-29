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

    # configura ISR_AD do usuario
    la      $t0, InterruptionServiceRoutine_user
    mtc0    $t0, $31


    # configura STATUS COP0
    li      $t0, 0b1;
    mtc0    $t0, $12;

    # configura porta IO
    la      $t0, 0x80000000
    li      $t1, 0x0000000f
    sw      $t1, 0($t0)
    li      $t1, 0b0001
    sll     $t1, $t1, 4
    addu    $t3, $t0, $t1
    li      $t2, 0x0000000f
    sw      $t2, 0($t3)
    li      $t2, 0x0000000f
    li      $t1, 0b0011
    sll     $t1, $t1, 4
    addu    $t3, $t0, $t1
    sw      $t2, 0($t3)

    # configura mascara de interrupcoes
    la      $t0, 0x80000210
    li      $t1, 0xf0
    sw      $t1, 0($t0)

    # Salta para o programa do usuário (BubbleSort)
    jal     BubbleSort

end_boot:
    j end_boot     # Loop 