lw_sw_all:
.align 4
.section .text
.globl _start
_start:
    
    # LRU = 0 0 0 0 1 0 0 0
    # way 0, set 011
    # Get some base addresses
    la x1, G60 # R0 <= 0x2c0, 2 instr
    la x2, S60 # R1 <= 0x3c0, 2 instr
    la x3, B60 # R2 <= 0x500, 2 instr

    lw x8, B74 #x8 <= 0xBADDBADD, 2 instr, cache miss (no write-back), way 0, set 001, LRU = 0 0 0 0 1 0 1 0 

    # cache miss on instructions, set 100, way 0, LRU = 0 0 0 1 1 0 1 0
    lw x8, S76 #x8 <= 0x52205220, 2 instr, cache miss (no write-back), way 0, set 111, LRU = 1 0 0 1 1 0 1 0 
    lw x7, B70 #x7 <= 0xBADDBADD, 2 instr, cache hit on way 0, set 001, check if still there
    lw x8, G7C #x8 <= 0x600D600D, 2 instr, cache miss (no write-back), way 1, set 111, LRU = 0 0 0 1 1 0 1 0 
    lw x7, G7C #x7 <= 0x600D600D, 2 instr, cache hit on way 1, set 111, check if still there

    # cache miss on instructions, set 101, way 0, LRU = 0 0 1 1 1 0 1 0
    lw x7, S7E #x7 <= 0x52205220, 2 instr, cache hit on way 0, set 111, check if still there, LRU = 1 0 1 1 1 0 1 0
    lw x7, B78 #x7 <= 0xBADDBADD, 2 instr, cache hit on way 0, set 001, check if still there
    lw x7, B78 #x7 <= 0xBADDBADD, 2 instr, cache hit on way 0, set 001, check if still there
    lw x7, B78 #x7 <= 0xBADDBADD, 2 instr, cache hit on way 0, set 001, check if still there

    # cache miss on instructions, set 110, way 0, LRU = 1 1 1 1 1 0 1 0
    lw x6, B62 #x6 <= 0xB99DB99D, 2 instr, cache miss (no write-back), way 0, set 000, LRU = 1 1 1 1 1 0 1 1

    lw x5, S66 #x5 <= 0x5DD05DD0, 2 instr, cache miss (no write-back), way 1, set 110, LRU = 1 0 1 1 1 0 1 1 
    
    # cache hit on set 110, way 0, LRU = 1 1 1 1 1 0 1 1
    sw x7, 16(x2) # S66 <= x7, 1 instr, cache hit on way 1, set 110, LRU = 1 0 1 1 1 0 1 1, dirty_bit1 = 0 1 0 0 0 0 0 0 
    
    # cache hit on set 110, way 0, LRU = 1 1 1 1 1 0 1 1
    lw x6, B66 #x6 <= 0xBBBDBBBD, 2 instr, cache hit on way 0, set 000, check if still there 
    sw x2, 20(x2) # S6A <= x2, 1 instr, cache hit on way 1, set 110, LRU = 1 0 1 1 1 0 1 1

    # cache miss on instructions (no writeback), set 111, way 1, LRU = 0 0 1 1 1 0 1 1
    sw x2, 8(x2) # S64 <= x2, 1 instr, cache hit on way 1, set 110, LRU = 0 0 1 1 1 0 1 1
    sw x2, 0(x1) # G60 <= x2, 1 instr, cache miss (no write-back), way 0, set 110, LRU = 0 1 1 1 1 0 1 1, dirty_bit0 = 0 1 0 0 0 0 0 0

    addi x5, x2, 1 # x5 <= x2 + 1 = 0x3c1 , 1 instr
    sw x5, 20(x2)  # S6A <= x2, 1 instr, cache hit on way 1, set 110, LRU = 0 0 1 1 1 0 1 1 

    la x1, G30 # x1 <= 260, 2 instr
    beq x0, x0, MORE # 1 instr, cache miss on branch address (no write-back), way 1, set 000, LRU = 0 0 1 1 1 0 1 0

