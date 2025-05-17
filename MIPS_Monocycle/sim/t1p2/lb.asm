.text
main:
	LA	$t0, array
	LB	$t1, 1($t0)
	LBU	$t2, 1($t0)
	LHU	$t3, 0($t0)
	LHU	$t4, 2($t0)
	SB	$t4, 1($t0)
	SB	$t4, 0($t0)
	ADDIU	$t0, $t0, 4
	JAL	end
	SH	$t1, 2($t0)

end:
	j end


.data
	array: 0x003d897c
