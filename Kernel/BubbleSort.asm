# Programa: BubbleSort
# Descri��o: Ordena��o crescente

.text
BubbleSort:
    addiu   $t8, $zero, 1           # t8 = 1: swap performed
    
while:
    beq     $t8, $zero, end         # Verifies if a swap has ocurred
    la      $s0, array              # s0 points the first array element
    la      $t6, size               # 
    lw      $t6, 0($t6)             # t6 <- size    
    addiu   $t6, $t6, -1            # size-- 
    addiu   $t8, $zero, 0           # swap <- 0
    
inner_loop:    
    beq     $t6, $zero, while       # Verifies if all elements were compared
    lw      $s1, 0($s0)             # s1 <- array[i]
    lw      $s2, 4($s0)             # s2 <- array[i + 1]
    slt     $t7, $s2, $s1           # array[i+1] < array[i] ?
    beq     $t7, $zero, continue    # if (array[i + 1] < array[i])
        addiu   $a0, $s0, 0         #     swap(&array[i], &array[i + 1])
        addiu   $a1, $s0, 4         #
        jal     swap                #
        addiu   $t8, $zero, 1       # Indicates a swap performed

continue:
    addiu   $s0, $s0, 4             # s0 points the next element
    addiu   $t6, $t6, -1            # size--
    j       inner_loop               

# Swaps array[i] and array[i + 1]
swap:
    addiu   $sp, $sp, -8            # Allocate stack space for registers storing
    sw      $s0, 0($sp)             # Save used registers
    sw      $s1, 4($sp)             #
    
    lw      $s0, 0($a0)             # s0 <- array[i]
    lw      $s1, 0($a1)             # s1 <- array[i + 1]
    sw      $s1, 0($a0)             # array[i] <- s1
    sw      $s0, 0($a1)             # array[i + 1] <- s0
    
    lw      $s0, 0($sp)             # Restore used registers
    lw      $s1, 4($sp)             # 
    addiu   $sp, $sp, 8             # Release stack space
    jr $ra                          # return 1
    
end: 
    j       end 

.data 
    array:      .word 4 2 1 5 4 9 3
    size:       .word 7
