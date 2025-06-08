
    .text
    .globl  entry_point
    .ent    entry_point
    .set    noreorder       /* Avoid branch delay slot */

entry_point:
    la  $sp, _stack_ptr     /* $sp = _stack_ptr */

    jal main
      
loop:
    j loop                  /* Loop after finish main thread */
    
    .end entry_point
   
 