.section .rodata
.balign 256
.zero 96

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

.section .text
.align 4

MORE:
    #instructions being read from way 1 set 000
    #LRU = 0 0 1 1 1 0 1 0
    #dirty_bit0 = 0 1 0 0 0 0 0 0
    #dirty_bit1 = 0 1 0 0 0 0 0 0

    la x2, S30 # x2 = 360, 2 instr
    la x3, B30 # x3 = 4a0, 2 instr

    sw x1, 64(x1) # G50 <= x1, 1 instr, cache miss (no write back), way 1, set 101, LRU = 0 0 0 1 1 0 1 0, dirty_bit1 = 0 1 1 0 0 0 0 0
    sw x2, 68(x2) # S52 <= x2, 1 instr, cache miss (no write back), way 0, set 101, LRU = 0 0 1 1 1 0 1 0, dirty_bit0 = 0 1 1 0 0 0 0 0
    sw x3, 72(x3) # B54 <= x3, 1 instr, cache miss (no write back), way 0, set 111, LRU = 1 0 1 1 1 0 1 0, dirty_bit0 = 1 1 1 0 0 0 0 0
    sw x3, 80(x1) # G58 <= x3, 1 instr, cache hit on way 1, set 101, LRU = 1 0 0 1 1 0 0 0

    # cache miss on instructions, way 1, set 001
    # LRU = 1 0 0 1 1 0 0 0
    # dirty_bit0 = 1 1 1 0 0 0 0 0
    # dirty_bit1 = 0 1 1 0 0 0 0 0
    lw x8, S52 # x8 <= 0x00000360, 2 instr, cache hit on way 0, set 101, LRU = 1 0 1 1 1 0 0 0
    lw x6, B5A # x6 <= 0xBAADBAAD, 2 instr, cache hit on way 0, set 111, LRU = 1 0 1 1 1 0 0 0 
    lw x7, G54 # x7 <= 0x600D600D, 2 instr, cache hit on way 1, set 101, LRU = 1 0 0 1 1 0 0 0 
    lw x6, S46 # x6 <= 0x52205220, 2 instr, cache miss (no write back), way 1, set 100, LRU = 1 0 0 0 1 0 0 0

    # cache miss on instructions, way 0 ,set 010
    # LRU = 1 0 0 0 1 1 0 0
    addi x5, x3, 1 # x5 <= x3 + 1 = 4a1, 1 instr
    lw x7, B42 # x7 <= 0xBAADBAAD, 2 instr, cache miss (write back of way 0 set 110), LRU = 1 1 0 0 1 1 0 0, dirty_bit0 = 1 0 1 0 0 0 0 0 
    add x7, x6, x7 # x7 <= x6+ x7 = 0x0CCE0CCD, overflow
    lw x6, G40 # x6 <= 0x00C200C2, 2 instr, cache miss (no write back), way 0, set 100, LRU = 1 1 0 1 1 1 0 0 
    add x7, x6, x7 # x7 <= x6 + x7 = 0d900d8f
    sw x7, 36(x1) # G42 <= x7, 1 instr, cache hit on way 0, set 100, dirty_bit0 = 1 0 1 1 0 0 0 0

    # cache miss on instructions, way 1, set 011
    # LRU  = 1 1 0 1 0 1 0 0
    # dirty_bit0 = 1 0 1 1 0 0 0 0
    # dirty_bit1 = 0 1 1 0 0 0 0 0
    and x4, x4, 0 # x4 <= x4 ^ 0 = 0, 1 instr 
    addi x4, x4, 13 # x4 <= x4 + 13 = 13, 1 instr
    sw x7, 0(x1) # G30 <= x7, 1 instr, cache miss (no write back), way 0, set 011, LRU = 1 1 0 1 1 1 0 0, dirty_bit0 = 1 0 1 1 1 0 0 0
    addi x5, x1, 1 # x5 <= x1 + 1 = 261, 1 instr
    lw x5, G30 # x5 <= 0d900d8f, 2 instr, cache hit on way 0, set 011
    sw x5, 20(x1) # G3A <= x5, 1 instr, cache hit on way 0, set 011 
    beq x0, x0, LOOP # 1 instr, cache miss on branch, LRU = 1 1 0 1 0 1 0 0

