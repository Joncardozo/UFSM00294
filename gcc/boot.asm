
    .text
    .globl  entry_point
    .ent    entry_point
    .set    noreorder       /* Avoid branch delay slot */

entry_point:
    la  $sp, _stack_ptr     /* $sp = _stack_ptr */
    la  $t0, ExceptionServiceRoutine
    mtc0 $t0, $30

    jal main
    nop

loop:
    j loop                  /* Loop after finish main thread */
    nop

    .end entry_point
