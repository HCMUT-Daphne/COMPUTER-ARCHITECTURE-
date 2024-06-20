coordinates:
    addi x1, x1, 3		/*xA*/
    addi x2, x2, 3		/*yA*/
    addi x3, x3, 2		/*xB*/
    addi x4, x4, 2		/*yB*/
    addi x5, x5, 0		/*xC*/
    addi x6, x6, 0		/*yC*/

xCA:
    sub x7, x5, x1
    bge x7, x0, sq_init_xCA
    sub x7, x0, x7
    sq_init_xCA:
    add x28, x7, x0
    add x10, x0, x0
    sq_loop_xCA:
    add x10, x10, x7
    addi x28, x28, -1
    beq x28, x0, sq_dist_dCA
    jal x0, sq_loop_xCA
sq_dist_dCA:
    sub x7, x6, x2
    bge x7, x0, sq_init_dCA
    sub x7, x0, x7
    sq_init_dCA:
    add x28, x7, x0
    sq_loop_dCA:
    add x10, x10, x7
    addi x28, x28, -1
    beq x28, x0, xCB
    jal x0, sq_loop_dCA

xCB:
    sub x8, x5, x3
    bge x8, x0, sq_init_xCB
    sub x8, x0, x8
    sq_init_xCB:
    add x28, x8, x0
    add x11, x0, x0
    sq_loop_xCB:
    add x11, x11, x8
    addi x28, x28, -1
    beq x28, x0, sq_dist_dCB
    jal x0, sq_loop_xCB
sq_dist_dCB:
    sub x8, x6, x4
    bge x8, x0, sq_init_dCB
    sub x8, x0, x8
    sq_init_dCB:
    add x28, x8, x0
    sq_loop_dCB:
    add x11, x11, x8
    addi x28, x28, -1
    beq x28, x0, check
    jal x0, sq_loop_dCB

check:
    beq x10, x11, comp_equal
    bltu x10, x11, comp_less
    addi x12, x0, 1
    jal x0, exit
    comp_equal:
    addi x12, x0, 0
    jal x0, exit
    comp_less:
    addi x12, x0, -1
    jal x0, exit

exit: