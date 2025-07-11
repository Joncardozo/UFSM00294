# Programa: BubbleSort
# Descri��o: Ordena��o crescente

.text
BubbleSort:
	addiu	$t8, $zero, 1	# t8 = 1: swap performed
	lw	$t9, arrayc	# load number of arrays
	la	$t0, array	# load first array element
	la	$t4, ($t0)
	la	$t6, size	# load array size element    
    
while:
	beq	$t8, $zero, outer_loop	# Verifies if a swap has ocurred
	lw	$t3, 0($t6)
	la	$t4, ($t0)
	addiu	$t8, $zero, 0	# swap <- 0
    
inner_loop:
	beq	$t3, $zero, while	# Verifies if all elements were compared
	lw	$t1, 0($t4)	# t1 <- array[i]
	lw	$t2, 4($t4)	# t2 <- array[i + 1]
	slt	$t7, $t2, $t1	# array[i+1] < array[i] ?
	beq	$t7, $zero, continue	# if (array[i + 1] < array[i])
	addiu	$a0, $t4, 0	# swap(&array[i], &array[i + 1])
	addiu	$a1, $t4, 4
	jal	swap
	addiu	$t8, $zero, 1	# Indicates a swap performed

continue:
	addiu	$t4, $t4, 4	# t0 points the next element
	addiu	$t3, $t3, -1	# size--
	j	inner_loop               

# Swaps array[i] and array[i + 1]
swap:
	lw	$t1, 0($a0)	# t1 <- array[i]
	lw	$t2, 0($a1)	# t2 <- array[i + 1]
	sw	$t2, 0($a0)	# array[i] <- t2
	sw	$t1, 0($a1)	# array[i + 1] <- t1
	jr	$ra
    
outer_loop:
	beq	$t9, $zero, end	# verifies if all arrays were sorted    
	addiu	$t9, $t9, -1	# arrayc--
	add	$t0, $t4, 4
	add	$t6, $t6, 4
	addiu	$t8, $zero, 1
	j	while
    
end: 
	j	end

.data 
    array:      .word 12 29 17 46 33 23 21 40 6 16 33 16 18 30 38 19 30 43 5 32 3 30 26 29 40 9 22 25 3 50 27 47 50 21 20 0 10 0 17 21 37 5 3 30 37 13 13 10 31 30 36 35 23 9 1 45 20 30 37 12 11 50 20 20 44 45 11 13 21 50 35 48 26 28 31 39 24 2 2 9 14 13 15 42 36 16 50 6 43 1 9 0 44 7 20 49 6 5 33 49
    size:       .word 50 50
    arrayc:     .word 2