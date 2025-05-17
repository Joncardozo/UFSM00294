# Boot.asm
.data
    .globl kernel_sp
    .globl user_sp

    stack_kernel:    .space 256
    stack_user:      .space 256

    kernel_sp:       .word 0
    user_sp:         .word 0

.text
.globl main
main:
    # $sp do kernel 
    la      $sp, stack_kernel + 256
    la      $t0, kernel_sp
    sw      $sp, 0($t0)

    #  $sp do usuário
    la      $sp, stack_user + 256
    la      $t0, user_sp
    sw      $sp, 0($t0)

    # porta de E/S
    li      $t1, 0xffff0000       
    li      $t2, 0x01               
    sw      $t2, 4($t1)             
    
    li      $t2, 0x00               
    sw      $t2, 0($t1)

    li      $t2, 0x01               
    sw      $t2, 8($t1)             
    
    # Salta para o programa do usuário (BubbleSort)
    jal     BubbleSort

end_boot:
    j end_boot     # Loop 