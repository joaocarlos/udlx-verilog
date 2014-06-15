
/////////////////////////////////////////////
//  ALL INSTRUCTIONS OPCODES AND FUNCTIONS
/////////////////////////////////////////////


/////////////////////////////////////////////
// I-TYPE INSTRUCTIONS
localparam LW_OPCODE = 6'h23;
localparam SW_OPCODE = 6'h2B;
localparam BRFL_OPCODE = 6'h2B;
localparam ADDI_OPCODE = 6'h08;
localparam SUBI_OPCODE = 6'h10;
localparam ANDI_OPCODE = 6'h12;
localparam ORI_OPCODE = 6'h13;
localparam BEQZ_OPCODE = 6'h04;
localparam BNEZ_OPCODE = 6'h05;
localparam JR_OPCODE = 6'h16;

////////////////////////////////////////////
// R-TYPE INSTRUCTIONS OPCODE
localparam R_TYPE_OPCODE = 6'h00;

////////////////////////////////////////////
// R-TYPE INSTRUCTIONS FUNCTIONS
localparam ADD_FUNCTION = 6'h20;
localparam SUB_FUNCTION = 6'h22;
localparam AND_FUNCTION = 6'h24;
localparam NOR_FUNCTION = 6'h27;
localparam OR_FUNCTION = 6'h25;
localparam DIV_FUNCTION = 6'h1A;
localparam MULT_FUNCTION = 6'h18;
localparam CMP_FUNCTION = 6'h1C;
localparam NOT_FUNCTION = 6'h1D;


////////////////////////////////////////////
// J-TYPE INSTRUCTIONS OPCODE
localparam JPC_OPCODE = 6'h02;
localparam CALL_OPCODE = 6'h3E;
localparam RET_OPCODE = 6'h3F;
