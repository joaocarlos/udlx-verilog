//==================================================================================================
//  Filename      : instruction_decoder.v
//  Created On    : 2014-06-06 21:35:39
//  Last Modified : 2014-06-06 22:35:43
//  Revision      : 
//  Author        : Victor Valente de Araujo
//  Company       : Universidade Federal da Bahia - UFBA
//  Email         : lintonthiago@gmail.com
//
//  Description   : 
//
//
//==================================================================================================
module execute_address_calculate
#(
   parameter DATA_WIDTH = 32,
   parameter PC_WIDTH = 32,
   parameter OPCODE_WIDTH = 6,
   parameter FUNCTION_WIDTH = 6, 
   parameter REG_ADDR_WIDTH = 5
)
(
   input clk,
   input rst_n,
//   input alu_src_in,
   input [OPCODE_WIDTH-1:0] alu_opcode_in,
   input [FUNCTION_WIDTH-1:0] alu_function_in,
   input [DATA_WIDTH-1:0] data_alu_a_in,
   input [DATA_WIDTH-1:0] data_alu_b_in,
   input [REG_ADDR_WIDTH-1:0] reg_a_addr_in,
   input [REG_ADDR_WIDTH-1:0] reg_b_addr_in,
   input [DATA_WIDTH-1:0] constant_in,
   input imm_inst_in,
   input write_back_mux_sel_in,
   input reg_wr_en_in,
   input [REG_ADDR_WIDTH-1:0] reg_wr_addr_in,
   input [PC_WIDTH-1:0] new_pc_in,
   input mem_data_rd_en_in,
   input mem_data_wr_en_in,
   input branch_inst_in,
   input jmp_inst_in,
   input jmp_use_r_in,
//   input [DATA_WIDTH-1:0] exe_mem_data_in,
//   input [DATA_WIDTH-1:0] mem_wb_data_in,
   input [DATA_WIDTH-1:0] ex_mem_reg_data,
   input [REG_ADDR_WIDTH-1:0] ex_mem_reg_addr,
   input ex_mem_reg_wr_ena,
   input [DATA_WIDTH-1:0] wb_reg_data,
   input [REG_ADDR_WIDTH-1:0] wb_reg_addr,
   input wb_reg_wr_ena,

   output mem_data_rd_en_out,
   output mem_data_wr_en_out,
   output [DATA_WIDTH-1:0] mem_data_out,
   output [DATA_WIDTH-1:0] alu_data_out,
   output reg_wr_en_out,
   output [REG_ADDR_WIDTH-1:0] reg_wr_addr_out,
   output write_back_mux_sel_out,
   output select_new_pc_out,
   output [PC_WIDTH-1:0] new_pc_out
);
//*******************************************************
//Internal
//*******************************************************
//Local Parameters

//Wires

wire select_new_pc;
wire [PC_WIDTH-1:0] pc_out;

wire branch_result;
wire [DATA_WIDTH-1:0] alu_b_mux_sel;
wire [DATA_WIDTH-1:0] alu_data_in_a;
wire [DATA_WIDTH-1:0] alu_data_in_b;

wire [DATA_WIDTH-1:0] alu_data;

//BRANCH CONTROL
//
branch_control
#(
   .DATA_WIDTH(DATA_WIDTH),
   .PC_WIDTH(PC_WIDTH)
)
branch_control_u0
(
   .jmp_inst(jmp_inst_in),
   .jmp_use_r(jmp_use_r_in),
   .branch_inst(branch_inst_in),
   .branch_result(branch_result),
   .pc_in(new_pc_in),
   .reg_a_data_in(alu_data_in_a),
   .reg_b_data_in(alu_b_mux_sel),
   .constant(constant_in),

   .select_new_pc(select_new_pc),
   .pc_out(pc_out)
);


//FOWARDING UNITS
//
forward_unit
#(
   .DATA_WIDTH(DATA_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH)
)
forward_unit
(
   .data_alu_a(data_alu_a_in),
   .data_alu_b(data_alu_b_in),
   .addr_alu_a(reg_a_addr_in),
   .addr_alu_b(reg_b_addr_in),
   .ex_mem_data(ex_mem_reg_data),
   .ex_mem_reg_addr(ex_mem_reg_addr),
   .ex_mem_reg_wr_ena(ex_mem_reg_wr_ena),
   .wb_reg_data(wb_reg_data),
   .wb_reg_addr(wb_reg_addr),
   .wb_reg_wr_ena(wb_reg_wr_ena),
   .alu_a_mux_sel(alu_data_in_a),
   .alu_b_mux_sel(alu_b_mux_sel)
);


//MUX select constant
//
mux_data
#(
   .DATA_WIDTH(DATA_WIDTH)
 )
mux_data_u0
(
   .data_a_in(alu_b_mux_sel),
   .data_b_in(constant_in),
   .mux_sel(imm_inst_in),
   .data_out(alu_data_in_b)
);


//ALU
//
alu
#(
   .DATA_WIDTH(DATA_WIDTH),
   .OPCODE_WIDTH(OPCODE_WIDTH)
)
alu_u0
(
  .alu_data_in_a(alu_data_in_a),
  .alu_data_in_b(alu_data_in_b),
  .alu_opcode(alu_opcode_in),
  .alu_function(alu_function_in),

  
  .alu_branch_result(branch_result),
  .alu_data_out(alu_data)
);


//ex_mem_pipe

execute_pipe
#(
    .PC_WIDTH(PC_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .REG_ADDR_WIDTH(REG_ADDR_WIDTH)
)
execute_pipe_u0
(
   .clk(clk),
   .rst_n(rst_n),

   .mem_data_rd_en_in(mem_data_rd_en_in),
   .mem_data_wr_en_in(mem_data_wr_en_in),
   .mem_data_in(alu_b_mux_sel),
   .alu_data_in(alu_data),
   .reg_wr_en_in(reg_wr_en_in),
   .reg_wr_addr_in(reg_wr_addr_in),
   .write_back_mux_sel_in(write_back_mux_sel_in),
   .select_new_pc_in(select_new_pc),
   .new_pc_in(pc_out),

   .mem_data_rd_en_out(mem_data_rd_en_out),
   .mem_data_wr_en_out(mem_data_wr_en_out),
   .mem_data_out(mem_data_out),
   .alu_data_out(alu_data_out),
   .reg_wr_en_out(reg_wr_en_out),
   .reg_wr_addr_out(reg_wr_addr_out),
   .write_back_mux_sel_out(write_back_mux_sel_out),
   .select_new_pc_out(select_new_pc_out),
   .new_pc_out(new_pc_out)
);



endmodule
