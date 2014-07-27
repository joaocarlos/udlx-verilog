inicio:
addi $4, $1, 345
addi $2, $1, 150
addi $2, $2, 30
#lui $1,0x0001001
sw $2 0x000000a($1)
#sw $2 0x10010000
j test2
not $7,$2
add $3,$2,$2
add $6,$4,$7
nop
nop
nop
nop
nop
sub $8,$4,$7
test2:
lw $3, 0x0000000a($1)
#ld $3, 0x10010000
sub $4, $2, $3
beqz $4, inicio
add $5,$3,$2
nop
nop
nop
nop
nop
nop
nop
nop
