# testes de forwarding

# setup values
addi $6, $1, 9
addi $2, $2, 5
# sw $2, 0x10010000
sw $2, 0x000000a($1)
nop
nop
nop
nop
# forwarding MEM -> EXE
add $3, $6, $2 # result "0xE"
and $6, $3, $2 # result "0x4"
# forwarding WB -> EXE
sub $4, $3, $2 # result "0x9"
add $3, $6, $3 # result "0x12"
# both forwardings
or  $5, $4, $3 # result "0x1B"
# forwarding WB -> MEM
# ld $3, 0x10010000
lw $3, 0x0000000a($1)
# sw $3, 0x10010004
addi $1, $1, 1
sw $3, 0x000000a($1)
nop
nop
nop
