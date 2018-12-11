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
	addi x2, x2, 0x01

	lui x4, 0x02
	lui x5, 0x01
    lui x12, 0xFFFFF
    nop
    nop
    nop
    nop
	xori x6, x5, 0x01
    auipc x7, 0x01 
    ori x8, x4, 0xFF
    andi x9, x4, 0x7FF
    slli x10, x4, 0x02
    srai x13, x12, 30
    srli x14, x12, 30
    slti x15, x4, 0x7FF
    sltiu x16, x4, 0x7FF
    
    
    

halt:                 # Infinite loop to keep the processor
    beq x0, x0, halt  # from trying to execute the data below.
                      # Your own programs should also make use
                      # of an infinite loop at the end.
.section .rodata

bad:        .word 0xdeadbeef
threshold:  .word 0x00000040
result:     .word 0x00000000
good:       .word 0x600d600d

