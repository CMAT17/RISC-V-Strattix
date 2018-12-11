riscv_mp0test.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.

    # Note that one/two/eight are data labels
    #lw  x1, threshold # X1 <- 0x80
    lui  x2, 2       # X2 <= 2
    lui  x3, 8     # X3 <= 8
	lui  x10, 4
	lui  x11, 7
	lui  x12, 0xa
    nop
	nop
	nop
	nop

	srli x10, x10, 5
	nop
	nop
	nop
	nop
	
	srli x11, x11, 4
	nop
	nop
	nop
	nop
	
	srli x12, x12, 4
	nop
	nop
	nop
	nop

    addi x4, x3, 0xff    # X4 <= X3 + 2
	nop
	nop
	nop
	nop

	sw x10, 0(x10)
	nop
	nop
	nop
	nop
	
	sw x11, 0(x11)
	nop
	nop
	nop
	nop

	sw x12, 0(x12)

	sw x4, 0(x4)
	nop
	nop
	nop
	nop
	
	sw x20, 0(x10)
	sw x21, 0(x11)
	sw x22, 0(x12)

	lw x5, 0(x4)
	nop
	nop
	nop
	nop
	lh x6, 0(x4)
	lhu x7, 0(x4)
	lb x8, 0(x4)
	lbu x9, 0(x4)
	nop
	nop
	nop
	nop
	
	sw x6, 0(x10)
	sh x6, 0(x11)
	sb x6, 0(x12)
	nop
	nop
	nop
	nop
	
	lw x13, 0(x10)
	lw x14, 0(x11)
	lw x15, 0(x12)
	nop
	nop
	nop
	nop	
 

loop1:
    nop
	nop
	nop
	nop
	addi x2, x2, 1
	nop
	nop
	nop
	nop
   	bne x2, x3, loop1
	nop
	nop
	nop
	nop


loop2:
	nop
	nop
	nop
	nop
	jal x0, loop2
