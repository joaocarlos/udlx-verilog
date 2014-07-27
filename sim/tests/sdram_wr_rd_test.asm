inicio:
addi $4, $zero, 0
addi $6, $zero, 0x10000
nop
nop
nop
write_branch:
#sw $4 0x10010000($4)
sw $4 0x00000000($4)
addi $4, $4, 4
sub $7, $4, $6
bnez $7, write_branch
nop
nop
eret 
nop
addi $4, $zero, 0
jal write_branch
jalr $t1,$t2
jr $t1
mult $t1,$t2
nop
nop
nop
read_branch:
#lw $5, 0x10010000($4)
lw $5, 0x00000000($4)
addi $4, $4, 4
nop
nop
sub $7, $4, $6
bnez $7, read_branch
nop
nop
addi $4, $zero, 0
nop
nop
j inicio
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
