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

    # Salta para o programa do usuário (leds)
    jal     main

end_boot:
    j end_boot     # Loop 