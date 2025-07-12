# Boot.asm
.data
    .globl kernel_sp
    .globl user_sp

    stack_kernel:    .space 512
    stack_user:      .space 128

    kernel_sp:       .word 0
    user_sp:         .word 0

.text
.set noreorder
.globl boot_start
.set noat
boot_start:

    # $sp do kernel
    la      $sp, stack_kernel + 512
    la      $t0, kernel_sp
    sw      $sp, 0($t0)

    #  $sp do usuário
    la      $sp, stack_user + 128
    la      $t0, user_sp
    sw      $sp, 0($t0)

    # configura ISR_AD do usuario
    la      $t0, InterruptionServiceRoutine_user
    mtc0    $t0, $31

    # configura ESR_AD
    la      $t0, ExceptionServiceRoutine
    mtc0    $t0, $30

    # configura STATUS COP0
    li      $t0, 0b1
    mtc0    $t0, $12

    # Salta para o programa do usuário
    jal     main
    nop

end_boot:
    j end_boot     # Loop
