addi $0,$0, 0x05
addi $1,$0, 0x01
addi $2,$2, 0x08
addi $3, $2, 0x01
addi $4, $4, 0x09
addi $5, $4, 0x01
addi $6, $6, 0x15
addi $7, $6, 0x01
add $8, $7, $6
addi $9, $9, 0x04
addi $10,$9,0x01
add $11, $9,$10
j jump
nop
nop
addi $12,$12,0x01
addi $13,$13,0x01
addi $14,$14,0x01
addi $15,$15,0x01
addi $16,$16,0x01
addi $17,$17,0x01
addi $18,$18,0x01
addi $19,$19,0x01
addi $20,$20,0x01
nop
nop
jump:
add $12, $0,$1
add $13, $2,$3
add $14, $4,$5
add $15, $6,$7
add $16, $8,$9
addi $17,$17,0xff
addi $18,$18,0xff
addi $19,$19,0xff
addi $20,$20,0xff
nop
nop
nop
nop
nop
nop