main:
        addiu   $sp,$sp,-224
        sw      $fp,220($sp)
        move    $fp,$sp
        li      $2,50                 # 0x32
        sw      $2,12($fp)
        sw      $0,8($fp)
        b       L2
        nop

L3:
        lw      $2,8($fp)
        nop
        addiu   $3,$2,1
        lui     $2, 0x1001            # Replace %hi(array_g) with actual address (assuming data starts at 0x10010000)
        lw      $4,8($fp)
        nop
        sll     $4,$4,2
        addiu   $2,$2, 0              # Replace %lo(array_g) with offset (0 in this case, since array_g is first)
        addu    $2,$4,$2
        sw      $3,0($2)
        lw      $2,8($fp)
        nop
        addiu   $2,$2,1
        sw      $2,8($fp)
L2:
        lui     $2, 0x1001            # Replace %hi(size_g) with actual address
        lw      $2, 0x200($2)         # Replace %lo(size_g) with offset (200 bytes after array_g)
        lw      $3,8($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,L3
        nop

        sw      $0,8($fp)
        b       L4
        nop

L5:
        lw      $2,8($fp)
        nop
        addiu   $3,$2,1
        lw      $2,8($fp)
        nop
        sll     $2,$2,2
        addiu   $4,$fp,8
        addu    $2,$4,$2
        sw      $3,8($2)
        lw      $2,8($fp)
        nop
        addiu   $2,$2,1
        sw      $2,8($fp)
L4:
        lw      $3,8($fp)
        lw      $2,12($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,L5
        nop

        move    $2,$0
        move    $sp,$fp
        lw      $fp,220($sp)
        addiu   $sp,$sp,224
        jr      $31
        nop
        
.data
array_g:
        .space  200
size_g:
        .word   50