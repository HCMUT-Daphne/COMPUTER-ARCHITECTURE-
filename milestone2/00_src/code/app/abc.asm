.global _boot
.text
_boot:

    /*LCD_CTRL*/
    addi x9, x0, 11
    addi x24, x0, 101

    addi x26, x0, 1
    slli x26, x26, 31
    ori x26, x26, 1024

    /*LCD_DATA*/
    addi x27, x0, 1
    slli x27, x27, 31
    ori x27, x27, 1536
    
    /*DELAY_1MS*/
    addi x23, x0, 625
    slli x23, x23, 3

    /*store_num*/
    ori x28, x27, 0x30
    sw   x28, 0x100(x0)
    ori x28, x27, 0x31
    sw   x28, 0x104(x0)
    ori x28, x27, 0x32
    sw   x28, 0x108(x0)
    ori x28, x27, 0x33
    sw   x28, 0x10c(x0)
    ori x28, x27, 0x34
    sw   x28, 0x110(x0)
    ori x28, x27, 0x35
    sw   x28, 0x114(x0)
    ori x28, x27, 0x36
    sw   x28, 0x118(x0)
    ori x28, x27, 0x37
    sw   x28, 0x11c(x0)
    ori x28, x27, 0x38
    sw   x28, 0x120(x0)
    ori x28, x27, 0x39
    sw   x28, 0x124(x0)

    /*JUMP_TO_MAIN*/
    jal x0, main

/*INIT*/
delay:
    delay_loop1:
    addi x29, x23, 0x0
    delay_loop2:
    addi x29, x29, -1
    bne x29, x0, delay_loop2
    addi x22, x22, -1
    bne x22, x0, delay_loop1
    jalr x0, x31, 0x0

lcd:
    sw x28, 0x228(x0)
    addi x22, x0, 5
    jal x31, delay
    addi x28, x28, -1024
    sw x28, 0x228(x0)
    addi x22, x0, 5
    jal x31, delay
    jalr x0, x25, 0x0

print_num:
    ori x28, x26, 0xC5
    jal x25, lcd
    lw x20, 0x08c(x16)
    bne x20, x0, print_negative
    ori x28, x27, 0x20
    jal x25, lcd
    jal x0, print_num_next
    print_negative:
    ori x28, x27, 0x2D
    jal x25, lcd
   
    print_num_next:
    ori x28, x26, 0xC6
    jal x25, lcd
    lw x19, 0x088(x16)
    slli x29, x19, 0x2
    lw x28, 0x100(x29)
    jal x25, lcd    

    ori x28, x26, 0xC7
    jal x25, lcd
    lw x18, 0x084(x16)
    slli x29, x18, 0x2
    lw x28, 0x100(x29)
    jal x25, lcd    

    ori x28, x26, 0xC8
    jal x25, lcd
    lw x17, 0x080(x16)
    slli x29, x17, 0x2
    lw x28, 0x100(x29)
    jal x25, lcd    

    jalr x0, x13, 0x0

check_enter:
    addi x15, x0, 0x0
    lw x21, 0x23c(x0)
    andi x28, x21, 0x1
    bne x28, x0, return_enter_false
    addi x22, x0, 20
    jal x31, delay
    lw x21, 0x23c(x0)
    andi x28, x21, 0x1
    bne x28, x0, return_enter_false
    addi x15, x0, 0x1
    jalr x0, x25, 0x0
    return_enter_false:
    jalr x0, x25, 0x0

check_next:
    addi x15, x0, 0x0
    lw x21, 0x23c(x0)
    andi x28, x21, 0x2
    bne x28, x0, return_next_false
    addi x22, x0, 20
    jal x31, delay
    lw x21, 0x23c(x0)
    andi x28, x21, 0x2
    bne x28, x0, return_next_false
    addi x15, x0, 0x1
    jalr x0, x25, 0x0
    return_next_false:
    jalr x0, x25, 0x0

check_down:
    addi x15, x0, 0x0
    lw x21, 0x23c(x0)
    andi x28, x21, 0x4
    bne x28, x0, return_down_false
    addi x22, x0, 15
    jal x31, delay
    lw x21, 0x23c(x0)
    andi x28, x21, 0x4
    bne x28, x0, return_down_false
    addi x15, x0, 0x1
    jalr x0, x25, 0x0
    return_down_false:
    jalr x0, x25, 0x0

check_up:
    addi x15, x0, 0x0
    lw x21, 0x23c(x0)
    andi x28, x21, 0x8
    bne x28, x0, return_up_false
    addi x22, x0, 15
    jal x31, delay
    lw x21, 0x23c(x0)
    andi x28, x21, 0x8
    bne x28, x0, return_up_false
    addi x15, x0, 0x1
    jalr x0, x25, 0x0
    return_up_false:
    jalr x0, x25, 0x0

