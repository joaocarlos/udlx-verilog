// +----------------------------------------------------------------------------
// GNU General Public License
// -----------------------------------------------------------------------------
// This file is part of uDLX (micro-DeLuX) soft IP-core.
//
// uDLX is free soft IP-core: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// uDLX soft core is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with uDLX. If not, see <http://www.gnu.org/licenses/>.
// +----------------------------------------------------------------------------
// PROJECT: uDLX core Processor
// ------------------------------------------------------------------------------
// FILE NAME   : id_ex_reg.v
// -----------------------------------------------------------------------------
// KEYWORDS    : dlx, decoder, instruction, execute, pipeline
// -----------------------------------------------------------------------------
// PURPOSE     : Decode/Execute pipeline registers
// -----------------------------------------------------------------------------
module id_ex_reg
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
   input en,
   input flush_in,

   input [DATA_WIDTH-1:0] data_alu_a_in,
   input [DATA_WIDTH-1:0] data_alu_b_in,
   input [PC_WIDTH-1:0] new_pc_in,
   input [INSTRUCTION_WIDTH-1:0] instruction_in,
   input [OPCODE_WIDTH-1:0] opcode_in,
   input [FUNCTION_WIDTH-1:0] inst_function_in,
   input [REG_ADDR_WIDTH-1:0] reg_rd_addr1_in,
   input [REG_ADDR_WIDTH-1:0] reg_rd_addr2_in,
//   input [REG_ADDR_WIDTH-1:0] reg_wr_addr_in,
//   input reg_wr_en_in,
   input [REG_ADDR_WIDTH-1:0] reg_a_wr_addr_in,
   input [REG_ADDR_WIDTH-1:0] reg_b_wr_addr_in,
   input reg_a_wr_en_in,
   input reg_b_wr_en_in,
   input [DATA_WIDTH-1:0] constant_in,
   input imm_inst_in,
//   input [IMEDIATE_WIDTH-1:0] immediate_in,
   input [PC_OFFSET_WIDTH-1:0] pc_offset_in,
   input mem_data_rd_en_in,
   input mem_data_wr_en_in,
   input write_back_mux_sel_in,
   input branch_inst_in,
   input branch_use_r_in,
   input jump_inst_in,
   input jump_use_r_in,

   output reg [DATA_WIDTH-1:0] data_alu_a_out,
   output reg [DATA_WIDTH-1:0] data_alu_b_out,
   output reg [PC_WIDTH-1:0] new_pc_out,
   output reg [INSTRUCTION_WIDTH-1:0] instruction_out,
   output reg [OPCODE_WIDTH-1:0] opcode_out,
   output reg [FUNCTION_WIDTH-1:0] inst_function_out,
//   output reg [FUNCTION_WIDTH-1:0] inst_function,
   output reg [REG_ADDR_WIDTH-1:0] reg_rd_addr1_out,
   output reg [REG_ADDR_WIDTH-1:0] reg_rd_addr2_out,
//   output reg [REG_ADDR_WIDTH-1:0] reg_wr_addr_out,
//   output reg reg_wr_en_out,
   output reg [REG_ADDR_WIDTH-1:0] reg_a_wr_addr_out,
   output reg [REG_ADDR_WIDTH-1:0] reg_b_wr_addr_out,
   output reg reg_a_wr_en_out,
   output reg reg_b_wr_en_out,
   output reg [DATA_WIDTH-1:0] constant_out,
   output reg imm_inst_out,
//   output reg [IMEDIATE_WIDTH-1:0] immediate_out,
   output reg [PC_OFFSET_WIDTH-1:0] pc_offset_out,
   output reg mem_data_rd_en_out,
   output reg mem_data_wr_en_out,
   output reg write_back_mux_sel_out,
   output reg branch_inst_out,
   output reg branch_use_r_out,
   output reg jump_inst_out,
   output reg jump_use_r_out
);

always@(posedge clk, negedge rst_n)begin
   if(!rst_n)begin
      data_alu_a_out <= 0;
      data_alu_b_out <= 0;
      new_pc_out <= 0;
      instruction_out <= 0;
      opcode_out <= 0;
      inst_function_out <= 0;
      reg_rd_addr1_out <= 0;
      reg_rd_addr2_out <= 0;
//      reg_wr_addr_out <= 0;
//      reg_wr_en_out <= 0;
      reg_a_wr_addr_out <= 0;
      reg_b_wr_addr_out <= 0;
      reg_a_wr_en_out <= 0;
      reg_b_wr_en_out <= 0;

      constant_out <= 0;
      imm_inst_out <= 0;
//      immediate_out <= 0;
      pc_offset_out <= 0;
      mem_data_rd_en_out <= 0;
      mem_data_wr_en_out <= 0;
      write_back_mux_sel_out <= 0;
      branch_inst_out <= 0;
      branch_use_r_out <= 0;
      jump_inst_out <= 0;
      jump_use_r_out <= 0;
   end
   else if(en) begin
      if(flush_in)begin
         data_alu_a_out <= 0;
         data_alu_b_out <= 0;
         new_pc_out <= 0;
         instruction_out <= 0;
         opcode_out <= 0;
         inst_function_out <= 0;
         reg_rd_addr1_out <= 0;
         reg_rd_addr2_out <= 0;
//         reg_wr_addr_out <= 0;
//         reg_wr_en_out <= 0;
         reg_a_wr_addr_out <= 0;
         reg_b_wr_addr_out <= 0;
         reg_a_wr_en_out <= 0;
         reg_b_wr_en_out <= 0;

         constant_out <= 0;
         imm_inst_out <= 0;
         pc_offset_out <= 0;
         mem_data_rd_en_out <= 0;
         mem_data_wr_en_out <= 0;
         write_back_mux_sel_out <= 0;
         branch_inst_out <= 0;
         branch_use_r_out <= 0;
         jump_inst_out <= 0;
         jump_use_r_out <= 0;
      end
      else begin
         data_alu_a_out <= data_alu_a_in;
         data_alu_b_out <= data_alu_b_in;
         new_pc_out <= new_pc_in;
         instruction_out <= instruction_in;
         opcode_out <= opcode_in;
         inst_function_out <= inst_function_in;
         reg_rd_addr1_out <= reg_rd_addr1_in;
         reg_rd_addr2_out <= reg_rd_addr2_in;
//         reg_wr_addr_out <= reg_wr_addr_in;
//         reg_wr_en_out <= reg_wr_en_in;
         reg_a_wr_addr_out <= reg_a_wr_addr_in;
         reg_b_wr_addr_out <= reg_b_wr_addr_in;
         reg_a_wr_en_out <= reg_a_wr_en_in;
         reg_b_wr_en_out <= reg_b_wr_en_in;
         constant_out <= constant_in;
         imm_inst_out <= imm_inst_in;
//         immediate_out <= immediate_in;
         pc_offset_out <= pc_offset_in;
         mem_data_rd_en_out <= mem_data_rd_en_in;
         mem_data_wr_en_out <= mem_data_wr_en_in;
         write_back_mux_sel_out <= write_back_mux_sel_in;
         branch_inst_out <= branch_inst_in;
         branch_use_r_out <= branch_use_r_in;
         jump_inst_out <= jump_inst_in;
         jump_use_r_out <= jump_use_r_in;
      end
   end
end


endmodule
