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
// FILE NAME   : execute_address_calculate.v
// KEYWORDS    : dlx, decoder, instruction
// -----------------------------------------------------------------------------
// PURPOSE: Top level module of Execute/Address Calculate stage
// -----------------------------------------------------------------------------
module execute_address_calculate
#(
   parameter DATA_WIDTH = 32,
   parameter PC_WIDTH = 32,
   parameter INSTRUCTION_WIDTH = 32,
   parameter OPCODE_WIDTH = 6,
   parameter FUNCTION_WIDTH = 6,
   parameter REG_ADDR_WIDTH = 5,
   parameter PC_OFFSET_WIDTH = 26
)
(
   input clk,
   input rst_n,

   input flush_in,

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
   input [PC_OFFSET_WIDTH-1:0] pc_offset_in,
   input branch_inst_in,
   input jmp_inst_in,
   input jmp_use_r_in,
//   input [DATA_WIDTH-1:0] exe_mem_data_in,
//   input [DATA_WIDTH-1:0] mem_wb_data_in,
   input [DATA_WIDTH-1:0] ex_mem_reg_data_in,
   input [REG_ADDR_WIDTH-1:0] ex_mem_reg_addr_in,
   input ex_mem_reg_wr_ena_in,
   input [DATA_WIDTH-1:0] wb_reg_data_in,
   input [REG_ADDR_WIDTH-1:0] wb_reg_addr_in,
   input wb_reg_wr_ena_in,
   input [INSTRUCTION_WIDTH-1:0] instruction_in,

   output mem_data_rd_en_out,
   output mem_data_wr_en_out,
   output [DATA_WIDTH-1:0] mem_data_out,
   output [DATA_WIDTH-1:0] alu_data_out,
   output reg_wr_en_out,
   output [REG_ADDR_WIDTH-1:0] reg_wr_addr_out,
   output write_back_mux_sel_out,
   output select_new_pc_out,
   output [PC_WIDTH-1:0] new_pc_out,
   output [INSTRUCTION_WIDTH-1:0] instruction_out,

   output [PC_WIDTH-1:0] fetch_new_pc_out,
   output fetch_select_new_pc_out
);

// -----------------------------------------------------------------------------
// Internal
// -----------------------------------------------------------------------------
// Local Parameters

// Wires

wire branch_result;
wire [DATA_WIDTH-1:0] alu_b_mux_sel;
wire [DATA_WIDTH-1:0] alu_data_in_a;
wire [DATA_WIDTH-1:0] alu_data_in_b;

wire [DATA_WIDTH-1:0] alu_data;

// -----------------------------------------------------------------------------
// Branch Control
// -----------------------------------------------------------------------------
branch_control
#(
   .DATA_WIDTH(DATA_WIDTH),
   .PC_WIDTH(PC_WIDTH),
   .PC_OFFSET_WIDTH(PC_OFFSET_WIDTH)
)
branch_control_u0
(
   .jmp_inst_in(jmp_inst_in),
   .jmp_use_r_in(jmp_use_r_in),
   .branch_inst_in(branch_inst_in),
   .branch_result_in(branch_result),
   .pc_in(new_pc_in),
   .reg_a_data_in(alu_data_in_a),
   .reg_b_data_in(alu_data_in_b),
   .pc_offset_in(pc_offset_in),

   .select_new_pc_out(fetch_select_new_pc_out),
   .pc_out(fetch_new_pc_out)
);

// -----------------------------------------------------------------------------
// Forwarding Units
// -----------------------------------------------------------------------------
forward_unit
#(
   .DATA_WIDTH(DATA_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH)
)
forward_unit
(
   .data_alu_a_in(data_alu_a_in),
   .data_alu_b_in(data_alu_b_in),
   .addr_alu_a_in(reg_a_addr_in),
   .addr_alu_b_in(reg_b_addr_in),
   .ex_mem_data_in(ex_mem_reg_data_in),
   .ex_mem_reg_addr_in(ex_mem_reg_addr_in),
   .ex_mem_reg_wr_ena_in(ex_mem_reg_wr_ena_in),
   .wb_reg_data_in(wb_reg_data_in),
   .wb_reg_addr_in(wb_reg_addr_in),
   .wb_reg_wr_ena_in(wb_reg_wr_ena_in),

   .alu_a_mux_sel_out(alu_data_in_a),
   .alu_b_mux_sel_out(alu_b_mux_sel)
);

// -----------------------------------------------------------------------------
// MUX select constant
// -----------------------------------------------------------------------------
mux_data
#(
   .DATA_WIDTH(DATA_WIDTH)
 )
mux_data_u0
(
   .data_a_in(alu_b_mux_sel),
   .data_b_in(constant_in),
   .mux_sel_in(imm_inst_in),
   .data_out(alu_data_in_b)
);

// -----------------------------------------------------------------------------
// ALU
// -----------------------------------------------------------------------------
alu
#(
   .DATA_WIDTH(DATA_WIDTH),
   .OPCODE_WIDTH(OPCODE_WIDTH)
)
alu_u0
(
  .alu_data_a_in(alu_data_in_a),
  .alu_data_b_in(alu_data_in_b),
  .alu_opcode_in(alu_opcode_in),
  .alu_function_in(alu_function_in),


  .alu_branch_result_out(branch_result),
  .alu_data_out(alu_data)
);


// -----------------------------------------------------------------------------
// EXE_MEM Pipeline registers
// -----------------------------------------------------------------------------
execute_pipe
#(
    .PC_WIDTH(PC_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
    .REG_ADDR_WIDTH(REG_ADDR_WIDTH)
)
execute_pipe_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .flush_in(flush_in),

   .mem_data_rd_en_in(mem_data_rd_en_in),
   .mem_data_wr_en_in(mem_data_wr_en_in),
   .mem_data_in(alu_b_mux_sel),
   .alu_data_in(alu_data),
   .reg_wr_en_in(reg_wr_en_in),
   .reg_wr_addr_in(reg_wr_addr_in),
   .write_back_mux_sel_in(write_back_mux_sel_in),
   .select_new_pc_in(fetch_select_new_pc_out),
   .new_pc_in(fetch_new_pc_out),
   .instruction_in(instruction_in),

   .mem_data_rd_en_out(mem_data_rd_en_out),
   .mem_data_wr_en_out(mem_data_wr_en_out),
   .mem_data_out(mem_data_out),
   .alu_data_out(alu_data_out),
   .reg_wr_en_out(reg_wr_en_out),
   .reg_wr_addr_out(reg_wr_addr_out),
   .write_back_mux_sel_out(write_back_mux_sel_out),
   .select_new_pc_out(select_new_pc_out),
   .new_pc_out(new_pc_out),
   .instruction_out(instruction_out)
);



endmodule