.section .rodata
.balign 256
.zero 96

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

V10: .word 0xBADDBADD
V12: .word 0xBADDBADD
V14: .word 0xB22DB22D
V16: .word 0xB33DB33D
V18: .word 0xB44DB44D
V1A: .word 0xB55DB55D
V1C: .word 0xB66DB66D
V1E: .word 0xB77DB77D
V20: .word 0xB88DB88D
V22: .word 0xB99DB99D
V24: .word 0xBAADBAAD
V26: .word 0xBBBDBBBD
V28: .word 0xBCCDBCCD
V2A: .word 0xBDDDBDDD
V2C: .word 0xBEEDBEED
V2E: .word 0xBFFDBFFD
V30: .word 0xBAADBAAD
V32: .word 0xBAADBAAD
V34: .word 0xBAADBAAD
V36: .word 0xBAADBAAD
V38: .word 0xBAADBAAD
V3A: .word 0xBAADBAAD
V3C: .word 0xBAADBAAD
V3E: .word 0xBAADBAAD
V40: .word 0xBAADBAAD
V42: .word 0xBAADBAAD
V44: .word 0xBAADBAAD
V46: .word 0xBAADBAAD
V48: .word 0xBAADBAAD
V4A: .word 0xBAADBAAD
V4C: .word 0xBAADBAAD
V4E: .word 0xBAADBAAD
V50: .word 0xBAADBAAD
V52: .word 0xBAADBAAD
V54: .word 0xBAADBAAD
V56: .word 0xBAADBAAD
V58: .word 0xBAADBAAD
V5A: .word 0xBAADBAAD
V5C: .word 0xBAADBAAD
V5E: .word 0xBAADBAAD
V60: .word 0xB88DB88D
V62: .word 0xB99DB99D
V64: .word 0xBAADBAAD
V66: .word 0xBBBDBBBD
V68: .word 0xBCCDBCCD
V6A: .word 0xBDDDBDDD
V6C: .word 0xBEEDBEED
V6E: .word 0xBFFDBFFD
V70: .word 0xBADDBADD
V72: .word 0xBADDBADD
V74: .word 0xBADDBADD
V76: .word 0xBADDBADD
V78: .word 0xBADDBADD
V7A: .word 0xBADDBADD
V7C: .word 0xBADDBADD
V7E: .word 0xBADDBADD
X10: .word 0xBADDBADD
X12: .word 0xBADDBADD
X14: .word 0xB22DB22D
X16: .word 0xB33DB33D
X18: .word 0xB44DB44D
X1A: .word 0xB55DB55D
X1C: .word 0xB66DB66D
X1E: .word 0xB77DB77D
X20: .word 0xB88DB88D
X22: .word 0xB99DB99D
X24: .word 0xBAADBAAD
X26: .word 0xBBBDBBBD
X28: .word 0xBCCDBCCD
X2A: .word 0xBDDDBDDD
X2C: .word 0xBEEDBEED
X2E: .word 0xBFFDBFFD
X30: .word 0xBAADBAAD
X32: .word 0xBAADBAAD
X34: .word 0xBAADBAAD
X36: .word 0xBAADBAAD
X38: .word 0xBAADBAAD
X3A: .word 0xBAADBAAD
X3C: .word 0xBAADBAAD
X3E: .word 0xBAADBAAD
X40: .word 0xBAADBAAD
X42: .word 0xBAADBAAD
X44: .word 0xBAADBAAD
X46: .word 0xBAADBAAD
X48: .word 0xBAADBAAD
X4A: .word 0xBAADBAAD
X4C: .word 0xBAADBAAD
X4E: .word 0xBAADBAAD
X50: .word 0xBAADBAAD
X52: .word 0xBAADBAAD
X54: .word 0xBAADBAAD
X56: .word 0xBAADBAAD
X58: .word 0xBAADBAAD
X5A: .word 0xBAADBAAD
X5C: .word 0xBAADBAAD
X5E: .word 0xBAADBAAD
X60: .word 0xB88DB88D
X62: .word 0xB99DB99D
X64: .word 0xBAADBAAD
X66: .word 0xBBBDBBBD
X68: .word 0xBCCDBCCD
X6A: .word 0xBDDDBDDD
X6C: .word 0xBEEDBEED
X6E: .word 0xBFFDBFFD
X70: .word 0xBADDBADD
X72: .word 0xBADDBADD
X74: .word 0xBADDBADD
X76: .word 0xBADDBADD
X78: .word 0xBADDBADD
X7A: .word 0xBADDBADD
X7C: .word 0xBADDBADD
X7E: .word 0xBADDBADD

T10: .word 0xBADDBADD
T12: .word 0xBADDBADD
T14: .word 0xB22DB22D
T16: .word 0xB33DB33D
T18: .word 0xB44DB44D
T1A: .word 0xB55DB55D
T1C: .word 0xB66DB66D
T1E: .word 0xB77DB77D
T20: .word 0xB88DB88D
T22: .word 0xB99DB99D
T24: .word 0xBAADBAAD
T26: .word 0xBBBDBBBD
T28: .word 0xBCCDBCCD
T2A: .word 0xBDDDBDDD
T2C: .word 0xBEEDBEED
T2E: .word 0xBFFDBFFD
T30: .word 0xBAADBAAD
T32: .word 0xBAADBAAD
T34: .word 0xBAADBAAD
T36: .word 0xBAADBAAD
T38: .word 0xBAADBAAD
T3A: .word 0xBAADBAAD
T3C: .word 0xBAADBAAD
T3E: .word 0xBAADBAAD
T40: .word 0xBAADBAAD
T42: .word 0xBAADBAAD
T44: .word 0xBAADBAAD
T46: .word 0xBAADBAAD
T48: .word 0xBAADBAAD
T4A: .word 0xBAADBAAD
T4C: .word 0xBAADBAAD
T4E: .word 0xBAADBAAD
T50: .word 0xBAADBAAD
T52: .word 0xBAADBAAD
T54: .word 0xBAADBAAD
T56: .word 0xBAADBAAD
T58: .word 0xBAADBAAD
T5A: .word 0xBAADBAAD
T5C: .word 0xBAADBAAD
T5E: .word 0xBAADBAAD
T60: .word 0xB88DB88D
T62: .word 0xB99DB99D
T64: .word 0xBAADBAAD
T66: .word 0xBBBDBBBD
T68: .word 0xBCCDBCCD
T6A: .word 0xBDDDBDDD
T6C: .word 0xBEEDBEED
T6E: .word 0xBFFDBFFD
T70: .word 0xBADDBADD
T72: .word 0xBADDBADD
T74: .word 0xBADDBADD
T76: .word 0xBADDBADD
T78: .word 0xBADDBADD
T7A: .word 0xBADDBADD
T7C: .word 0xBADDBADD
T7E: .word 0xBADDBADD
C10: .word 0xBADDBADD
C12: .word 0xBADDBADD
C14: .word 0xB22DB22D
C16: .word 0xB33DB33D
C18: .word 0xB44DB44D
C1A: .word 0xB55DB55D
C1C: .word 0xB66DB66D
C1E: .word 0xB77DB77D
C20: .word 0xB88DB88D
C22: .word 0xB99DB99D
C24: .word 0xBAADBAAD
C26: .word 0xBBBDBBBD
C28: .word 0xBCCDBCCD
C2A: .word 0xBDDDBDDD
C2C: .word 0xBEEDBEED
C2E: .word 0xBFFDBFFD
C30: .word 0xBAADBAAD
C32: .word 0xBAADBAAD
C34: .word 0xBAADBAAD
C36: .word 0xBAADBAAD
C38: .word 0xBAADBAAD
C3A: .word 0xBAADBAAD
C3C: .word 0xBAADBAAD
C3E: .word 0xBAADBAAD
C40: .word 0xBAADBAAD
C42: .word 0xBAADBAAD
C44: .word 0xBAADBAAD
C46: .word 0xBAADBAAD
C48: .word 0xBAADBAAD
C4A: .word 0xBAADBAAD
C4C: .word 0xBAADBAAD
C4E: .word 0xBAADBAAD
C50: .word 0xBAADBAAD
C52: .word 0xBAADBAAD
C54: .word 0xBAADBAAD
C56: .word 0xBAADBAAD
C58: .word 0xBAADBAAD
C5A: .word 0xBAADBAAD
C5C: .word 0xBAADBAAD
C5E: .word 0xBAADBAAD
C60: .word 0xB88DB88D
C62: .word 0xB99DB99D
C64: .word 0xBAADBAAD
C66: .word 0xBBBDBBBD
C68: .word 0xBCCDBCCD
C6A: .word 0xBDDDBDDD
C6C: .word 0xBEEDBEED
C6E: .word 0xBFFDBFFD
C70: .word 0xBADDBADD
C72: .word 0xBADDBADD
C74: .word 0xBADDBADD
C76: .word 0xBADDBADD
C78: .word 0xBADDBADD
C7A: .word 0xBADDBADD
C7C: .word 0xBADDBADD
C7E: .word 0xBADDBADD

.section .text
.align 4

# cache miss on instructions from branch (no write-back), way 1 set 100
# LRU = 1 1 0 0 0 1 0 0
# dirty_bit0 = 1 0 1 1 1 0 0 0
# dirty_bit1 = 0 1 1 0 0 0 0 0
# below are first iteration comments
LOOP:
    lw x6, S34 # x6 = 0x52205220, 2 instr, cache miss (write back of way 0, set 011), LRU = 1 1 0 0 1 1 0 0, dirty_bit0 = 1 0 1 1 0 0 0 0 
    lw x5, G32 # x5 = 0x600D600D, 2 instr, cache miss (no write back), way 1, set 011, LRU = 1 1 0 1 1 1 0 0
    lw x7, G30 # x7 = 0x0d900d8f, 2 instr, cache hit, way 1, set 011 
    lw x7, G34 # x7 = 0x600D600D, 2 instr, cache hit, way 1, set 011 

# cache miss on instructions, way 1, set 011
# LRU = 1 1 0 0 0 1 0 0
    lw x5, B3C # x5 = 0xBAADBAAD, 2 instr , cache miss (write back of way 1, set 101), LRU = 1 1 1 0 1 1 0 0, dirty_bit0 = 1 0 0 1 0 0 0 0
    addi x4, x4, -1
    bgtz x4, LOOP

    sw x1, V10
    sw x1, V20
    sw x1, V30
    sw x1, V40
    sw x1, V50
    sw x1, V60
    sw x1, V70
    sw x1, T10
    sw x1, T20
    sw x1, T30
    sw x1, T40
    sw x1, T50
    sw x1, T60
    sw x1, T70
    sw x1, C10
    sw x1, C20
    sw x1, C30
    sw x1, C40
    sw x1, C50
    sw x1, C60
    sw x1, C70
    sw x1, X10
    sw x1, X20
    sw x1, X30
    sw x1, X40
    sw x1, X50
    sw x1, X60
    sw x1, X70

HALT:  
    beq x0, x0, HALT

.section .rodata
.balign 256
.zero 96

