# CE119 Lab03 - TN3 - 25521783
.data
n:      .word 20
msg:    .asciiz "F(n) = "
.text
.globl main
main:
        lw   $a0, n
        jal  fib_rec             # doi thanh fib_iter de so sanh
        move $s0, $v0
        li   $v0, 4
        la   $a0, msg
        syscall
        move $a0, $s0
        li   $v0, 1
        syscall
        li   $v0, 10
        syscall

# fib_rec: F(n) de quy
# vao: $a0 = n | ra: $v0 = F(n)
# dung: $s0 = n, $s1 = F(n-1), $ra; $t0
# khung 12 byte: 8=$ra, 4=$s0, 0=$s1
fib_rec:
        addi $sp, $sp, -12
        sw   $ra, 8($sp)
        sw   $s0, 4($sp)
        sw   $s1, 0($sp)
        move $s0, $a0
        slti $t0, $s0, 2
        beq  $t0, $zero, fr_recur
        move $v0, $s0            # co so: F(0)=0, F(1)=1
        j    fr_exit
fr_recur:
        addi $a0, $s0, -1
        jal  fib_rec
        move $s1, $v0
        addi $a0, $s0, -2
        jal  fib_rec
        add  $v0, $s1, $v0
fr_exit:
        lw   $s1, 0($sp)
        lw   $s0, 4($sp)
        lw   $ra, 8($sp)
        addi $sp, $sp, 12
        jr   $ra

# fib_iter: tinh F(n) bang vong lap
# Tham so : $a0 = n Tra ve : $v0 = F(n)
# Thanh ghi: $t0-$t3 (thu tuc la)
fib_iter:
        move $v0, $zero          # a = F(0)
        li   $t0, 1              # b = F(1)
        move $t1, $zero          # i = 0
fi_loop:
        slt  $t2, $t1, $a0
        beq  $t2, $zero, fi_done
        addu $t3, $v0, $t0       # a + b
        move $v0, $t0
        move $t0, $t3
        addiu $t1, $t1, 1
        j    fi_loop
fi_done:
        jr   $ra
