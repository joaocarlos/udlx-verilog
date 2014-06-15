//==================================================================================================
//  Filename      : inst_decode_pipe.v
//  Created On    : 2014-06-06 21:35:39
//  Last Modified : 2014-06-06 22:35:43
//  Revision      : 
//  Author        : Victor Valente de Araujo
//  Company       : Universidade Federal da Bahia - UFBA
//  Email         : 
//
//  Description   : 
//
//
//==================================================================================================
module inst_decode_pipe
#(
   parameter INSTRUCTION_WIDTH = 32,
   parameter PC_WIDTH = 20,
   parameter DATA_WIDTH = 32,
   parameter OPCODE_WIDTH = 6,
   parameter FUNCTION_WIDTH = 5,
   parameter REG_ADDR_WIDTH = 5,
   parameter IMEDIATE_WIDTH = 16,
   parameter PC_OFFSET_WIDTH = 26
)
(
   input clk,
   input rst_n,

   input [DATA_WIDTH-1:0] data_alu_a_in, 
   input [DATA_WIDTH-1:0] data_alu_b_in, 
   input [PC_WIDTH-1:0] new_pc_in,
   input [OPCODE_WIDTH-1:0] opcode_in,
   input [FUNCTION_WIDTH-1:0] inst_function_in,
   input [REG_ADDR_WIDTH-1:0] read_address1_in,
   input [REG_ADDR_WIDTH-1:0] read_address2_in,
   input [REG_ADDR_WIDTH-1:0] reg_wr_addr_in,
   input reg_wr_en_in,
   input [DATA_WIDTH-1:0] constant_in,
   input imm_inst_in,
//   input [IMEDIATE_WIDTH-1:0] immediate_in,
   input [PC_OFFSET_WIDTH-1:0] pc_offset_in,
   input mem_data_rd_en_in,
   input mem_data_wr_en_in,
   input write_back_mux_sel_in,
   input branch_inst_in,
   input jump_inst_in,
   input jump_use_r_in,

   output reg [DATA_WIDTH-1:0] data_alu_a_out, 
   output reg [DATA_WIDTH-1:0] data_alu_b_out, 
   output reg [PC_WIDTH-1:0] new_pc_out,
   output reg [OPCODE_WIDTH-1:0] opcode_out,
   output reg [FUNCTION_WIDTH-1:0] inst_function_out,
   output reg [FUNCTION_WIDTH-1:0] inst_function,
   output reg [REG_ADDR_WIDTH-1:0] read_address1_out,
   output reg [REG_ADDR_WIDTH-1:0] read_address2_out,
   output reg [REG_ADDR_WIDTH-1:0] reg_wr_addr_out,
   output reg reg_wr_en_out,
   output reg [DATA_WIDTH-1:0] constant_out,
   output reg imm_inst_out,
//   output reg [IMEDIATE_WIDTH-1:0] immediate_out,
   output reg [PC_OFFSET_WIDTH-1:0] pc_offset_out,
   output reg mem_data_rd_en_out,
   output reg mem_data_wr_en_out,
   output reg write_back_mux_sel_out,
   output reg branch_inst_out,
   output reg jump_inst_out,
   output reg jump_use_r_out
);

always@(posedge clk, negedge rst_n)begin
   if(!rst_n)begin
      data_alu_a_out <= 0;
      data_alu_b_out <= 0;
      new_pc_out <= 0;
      opcode_out <= 0;
      inst_function_out <= 0;
      read_address1_out <= 0;
      read_address2_out <= 0;
      reg_wr_addr_out <= 0;
      reg_wr_en_out <= 0;
      constant_out <= 0;
      imm_inst_out <= 0;
//      immediate_out <= 0;
      pc_offset_out <= 0;
      mem_data_rd_en_out <= 0;
      mem_data_wr_en_out <= 0;
      write_back_mux_sel_out <= 0;
      branch_inst_out <= 0;
      jump_inst_out <= 0;
      jump_use_r_out <= 0;
   end
   else begin
      data_alu_a_out <= data_alu_a_in;
      data_alu_b_out <= data_alu_b_in;
      new_pc_out <= new_pc_in;
      opcode_out <= opcode_in;
      inst_function_out <= inst_function_in;
      read_address1_out <= read_address1_in;
      read_address2_out <= read_address2_in;
      reg_wr_addr_out <= reg_wr_addr_in;
      reg_wr_en_out <= reg_wr_en_in;
      constant_out <= constant_in;
      imm_inst_out <= imm_inst_in;
//      immediate_out <= immediate_in;
      pc_offset_out <= pc_offset_in;
      mem_data_rd_en_out <= mem_data_rd_en_in;
      mem_data_wr_en_out <= mem_data_wr_en_in;
      write_back_mux_sel_out <= write_back_mux_sel_in;
      branch_inst_out <= branch_inst_in;
      jump_inst_out <= jump_inst_in;
      jump_use_r_out <= jump_use_r_in;
   end
end


endmodule
