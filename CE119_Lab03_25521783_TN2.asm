# CE119 Lab03 - TN2 - 25521783
.data
str1:   .asciiz "kien truc may tinh"
str2:   .asciiz "mips"
str3:   .asciiz ""
str4:   .asciiz "a bc def"
str5:   .asciiz "thanh ghi s phai duoc bao toan"
tests:  .word str1, str2, str3, str4, str5
bar:    .asciiz "|"
nl:     .asciiz "\n"
.text
.globl main
main:
        la   $s0, tests          # con tro vao bang chuoi
        li   $s1, 5              # so chuoi
m_loop:
        lw   $a0, 0($s0)
        jal  reverse_words
        li   $v0, 4
        la   $a0, bar
        syscall
        lw   $a0, 0($s0)
        syscall
        la   $a0, bar
        syscall
        la   $a0, nl
        syscall
        addiu $s0, $s0, 4
        addiu $s1, $s1, -1
        bne  $s1, $zero, m_loop
        li   $v0, 10
        syscall

# reverse_words: dao thu tu tu tai cho
# vao: $a0 = dia chi chuoi | ra: khong
# dung: $s0 = dau tu, $s1 = con tro duyet, $ra; $t0, $t1
# khung 12 byte: 8=$ra, 4=$s0, 0=$s1
reverse_words:
        addi $sp, $sp, -12
        sw   $ra, 8($sp)
        sw   $s0, 4($sp)
        sw   $s1, 0($sp)
        move $s0, $a0
        jal  strlen
        beq  $v0, $zero, rw_exit     # chuoi rong
        move $a0, $s0
        addu $a1, $s0, $v0
        addiu $a1, $a1, -1
        jal  rev_range               # dao ca chuoi
        move $s1, $s0
rw_scan:
        lbu  $t0, 0($s1)
        beq  $t0, $zero, rw_word
        li   $t1, 32                 # ' '
        beq  $t0, $t1, rw_word
        addiu $s1, $s1, 1
        j    rw_scan
rw_word:
        move $a0, $s0                # dao tu [s0, s1-1]
        addiu $a1, $s1, -1
        jal  rev_range
        lbu  $t0, 0($s1)             # doc lai, $t0 da bi doi
        beq  $t0, $zero, rw_exit
        addiu $s1, $s1, 1
        move $s0, $s1
        j    rw_scan
rw_exit:
        lw   $s1, 0($sp)
        lw   $s0, 4($sp)
        lw   $ra, 8($sp)
        addi $sp, $sp, 12
        jr   $ra

# strlen (thu tuc la)
# vao: $a0 = dia chi chuoi | ra: $v0 = do dai | dung: $t0, $t1
strlen:
        move $v0, $zero
sl_loop:
        addu $t0, $a0, $v0
        lbu  $t1, 0($t0)
        beq  $t1, $zero, sl_done
        addiu $v0, $v0, 1
        j    sl_loop
sl_done:
        jr   $ra

# rev_range: dao doan [$a0, $a1] (thu tuc la)
# vao: $a0 = dau, $a1 = cuoi | ra: khong | dung: $t0, $t1, $a0, $a1
# so sanh khong dau, doan rong thi khong lam gi
rev_range:
        sltu $t0, $a0, $a1
        beq  $t0, $zero, rr_done
rr_loop:
        lbu  $t0, 0($a0)
        lbu  $t1, 0($a1)
        sb   $t1, 0($a0)
        sb   $t0, 0($a1)
        addiu $a0, $a0, 1
        addiu $a1, $a1, -1
        sltu $t0, $a0, $a1
        bne  $t0, $zero, rr_loop
rr_done:
        jr   $ra
