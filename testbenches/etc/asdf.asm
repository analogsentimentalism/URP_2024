main:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        li      a5,1
        sw      a5,-20(s0)
        li      a5,2
        sw      a5,-20(s0)
        li      a5,3
        sw      a5,-20(s0)
        li      a5,4
        sw      a5,-20(s0)
        sw      zero,-24(s0)
        j       .L2
.L5:
        lw      a4,-24(s0)
        lw      a5,-20(s0)
        sub     a5,a4,a5
        seqz    a5,a5
        andi    a5,a5,0xff
        bne     a5,zero,.L7
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L2:
        lw      a5,-24(s0)
        slti    a5,a5,10
        andi    a5,a5,0xff
        bne     a5,zero,.L5
        j       .L4
.L7:
        nop
.L4:
        sw      zero,-20(s0)
        sw      zero,-24(s0)
        li      a5,0
        mv      a0,a5
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra