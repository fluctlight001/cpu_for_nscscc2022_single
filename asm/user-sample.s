.set noreorder
.set noat
.globl __start
.section text

__start:
.text
    ori $t0, $zero, 0x1   # t0 = 1
    ori $t1, $zero, 0x1   # t1 = 1
    ori $t3, $zero, 0xdead
    ori $t4, $zero, 0x0   
    ori $t5, $zero, 0x0   # flag
    ori $t6, $zero, 0xffff # 65535
    ori $t7, $zero, 0x1   # 0x1
    ori $v0, $zero, 0x0

    ori $v1, $zero, 0x8     # v1 = 8
    lui $a0, 0x8040       # a0 = 0x80400000
    lui $a1, 0x8050
    lui $a2, 0x8050
    lui $a3, 0x0001

loop:
    ori $t0, $zero, 0x1   # t0 = 1
    lw      $v0, 0($a0)
    addiu   $a0, $a0, 0x4
    sw $t3, 0($a2)
    sw $t3, 4($a2)

    
end:
    jr    $ra
    ori   $zero, $zero, 0 # nop
