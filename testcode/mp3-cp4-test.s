#  mp3-cp3.s version 1.0
.align 4
.section .text
.globl _start
_start:

# From the MP3 doc:
# 	By checkpoint 3, your pipeline should be able to do hazard detection and forwarding.
# 	Note that you should not stall or forward for dependencies on register x0 or when an
# 	instruction does not use one of the source registers (such as rs2 for immediate instructions). 
# 	Furthermore, your L2 cache should be completed and integrated into your cache hierarchy.

# check that we can write to physical memory through eviction write buffer
#	- no wires exist for L2 to write to physical memory, only read
	la	 x1, TEST
	add  x2, x0, 55
	sw	 x2, 0(x1)
	lw	 x3, TEST

	beq	 x3, x0, hard_fail	# check if value placed and retrieved from physical memory correctly 

# Initialize x1 with 0 to record number of mis-predicts manually
	addi x1, x0, -1

# Initialize x2 with 0 to load mis-predict counter into to check against
	add  x2, x0, x0

# Create mis-predict loop limiter to only run loop 10 times
	addi x3, x0, 10

loop_on_mispredicts:
	addi x4, x0, 1
	addi x1, x1, 1			# increment mis-predict count
	addi x8, x0, 0xFFFFFFF8
	lw	 x2, 0(x8)			# load mis-predict count into register x2
	sub  x3, x3, x4			# decrement loop limiter

	beq  x3, x0, test_mispredict_count	# 10 iterations, increments mis-predict on final comp -> taken
	bne  x3, x0, loop_on_mispredicts	# statically predict not-taken, so this increments mis-predict counter
	beq  x0, x0, hard_fail

test_mispredict_count:
	beq  x1, x2, test_correct_predict_count
	beq  x0, x0, hard_fail

no_mispredicts:
	beq  x0, x0, test_stall_mem_dep

test_correct_predict_count:
# test that branches are statically predicted not-taken
	addi x8, x0, 0xFFFFFFF8
	sw	 x0, 0(x8)	# reset branch_mispred_count
	addi x8, x0, 0xFFFFFFF9
	sw   x0, 0(x8)	# reset branch_count

	bne  x0, x0, hard_fail	
	bne  x0, x0, hard_fail
	bne  x0, x0, hard_fail	
	bne  x0, x0, hard_fail
	bne  x0, x0, hard_fail
	
	addi x8, x0, 0xFFFFFFF8
	lw   x1, 0(x8)
	beq  x0, x1, no_mispredicts
	beq  x0, x0, hard_fail

test_stall_mem_dep:
# tests whether the count for memory instruction dependencies stalling pipeline is correct
	addi x8, x0, 0xFFFFFFF7
	sw   x0, 0(x8)	# reset stall_mem_dep_count
	lw	 x6, 0(x8)

	lw   x1, FULL
	add  x1, x1, 4
	
	addi x8, x0, 0xFFFFFFF7
	lw   x2, 0(x8)
	addi x3, x0, 1

	beq  x2, x3, test_stall_dec_wb_dep
	beq  x0, x0, hard_fail

test_stall_dec_wb_dep:
	addi x8, x0, 0xFFFFFFF6
	sw   x0, 0(x8)	# reset stall_dec_wb_dep_count
	lw	 x1, 0(x8)
	
	addi x10, x0, 1
	addi x2, x0, 2
	addi x3, x0, 3
	add	 x4, x10, x2	# create 2 WR -> DEC dependencies, so count increments 2

	addi x8, x0, 0xFFFFFFF6
	lw   x9, 0(x8)
	
	beq  x9, x2, success

soft_fail:
	lw   x5, SOFT_FAIL
	beq  x0, x0, soft_fail

success:
	lw   x5, SUCCESS
	beq  x0, x0, success

hard_fail:
	lw   x5, HARD_FAIL
	beq  x0, x0, hard_fail


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
HARD_FAIL:	.word 0xFFFFFBAD
SOFT_FAIL:	.word 0x00000BAD
SUCCESS:	.word 0x050CCE55
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
