//==================================================================================================
//  Filename      : instruction_decode.v
//  Created On    : 2014-06-07 10:00:00
//  Last Modified : 2014-06-07 14:00:00
//  Revision      : 
//  Author        : Victor Valente de Araujo
//  Company       : Universidade Federal da Bahia - UFBA
//  Email         : victor.valente.araujo@gmail.com
//
//  Description   : 
//
//
//==================================================================================================
module instruction_decode
#(
    INSTRUCTION_WIDTH = 32,
    REG_ADDR_WIDTH = 5,
    IMEDIATE_WIDTH = 16,
    DECODED_INST_WIDTH = 4
)
(
  input clk,
  input rst_n,
  input [INSTRUCTION_WIDTH-1:0] instruction_reg_in,
  input [PC_WIDTH-1:0] new_pc_in,
  input wb_write_enable,
  input [DATA_WIDTH-1:0] wb_write_data,
  output alu_src_out,
  output [REG_ADDR_WIDTH-1:0] read_address1_out,
  output [REG_ADDR_WIDTH-1:0] read_address2_out,
  output [INSTRUCTION_WIDTH-1:0] instruction_out,
  output [OPCODE_WIDHT-1:0] opcode_out,
  output [FUNCTION_WIDTH-1:0] inst_function_out, //added, will exist when the function is zero
  output mem_data_wr_en_out,
  output write_back_mux_sel_out,
  output w_reg_wr_en_out,
  output [REG_ADDR_WIDTH-1:0] w_reg_addr_out,
  output [DATA_WIDTH-1:0] constant_out,
  output [DATA_WIDTH-1:0] data_alu_a_out,
  output [DATA_WIDTH-1:0] data_alu_b_out,
  output [PC_WIDTH-1:0] new_pc_out,
  output [PC_OFFSET_WIDTH-1:0] pc_offset_out,
  output branch_inst_out, 
  output jump_inst_out

);
//*******************************************************
//Internal
//*******************************************************
//Local Parameters

//Wires

wire [DATA_WIDHT-1:0] data_alu_a; 
wire [DATA_WIDHT-1:0] data_alu_b; 
wire [OPCODE_WIDTH-1:0] opcode;
wire [FUNCTION_WIDTH-1:0] inst_function;
wire [REG_ADDR_WIDTH-1:0] read_address1;
wire [REG_ADDR_WIDTH-1:0] read_address2;
wire [REG_ADDR_WIDTH-1:0] w_reg_addr;
wire w_reg_wr_en;
wire [IMEDIATE_WIDTH-1:0] immediate;
wire [DATA_WIDTH-1:0] constant;
wire [PC_OFFSET_WIDTH-1:0] pc_offset;
wire mem_data_wr_en;
wire write_back_mux_sel;
wire branch_inst;
wire jump_inst;

//Registers

//*******************************************************
//General Purpose Signals
//*******************************************************

//*******************************************************
//Outputs
//*******************************************************
//ranges dependem das instruções a serem definidas


instruction_decoder
#(
   .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
   .OPCODE_WIDTH(OPCODE_WIDTH),
   .FUNCTION_WIDTH(FUNCTION_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH),
   .IMEDIATE_WIDTH(IMEDIATE_WIDTH),
   .PC_OFFSET_WIDTH(PC_OFFSET_WIDTH)
)
instruction_decoder_u0
(/*autoport*/
   .instruction_in(instruction_in),
   .opcode(opcode),
   .inst_function(inst_function),
   .read_address1_out(read_address1),
   .read_address2_out(read_address2),
   .w_reg_addr_out(w_reg_addr),
   .w_reg_wr_en_out(w_reg_wr_en),
   .immediate_out(immediate),
   .pc_offset(pc_offset),
   .mem_data_wr_en_out(mem_data_wr_en),
   .write_back_mux_sel_out(write_back_mux_sel),
   .branch_inst_out(branch_inst),
   .jump_inst_out(jump_inst)
);


register_bank
#(
   .DATA_WIDTH(DATA_WIDTH),
   .MEMORY_SIZE(MEMORY_SIZE),
   .ADDRESS_WIDTH(ADDRESS_WIDTH),
)
register_bank_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .read_address_1(read_address_1),
   .read_address_2(read_address_2),
   .write_address(write_address),
   .write_enable(wb_write_enable),
   .write_data(wb_write_data),
   .read_data_1(data_alu_a),
   .read_data_2(data_alu_b),
);



//control
//control_u0
//(
//   .decoded_inst_in(decoded_inst_in),
//   .alu_src_out(alu_src_out),
//   .alu_opcode_out(alu_opcode_out),
//   .mem_data_wr_en_out(mem_data_wr_en_out),
//   .write_back_mux_sel_out(write_back_mux_sel_out),
//   .w_reg_wr_en_out(w_reg_wr_en_out),
//   .data_alu_a_out(data_alu_a_out),
//   .data_alu_b_out(data_alu_b_out),
//   .new_pc_out(new_pc_out),
//   .branch_inst_out(branch_inst_out),
//   .jmp_inst_out(jmp_inst_out),
//);


signal_extend
#(
    .OUT_DATA_WIDTH(32),
    .IN_DATA_WIDTH(16)
)
signal_extend_u0
(
    .signal_in(immediate),
    .signal_out(constant)
);

inst_decode_pipe
   .PC_WIDTH(PC_WIDTH),
   .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
   .DATA_WIDTH(DATA_WIDTH),
   .OPCODE_WIDTH(OPCODE_WIDTH),
   .FUNCTION_WIDTH(FUNCTION_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH),
   .IMEDIATE_WIDTH(IMEDIATE_WIDTH),
   .PC_OFFSET_WIDTH(PC_OFFSET_WIDTH)
)
inst_decode_pipe_u0
(/*autoport*/
   .clk(clk),
   .rst_n(rst_n),

   .data_alu_a_in(data_alu_a),
   .data_alu_b_in(data_alu_b),
   .new_pc_in(new_pc_in),
   .instruction_in(instruction_reg_in),
   .opcode_in(opcode),
   .inst_function_in(inst_function),
   .read_address1_in(read_address1),
   .read_address2_in(read_address2),
   .w_reg_addr_in(w_reg_addr),
   .w_reg_wr_en_in(w_reg_wr_en),
   .constant_out(constant),
   .pc_offset_in(pc_offset),
   .mem_data_wr_en_in(mem_data_wr_en),
   .write_back_mux_sel_in(write_back_mux_sel)
   .branch_inst_in(branch_inst),
   .jump_inst_in(jump_inst)


   .data_alu_a_out(data_alu_a_out),
   .data_alu_b_out(data_alu_b_out),
   .new_pc_out(new_pc_out),
   .instruction_out(instruction_out),
   .opcode_out(opcode_out),
   .inst_function_out(inst_function_out),
   .read_address1_out(read_address1_out),
   .read_address2_out(read_address2_out),
   .w_reg_addr_out(w_reg_addr_out),
   .w_reg_wr_en_out(w_reg_wr_en_out),
   .constant_out(constant_out),
   .pc_offset_out(pc_offset_out),
   .mem_data_wr_en_out(mem_data_wr_en_out),
   .write_back_mux_sel_out(write_back_mux_sel_out),
   .branch_inst_out(branch_inst_out),
   .jump_inst_out(jump_inst_out)
 );


endmodule
