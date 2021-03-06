.align 4
.section .text
.globl _start

_start:

    la x8, ZERO					# x8 = address of ZERO (0x00000570)
    addi x1, x1, 12				# x1 = 0x0000000c (12)
    nop
    nop
    nop

    addi x1, x1, -5				# x1 = 0x00000007 (7)
    nop
    nop
    nop

    addi x1, x1, 0				# x1 = 0x00000007 (7)
    nop
    nop
    nop

    sw x1, aacus, x15			# 0xFFFFFFFF = 7

    andi x2, x8, 0x00000F		# x2 = 0x00000570 AND 0x00000F = 0x0
    nop
    nop
    nop

    sw x2, joiner, x15			# 0x00001010 = 0x0 
    nop
    nop
    nop

    lw x3, DEEB					# x3 = 0xDEEBDEEB
    nop
    nop
    nop
    lw x4, LEAF					# x4 = 0x00001EAF
    nop
    nop
    nop
    lw x5, D22D					# x5 = 0xD22DD22D
    nop
    nop
    nop
    lw x6, LIFE					# x6 = 0x00000042
    nop
    nop
    nop

    add x3, x3, x4				# x3 = 0xDEEDFD9A
    nop
    nop
    nop

    add x3, x3, x3				# x3 = 0xBDD7FB34
    nop
    nop
    nop

    sw x3, calcx, x15			# store x3 in 0x00001234 slot after joiner

    and x4, x5, x3				# x4 = 0x9005d224
    nop
    nop
    nop

    sw x4, joiner, x15			# store x4 in 0x00001010 slot before calcx

    not x5, x5					# x5 = 0x2DD22DD2
    nop
    nop
    nop

    sw x5, duh, x15				# store x5 in new cache line

    lw x6, FOED					# x6 = 0xF0EDF0ED
    nop
    nop
    nop

    lw x7, FOED					# x7 = 0xF0EDF0ED
    nop
    nop
    nop

    slli x6, x6, 8				# x6 = 0xEDF0ED00
    nop
    nop
    nop

    srli x7, x7, 3				# x7 = 0x1E1DBE1D
    nop
    nop
    nop

    srai x6, x6, 6				# x6 = 0xFFB7C3B4
    nop
    nop
    nop

    sw x6, fivespd, x15			# store x6
    nop
    nop
    nop

    sw x7, fivespd, x15			# store x7
    nop
    nop
    nop

    lw x1, ZERO					# x1 = 0x00000000
    lw x2, ZERO					# x2 = 0x00000000
    lw x3, D22D					# x3 = 0xD22DD22D
    lw x4, LIFE					# x4 = 0x00000042
    lw x5, FOED					# x5 = 0xF0EDF0ED
    lw x6, DEEB					# x6 = 0xDEEBDEEB
    lw x7, LEAF					# x7 = 0x00001EAF

    lw x1, BOMB					# x1 = 0xB006B006
    nop
    nop
    nop

    la x2, HOWHIGH				# x2 = address of HOWHIGH
    nop
    nop
    nop
    jalr x0, x2, 0

    nop
    nop
    nop

    lw x1, GOOF					# DO NOT WANT x1 = 0x0000600F
    nop
    nop
    nop

HOWHIGH:
    sw x1, dunk, x15			# should see bomb - goof - bomb in cache line
    nop
    nop
    nop

    lw x2, DEEB					# x2 = 0xDEEBDEEB
    nop
    nop
    nop

    sw x2, SPOT1, x15			# ABBAABBA - 00000110 - ABCDABCD - DEEBDEEB
    lw x3, FOED					# x3 = 0xF0EDF0ED
    lw x4, LEAF					# x4 = 0x00001EAF
    nop
    nop
    nop
    sw x3, SPOT2, x15			# ABBAABBA - 00000110 - F0EDF0ED - DEEBDEEB
    sw x4, SPOT3, x15			# ABBAABBA - 00001EAF - F0EDF0ED - DEEBDEEB
    lw x5, GOOD					# x5 = 0x0000600D
    nop
    nop
    nop
    sw x5, SPOT4, x15			# 0000600D - 00001EAF - FOEDF0ED - DEEBDEEB
    nop
    nop
    nop

    lw x5, SPOT1				# x5 = 0xDEEBDEEB
    lw x4, SPOT2				# x4 = 0xF0EDF0ED
    lw x3, SPOT3				# x3 = 0x00001EAF
    lw x2, SPOT4				# x2 = 0x0000600D
    sw x5, SPOT4, x15			# DEEBDEEB - 00001EAF - F0EDF0ED - DEEBDEEB
    sw x4, SPOT4, x15			# F0EDF0ED - 00001EAF - F0EDF0ED - DEEBDEEB
    sw x3, SPOT4, x15			# 00001EAF - 00001EAF - F0EDF0ED - DEEBDEEB
    sw x2, SPOT4, x15			# 0000600D - 00001EAF - F0EDF0ED - DEEBDEEB
    nop
    nop
    nop
    add x2, x2, x3				# x2 = 0x00007EBC 
    nop
    nop
    nop
    add x3, x4, x5				# x3 = 0xCFD9CFD8
    nop
    nop
    nop
    add x2, x2, x3				# x2 = 0xCFDA4E94
    nop
    nop
    nop

    addi x3, x8,1				# x3 = 0x00000571  
    nop
    nop
    nop

    la x16, ZOOP				# x16 = 0x00000574 (addr of ZOOP)
    sb x6, 1(x16)				# store EB into ZOOP (0x0000700F -> 0x0000EB0F)
    lw x4, ZOOP					# x4 = 0x0000EB0F

    sb x7, BEAD, x15			# store AF in BEAD (0xBEADBEAD -> 0xBEADBEAF)
    lw x3, BEAD					# x3 = 0xBEADBEAF
    nop
    nop
    nop
    sw x3, chew, x15			# store x3 (0xCCCCCCCC -> 0xBEADBEAF)
    sw x4, chew, x15			# store x4 (0xCCCCCCCC -> 0x0000EB0F)
    add x3, x3, x4				# x3 = 0xBEAEA9BE

    lw x4, ZERO					# x4 = 0x00000000

    jal x7,  MUDDLE				# (x4 becomes 0xE during MUDDLE then returns here)	

    sw x4, MUDPIE, x15			# store 0xE 

    la x5, MUDDLER				# x5 = addr of MUDDLER code label
    nop
    nop
    nop
    jalr x7, x5, 0				# jump to MUDDLER code block segment and link to x7 (x5 <= 0x00000042)

    sw x5, MUDPIE, x15			# MUDPIE = 0x00000042

    addi x6, x8, 1				# x6 = 0x00000571
    nop
    nop
    nop
    la x17, COOKIE				# x17 = addr of COOKIE
    lb x6, 1(x17)				# x6 = 0xFFFFFFD0
    nop

    lb x7, COOKIE				# x7 = 0xFFFFFFCA
    nop
    sw x6, crumb, x15			# 0x00006969 -> 0xFFFFFFD0
    nop
    sw x7, crumb, x15			# 0xFFFFFFD0 -> 0xFFFFFFCA
    nop
    nop
    nop
    add x6, x6, x7				# x6 = 0xFFFFFF9A

    jal x7, HOPE				# (x1 - x6 <= 0x0000600D)

    sw x6, FUN, x15				# store 0x0000600D in FUN

    lw x1,ZERO					# x1 = 0x00000000
    lw x2,ZERO					# x2 = 0x00000000
    lw x3,ZERO					# x3 = 0x00000000
    lw x4,GOOD					# x4 = 0x0000600D
    lw x5,GOOD					# x5 = 0x0000600D
    lw x6,GOOD					# x6 = 0x0000600D

    lw x1, GAME					# x1 = 0xBA11BA11
    nop
    nop
    nop

    sw x4, RESULT, x15			# store 0x0000600D in RESULT
    nop
    nop
    nop
    lw x2, RESULT				# x2 = 0x0000600D

    sw x1, GOOF, x15			# store 0xBA11BA11 into GOOF
    sw x2, GOOF, x15			# store 0x0000600D into GOOF
    nop

    andi x3, x3, 0				# x3 = 0x00000000
    blt x0, x3, DOH				# DO NOT WANT TO BRANCH
    bgt x0, x3, DOH				# DO NOT WANT TO BRANCH
    bne x0, x3, DOH				# DO NOT WANT TO BRANCH
    beq x0, x3, WOOHOO			# BRANCH !
    bge x0, x3, DOH				# DO NOT WANT TO BRANCH
    beq x0, x0, DOH				# SHOULD NOT REACH - SHOULD NOT BRANCH HERE

DOH:							# SHOULD NEVER TOUCH
    addi x3, x3, 4

WOOHOO:							# x3 = 0x00000006
    addi x3, x3, 6
    andi x4,x4,0				# x4 = 0x00000000
    beq x0, x3, SOFAR			# SHOULD NOT BRANCH
    addi x3, x3, 1				# x3 = 0x00000007

SOFAR:							# FALL INTO
    addi x3, x3, 6				# x3 = 0x0000000D
    andi x4,x4,0				# x4 = 0x00000000

    bne x0, x4, DOH2			# SHOULD NOT BRANCH

    nop
    nop
    nop
    addi x4, x4, 10				# x4 = 0x0000000A
    nop
    blt x0, x4, SOGOOD			# 0x0 < 0xA => BRANCH
DOH2:
    addi x3, x3, 6				# SHOULD NEVER TOUCH
    beq x0, x0, GetOverHere
SOGOOD:							
    addi x3, x3, 3				# x3 = 0x00000010
    nop
    nop
    nop
GetOverHere:
    add x3, x3, x4				# x3 = 0x0000001A
    nop
    nop
    nop
    sw x3, GOOF, x15			# 0x1A => GOOF


    sw x1, SPOT1, x15			# 0xBA11BA11 => SPOT1
    sw x2, SPOT2, x15			# 0x0000600D => SPOT2
    sw x3, SPOT3, x15			# 0x0000001A => SPOT3

    la x1, Beg1					# x1 = addr Beg1
END_m:
    jalr x0, x1, 0				# jump and link reg to Beg1


ZERO:   .word 0x00000000
ZOOP :  .word 0x0000700F
BEAD :  .word 0xBEADBEAD
FUN :   .word HOPE
DEEB:   .word 0xDEEBDEEB		# new cache line
LEAF:   .word 0x00001EAF
D22D:   .word 0xD22DD22D
LIFE:   .word 0x00000042
FOED:   .word 0xF0EDF0ED
BOMB:   .word 0xB006B006
GOOF:   .word 0x0000600F
dunk:   .word 0xdddddddd
RESULT: .word 0x00000000		# new cache line
GOOD:   .word 0x0000600D
COOKIE: .word 0xD0CAD0CA
FOOB:   .word 0xF00BF00B
aacus:  .word 0xFFFFFFFF

joiner: .word 0x00001010
calcx:  .word 0x00001234
fivespd:.word 0x89218921
duh:    .word 0x99999999		# new cache line
chew:   .word 0xcccccccc
crumb:  .word 0x00006969
GAME:   .word 0xba11ba11

SPOT1:  .word 0x88888888
SPOT2:  .word 0xABCDABCD
SPOT3:  .word 0x00000110
SPOT4:  .word 0xABBAABBA

TEST:   .word GAME				# new cache line
DONE:   .word RESULT
MUDPIE: .word 0x00000000
BLUNDER:    .word Beg1

MUDDLE:
    nop
    nop
    nop
    addi x4, x4,14				# x4 = 0x0000000E
    jalr x0, x7, 0

MUDDLER:

    lw x5, LIFE
    jalr x0, x7, 0

HOPE:
    lw x1,GOOD
    lw x2,GOOD
    lw x3,GOOD
    lw x4,GOOD
    lw x5,GOOD
    lw x6,GOOD
    jalr x0, x7, 0







Beg1:
    la x8, BlackHole				# x8 = addr of BlackHole
    andi x1, x1, 0					# x1 = 0x00000000
    andi x2, x2, 0					# x2 = 0x00000000
    andi x3, x3, 0					# x3 = 0x00000000
    addi x3, x3, 13					# x3 = 0x0000000D
    addi x2, x2, 0x0000B			# x2 = 0x0000000B





    add x1, x2, x3					# x1 = 0x00000018
    addi x4, x1, 3					# x4 = 0x0000001B

    slli x2, x2, 3					# x2 = 0x00000058
    not x5, x3						# x5 = 0xFFFFFFF2
    andi x3, x2, 15					# x3 = 0x00000008

    nop
    nop
    add x5, x3, x3					# x5 = 0x00000010

    addi x1, x4, 5					# x1 = 0x00000020
    addi x1, x4, 10					# x1 = 0x00000025
    addi x1, x4, 14					# x1 = 0x00000029
    andi x2, x1, -1					# x2 = 0x00000029

    sw x2, BlackHole, x15			# store 0x00000029 
    sw x5, BlackHole, x15			# store 0x00000010

    la x10, BlackHole				# x10 = addr of BlackHole
    addi x10, x10, 4				# x10 = addr of BlackHole + 4
    sw x2, 0(x10) 					# exception here PC 0xffffffff8000065c

    lw x3, Photostat				# x3 = 0x00000000
    lw x3, LdThis					# x3 = 0xABDAABDA
    sw x3, Photostat, x15			# 0xABDAABDA => Photostat

    lw x3, nosedive					# x3 = 0x9A4D9A4D
    addi x4, x3, 11					# x4 = 0x9A4D9A58

    lw x3, tailspin					# x3 = 0x00003DAC
    srl x4, x4, 1					# x4 = 0x4D26CD2C
    addi x5, x3, 7					# x5 = 0x00003DB3

    lw x1, quark					# x1 = 0x0000276C
    addi x5, x5, 12					# x5 = 0x00003DBF
    addi x1, x4, 12					# x1 = 0x4D26CD38
    addi x2, x3, 12					# x2 = 0x00003DB8

    sw x1, beancounter, x15			# 0x4D26CD38 => beancounter
    sw x2, beancounter, x15			# 0x00003DB8 => beancounter
    sw x3, beancounter, x15			# 0x00003DAC => beancounter
    sw x4, beancounter, x15			# 0x4D26CD2C => beancounter
    sw x5, beancounter, x15			# 0x0000CDBF => beancounter

    addi x5, x1, 0					# x5 = 0x4D26CD38
    addi x6, x3, 0					# x6 = 0x00003DAC
    addi x7, x4, 0					# x7 = 0x4D26CD2C

    andi x1, x1, 0					# x1 = 0x00000000
    andi x3, x3, 0					# x3 = 0x00000000
    andi x4, x4, 0					# x4 = 0x00000000
    addi x1, x1, 8					# x1 = 0x00000008
    addi x3, x3, 2					# x3 = 0x00000002
    addi x4, x4, 2					# x4 = 0x00000002

    blt x0, x4, T1					# SHOULD BRANCH
    addi x3, x3, 1					# SHOULD NOT INCREMENT x3
T1:
    addi x1, x1, 9					# x1 = 0x00000011
    bgt x0, x1, T2					# SHOULD NOT BRANCH
    addi x4, x4, 1					# x4 = 0x00000003


    lw x2, SPOT1					# x2 = 0xBA11BA11
    lw x6, SPOT2					# x6 = 0x0000600D
    lw x7, SPOT3					# x7 = 0x0000001A

    la x8, BlackHole				# x8 = addr of BlackHole
    andi x3, x3, 0					# x3 = ox00000000
    andi x4, x4, 0					# x4 = 0x00000000
    nop
    addi x3, x3, 2					# x3 = 0x00000002
    addi x4, x4, 3					# x4 = 0x00000003

T2:
    lw x1, pessimist				# x1 = 0xFB03FB03 (negative)
    bgt x0, x1, T3					# SHOULD BRANCH
    addi x3, x3, 1					# SHOULD NOT INCREMENT x3
T3:
    lw x1, optimist					# x1 = 0x00000111
    beq x0, x1, T4					# SHOULD NOT BRANCH
    addi x4, x4, 1					# SHOULD INCREMENT x4
T4:
    lw x1, pessimist				# x1 = 0xFB03FB03 (negative)
    bge x0, x1, T5					# SHOULD BRANCH 
    addi x3, x3, 1					# SHOULD NOT INCREMENT x3
T5:
    lw x1, quark					# x1 = 0x0000276C
    bge x0, x1, T6					# SHOULD NOT BRANCH
    addi x4, x4, 1					# SHOULD INCREMENT x4
T6:
    andi x1, x8, 0					# x1 = 0x00000000

    la x1, BlackHole				# x1 = addr BlackHole
    blt x0, x1, T7					# SHOULD BRANCH
    addi x3, x3, 1					# SHOULD NOT INCREMENT x3

T7:
    sw x3, cc1, x15					# store 0x00000002 => cc1
    sw x4, cc2, x15					# store 0x00000005 => cc2

    andi x1, x1, 0					# x1 = 0x00000000
    andi x5, x5, 0					# x5 = 0x00000000

    addi x1, x1, -1					# x1 = 0xFFFFFFFF (negative)
    bgt x0, x1, T10					# SHOULD BRANCH
    addi x5, x5, 1					# SHOULD NOT INCREMENT x5
    addi x1, x1, -7					# SHOUDD NOT INCREMENT x1 by -7
T10:
    add x5, x1, x5					# x5 = 0xFFFFFFFF
    nop
    nop
    nop
    sw x5, acorn, x15				# 0x00000FEE <= 0xFFFFFFFF
    addi x8, x5, 0					# x8 = 0xFFFFFFFF

    andi x5, x5, 0					# x5 = 0x00000000

    la x1, GetHere					# x1 = addr of GetHere
    jalr x0, x1, 0					# jump to GetHere (do not jump back)
    addi x5, x5, 1					# (never increment x5 in this scope)

GetHere:
    add x5, x8, x5					# x5 = 0xFFFFFFFF
    nop			
    nop
    nop
    lw x1, FUN						# x1 = 0x0000600D
    la x8, BlackHole				# x8 = addr of BlackHole
    sw x5, BlackHole, x15			# 0xFFFFFFFF => BlackHole

    beq x0, x0, MoneyMoney			# Branch to MoneyMoney

BlackHole:  .word 0
WormHole:   .word 0
LdThis:     .word 0xabdaabda
Photostat:  .word 0
nosedive:   .word 0x9A4D9A4D
tailspin:   .word 0x00003DAC
compass:    .word quark
beancounter:    .word 0xfaddfadd
pessimist:  .word 0xFB03FB03
optimist:   .word 0x00000111
gloomy:     .word pessimist
cc1:        .word 0xf00ff00f
cc2:        .word 0xf00ff00f
acorn:      .word 0x00000FEE
quark:      .word 0x0000276C
payout:     .word MoneyMoney

MoneyMoney:

    andi x7, x7, 0					# x7 = 0x00000000
    andi x6, x6, 0					# x6 = 0x00000000
    andi x5, x5, 0					# x5 = 0x00000000
    andi x4, x4, 0					# x4 = 0x00000000
    andi x3, x3, 0					# x3 = 0x00000000
    andi x2, x2, 0					# x2 = 0x00000000
    andi x1, x1, 0					# x1 = 0x00000000
    andi x8, x8, 0					# x8 = 0x00000000


    la x1, M00						# x1 = addr of M00 (beginning of empty memory expanse)
    lw x2, Counter2					# x2 = 0x00004A3F
    lw x3, TWOFIVESIX				# x3 = 0x00000100
FillM1:
    sw x2, 0(x1)					# store 0x00004A3F into #(x1) offset of M00
    addi x2, x2, -7					# x2 = 0x00004A38
    addi x1, x1, 4					# x1 = addr of M00 + 4 (0x00000C80)
    addi x3, x3, -1					# x3 = 0x000000FF
    blt x0, x3, FillM1				# LOOP 256 times 

    la x4, M00						# x4 = addr of M00 (0x00000C80)
    lw x2, TWOFIVESIX				# x2 = 0x00000010
    add x4, x2, x4					# x4 = addr of M00 + 246
    lw x3, Counter2					# x3 = 0x00004A3F
    andi x1, x1, 0					# x1 = 0x00000000
    andi x2, x2, 0					# x2 = 0x00000000

FILLM2:
    jal x7,  CalAddress				# jump to CalAddress (
    add x6, x5, x4				
    sw  x3, 0(x6)
    addi x3, x3, -2
    jal x7,  CalNEXT2
    addi x5, x1, 0
    ble x0, x5, FILLM2

    la x4,  M00
    lw x2, TWOFIVESIX
    add x4, x2, x4
    add x4, x2, x4
    lw x3, Counter2
    andi x1, x1, 0
    andi x2, x2, 0
FILLM3:
    jal x7,  CalAddress
    add x6, x5, x4
    sw  x3, 0(x6)
    addi x3, x3, -5
    jal x7,  CalNEXT3
    addi x5, x1, 0
    ble x0, x5, FILLM3

    la x3, M00
    lw x4, TWOFIVESIX
    add x4, x3, x4
    andi x6, x6, 0

Continue1_2:

    lw x1, X2
    lw x2, Y2
    jal x7,  CalAddress
    add x7, x5, x4
    lw x6, 0(x7)
    jal x7,  CalNEXT3
    sw x1, X2, x15
    sw x2, Y2, x15
    
    lw x1, XX1
    lw x2, Y1
    jal x7,  CalAddress
    add x5, x5, x3
    lw x7, 0(x5)
    add x6, x6, x7
    sw x6, 0(x5)
    
    jal x7,  CalNEXT2
    addi x7, x1, 0
    bgt x0, x7, Done3
    sw x1, XX1, x15
    sw x2, Y1, x15
    
    beq x0, x0, Continue1_2
Done3:

    andi x1, x1, 0
    sw  x1, XX1, x15
    sw x1, X2, x15
    sw  x1, Y1, x15
    sw  x1, Y2, x15
    
    la x3,  M00
    lw x4, TWOFIVESIX
    add x4, x4, x4
    add x4, x3, x4
    andi x6, x6, 0

Continue1_3:

    lw x1, X2
    lw x2, Y2
    jal x7,  CalAddress
    add x7, x5, x3
    lw x6, 0(x7)
    jal x7,  CalNEXT1
    sw x1, X2, x15
    sw x2, Y2, x15
    
    lw x1, XX1
    lw x2, Y1
    jal x7,  CalAddress
    add x5, x5, x4
    lw x7, 0(x5)
    add x6, x6, x7
    sw x6, 0(x5)
    
    jal x7,  CalNEXT3
    addi x7, x1, 0
    bgt x0, x7, Done4
    sw x1, XX1, x15
    sw x2, Y1, x15
    
    beq x0, x0, Continue1_3
Done4:

    beq x0, x0, CHECKSUM

CalNEXT1:

    addi x5, x1, -15
    beq x0, x5, YTEST
    addi x1, x1, 1
    beq x0, x0, SKip

YTEST:
    addi x5, x2, -15
    beq x0, x5, DoneFor
    addi x2, x2, 1
    andi x1, x1, 0
    beq x0, x0, SKip

DoneFor:
    andi x1, x1, 0
    addi x1, x1, -1

SKip:
    jalr x0, x7, 0

CalNEXT2:

    addi x5, x2, -15
    beq x0, x5, XTEST
    addi x2, x2, 1
    beq x0, x0, SKip1

XTEST:
    addi x5, x1, -15
    beq x0, x5, Done1
    addi x1, x1, 1
    andi x2, x2, 0
    beq x0, x0, SKip1

Done1:
    andi x1, x1, 0
    addi x1, x1, -1

SKip1:
    jalr x0, x7, 0

CalNEXT3:

    sw x3, TEMP3, x15
    
    addi x3, x1, -15
    beq x0, x3, DRow
    addi x3, x2, 0
    beq x0, x3, DRow1
    lw x3, NEGONEFIVE
    addi x3, x1, -15
    beq x0, x3, DRow
    
    addi x1, x1, 1
    addi x2, x2, -1
    beq x0, x0, SKIP2

DRow1:
    addi x2, x1, 1
    andi x1, x1, 0
    beq x0, x0, SKIP2

DRow:
    addi x3, x2, -15
    beq x0, x3, Done2

    addi x1, x2, 1
    andi x2, x2, 0
    addi x2, x2, 15
    beq x0, x0, SKIP2

Done2:
    andi x1, x1, 0
    addi x1, x1, -1

SKIP2:
    lw x3, TEMP3
    jalr x0, x7, 0

CalAddress:
    slli x5, x2, 5
    add x5, x1, x5
    slli x5, x5, 2
    jalr x0, x7, 0

CHECKSUM:

    la  x1, M00							# x1 = 0x00000C80
    lw x4, TWOFIVESIX					# x4 = 0x00000100
    add x4, x4, x4						# x4 = 0x00000200
    add x1, x4, x1						# x1 = addr of M00 + 0x200
    andi x7, x7, 0						# x7 = 0x00000000
    andi x6, x6, 0						# x6 = 0x00000000
    andi x5, x5, 0						# x5 = 0x00000000
    andi x4, x4, 0						# x4 = 0x00000000

    lw  x2, ONEFOURTHREE				# x2 = 0x0000003F
LoopRowsA:								# LOOP 64 times
    lw  x3, 0(x1)						# sum values from (M00+0x200) to (M00+0x200)+64*4
    add x4, x3, x4
    addi x1, x1, 4
    addi x2, x2, -1
    ble x0, x2, LoopRowsA
    
    slli x4,x4,2						# x4 = x4 * 2
    	
    lw  x2, ONEFOURTHREE				# x2 = 0x0000003F
LoopRowsB:								# LOOP 64 times
    lw  x3, 0(x1)						# sum values from (M00+0x200)+64*4 to (M00+0x200)+128*4
    add x5, x3, x5
    addi x1, x1, 4
    addi x2, x2, -1
    ble x0, x2, LoopRowsB

    slli x5,x5,2						# x5 = x5 * 2
    		
    lw  x2, ONEFOURTHREE				# x2 = 0x0000003F
LoopRowsC:								# sum values from (M00+0x200)+128*4 to (M00+0x200)+192*4
    lw  x3, 0(x1)
    add x6, x3, x6
    addi x1, x1, 4
    addi x2, x2, -1
    ble x0, x2, LoopRowsC
    
    slli x6,x6,2						# x6 = x6 * 2
    	
    lw  x2, ONEFOURTHREE				# x2 = 0x0000003F
LoopRowsD:								# sum values from (M00+0x200)+192*4 to (M00+0x200)+256*4
    lw  x3, 0(x1)
    add x7, x3, x7
    addi x1, x1, 4
    addi x2, x2, -1
    ble x0, x2, LoopRowsD
    
    and x3, x3,x7						# x3 = 
    not x7,x7
    
    
    
    HALT:
    beq x0, x0, HALT


.section .rodata

XX1:             .word    0x00000000
Y1:             .word    0x00000000
X2:             .word    0x00000000
Y2:             .word    0x00000000
TEMP1:          .word    0x00000000
TEMP2:          .word    0x00000000
TEMP3:          .word    0x00000000
TEMP4:          .word    0x00000000
TWOFIVESIX:     .word       256
UpperMemStart:  .word    0xF000F000
Counter1:       .word    0x00000FFF
Counter2:       .word    0x00004A3F
ONEFOURTHREE:   .word        63
NEGONEFIVE:     .word       -15
Mask:           .word    0x000000FF


M00:    .word           0x00000000
M01:    .word           0x00000000
M02:    .word           0x00000000
M03:    .word           0x00000000
M04:    .word           0x00000000
M05:    .word           0x00000000
M06:    .word           0x00000000
M07:    .word           0x00000000
M08:    .word           0x00000000
M09:    .word           0x00000000
M0A:    .word           0x00000000
M0B:    .word           0x00000000
M0C:    .word           0x00000000
M0D:    .word           0x00000000
M0E:    .word           0x00000000
M0F:    .word           0x00000000

M10:    .word           0x00000000
M11:    .word           0x00000000
M12:    .word           0x00000000
M13:    .word           0x00000000
M14:    .word           0x00000000
M15:    .word           0x00000000
M16:    .word           0x00000000
M17:    .word           0x00000000
M18:    .word           0x00000000
M19:    .word           0x00000000
M1A:    .word           0x00000000
M1B:    .word           0x00000000
M1C:    .word           0x00000000
M1D:    .word           0x00000000
M1E:    .word           0x00000000
M1F:    .word           0x00000000

M20:    .word           0x00000000
M21:    .word           0x00000000
M22:    .word           0x00000000
M23:    .word           0x00000000
M24:    .word           0x00000000
M25:    .word           0x00000000
M26:    .word           0x00000000
M27:    .word           0x00000000
M28:    .word           0x00000000
M29:    .word           0x00000000
M2A:    .word           0x00000000
M2B:    .word           0x00000000
M2C:    .word           0x00000000
M2D:    .word           0x00000000
M2E:    .word           0x00000000
M2F:    .word           0x00000000

M30:    .word           0x00000000
M31:    .word           0x00000000
M32:    .word           0x00000000
M33:    .word           0x00000000
M34:    .word           0x00000000
M35:    .word           0x00000000
M36:    .word           0x00000000
M37:    .word           0x00000000
M38:    .word           0x00000000
M39:    .word           0x00000000
M3A:    .word           0x00000000
M3B:    .word           0x00000000
M3C:    .word           0x00000000
M3D:    .word           0x00000000
M3E:    .word           0x00000000
M3F:    .word           0x00000000

M40:    .word           0x00000000
M41:    .word           0x00000000
M42:    .word           0x00000000
M43:    .word           0x00000000
M44:    .word           0x00000000
M45:    .word           0x00000000
M46:    .word           0x00000000
M47:    .word           0x00000000
M48:    .word           0x00000000
M49:    .word           0x00000000
M4A:    .word           0x00000000
M4B:    .word           0x00000000
M4C:    .word           0x00000000
M4D:    .word           0x00000000
M4E:    .word           0x00000000
M4F:    .word           0x00000000

M50:    .word           0x00000000
M51:    .word           0x00000000
M52:    .word           0x00000000
M53:    .word           0x00000000
M54:    .word           0x00000000
M55:    .word           0x00000000
M56:    .word           0x00000000
M57:    .word           0x00000000
M58:    .word           0x00000000
M59:    .word           0x00000000
M5A:    .word           0x00000000
M5B:    .word           0x00000000
M5C:    .word           0x00000000
M5D:    .word           0x00000000
M5E:    .word           0x00000000
M5F:    .word           0x00000000

M60:    .word           0x00000000
M61:    .word           0x00000000
M62:    .word           0x00000000
M63:    .word           0x00000000
M64:    .word           0x00000000
M65:    .word           0x00000000
M66:    .word           0x00000000
M67:    .word           0x00000000
M68:    .word           0x00000000
M69:    .word           0x00000000
M6A:    .word           0x00000000
M6B:    .word           0x00000000
M6C:    .word           0x00000000
M6D:    .word           0x00000000
M6E:    .word           0x00000000
M6F:    .word           0x00000000

M70:    .word           0x00000000
M71:    .word           0x00000000
M72:    .word           0x00000000
M73:    .word           0x00000000
M74:    .word           0x00000000
M75:    .word           0x00000000
M76:    .word           0x00000000
M77:    .word           0x00000000
M78:    .word           0x00000000
M79:    .word           0x00000000
M7A:    .word           0x00000000
M7B:    .word           0x00000000
M7C:    .word           0x00000000
M7D:    .word           0x00000000
M7E:    .word           0x00000000
M7F:    .word           0x00000000

M80:    .word           0x00000000
M81:    .word           0x00000000
M82:    .word           0x00000000
M83:    .word           0x00000000
M84:    .word           0x00000000
M85:    .word           0x00000000
M86:    .word           0x00000000
M87:    .word           0x00000000
M88:    .word           0x00000000
M89:    .word           0x00000000
M8A:    .word           0x00000000
M8B:    .word           0x00000000
M8C:    .word           0x00000000
M8D:    .word           0x00000000
M8E:    .word           0x00000000
M8F:    .word           0x00000000

M90:    .word           0x00000000
M91:    .word           0x00000000
M92:    .word           0x00000000
M93:    .word           0x00000000
M94:    .word           0x00000000
M95:    .word           0x00000000
M96:    .word           0x00000000
M97:    .word           0x00000000
M98:    .word           0x00000000
M99:    .word           0x00000000
M9A:    .word           0x00000000
M9B:    .word           0x00000000
M9C:    .word           0x00000000
M9D:    .word           0x00000000
M9E:    .word           0x00000000
M9F:    .word           0x00000000

MA0:    .word           0x00000000
MA1:    .word           0x00000000
MA2:    .word           0x00000000
MA3:    .word           0x00000000
MA4:    .word           0x00000000
MA5:    .word           0x00000000
MA6:    .word           0x00000000
MA7:    .word           0x00000000
MA8:    .word           0x00000000
MA9:    .word           0x00000000
MAA:    .word           0x00000000
MAB:    .word           0x00000000
MAC:    .word           0x00000000
MAD:    .word           0x00000000
MAE:    .word           0x00000000
MAF:    .word           0x00000000

MB0:    .word           0x00000000
MB1:    .word           0x00000000
MB2:    .word           0x00000000
MB3:    .word           0x00000000
MB4:    .word           0x00000000
MB5:    .word           0x00000000
MB6:    .word           0x00000000
MB7:    .word           0x00000000
MB8:    .word           0x00000000
MB9:    .word           0x00000000
MBA:    .word           0x00000000
MBB:    .word           0x00000000
MBC:    .word           0x00000000
MBD:    .word           0x00000000
MBE:    .word           0x00000000
MBF:    .word           0x00000000

MC0:    .word           0x00000000
MC1:    .word           0x00000000
MC2:    .word           0x00000000
MC3:    .word           0x00000000
MC4:    .word           0x00000000
MC5:    .word           0x00000000
MC6:    .word           0x00000000
MC7:    .word           0x00000000
MC8:    .word           0x00000000
MC9:    .word           0x00000000
MCA:    .word           0x00000000
MCB:    .word           0x00000000
MCC:    .word           0x00000000
MCD:    .word           0x00000000
MCE:    .word           0x00000000
MCF:    .word           0x00000000

MD0:    .word           0x00000000
MD1:    .word           0x00000000
MD2:    .word           0x00000000
MD3:    .word           0x00000000
MD4:    .word           0x00000000
MD5:    .word           0x00000000
MD6:    .word           0x00000000
MD7:    .word           0x00000000
MD8:    .word           0x00000000
MD9:    .word           0x00000000
MDA:    .word           0x00000000
MDB:    .word           0x00000000
MDC:    .word           0x00000000
MDD:    .word           0x00000000
MDE:    .word           0x00000000
MDF:    .word           0x00000000

ME0:    .word           0x00000000
ME1:    .word           0x00000000
ME2:    .word           0x00000000
ME3:    .word           0x00000000
ME4:    .word           0x00000000
ME5:    .word           0x00000000
ME6:    .word           0x00000000
ME7:    .word           0x00000000
ME8:    .word           0x00000000
ME9:    .word           0x00000000
MEA:    .word           0x00000000
MEB:    .word           0x00000000
MEC:    .word           0x00000000
MED:    .word           0x00000000
MEE:    .word           0x00000000
MEF:    .word           0x00000000

MF0:    .word           0x00000000
MF1:    .word           0x00000000
MF2:    .word           0x00000000
MF3:    .word           0x00000000
MF4:    .word           0x00000000
MF5:    .word           0x00000000
MF6:    .word           0x00000000
MF7:    .word           0x00000000
MF8:    .word           0x00000000
MF9:    .word           0x00000000
MFA:    .word           0x00000000
MFB:    .word           0x00000000
MFC:    .word           0x00000000
MFD:    .word           0x00000000
MFE:    .word           0x00000000
MFF:    .word           0x00000000





N00:    .word           0x00000000
N01:    .word           0x00000000
N02:    .word           0x00000000
N03:    .word           0x00000000
N04:    .word           0x00000000
N05:    .word           0x00000000
N06:    .word           0x00000000
N07:    .word           0x00000000
N08:    .word           0x00000000
N09:    .word           0x00000000
N0A:    .word           0x00000000
N0B:    .word           0x00000000
N0C:    .word           0x00000000
N0D:    .word           0x00000000
N0E:    .word           0x00000000
N0F:    .word           0x00000000

N10:    .word           0x00000000
N11:    .word           0x00000000
N12:    .word           0x00000000
N13:    .word           0x00000000
N14:    .word           0x00000000
N15:    .word           0x00000000
N16:    .word           0x00000000
N17:    .word           0x00000000
N18:    .word           0x00000000
N19:    .word           0x00000000
N1A:    .word           0x00000000
N1B:    .word           0x00000000
N1C:    .word           0x00000000
N1D:    .word           0x00000000
N1E:    .word           0x00000000
N1F:    .word           0x00000000

N20:    .word           0x00000000
N21:    .word           0x00000000
N22:    .word           0x00000000
N23:    .word           0x00000000
N24:    .word           0x00000000
N25:    .word           0x00000000
N26:    .word           0x00000000
N27:    .word           0x00000000
N28:    .word           0x00000000
N29:    .word           0x00000000
N2A:    .word           0x00000000
N2B:    .word           0x00000000
N2C:    .word           0x00000000
N2D:    .word           0x00000000
N2E:    .word           0x00000000
N2F:    .word           0x00000000

N30:    .word           0x00000000
N31:    .word           0x00000000
N32:    .word           0x00000000
N33:    .word           0x00000000
N34:    .word           0x00000000
N35:    .word           0x00000000
N36:    .word           0x00000000
N37:    .word           0x00000000
N38:    .word           0x00000000
N39:    .word           0x00000000
N3A:    .word           0x00000000
N3B:    .word           0x00000000
N3C:    .word           0x00000000
N3D:    .word           0x00000000
N3E:    .word           0x00000000
N3F:    .word           0x00000000

N40:    .word           0x00000000
N41:    .word           0x00000000
N42:    .word           0x00000000
N43:    .word           0x00000000
N44:    .word           0x00000000
N45:    .word           0x00000000
N46:    .word           0x00000000
N47:    .word           0x00000000
N48:    .word           0x00000000
N49:    .word           0x00000000
N4A:    .word           0x00000000
N4B:    .word           0x00000000
N4C:    .word           0x00000000
N4D:    .word           0x00000000
N4E:    .word           0x00000000
N4F:    .word           0x00000000

N50:    .word           0x00000000
N51:    .word           0x00000000
N52:    .word           0x00000000
N53:    .word           0x00000000
N54:    .word           0x00000000
N55:    .word           0x00000000
N56:    .word           0x00000000
N57:    .word           0x00000000
N58:    .word           0x00000000
N59:    .word           0x00000000
N5A:    .word           0x00000000
N5B:    .word           0x00000000
N5C:    .word           0x00000000
N5D:    .word           0x00000000
N5E:    .word           0x00000000
N5F:    .word           0x00000000

N60:    .word           0x00000000
N61:    .word           0x00000000
N62:    .word           0x00000000
N63:    .word           0x00000000
N64:    .word           0x00000000
N65:    .word           0x00000000
N66:    .word           0x00000000
N67:    .word           0x00000000
N68:    .word           0x00000000
N69:    .word           0x00000000
N6A:    .word           0x00000000
N6B:    .word           0x00000000
N6C:    .word           0x00000000
N6D:    .word           0x00000000
N6E:    .word           0x00000000
N6F:    .word           0x00000000

N70:    .word           0x00000000
N71:    .word           0x00000000
N72:    .word           0x00000000
N73:    .word           0x00000000
N74:    .word           0x00000000
N75:    .word           0x00000000
N76:    .word           0x00000000
N77:    .word           0x00000000
N78:    .word           0x00000000
N79:    .word           0x00000000
N7A:    .word           0x00000000
N7B:    .word           0x00000000
N7C:    .word           0x00000000
N7D:    .word           0x00000000
N7E:    .word           0x00000000
N7F:    .word           0x00000000

N80:    .word           0x00000000
N81:    .word           0x00000000
N82:    .word           0x00000000
N83:    .word           0x00000000
N84:    .word           0x00000000
N85:    .word           0x00000000
N86:    .word           0x00000000
N87:    .word           0x00000000
N88:    .word           0x00000000
N89:    .word           0x00000000
N8A:    .word           0x00000000
N8B:    .word           0x00000000
N8C:    .word           0x00000000
N8D:    .word           0x00000000
N8E:    .word           0x00000000
N8F:    .word           0x00000000

N90:    .word           0x00000000
N91:    .word           0x00000000
N92:    .word           0x00000000
N93:    .word           0x00000000
N94:    .word           0x00000000
N95:    .word           0x00000000
N96:    .word           0x00000000
N97:    .word           0x00000000
N98:    .word           0x00000000
N99:    .word           0x00000000
N9A:    .word           0x00000000
N9B:    .word           0x00000000
N9C:    .word           0x00000000
N9D:    .word           0x00000000
N9E:    .word           0x00000000
N9F:    .word           0x00000000

NA0:    .word           0x00000000
NA1:    .word           0x00000000
NA2:    .word           0x00000000
NA3:    .word           0x00000000
NA4:    .word           0x00000000
NA5:    .word           0x00000000
NA6:    .word           0x00000000
NA7:    .word           0x00000000
NA8:    .word           0x00000000
NA9:    .word           0x00000000
NAA:    .word           0x00000000
NAB:    .word           0x00000000
NAC:    .word           0x00000000
NAD:    .word           0x00000000
NAE:    .word           0x00000000
NAF:    .word           0x00000000

NB0:    .word           0x00000000
NB1:    .word           0x00000000
NB2:    .word           0x00000000
NB3:    .word           0x00000000
NB4:    .word           0x00000000
NB5:    .word           0x00000000
NB6:    .word           0x00000000
NB7:    .word           0x00000000
NB8:    .word           0x00000000
NB9:    .word           0x00000000
NBA:    .word           0x00000000
NBB:    .word           0x00000000
NBC:    .word           0x00000000
NBD:    .word           0x00000000
NBE:    .word           0x00000000
NBF:    .word           0x00000000

NC0:    .word           0x00000000
NC1:    .word           0x00000000
NC2:    .word           0x00000000
NC3:    .word           0x00000000
NC4:    .word           0x00000000
NC5:    .word           0x00000000
NC6:    .word           0x00000000
NC7:    .word           0x00000000
NC8:    .word           0x00000000
NC9:    .word           0x00000000
NCA:    .word           0x00000000
NCB:    .word           0x00000000
NCC:    .word           0x00000000
NCD:    .word           0x00000000
NCE:    .word           0x00000000
NCF:    .word           0x00000000

ND0:    .word           0x00000000
ND1:    .word           0x00000000
ND2:    .word           0x00000000
ND3:    .word           0x00000000
ND4:    .word           0x00000000
ND5:    .word           0x00000000
ND6:    .word           0x00000000
ND7:    .word           0x00000000
ND8:    .word           0x00000000
ND9:    .word           0x00000000
NDA:    .word           0x00000000
NDB:    .word           0x00000000
NDC:    .word           0x00000000
NDD:    .word           0x00000000
NDE:    .word           0x00000000
NDF:    .word           0x00000000

NE0:    .word           0x00000000
NE1:    .word           0x00000000
NE2:    .word           0x00000000
NE3:    .word           0x00000000
NE4:    .word           0x00000000
NE5:    .word           0x00000000
NE6:    .word           0x00000000
NE7:    .word           0x00000000
NE8:    .word           0x00000000
NE9:    .word           0x00000000
NEA:    .word           0x00000000
NEB:    .word           0x00000000
NEC:    .word           0x00000000
NED:    .word           0x00000000
NEE:    .word           0x00000000
NEF:    .word           0x00000000

NF0:    .word           0x00000000
NF1:    .word           0x00000000
NF2:    .word           0x00000000
NF3:    .word           0x00000000
NF4:    .word           0x00000000
NF5:    .word           0x00000000
NF6:    .word           0x00000000
NF7:    .word           0x00000000
NF8:    .word           0x00000000
NF9:    .word           0x00000000
NFA:    .word           0x00000000
NFB:    .word           0x00000000
NFC:    .word           0x00000000
NFD:    .word           0x00000000
NFE:    .word           0x00000000
NFF:    .word           0x00000000


O00:    .word           0x00000000
O01:    .word           0x00000000
O02:    .word           0x00000000
O03:    .word           0x00000000
O04:    .word           0x00000000
O05:    .word           0x00000000
O06:    .word           0x00000000
O07:    .word           0x00000000
O08:    .word           0x00000000
O09:    .word           0x00000000
O0A:    .word           0x00000000
O0B:    .word           0x00000000
O0C:    .word           0x00000000
O0D:    .word           0x00000000
O0E:    .word           0x00000000
O0F:    .word           0x00000000

O10:    .word           0x00000000
O11:    .word           0x00000000
O12:    .word           0x00000000
O13:    .word           0x00000000
O14:    .word           0x00000000
O15:    .word           0x00000000
O16:    .word           0x00000000
O17:    .word           0x00000000
O18:    .word           0x00000000
O19:    .word           0x00000000
O1A:    .word           0x00000000
O1B:    .word           0x00000000
O1C:    .word           0x00000000
O1D:    .word           0x00000000
O1E:    .word           0x00000000
O1F:    .word           0x00000000

O20:    .word           0x00000000
O21:    .word           0x00000000
O22:    .word           0x00000000
O23:    .word           0x00000000
O24:    .word           0x00000000
O25:    .word           0x00000000
O26:    .word           0x00000000
O27:    .word           0x00000000
O28:    .word           0x00000000
O29:    .word           0x00000000
O2A:    .word           0x00000000
O2B:    .word           0x00000000
O2C:    .word           0x00000000
O2D:    .word           0x00000000
O2E:    .word           0x00000000
O2F:    .word           0x00000000

O30:    .word           0x00000000
O31:    .word           0x00000000
O32:    .word           0x00000000
O33:    .word           0x00000000
O34:    .word           0x00000000
O35:    .word           0x00000000
O36:    .word           0x00000000
O37:    .word           0x00000000
O38:    .word           0x00000000
O39:    .word           0x00000000
O3A:    .word           0x00000000
O3B:    .word           0x00000000
O3C:    .word           0x00000000
O3D:    .word           0x00000000
O3E:    .word           0x00000000
O3F:    .word           0x00000000

O40:    .word           0x00000000
O41:    .word           0x00000000
O42:    .word           0x00000000
O43:    .word           0x00000000
O44:    .word           0x00000000
O45:    .word           0x00000000
O46:    .word           0x00000000
O47:    .word           0x00000000
O48:    .word           0x00000000
O49:    .word           0x00000000
O4A:    .word           0x00000000
O4B:    .word           0x00000000
O4C:    .word           0x00000000
O4D:    .word           0x00000000
O4E:    .word           0x00000000
O4F:    .word           0x00000000

O50:    .word           0x00000000
O51:    .word           0x00000000
O52:    .word           0x00000000
O53:    .word           0x00000000
O54:    .word           0x00000000
O55:    .word           0x00000000
O56:    .word           0x00000000
O57:    .word           0x00000000
O58:    .word           0x00000000
O59:    .word           0x00000000
O5A:    .word           0x00000000
O5B:    .word           0x00000000
O5C:    .word           0x00000000
O5D:    .word           0x00000000
O5E:    .word           0x00000000
O5F:    .word           0x00000000

O60:    .word           0x00000000
O61:    .word           0x00000000
O62:    .word           0x00000000
O63:    .word           0x00000000
O64:    .word           0x00000000
O65:    .word           0x00000000
O66:    .word           0x00000000
O67:    .word           0x00000000
O68:    .word           0x00000000
O69:    .word           0x00000000
O6A:    .word           0x00000000
O6B:    .word           0x00000000
O6C:    .word           0x00000000
O6D:    .word           0x00000000
O6E:    .word           0x00000000
O6F:    .word           0x00000000

O70:    .word           0x00000000
O71:    .word           0x00000000
O72:    .word           0x00000000
O73:    .word           0x00000000
O74:    .word           0x00000000
O75:    .word           0x00000000
O76:    .word           0x00000000
O77:    .word           0x00000000
O78:    .word           0x00000000
O79:    .word           0x00000000
O7A:    .word           0x00000000
O7B:    .word           0x00000000
O7C:    .word           0x00000000
O7D:    .word           0x00000000
O7E:    .word           0x00000000
O7F:    .word           0x00000000

O80:    .word           0x00000000
O81:    .word           0x00000000
O82:    .word           0x00000000
O83:    .word           0x00000000
O84:    .word           0x00000000
O85:    .word           0x00000000
O86:    .word           0x00000000
O87:    .word           0x00000000
O88:    .word           0x00000000
O89:    .word           0x00000000
O8A:    .word           0x00000000
O8B:    .word           0x00000000
O8C:    .word           0x00000000
O8D:    .word           0x00000000
O8E:    .word           0x00000000
O8F:    .word           0x00000000

O90:    .word           0x00000000
O91:    .word           0x00000000
O92:    .word           0x00000000
O93:    .word           0x00000000
O94:    .word           0x00000000
O95:    .word           0x00000000
O96:    .word           0x00000000
O97:    .word           0x00000000
O98:    .word           0x00000000
O99:    .word           0x00000000
O9A:    .word           0x00000000
O9B:    .word           0x00000000
O9C:    .word           0x00000000
O9D:    .word           0x00000000
O9E:    .word           0x00000000
O9F:    .word           0x00000000

OA0:    .word           0x00000000
OA1:    .word           0x00000000
OA2:    .word           0x00000000
OA3:    .word           0x00000000
OA4:    .word           0x00000000
OA5:    .word           0x00000000
OA6:    .word           0x00000000
OA7:    .word           0x00000000
OA8:    .word           0x00000000
OA9:    .word           0x00000000
OAA:    .word           0x00000000
OAB:    .word           0x00000000
OAC:    .word           0x00000000
OAD:    .word           0x00000000
OAE:    .word           0x00000000
OAF:    .word           0x00000000

OB0:    .word           0x00000000
OB1:    .word           0x00000000
OB2:    .word           0x00000000
OB3:    .word           0x00000000
OB4:    .word           0x00000000
OB5:    .word           0x00000000
OB6:    .word           0x00000000
OB7:    .word           0x00000000
OB8:    .word           0x00000000
OB9:    .word           0x00000000
OBA:    .word           0x00000000
OBB:    .word           0x00000000
OBC:    .word           0x00000000
OBD:    .word           0x00000000
OBE:    .word           0x00000000
OBF:    .word           0x00000000

OC0:    .word           0x00000000
OC1:    .word           0x00000000
OC2:    .word           0x00000000
OC3:    .word           0x00000000
OC4:    .word           0x00000000
OC5:    .word           0x00000000
OC6:    .word           0x00000000
OC7:    .word           0x00000000
OC8:    .word           0x00000000
OC9:    .word           0x00000000
OCA:    .word           0x00000000
OCB:    .word           0x00000000
OCC:    .word           0x00000000
OCD:    .word           0x00000000
OCE:    .word           0x00000000
OCF:    .word           0x00000000

OD0:    .word           0x00000000
OD1:    .word           0x00000000
OD2:    .word           0x00000000
OD3:    .word           0x00000000
OD4:    .word           0x00000000
OD5:    .word           0x00000000
OD6:    .word           0x00000000
OD7:    .word           0x00000000
OD8:    .word           0x00000000
OD9:    .word           0x00000000
ODA:    .word           0x00000000
ODB:    .word           0x00000000
ODC:    .word           0x00000000
ODD:    .word           0x00000000
ODE:    .word           0x00000000
ODF:    .word           0x00000000

OE0:    .word           0x00000000
OE1:    .word           0x00000000
OE2:    .word           0x00000000
OE3:    .word           0x00000000
OE4:    .word           0x00000000
OE5:    .word           0x00000000
OE6:    .word           0x00000000
OE7:    .word           0x00000000
OE8:    .word           0x00000000
OE9:    .word           0x00000000
OEA:    .word           0x00000000
OEB:    .word           0x00000000
OEC:    .word           0x00000000
OED:    .word           0x00000000
OEE:    .word           0x00000000
OEF:    .word           0x00000000

OF0:    .word           0x00000000
OF1:    .word           0x00000000
OF2:    .word           0x00000000
OF3:    .word           0x00000000
OF4:    .word           0x00000000
OF5:    .word           0x00000000
OF6:    .word           0x00000000
OF7:    .word           0x00000000
OF8:    .word           0x00000000
OF9:    .word           0x00000000
OFA:    .word           0x00000000
OFB:    .word           0x00000000
OFC:    .word           0x00000000
OFD:    .word           0x00000000
OFE:    .word           0x00000000
OFF:    .word           0x00000000


