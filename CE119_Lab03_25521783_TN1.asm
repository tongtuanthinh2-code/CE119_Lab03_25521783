# CE119 Lab03 - TN1 - 25521783
.data
msg:    .asciiz "Ket qua: "
.text
.globl main
main:
        li   $a0, 5
        jal  outer
        move $s0, $v0
        li   $v0, 4
        la   $a0, msg
        syscall
        move $a0, $s0
        li   $v0, 1
        syscall
        li   $v0, 10
        syscall

# outer(x) = inner(x) + 1
# vao: $a0 = x | ra: $v0 | dung: $ra (cat vao stack)
outer:
        addi $sp, $sp, -4
        sw   $ra, 0($sp)
        jal  inner
        addi $v0, $v0, 1
        lw   $ra, 0($sp)
        addi $sp, $sp, 4
        jr   $ra

# inner(x) = 2x (thu tuc la)
# vao: $a0 = x | ra: $v0 | dung: $v0
inner:
        add  $v0, $a0, $a0
        jr   $ra