check_sw0:
    addi x15, x0, 0x0
    lw x14, 0x240(x0)
    andi x28, x14, 0x1
    beq x28, x0, return_sw0_false
    addi x22, x0, 20
    jal x31, delay
    lw x14, 0x240(x0)
    andi x28, x14, 0x1
    beq x28, x0, return_sw0_false
    addi x15, x0, 0x1
    jalr x0, x25, 0x0  
    return_sw0_false:
    jalr x0, x25, 0x0

check_sw1:
    addi x15, x0, 0x0
    lw x14, 0x240(x0)
    andi x28, x14, 0x2
    beq x28, x0, return_sw1_false
    addi x22, x0, 20
    jal x31, delay
    lw x14, 0x240(x0)
    andi x28, x14, 0x2
    beq x28, x0, return_sw1_false
    addi x15, x0, 0x1
    jalr x0, x25, 0x0  
    return_sw1_false:
    jalr x0, x25, 0x0

check_sw2:
    addi x15, x0, 0x0
    lw x14, 0x240(x0)
    andi x28, x14, 0x4
    beq x28, x0, return_sw2_false
    addi x22, x0, 20
    jal x31, delay
    lw x14, 0x240(x0)
    andi x28, x14, 0x4
    beq x28, x0, return_sw2_false
    addi x15, x0, 0x1
    jalr x0, x25, 0x0  
    return_sw2_false:
    jalr x0, x25, 0x0

check_sw3:
    addi x15, x0, 0x0
    lw x14, 0x240(x0)
    andi x28, x14, 0x8
    beq x28, x0, return_sw3_false
    addi x22, x0, 20
    jal x31, delay
    lw x14, 0x240(x0)
    andi x28, x14, 0x8
    beq x28, x0, return_sw3_false
    addi x15, x0, 0x1
    jalr x0, x25, 0x0  
    return_sw3_false:
    jalr x0, x25, 0x0

