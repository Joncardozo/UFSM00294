.text


.globl InterruptionServiceRoutine
InterruptionServiceRoutine:

    # Salva contexto 
    la      $k0, PCB
    sw      $at,   0($k0)
    sw      $v0,   4($k0)
    sw      $v1,   8($k0)
    sw      $a0,  12($k0)
    sw      $a1,  16($k0)
    sw      $a2,  20($k0)
    sw      $a3,  24($k0)
    sw      $t0,  28($k0)
    sw      $t1,  32($k0)
    sw      $t2,  36($k0)
    sw      $t3,  40($k0)
    sw      $t4,  44($k0)
    sw      $t5,  48($k0)
    sw      $t6,  52($k0)
    sw      $t7,  56($k0)
    sw      $t8,  60($k0)
    sw      $t9,  64($k0)
    sw      $s0,  68($k0)
    sw      $s1,  72($k0)
    sw      $s2,  76($k0)
    sw      $s3,  80($k0)
    sw      $s4,  84($k0)
    sw      $s5,  88($k0)
    sw      $s6,  92($k0)
    sw      $s7,  96($k0)
    sw      $gp, 100($k0)
    sw      $fp, 104($k0)
    sw      $sp, 108($k0)   
    sw      $ra, 112($k0)

    # Salta para pilha do kernel
    la      $k1, kernel_sp
    lw      $sp, 0($k1)

    # Verifica periférico
    li      $k1, 0xffff0000        
    lw      $t0, 8($k1)           
    
    # Verifica se o bit 0 está setado → periférico 1
    andi    $t1, $t0, 0x1
    bne     $t1, $zero, Peripheral1Handler

    # Default
    j RestoreContext

# Handler do Periférico 1: incrementa contador de 8 bits
Peripheral1Handler:
    li      $k1, 0xffff0000
    lw      $t2, 0($k1)            # Lê porta de saída
    addiu   $t2, $t2, 1            # Incrementa contador
    sw      $t2, 0($k1)            # Escreve de volta
    j       RestoreContext         # Corrige retorno com restauração do contexto


# Restauração do contexto
RestoreContext:
    la      $k0, PCB
    lw      $at,   0($k0)
    lw      $v0,   4($k0)
    lw      $v1,   8($k0)
    lw      $a0,  12($k0)
    lw      $a1,  16($k0)
    lw      $a2,  20($k0)
    lw      $a3,  24($k0)
    lw      $t0,  28($k0)
    lw      $t1,  32($k0)
    lw      $t2,  36($k0)
    lw      $t3,  40($k0)
    lw      $t4,  44($k0)
    lw      $t5,  48($k0)
    lw      $t6,  52($k0)
    lw      $t7,  56($k0)
    lw      $t8,  60($k0)
    lw      $t9,  64($k0)
    lw      $s0,  68($k0)
    lw      $s1,  72($k0)
    lw      $s2,  76($k0)
    lw      $s3,  80($k0)
    lw      $s4,  84($k0)
    lw      $s5,  88($k0)
    lw      $s6,  92($k0)
    lw      $s7,  96($k0)
    lw      $gp, 100($k0)
    lw      $fp, 104($k0)
    lw      $sp, 108($k0)
    lw      $ra, 112($k0)

    eret                       # Retorna da interrupção


.data
    PCB:    .space 116