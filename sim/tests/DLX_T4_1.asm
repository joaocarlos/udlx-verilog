addi $0,$0, 200
addi $1,$1, 200
nop
nop
nop
nop
nop
cmp $15, $0,$1
nop
nop
nop
nop
nop
beqz $15,writeregisters
addi $16,$16, 1
addi $17,$17, 1
addi $18,$18, 1
addi $19,$19, 1
nop
writeregisters:
addi $2,$2, 8
addi $3,$3, 350
addi $4,$4, 400
addi $5,$5, 450
addi $6,$6, 400
addi $7,$7, 350
addi $8,$8, 300
addi $9,$9, 70
addi $10,$10, 255
addi $11,$11, 50
addi $12,$12, 30
addi $13,$13, 1
addi $14,$14, 255
nop
nop
nop
nop
nop
nop