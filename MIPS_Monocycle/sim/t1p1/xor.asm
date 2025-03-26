
.text
main:   
	addiu	$t0, $zero, 7
	addiu	$t1, $zero, 1
	xor	$t2, $t0, $t1
	xori	$t3, $t2, 1
	andi	$t4, $t0, 4
	nor	$t5, $t3, $t0
	addiu	$t6, $zero, 1
	bne	$t6, $zero, shift
	addiu	$t7, $zero, 1
	
shift:
	sll	$t7, $t6, 2
	srl	$t8, $t7, 2
	sra	$t9, $t7, 2
	sllv	$t0, $t1, $t9
	srlv	$t0, $t0, $t9
	
end:
	j	end
