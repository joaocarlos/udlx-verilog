nop
andi $1, $1, 0
addi $3, $1, 0x64 #endereço final
addi $2, $1, 0x1000
add $2, $2, $2 
add $2, $2, $2 
add $2, $2, $2 
add $2, $2, $2 
add $2, $2, $2 
add $3, $3, $2

read_data:
nop
lw $4, 0x0($2)
sw $4, 0x0($2)
addi $2, $2, 0x04
sub $5, $3, $2
bnez $5, read_data
addi $2, $0, 0
addi $3, $0, 0
addi $4, $0, 0
jr $7
nop
nop
