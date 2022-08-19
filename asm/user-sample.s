.set noreorder
.set noat
.globl __start
.section text

__start:
.text
    ori $t0, $zero, 0x1   # t0 = 1
    ori $t1, $zero, 0x1   # t1 = 1
    ori $t4, $zero, 0x0   
    ori $t5, $zero, 0x0   # flag
    ori $t6, $zero, 0xffff # 65535
    ori $t7, $zero, 0x1   # 0x1
    ori $v0, $zero, 0x0

    ori $v1, $zero, 0x8     # v1 = 8
    lui $a0, 0x8040       # a0 = 0x80400000
    lui $a1, 0x8050
    lui $a2, 0x8050

loop:
    lw      $v0, 0($a0)
    addiu   $a0, $a0, 0x4
    beq     $a0,$a1, end
loop2:
    ori $t2, $zero, 0
    beq   $t0, $t6, endloop2
    ori   $zero, $zero, 0 # nop

    mul   $t1, $t0, $t0

    beq   $t1, $v0, part1
    ori   $zero, $zero, 0 # nop

    sltu  $t2, $v0, $t1
    beq   $t2, $t7, part2
    ori   $zero, $zero, 0 # nop
    beq   $zero,$zero,loop2
    addiu $t0, $t0, 0x1
part1:    
    sw  $t0,0($a2)
    beq $zero, $zero ,endloop2
    ori $t5, $zero, 0x1   # flag
part2:
    sub $t0, $t0, 0x1
    sw  $t0,0($a2)
    beq $zero, $zero ,endloop2
    ori $t5, $zero, 0x1   # flag
    
endloop2:
    beq $t5, $t7, part3
    ori   $zero, $zero, 0 # nop
    sw $t6, 0($a2)
    
part3:
    addiu $t4, $t4 ,1

    bne $t4,$a3,loop
    addiu $a3, $a3, 0x4
    
end:
    jr    $ra
    ori   $zero, $zero, 0 # nop
