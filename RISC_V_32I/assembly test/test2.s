addi a0, zero, 0x055
lui a1, 0x94000
addi a2, zero, 0x001
addi t0, zero, 0x100
addi a3, zero, 0x006
addi a7, zero, 0x008

shift:
    sll a4, a0, a2
    srl a5, a1, a2
    sra a6, a1, a2
    slt t1, a4, a7
    slti t2, a2, 0x003
    sltu t3, a6, zero
    sltiu t4, a2, -0x003
    sw a4, 0x000(t0)
    sw a5, 0x004(t0)
    sw a6, 0x008(t0)
    addi t0, t0, 0x00C
    addi a2, a2, 0x001
    bge a3, a2, shift
    add t5, zero, t0
   	jal ra, logic
    
logic:
    addi a4, zero, -0x001
    and a5, a4, a0
    xor a6, a4, a0
    or  a7, a4, a0
    sw  a5, 0x004(t0)
    sw  a6, 0x008(t0)
    sw  a7, 0x00C(t0)
    andi a5, a4, -0x002
    xori a6, a4, -0x002
    ori  a7, a4, -0x002
    sw  a5, 0x010(t0)
    sw  a6, 0x014(t0)
    sw  a7, 0x018(t0)

addi t0, zero, 0x100
lw a5, 0x000(t0)
lw a6, 0x004(t0)
lw a7, 0x008(t0)
nop
