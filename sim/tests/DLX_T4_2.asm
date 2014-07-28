addi $0,$0, 200
addi $1,$1, 250
nop
nop
nop
nop
nop
sub $15,$1,$0
nop
nop
nop
nop
nop
bnez $15,writeregisters
addi $16,$16, 1
addi $17,$17, 1
addi $18,$18, 1
addi $19,$19, 1
nop
writeregisters:
addi $2,$2, 0xff
addi $3,$3, 0xff
addi $4,$4, 0xff
addi $5,$5, 0xf0f
addi $6,$6, 0xff
addi $7,$7, 0xff
addi $8,$8, 0xff
addi $9,$9, 0xff
addi $10,$10, 0xf0f
addi $11,$11, 0xf0f
addi $12,$12, 0xf0f
addi $13,$13, 0xf0f
addi $14,$14, 0xf0f
nop
nop
nop
nop
nop
nop
