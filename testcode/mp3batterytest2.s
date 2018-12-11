mp0test.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:

	lui x1, 0x04
	lui x2, 0x01
    nop
    nop
    nop
    nop
	add x2, x2, x1

	lui x4, 0x02
	lui x5, 0x01
    lui x12, 0xFFFFF
    nop
    nop
    nop
    nop
	xor x6, x5, x4
    or x8, x4, x5
    and x9, x4, x5
    sll x10, x4, x5
    sra x13, x12, x12
    srl x14, x12, x12
    sub x15, x4, x5
    slt x16, x4, x5
    sltu x17, x4, x5

    
    
    
    

halt:                 # Infinite loop to keep the processor
    beq x0, x0, halt  # from trying to execute the data below.
                      # Your own programs should also make use
                      # of an infinite loop at the end.
.section .rodata

bad:        .word 0xdeadbeef
threshold:  .word 0x00000040
result:     .word 0x00000000
good:       .word 0x600d600d

