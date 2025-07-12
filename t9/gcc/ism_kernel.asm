.text

.set noreorder
.set noat

.globl InterruptionServiceRoutine_kernel
InterruptionServiceRoutine_kernel:

    # salva epc
    addiu   $sp, $sp, -128   # aumenta pilha

    # salva contexto
    sw      $at,   0($sp)
    sw      $v0,   4($sp)
    sw      $v1,   8($sp)
    sw      $a0,  12($sp)
    sw      $a1,  16($sp)
    sw      $a2,  20($sp)
    sw      $a3,  24($sp)
    sw      $t0,  28($sp)
    sw      $t1,  32($sp)
    sw      $t2,  36($sp)
    sw      $t3,  40($sp)
    sw      $t4,  44($sp)
    sw      $t5,  48($sp)
    sw      $t6,  52($sp)
    sw      $t7,  56($sp)
    sw      $t8,  60($sp)
    sw      $t9,  64($sp)
    sw      $s0,  68($sp)
    sw      $s1,  72($sp)
    sw      $s2,  76($sp)
    sw      $s3,  80($sp)
    sw      $s4,  84($sp)
    sw      $s5,  88($sp)
    sw      $s6,  92($sp)
    sw      $s7,  96($sp)
    sw      $gp, 100($sp)
    sw      $fp, 104($sp)
    sw      $ra, 112($sp)

    mfc0    $t0, $14
    sw      $t0, 124($sp)

    # salva mascara de interrupcoes
    la      $t1, 0x80000210
    lw      $t2, 0($t1)
    sw      $t2, 120($sp)

    # Lê ID da interrupção
    la      $t1, 0x80000200
    lw      $t2, 0($t1)

    # Mascara interrupções com prioridade menor ou igual a atual
    la      $t1, 0x80000210
    li      $t3, 0xFF
    li      $t4, 0x8
    subu    $t4, $t4, $t2
    srlv    $t3, $t3, $t4
    lw      $t5, 0($t1)
    and     $t5, $t5, $t3
    sw      $t5, 0($t1)

    # Reabilita interrupções (STATUS[0] = 1)
    li      $t0, 0b1
    mtc0    $t0, $12

    #### jump table
    la      $t0, user_handlers
    sll     $t3, $t2, 2
    addu    $t4, $t0, $t3
    lw      $t5, 0($t4)
    jalr    $t5
    nop

    # Desabilita interrupções antes de restaurar
    li      $t0, 0
    mtc0    $t0, $12

    j RestoreContext

RestoreContext:

    # restaura mascara de interrupcoes
    lw      $t2, 120($sp)
    la      $t1, 0x80000210
    sw      $t2, 0($t1)

    # ACK para o PIC
    la      $t0, 0x80000220
    la      $t1, 0x80000200
    lw      $t2, 0($t1)
    sw      $t2, 0($t0)

    # restaura epc da stack
    lw      $t0, 124($sp)
    mtc0    $t0, $14

    # restaura registradores
    #lw      $at,   0($sp)
    lw      $v0,   4($sp)
    lw      $v1,   8($sp)
    lw      $a0,  12($sp)
    lw      $a1,  16($sp)
    lw      $a2,  20($sp)
    lw      $a3,  24($sp)
    lw      $t0,  28($sp)
    lw      $t1,  32($sp)
    lw      $t2,  36($sp)
    lw      $t3,  40($sp)
    lw      $t4,  44($sp)
    lw      $t5,  48($sp)
    lw      $t6,  52($sp)
    lw      $t7,  56($sp)
    lw      $t8,  60($sp)
    lw      $t9,  64($sp)
    lw      $s0,  68($sp)
    lw      $s1,  72($sp)
    lw      $s2,  76($sp)
    lw      $s3,  80($sp)
    lw      $s4,  84($sp)
    lw      $s5,  88($sp)
    lw      $s6,  92($sp)
    lw      $s7,  96($sp)
    lw      $gp, 100($sp)
    lw      $fp, 104($sp)
    lw      $ra, 112($sp)

    addiu   $sp, $sp, 128    # desaloca stack

    eret
