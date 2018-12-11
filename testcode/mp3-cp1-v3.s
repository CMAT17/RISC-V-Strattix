#mp3-cp1.s version 3.0
.align 4
.section .text
.globl _start
_start:
    lw x1, %lo(NEGTWO)(x0)
    lw x2, %lo(TWO)(x0)
    lw x4, %lo(ONE)(x0)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    beq x0, x0, LOOP
    nop
    nop
    nop
    nop
    nop
    nop
    nop

.section .rodata
.balign 256
ONE:    .word 0x00000001
TWO:    .word 0x00000002
NEGTWO: .word 0xFFFFFFFE
TEMP1:  .word 0x00000001
GOOD:   .word 0x600D600D
BADD:   .word 0xBADDBADD

	
.section .text
.align 4
LOOP:
    add x3, x1, x2 # X3 <= X1 + X2
    and x5, x1, x4 # X5 <= X1 & X4
    not x6, x1     # X6 <= ~X1
    addi x9, x0, %lo(TEMP1) # X9 <= address of TEMP1
	addi x16, x0, %lo(NEGTWO)
	addi x20, x0, 0xff
	nop
	nop
	nop
	nop
	nop
	nop
	sll x20, x20, 12 
	nop
	nop
	nop
	nop
	nop
	nop
	addi x20, x20, 0xF
    nop
    nop
    nop
    nop
    nop
    nop
	sw x20, 0(x16)
	nop
	nop
	nop
	nop
	nop
	nop
	lw x17, %lo(NEGTWO)(x0)
	nop
	nop
	nop
	nop
	nop
	nop
	sw x0, 0(x16)
	nop
	nop
	nop
	nop
	nop
	nop
	sh x20, 0(x16)
	nop
	nop
	nop
	nop
	nop
	nop
	lw x18, %lo(NEGTWO)(x0)
	nop
	nop
	nop
	nop
	nop
	nop
	sw x0, 0(x16)
	nop
	nop
	nop
	nop
	nop
	nop
	sb x20, 0(x16)
	nop
	nop
	nop
	nop
	nop
	nop
	lw x19, %lo(NEGTWO)(x0) 
	nop
	nop
	nop
	nop
	nop
	nop
	lh x17, %lo(NEGTWO)(x0)
	lhu x18, %lo(NEGTWO)(x0)
	lb x17, %lo(NEGTWO)(x0)
	lbu x18, %lo(NEGTWO)(x0)
	nop
	nop
	nop
	nop
	nop
	nop
    sw x6, 0(x9)   # TEMP1 <= x6
    lw x7, %lo(TEMP1)(x0) # X7    <= TEMP1
    add x1, x1, x4 # X1    <= X1 + X4
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    blt x0, x1, DONEa
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    beq x0, x0, LOOP
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    lw x1, %lo(BADD)(x0)
HALT:	
    beq x0, x0, HALT
    nop
    nop
    nop
    nop
    nop
    nop
    nop
		
DONEa:
    lw x1, %lo(GOOD)(x0)
	lh x12, %lo(GOOD)(x0)
	lhu x13, %lo(GOOD)(x0)
	lb x14, %lo(GOOD)(x0)
	lbu x15, %lo(GOOD)(x0)
DONEb:	
    beq x0, x0, DONEb
    nop
    nop
    nop
    nop
    nop
    nop
    nop
	
