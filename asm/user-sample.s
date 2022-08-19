.set noreorder
.set noat
.globl __start
.section text

__start:
.text
    lui $s0, 0xfffe
    ori $s0, $s0, 0x0001
    ori $t0, $zero, 0x1   # t0 = l
    ori $t1, $zero, 0x1   # t1 = r
    
    ori $t3, $zero, 0xdead # t3 = m
    ori $t4, $zero, 0x0   
    ori $t5, $zero, 0x0   # flag
    ori $t6, $zero, 0xffff # 65535
    ori $t7, $zero, 0x1   # 0x1
    ori $v0, $zero, 0x0

    ori $v1, $zero, 0x8     # v1 = 8
    lui $a0, 0x8040       # a0 = 0x80400000
    lui $a1, 0x8050
    lui $a2, 0x8050
    lui $a3, 0x0010

loop1:
    ori $t0, $zero, 0
    ori $t1, $zero, 0xffff
    lw $v0, 0($a0)
    addiu $a0, $a0, 4
    beq $a0, $a1, end
    ori   $zero, $zero, 0 # nop
    sltu $t2, $s0, $v0
    beq $t2, $zero, loop2
    ori   $zero, $zero, 0 # nop
    sw $t6, 0($a2)
    addiu $a2, $a2, 4
    beq $zero, $zero, loop1
    ori   $zero, $zero, 0 # nop
loop2:
    addu $t3, $t0, $t1
    srl $t3, $t3, 1
    mul $t2, $t0, $t0
    bne $v0, $t2, part1
    ori   $zero, $zero, 0 # nop
    sw $t0, 0($a2)
    addiu $a2, $a2, 4
    beq $zero, $zero, loop1
    ori $zero,$zero, 0
part1:
    mul $t2, $t1, $t1
    bne $v0, $t2, part2
    ori   $zero, $zero, 0 # nop
    sw $t1, 0($a2)
    addiu $a2, $a2, 4
    beq $zero, $zero, loop1
    ori $zero,$zero, 0
part2:
    mul $t2, $t3, $t3
    bne $v0, $t2, part3
    ori   $zero, $zero, 0 # nop
    sw $t3, 0($a2)
    addiu $a2, $a2, 4
    beq $zero, $zero, loop1
    ori $zero,$zero, 0
part3:
    addu $t2, $t0, $t7
    bne $t2, $t1, part4
    ori   $zero, $zero, 0 # nop
    sw $t0, 0($a2)
    addiu $a2, $a2, 4
    beq $zero, $zero, loop1
    ori $zero,$zero, 0
part4:
    mul $t2, $t3, $t3
    sltu $t2, $t2, $v0
    beq $t2, $zero, part5
    ori $zero,$zero, 0
    xor $t0, $t0, $t0
    addu $t0, $t0, $t3
    beq $zero, $zero, loop2
    ori $zero,$zero, 0
part5:
    xor $t1, $t1, $t1
    addu $t1, $t1, $t3
    beq $zero, $zero, loop2
    ori $zero,$zero, 0


end:
    jr    $ra
    ori   $zero, $zero, 0 # nop
