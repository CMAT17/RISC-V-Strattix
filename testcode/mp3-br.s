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
    nop
	nop
	nop
	nop

    addi x4, x3, 4    # X4 <= X3 + 2
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
