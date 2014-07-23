#init LCD
nop
andi $4, $3, 0x00000000 #zerando
addi $4, $3, 10 #inicializando delay
andi $7, $3, 0x00000000 #zerando
addi $7, $3, 10000 #constador alvo
init:
#count
increment:
nop
addi $10, $10, 1
sw $10 0
lw $9 0
sw $9 0xFFFFFFFF
#add_delay_0:
andi $3, $8, 0x00000000 #zerando
wait1:
addi $3, $3, 1 #contando
sub $5, $4, $3
bnez $5, wait1
sub $6, $7, $9
j increment
nop
nop
                  
