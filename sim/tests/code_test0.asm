inicio:
addi $4, $1, 345
addi $2, $1, 150
sub $3, $2, $4
add $5, $1, $4
and $4, $5, $2
# para gerar o .hex usar o comando abaixo
sw $2 0x000000a($1)
# para simular usar o comando abaixo
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
# para gerar o .hex usar o comando abaixo
lw $3, 0x0000000a($1)
# para simular usar o comando abaixo
#ld $3, 0x10010000
sub $4, $2, $3
beqz $4, inicio
add $5,$3,$2
sub $5,$7,$2
or $5,$7,$2
nop
nop
nop
nop
nop
nop
nop
nop