/*MAIN PROGRAM*/
main:
        ori x28, x26, 0x38
        jal x25, lcd
        ori x28, x26, 0x0C
        jal x25, lcd
        ori x28, x26, 0x01
        jal x25, lcd        

    /*milestoneii*/
    /*line_1_MILESTONE2:NHOM9*/
        ori x28, x26, 0x38
        jal x25, lcd
        ori x28, x26, 0x0C
        jal x25, lcd
        ori x28, x26, 0x01
        jal x25, lcd
        ori x28, x26, 0x80
        jal x25, lcd
        ori x28, x27, 0x4D
        jal x25, lcd
        ori x28, x27, 0x49
        jal x25, lcd
        ori x28, x27, 0x4C
        jal x25, lcd
        ori x28, x27, 0x45
        jal x25, lcd
        ori x28, x27, 0x53
        jal x25, lcd
        ori x28, x27, 0x54
        jal x25, lcd
        ori x28, x27, 0x4F
        jal x25, lcd
        ori x28, x27, 0x4E
        jal x25, lcd
        ori x28, x27, 0x45
        jal x25, lcd
        ori x28, x27, 0x32
        jal x25, lcd
        ori x28, x27, 0x3A
        jal x25, lcd
        ori x28, x27, 0x4E
        jal x25, lcd
        ori x28, x27, 0x48
        jal x25, lcd
        ori x28, x27, 0x4F
        jal x25, lcd
        ori x28, x27, 0x4D
        jal x25, lcd
        ori x28, x27, 0x39
        jal x25, lcd

    /*line_2_<ENTER>*/
        ori x28, x26, 0xC9
        jal x25, lcd
        ori x28, x27, 0x3C
        jal x25, lcd
        ori x28, x27, 0x45
        jal x25, lcd
        ori x28, x27, 0x4E
        jal x25, lcd
        ori x28, x27, 0x54
        jal x25, lcd
        ori x28, x27, 0x45
        jal x25, lcd
        ori x28, x27, 0x52
        jal x25, lcd
        ori x28, x27, 0x3E
        jal x25, lcd

    /*next*/
        standby0:
        jal x25, check_enter
        beq x15, x0, standby0

    /*L1:Coordinates: ?*/
        ori x28, x26, 0x38
        jal x25, lcd
        ori x28, x26, 0x0C
        jal x25, lcd
        ori x28, x26, 0x01
        jal x25, lcd
        ori x28, x26, 0x80
        jal x25, lcd
        ori x28, x27, 0x43
        jal x25, lcd
        ori x28, x27, 0x6F
        jal x25, lcd
        ori x28, x27, 0x6F
        jal x25, lcd
        ori x28, x27, 0x72
        jal x25, lcd
        ori x28, x27, 0x64
        jal x25, lcd
        ori x28, x27, 0x69
        jal x25, lcd
        ori x28, x27, 0x6E
        jal x25, lcd
        ori x28, x27, 0x61
        jal x25, lcd
        ori x28, x27, 0x74
        jal x25, lcd
        ori x28, x27, 0x65
        jal x25, lcd
        ori x28, x27, 0x73
        jal x25, lcd
        ori x28, x27, 0x3A
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd

    /*input_loop*/
    input_loop:
             
        /*====================================*/
        /*===============XA===================*/
        /*====================================*/        
        addi x22, x0, 100
        jal x31, delay
                
        input_xa:
        /*====================================*/
        /*L1:Coordinates: A*/
        ori x28, x26, 0x8D
        jal x25, lcd
        ori x28, x27, 0x41
        jal x25, lcd   
        /*L2:xA=*/
        ori x28, x26, 0xC0
        jal x25, lcd
        ori x28, x27, 0x78
        jal x25, lcd
        ori x28, x27, 0x41
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        ori x28, x27, 0x3D
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        
        addi x16, x0, 0x0

        xa_loop:
        /*input_sw3*/
        xa_input_sw3:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_ya
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw3
        addi x20, x15, 0x0
        sw x20, 0x08C(x16)

        /*input_sw2*/
        xa_input_sw2:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_ya
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw2
        beq x15, x0, xa_exit_sw2_check

        xa_sw2_check_up:
        jal x25, check_up
        beq x15, x0, xa_sw2_check_down
        addi x29, x0, 9
        beq x19, x29, xa_reset_sw2_check_up
        addi x19, x19, 1
        jal x0, xa_sw2_check_down
        xa_reset_sw2_check_up:
        addi x19, x0, 0x0

        xa_sw2_check_down:
        jal x25, check_down
        beq x15, x0, xa_exit_sw2_check
        beq x19, x0, xa_reset_sw2_check_down
        addi x19, x19, -1
        jal x0, xa_exit_sw2_check
        xa_reset_sw2_check_down:
        addi x19, x0, 0x9

        xa_exit_sw2_check:
        sw x19, 0x088(x16)

        /*input_sw1*/
        xa_input_sw1:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_ya
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw1
        beq x15, x0, xa_exit_sw1_check

        xa_sw1_check_up:
        jal x25, check_up
        beq x15, x0, xa_sw1_check_down
        addi x29, x0, 9
        beq x18, x29, xa_reset_sw1_check_up
        addi x18, x18, 1
        jal x0, xa_sw1_check_down
        xa_reset_sw1_check_up:
        addi x18, x0, 0x0

        xa_sw1_check_down:
        jal x25, check_down
        beq x15, x0, xa_exit_sw1_check
        beq x18, x0, xa_reset_sw1_check_down
        addi x18, x18, -1
        jal x0, xa_exit_sw1_check
        xa_reset_sw1_check_down:
        addi x18, x0, 0x9

        xa_exit_sw1_check:
        sw x18, 0x084(x16)

        /*input_sw0*/
        xa_input_sw0:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_ya
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw0
        beq x15, x0, xa_exit_sw0_check

        xa_sw0_check_up:
        jal x25, check_up
        beq x15, x0, xa_sw0_check_down
        addi x29, x0, 9
        beq x17, x29, xa_reset_sw0_check_up
        addi x17, x17, 1
        jal x0, xa_sw0_check_down
        xa_reset_sw0_check_up:
        addi x17, x0, 0x0

        xa_sw0_check_down:
        jal x25, check_down
        beq x15, x0, xa_exit_sw0_check
        beq x17, x0, xa_reset_sw0_check_down
        addi x17, x17, -1
        jal x0, xa_exit_sw0_check
        xa_reset_sw0_check_down:
        addi x17, x0, 0x9

        xa_exit_sw0_check:
        sw x17, 0x080(x16)

        jal x0, input_xa

        /*====================================*/
        /*===============yA===================*/
        /*====================================*/    
        addi x22, x0, 100
        jal x31, delay

        input_ya:
        /*L2:ya=*/
        ori x28, x26, 0xC0
        jal x25, lcd
        ori x28, x27, 0x79
        jal x25, lcd
        ori x28, x27, 0x41
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        ori x28, x27, 0x3D
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        
        addi x16, x0, 0x14

        ya_loop:
        
        /*input_sw3*/
        ya_input_sw3:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xb
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw3
        addi x20, x15, 0x0
        sw x20, 0x08C(x16)

        /*input_sw2*/
        ya_input_sw2:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xb
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw2
        beq x15, x0, ya_exit_sw2_check

        ya_sw2_check_up:
        jal x25, check_up
        beq x15, x0, ya_sw2_check_down
        addi x29, x0, 9
        beq x19, x29, ya_reset_sw2_check_up
        addi x19, x19, 1
        jal x0, ya_sw2_check_down
        ya_reset_sw2_check_up:
        addi x19, x0, 0x0

        ya_sw2_check_down:
        jal x25, check_down
        beq x15, x0, ya_exit_sw2_check
        beq x19, x0, ya_reset_sw2_check_down
        addi x19, x19, -1
        jal x0, ya_exit_sw2_check
        ya_reset_sw2_check_down:
        addi x19, x0, 0x9

        ya_exit_sw2_check:
        sw x19, 0x088(x16)

        /*input_sw1*/
        ya_input_sw1:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xb
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw1
        beq x15, x0, ya_exit_sw1_check

        ya_sw1_check_up:
        jal x25, check_up
        beq x15, x0, ya_sw1_check_down
        addi x29, x0, 9
        beq x18, x29, ya_reset_sw1_check_up
        addi x18, x18, 1
        jal x0, ya_sw1_check_down
        ya_reset_sw1_check_up:
        addi x18, x0, 0x0

        ya_sw1_check_down:
        jal x25, check_down
        beq x15, x0, ya_exit_sw1_check
        beq x18, x0, ya_reset_sw1_check_down
        addi x18, x18, -1
        jal x0, ya_exit_sw1_check
        ya_reset_sw1_check_down:
        addi x18, x0, 0x9

        ya_exit_sw1_check:
        sw x18, 0x084(x16)

        /*input_sw0*/
        ya_input_sw0:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xb
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw0
        beq x15, x0, ya_exit_sw0_check

        ya_sw0_check_up:
        jal x25, check_up
        beq x15, x0, ya_sw0_check_down
        addi x29, x0, 9
        beq x17, x29, ya_reset_sw0_check_up
        addi x17, x17, 1
        jal x0, ya_sw0_check_down
        ya_reset_sw0_check_up:
        addi x17, x0, 0x0

        ya_sw0_check_down:
        jal x25, check_down
        beq x15, x0, ya_exit_sw0_check
        beq x17, x0, ya_reset_sw0_check_down
        addi x17, x17, -1
        jal x0, ya_exit_sw0_check
        ya_reset_sw0_check_down:
        addi x17, x0, 0x9

        ya_exit_sw0_check:
        sw x17, 0x080(x16)


        jal x0, input_ya

        
        /*====================================*/
        /*===============xb===================*/
        /*====================================*/    
        addi x22, x0, 100
        jal x31, delay

        input_xb:
        /*====================================*/
        /*L1:Coordinates: B*/
        ori x28, x26, 0x8D
        jal x25, lcd
        ori x28, x27, 0x42
        jal x25, lcd
        /*L2:xb=*/
        ori x28, x26, 0xC0
        jal x25, lcd
        ori x28, x27, 0x78
        jal x25, lcd
        ori x28, x27, 0x42
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        ori x28, x27, 0x3D
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        
        addi x16, x0, 0x28

        xb_loop:
        
        /*input_sw3*/
        xb_input_sw3:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_yb
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw3
        addi x20, x15, 0x0
        sw x20, 0x08C(x16)

        /*input_sw2*/
        xb_input_sw2:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_yb
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw2
        beq x15, x0, xb_exit_sw2_check

        xb_sw2_check_up:
        jal x25, check_up
        beq x15, x0, xb_sw2_check_down
        addi x29, x0, 9
        beq x19, x29, xb_reset_sw2_check_up
        addi x19, x19, 1
        jal x0, xb_sw2_check_down
        xb_reset_sw2_check_up:
        addi x19, x0, 0x0

        xb_sw2_check_down:
        jal x25, check_down
        beq x15, x0, xb_exit_sw2_check
        beq x19, x0, xb_reset_sw2_check_down
        addi x19, x19, -1
        jal x0, xb_exit_sw2_check
        xb_reset_sw2_check_down:
        addi x19, x0, 0x9

        xb_exit_sw2_check:
        sw x19, 0x088(x16)

        /*input_sw1*/
        xb_input_sw1:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_yb
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw1
        beq x15, x0, xb_exit_sw1_check

        xb_sw1_check_up:
        jal x25, check_up
        beq x15, x0, xb_sw1_check_down
        addi x29, x0, 9
        beq x18, x29, xb_reset_sw1_check_up
        addi x18, x18, 1
        jal x0, xb_sw1_check_down
        xb_reset_sw1_check_up:
        addi x18, x0, 0x0

        xb_sw1_check_down:
        jal x25, check_down
        beq x15, x0, xb_exit_sw1_check
        beq x18, x0, xb_reset_sw1_check_down
        addi x18, x18, -1
        jal x0, xb_exit_sw1_check
        xb_reset_sw1_check_down:
        addi x18, x0, 0x9

        xb_exit_sw1_check:
        sw x18, 0x084(x16)

        /*input_sw0*/
        xb_input_sw0:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_yb
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw0
        beq x15, x0, xb_exit_sw0_check

        xb_sw0_check_up:
        jal x25, check_up
        beq x15, x0, xb_sw0_check_down
        addi x29, x0, 9
        beq x17, x29, xb_reset_sw0_check_up
        addi x17, x17, 1
        jal x0, xb_sw0_check_down
        xb_reset_sw0_check_up:
        addi x17, x0, 0x0

        xb_sw0_check_down:
        jal x25, check_down
        beq x15, x0, xb_exit_sw0_check
        beq x17, x0, xb_reset_sw0_check_down
        addi x17, x17, -1
        jal x0, xb_exit_sw0_check
        xb_reset_sw0_check_down:
        addi x17, x0, 0x9

        xb_exit_sw0_check:
        sw x17, 0x080(x16)


        jal x0, input_xb

        /*====================================*/
        /*===============yb===================*/
        /*====================================*/    
        addi x22, x0, 100
        jal x31, delay

        input_yb:
        /*L2:yb=*/
        ori x28, x26, 0xC0
        jal x25, lcd
        ori x28, x27, 0x79
        jal x25, lcd
        ori x28, x27, 0x42
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        ori x28, x27, 0x3D
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        
        addi x16, x0, 0x3C

        yb_loop:
        
        /*input_sw3*/
        yb_input_sw3:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xc
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw3
        addi x20, x15, 0x0
        sw x20, 0x08C(x16)

        /*input_sw2*/
        yb_input_sw2:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xc
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw2
        beq x15, x0, yb_exit_sw2_check

        yb_sw2_check_up:
        jal x25, check_up
        beq x15, x0, yb_sw2_check_down
        addi x29, x0, 9
        beq x19, x29, yb_reset_sw2_check_up
        addi x19, x19, 1
        jal x0, yb_sw2_check_down
        yb_reset_sw2_check_up:
        addi x19, x0, 0x0

        yb_sw2_check_down:
        jal x25, check_down
        beq x15, x0, yb_exit_sw2_check
        beq x19, x0, yb_reset_sw2_check_down
        addi x19, x19, -1
        jal x0, yb_exit_sw2_check
        yb_reset_sw2_check_down:
        addi x19, x0, 0x9

        yb_exit_sw2_check:
        sw x19, 0x088(x16)

        /*input_sw1*/
        yb_input_sw1:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xc
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw1
        beq x15, x0, yb_exit_sw1_check

        yb_sw1_check_up:
        jal x25, check_up
        beq x15, x0, yb_sw1_check_down
        addi x29, x0, 9
        beq x18, x29, yb_reset_sw1_check_up
        addi x18, x18, 1
        jal x0, yb_sw1_check_down
        yb_reset_sw1_check_up:
        addi x18, x0, 0x0

        yb_sw1_check_down:
        jal x25, check_down
        beq x15, x0, yb_exit_sw1_check
        beq x18, x0, yb_reset_sw1_check_down
        addi x18, x18, -1
        jal x0, yb_exit_sw1_check
        yb_reset_sw1_check_down:
        addi x18, x0, 0x9

        yb_exit_sw1_check:
        sw x18, 0x084(x16)

        /*input_sw0*/
        yb_input_sw0:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xc
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw0
        beq x15, x0, yb_exit_sw0_check

        yb_sw0_check_up:
        jal x25, check_up
        beq x15, x0, yb_sw0_check_down
        addi x29, x0, 9
        beq x17, x29, yb_reset_sw0_check_up
        addi x17, x17, 1
        jal x0, yb_sw0_check_down
        yb_reset_sw0_check_up:
        addi x17, x0, 0x0

        yb_sw0_check_down:
        jal x25, check_down
        beq x15, x0, yb_exit_sw0_check
        beq x17, x0, yb_reset_sw0_check_down
        addi x17, x17, -1
        jal x0, yb_exit_sw0_check
        yb_reset_sw0_check_down:
        addi x17, x0, 0x9

        yb_exit_sw0_check:
        sw x17, 0x080(x16)

        jal x0, input_yb

        
        /*====================================*/
        /*===============xc===================*/
        /*====================================*/    
        addi x22, x0, 100
        jal x31, delay

        input_xc:
        /*====================================*/
        /*L1:Coordinates: C*/
        ori x28, x26, 0x8D
        jal x25, lcd
        ori x28, x27, 0x43
        jal x25, lcd
        /*L2:xc=*/
        ori x28, x26, 0xC0
        jal x25, lcd
        ori x28, x27, 0x78
        jal x25, lcd
        ori x28, x27, 0x43
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        ori x28, x27, 0x3D
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        
        addi x16, x0, 0x50

        xc_loop:
        
        /*input_sw3*/
        xc_input_sw3:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_yc
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw3
        addi x20, x15, 0x0
        sw x20, 0x08C(x16)

        /*input_sw2*/
        xc_input_sw2:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_yc
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw2
        beq x15, x0, xc_exit_sw2_check

        xc_sw2_check_up:
        jal x25, check_up
        beq x15, x0, xc_sw2_check_down
        addi x29, x0, 9
        beq x19, x29, xc_reset_sw2_check_up
        addi x19, x19, 1
        jal x0, xc_sw2_check_down
        xc_reset_sw2_check_up:
        addi x19, x0, 0x0

        xc_sw2_check_down:
        jal x25, check_down
        beq x15, x0, xc_exit_sw2_check
        beq x19, x0, xc_reset_sw2_check_down
        addi x19, x19, -1
        jal x0, xc_exit_sw2_check
        xc_reset_sw2_check_down:
        addi x19, x0, 0x9

        xc_exit_sw2_check:
        sw x19, 0x088(x16)

        /*input_sw1*/
        xc_input_sw1:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_yc
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw1
        beq x15, x0, xc_exit_sw1_check

        xc_sw1_check_up:
        jal x25, check_up
        beq x15, x0, xc_sw1_check_down
        addi x29, x0, 9
        beq x18, x29, xc_reset_sw1_check_up
        addi x18, x18, 1
        jal x0, xc_sw1_check_down
        xc_reset_sw1_check_up:
        addi x18, x0, 0x0

        xc_sw1_check_down:
        jal x25, check_down
        beq x15, x0, xc_exit_sw1_check
        beq x18, x0, xc_reset_sw1_check_down
        addi x18, x18, -1
        jal x0, xc_exit_sw1_check
        xc_reset_sw1_check_down:
        addi x18, x0, 0x9

        xc_exit_sw1_check:
        sw x18, 0x084(x16)

        /*input_sw0*/
        xc_input_sw0:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_yc
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw0
        beq x15, x0, xc_exit_sw0_check

        xc_sw0_check_up:
        jal x25, check_up
        beq x15, x0, xc_sw0_check_down
        addi x29, x0, 9
        beq x17, x29, xc_reset_sw0_check_up
        addi x17, x17, 1
        jal x0, xc_sw0_check_down
        xc_reset_sw0_check_up:
        addi x17, x0, 0x0

        xc_sw0_check_down:
        jal x25, check_down
        beq x15, x0, xc_exit_sw0_check
        beq x17, x0, xc_reset_sw0_check_down
        addi x17, x17, -1
        jal x0, xc_exit_sw0_check
        xc_reset_sw0_check_down:
        addi x17, x0, 0x9

        xc_exit_sw0_check:
        sw x17, 0x080(x16)


        jal x0, input_xc


        /*====================================*/
        /*===============yc===================*/
        /*====================================*/    
        addi x22, x0, 100
        jal x31, delay

        input_yc:
        /*L2:yc=*/
        ori x28, x26, 0xC0
        jal x25, lcd
        ori x28, x27, 0x79
        jal x25, lcd
        ori x28, x27, 0x43
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        ori x28, x27, 0x3D
        jal x25, lcd
        ori x28, x27, 0x20
        jal x25, lcd
        
        addi x16, x0, 0x64

        yc_loop:
        
        /*input_sw3*/
        yc_input_sw3:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xa
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw3
        addi x20, x15, 0x0
        sw x20, 0x08C(x16)

        /*input_sw2*/
        yc_input_sw2:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xa
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw2
        beq x15, x0, yc_exit_sw2_check

        yc_sw2_check_up:
        jal x25, check_up
        beq x15, x0, yc_sw2_check_down
        addi x29, x0, 9
        beq x19, x29, yc_reset_sw2_check_up
        addi x19, x19, 1
        jal x0, yc_sw2_check_down
        yc_reset_sw2_check_up:
        addi x19, x0, 0x0

        yc_sw2_check_down:
        jal x25, check_down
        beq x15, x0, yc_exit_sw2_check
        beq x19, x0, yc_reset_sw2_check_down
        addi x19, x19, -1
        jal x0, yc_exit_sw2_check
        yc_reset_sw2_check_down:
        addi x19, x0, 0x9

        yc_exit_sw2_check:
        sw x19, 0x088(x16)

        /*input_sw1*/
        yc_input_sw1:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xa
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw1
        beq x15, x0, yc_exit_sw1_check

        yc_sw1_check_up:
        jal x25, check_up
        beq x15, x0, yc_sw1_check_down
        addi x29, x0, 9
        beq x18, x29, yc_reset_sw1_check_up
        addi x18, x18, 1
        jal x0, yc_sw1_check_down
        yc_reset_sw1_check_up:
        addi x18, x0, 0x0

        yc_sw1_check_down:
        jal x25, check_down
        beq x15, x0, yc_exit_sw1_check
        beq x18, x0, yc_reset_sw1_check_down
        addi x18, x18, -1
        jal x0, yc_exit_sw1_check
        yc_reset_sw1_check_down:
        addi x18, x0, 0x9

        yc_exit_sw1_check:
        sw x18, 0x084(x16)

        /*input_sw0*/
        yc_input_sw0:
        jal x13, print_num

        jal x25, check_next
        bne x15, x0, input_xa
        jal x25, check_enter
        bne x15, x0, result

        jal x25, check_sw0
        beq x15, x0, yc_exit_sw0_check

        yc_sw0_check_up:
        jal x25, check_up
        beq x15, x0, yc_sw0_check_down
        addi x29, x0, 9
        beq x17, x29, yc_reset_sw0_check_up
        addi x17, x17, 1
        jal x0, yc_sw0_check_down
        yc_reset_sw0_check_up:
        addi x17, x0, 0x0

        yc_sw0_check_down:
        jal x25, check_down
        beq x15, x0, yc_exit_sw0_check
        beq x17, x0, yc_reset_sw0_check_down
        addi x17, x17, -1
        jal x0, yc_exit_sw0_check
        yc_reset_sw0_check_down:
        addi x17, x0, 0x9

        yc_exit_sw0_check:
        sw x17, 0x080(x16)

        jal x0, input_yc


        result:
        ori x28, x26, 0x38
        jal x25, lcd
        ori x28, x26, 0x0C
        jal x25, lcd
        ori x28, x26, 0x01
        jal x25, lcd
        ori x28, x26, 0x84
        jal x25, lcd
        ori x28, x27, 0x3C
        jal x25, lcd
        ori x28, x27, 0x52
        jal x25, lcd
        ori x28, x27, 0x45
        jal x25, lcd
        ori x28, x27, 0x53
        jal x25, lcd
        ori x28, x27, 0x55
        jal x25, lcd
        ori x28, x27, 0x4C
        jal x25, lcd
        ori x28, x27, 0x54
        jal x25, lcd
        ori x28, x27, 0x3E
        jal x25, lcd

        /*xa*/
        find_xa:
        addi x16, x0, 0x0
        lw x20, 0x08C(x16)
        lw x19, 0x088(x16)
        lw x18, 0x084(x16)
        lw x17, 0x080(x16)

        addi x1, x0, 0x0
        add x1, x1, x17
        addi x28, x9, 0
        xa_for1:
        addi x28, x28, -1
        beq x28, x0, xa_exit_for1
        add x1, x1, x18
        jal x0, xa_for1
        xa_exit_for1:
        addi x28, x24, 0
        xa_for2:
        addi x28, x28, -1
        beq x28, x0, xa_exit_for2
        add x1, x1, x19
        jal x0, xa_for2
        xa_exit_for2:
        beq x20, x0, find_ya
        sub x1, x0, x1

        /*ya*/
        find_ya:
        addi x16, x0, 0x14
        lw x20, 0x08C(x16)
        lw x19, 0x088(x16)
        lw x18, 0x084(x16)
        lw x17, 0x080(x16)

        addi x2, x0, 0x0
        add x2, x2, x17
        addi x28, x9, 0
        ya_for1:
        addi x28, x28, -1
        beq x28, x0, ya_exit_for1
        add x2, x2, x18
        jal x0, ya_for1
        ya_exit_for1:
        addi x28, x24, 0
        ya_for2:
        addi x28, x28, -1
        beq x28, x0, ya_exit_for2
        add x2, x2, x19
        jal x0, ya_for2
        ya_exit_for2:
        beq x20, x0, find_xb
        sub x2, x0, x2

        /*xb*/
        find_xb:
        addi x16, x0, 0x28
        lw x20, 0x08C(x16)
        lw x19, 0x088(x16)
        lw x18, 0x084(x16)
        lw x17, 0x080(x16)

        addi x3, x0, 0x0
        add x3, x3, x17
        addi x28, x9, 0
        xb_for1:
        addi x28, x28, -1
        beq x28, x0, xb_exit_for1
        add x3, x3, x18
        jal x0, xb_for1
        xb_exit_for1:
        addi x28, x24, 0
        xb_for2:
        addi x28, x28, -1
        beq x28, x0, xb_exit_for2
        add x3, x3, x19
        jal x0, xb_for2
        xb_exit_for2:
        beq x20, x0, find_yb
        sub x3, x0, x3

        /*yb*/
        find_yb:
        addi x16, x0, 0x28
        lw x20, 0x08C(x16)
        lw x19, 0x088(x16)
        lw x18, 0x084(x16)
        lw x17, 0x080(x16)

        addi x4, x0, 0x0
        add x4, x4, x17
        addi x28, x9, 0
        yb_for1:
        addi x28, x28, -1
        beq x28, x0, yb_exit_for1
        add x4, x4, x18
        jal x0, yb_for1
        yb_exit_for1:
        addi x28, x24, 0
        yb_for2:
        addi x28, x28, -1
        beq x28, x0, yb_exit_for2
        add x4, x4, x19
        jal x0, yb_for2
        yb_exit_for2:
        beq x20, x0, find_xc
        sub x4, x0, x4

        /*xc*/
        find_xc:
        addi x16, x0, 0x50
        lw x20, 0x08C(x16)
        lw x19, 0x088(x16)
        lw x18, 0x084(x16)
        lw x17, 0x080(x16)

        addi x5, x0, 0x0
        add x5, x5, x17
        addi x28, x9, 0
        xc_for1:
        addi x28, x28, -1
        beq x28, x0, xc_exit_for1
        add x5, x5, x18
        jal x0, xc_for1
        xc_exit_for1:
        addi x28, x24, 0
        xc_for2:
        addi x28, x28, -1
        beq x28, x0, xc_exit_for2
        add x5, x5, x19
        jal x0, xc_for2
        xc_exit_for2:
        beq x20, x0, find_yc
        sub x5, x0, x5

        /*yc*/
        find_yc:
        addi x16, x0, 0x64
        lw x20, 0x08C(x16)
        lw x19, 0x088(x16)
        lw x18, 0x084(x16)
        lw x17, 0x080(x16)

        addi x6, x0, 0x0
        add x6, x6, x17
        addi x28, x9, 0
        yc_for1:
        addi x28, x28, -1
        beq x28, x0, yc_exit_for1
        add x6, x6, x18
        jal x0, yc_for1
        yc_exit_for1:
        addi x28, x24, 0
        yc_for2:
        addi x28, x28, -1
        beq x28, x0, yc_exit_for2
        add x6, x6, x19
        jal x0, yc_for2
        yc_exit_for2:
        beq x20, x0, khoangcach
        sub x6, x0, x6

        khoangcach:
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
    jal x0, output
    comp_equal:
    addi x12, x0, 0
    jal x0, output
    comp_less:
    addi x12, x0, -1
    jal x0, output
    

