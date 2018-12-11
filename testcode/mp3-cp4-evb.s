#  mp3-cp3.s version 1.0
.align 4
.section .text
.globl _start
_start:
	
	add  x1, x0, x0
	addi x2, x0, 32
	addi x10, x0, 0x80
	addi x11, x0, 0x80

loop:

	la	 x3, A

	sll  x4, x2, x1	
	add	 x3, x3, x4

	sw	 x10, 0(x3)
	sw	 x10, 4(x3)
	sw	 x10, 8(x3)
	sw	 x10, 12(x3)
	sw	 x10, 16(x3)
	sw	 x10, 24(x3)
	sw	 x10, 28(x3)
	sw	 x10, 32(x3)

	addi x1, x1, 0x2
	
	bne  x1, x11, loop

halt:
	beq  x0, x0, halt


.section .rodata
.balign 256
DataSeg:
	nop
	nop
	nop
	nop
	nop
	nop
BAD:    		.word 0x00BADBAD
PAY_RESPECTS:	.word 0xFFFFFFFF
   # cache line boundary - this cache line should never be loaded

A:		.word 0x00000001
GOOD:	.word 0x600D600D
NOPE:	.word 0x00BADBAD
TEST:	.word 0x00000000
FULL:	.word 0xFFFFFFFF
	nop
	nop
	nop
   # cache line boundary

B:		.word 0x00000002
	nop
	nop
	nop
	nop
	nop
	nop
	nop
   # cache line boundary

C:		.word 0x00000003
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	# cache line boundary

D:		.word 0x00000004
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	# cache line boundary

E:		.word 0x00000005
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	# cache line boundary


F:		.word 0x00000006
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	# cache line boundary


_10:		.word 0x00000007
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	# cache line boundary


_11:		.word 0x00000008
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	# cache line boundary
