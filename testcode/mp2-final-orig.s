lw_sw_all:
.align 4
.section .text
.globl _start
_start:

    lw x10, B74
    lw x11, S76
    lw x7, B70
    lw x12, G7C
    lw x4, G7C
    lw x5, S7E
    lw x6, B78
    lw x7, B78
    lw x8, B78
    lw x5, B62
    lw x6, S66
    sw x6, S68, x9
    lw x2, B66
    sw x2, S6A, x9
    sw x2, S64, x9
    sw x2, G60, x9
    addi x5, x2, 1
    sw x5, S6A, x9

    sw x1, G50, x9
    sw x2, S52, x9
    sw x3, B54, x9
    sw x3, G58, x9
    lw x13, S52
    lw x14, B5A
    lw x7, G54
    lw x6, S46
    addi x5, x3, 1
    lw x7, B42
    add x7, x6, x7
    add x7, x6, x7
    addi x4, x1, 0
    addi x4, x4, 13
    sw x7, G30, x9
    addi x5, x1, 1
    lw x5, G30
    sw x5, G3A, x9

LOOP:
    lw x6, S34
    lw x5, G32
    lw x7, G30
    lw x7, G34
    lw x5, B3C
    addi x4, x4, -1
    bgtz x4, LOOP

HALT:
    beq x0, x0, HALT

.section .rodata

G30: .word 0x600D600D
G32: .word 0x600D600D
G34: .word 0x600D600D
G36: .word 0x600D600D
G38: .word 0x600D600D
G3A: .word 0x600D600D
G3C: .word 0x600D600D
G3E: .word 0x600D600D

G40: .word 0x00C200C2
G42: .word 0x01480148
G44: .word 0x11221122
G46: .word 0x33443344
G48: .word 0x55665566
G4A: .word 0x77887788
G4C: .word 0x99AA99AA
G4E: .word 0xBBCCBBCC

G50: .word 0x600D600D
G52: .word 0x600D600D
G54: .word 0x600D600D
G56: .word 0x600D600D
G58: .word 0x600D600D
G5A: .word 0x600D600D
G5C: .word 0x600D600D
G5E: .word 0x600D600D

G60: .word 0x666D666D
G62: .word 0x677D677D
G64: .word 0x688D688D
G66: .word 0x699D699D
G68: .word 0x6AAD6AAD
G6A: .word 0x6BBD6BBD
G6C: .word 0x6CCD6CCD
G6E: .word 0x6DDD6DDD

G70: .word 0x600D600D
G72: .word 0x600D600D
G74: .word 0x600D600D
G76: .word 0x600D600D
G78: .word 0x600D600D
G7A: .word 0x600D600D
G7C: .word 0x600D600D
G7E: .word 0x600D600D

S30: .word 0x52205220
S32: .word 0x52205220
S34: .word 0x52205220
S36: .word 0x52205220
S38: .word 0x52205220
S3A: .word 0x52205220
S3C: .word 0x52205220
S3E: .word 0x52205220

S40: .word 0x52205220
S42: .word 0x52205220
S44: .word 0x52205220
S46: .word 0x52205220
S48: .word 0x52205220
S4A: .word 0x52205220
S4C: .word 0x52205220
S4E: .word 0x52205220

S50: .word 0x52205220
S52: .word 0x52205220
S54: .word 0x52205220
S56: .word 0x52205220
S58: .word 0x52205220
S5A: .word 0x52205220
S5C: .word 0x52205220
S5E: .word 0x52205220

S60: .word 0x5AA05AA0
S62: .word 0x5BB05BB0
S64: .word 0x5CC05CC0
S66: .word 0x5DD05DD0
S68: .word 0x5EE05EE0
S6A: .word 0x5FF05FF0
S6C: .word 0x51105110
S6E: .word 0x52205220

S70: .word 0x52205220
S72: .word 0x52205220
S74: .word 0x52205220
S76: .word 0x52205220
S78: .word 0x52205220
S7A: .word 0x52205220
S7C: .word 0x52205220
S7E: .word 0x52205220

B10: .word 0xBADDBADD
B12: .word 0xBADDBADD
B14: .word 0xB22DB22D
B16: .word 0xB33DB33D
B18: .word 0xB44DB44D
B1A: .word 0xB55DB55D
B1C: .word 0xB66DB66D
B1E: .word 0xB77DB77D

B20: .word 0xB88DB88D
B22: .word 0xB99DB99D
B24: .word 0xBAADBAAD
B26: .word 0xBBBDBBBD
B28: .word 0xBCCDBCCD
B2A: .word 0xBDDDBDDD
B2C: .word 0xBEEDBEED
B2E: .word 0xBFFDBFFD

B30: .word 0xBAADBAAD
B32: .word 0xBAADBAAD
B34: .word 0xBAADBAAD
B36: .word 0xBAADBAAD
B38: .word 0xBAADBAAD
B3A: .word 0xBAADBAAD
B3C: .word 0xBAADBAAD
B3E: .word 0xBAADBAAD

B40: .word 0xBAADBAAD
B42: .word 0xBAADBAAD
B44: .word 0xBAADBAAD
B46: .word 0xBAADBAAD
B48: .word 0xBAADBAAD
B4A: .word 0xBAADBAAD
B4C: .word 0xBAADBAAD
B4E: .word 0xBAADBAAD

B50: .word 0xBAADBAAD
B52: .word 0xBAADBAAD
B54: .word 0xBAADBAAD
B56: .word 0xBAADBAAD
B58: .word 0xBAADBAAD
B5A: .word 0xBAADBAAD
B5C: .word 0xBAADBAAD
B5E: .word 0xBAADBAAD

B60: .word 0xB88DB88D
B62: .word 0xB99DB99D
B64: .word 0xBAADBAAD
B66: .word 0xBBBDBBBD
B68: .word 0xBCCDBCCD
B6A: .word 0xBDDDBDDD
B6C: .word 0xBEEDBEED
B6E: .word 0xBFFDBFFD

B70: .word 0xBADDBADD
B72: .word 0xBADDBADD
B74: .word 0xBADDBADD
B76: .word 0xBADDBADD
B78: .word 0xBADDBADD
B7A: .word 0xBADDBADD
B7C: .word 0xBADDBADD
B7E: .word 0xBADDBADD