output:
    ori x28, x26, 0xC0
    jal x25, lcd
    ori x28, x27, 0x43
    jal x25, lcd
    ori x28, x27, 0x6C
    jal x25, lcd
    ori x28, x27, 0x6F
    jal x25, lcd
    ori x28, x27, 0x73
    jal x25, lcd
    ori x28, x27, 0x65
    jal x25, lcd
    ori x28, x27, 0x72
    jal x25, lcd
    ori x28, x27, 0x20
    jal x25, lcd
    ori x28, x27, 0x74
    jal x25, lcd
    ori x28, x27, 0x6F
    jal x25, lcd
    ori x28, x27, 0x20
    jal x25, lcd
    ori x28, x27, 0x43
    jal x25, lcd
    ori x28, x27, 0x3A
    jal x25, lcd

    beq x12, x0, print_eq
    addi x28, x0, -1
    beq x12, x28, print_less
    addi x28, x0, 1
    beq x12, x28, print_gra
    jal x0, exit

    print_eq:
    ori x28, x26, 0xCD
    jal x25, lcd
    ori x28, x27, 0x41
    jal x25, lcd
    ori x28, x27, 0x26
    jal x25, lcd
    ori x28, x27, 0x42
    jal x25, lcd
    jal x0, exit

    print_less:
    ori x28, x26, 0xCD
    jal x25, lcd
    ori x28, x27, 0x41
    jal x25, lcd
    jal x0, exit

    print_gra:
    ori x28, x26, 0xCD
    jal x25, lcd
    ori x28, x27, 0x42
    jal x25, lcd
    jal x0, exit






         



        

exit:
    jal x25, exit

.data
variable:
	.word 0xdeadbeef
                    