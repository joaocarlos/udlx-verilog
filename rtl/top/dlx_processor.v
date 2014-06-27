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
// FILE NAME   : dlx_processor.v
// KEYWORDS    : dlx, pipeline, core, toplevel
// -----------------------------------------------------------------------------
// PURPOSE: Top level entity of uDLX core processor
// -----------------------------------------------------------------------------

module dlx_processor
#(
   parameter DATA_WIDTH = 32,
   parameter INST_ADDR_WIDTH = 20,
   parameter DATA_ADDR_WIDTH = 32
)
(
   input clk,
   input rst_n,
//   input enable, //removed the clock gate
   output instr_rd_en,
   output [INST_ADDR_WIDTH-1:0] instr_addr,
   input [DATA_WIDTH-1:0] instruction,
   output data_rd_en,
   output data_wr_en,
   output [DATA_ADDR_WIDTH-1:0] data_addr,
   input [DATA_WIDTH-1:0] data_read,
   output [DATA_WIDTH-1:0] data_write
);

localparam INSTRUCTION_WIDTH = DATA_WIDTH;
localparam PC_WIDTH = INST_ADDR_WIDTH;
localparam REG_ADDR_WIDTH = 5;
localparam OPCODE_WIDTH = 6;
localparam FUNCTION_WIDTH = 6;
localparam IMEDIATE_WIDTH = 16;
localparam PC_OFFSET_WIDTH = 26;


localparam PC_INITIAL_ADDRESS = 20'h40000;

// -----------------------------------------------------------------------------
// Internal signals
// -----------------------------------------------------------------------------
// Wires

// -----------------------------------------------------------------------------
// if_id Wires
// -----------------------------------------------------------------------------
wire [PC_WIDTH-1:0] if_id_new_pc;
wire [PC_WIDTH-1:0] new_pc;
wire [INSTRUCTION_WIDTH-1:0] if_id_instruction;
// wire [PC_WIDTH-1:0] instr_addr;

wire stall;
wire flush;

// -----------------------------------------------------------------------------
// id_exe Wires
// -----------------------------------------------------------------------------
wire [REG_ADDR_WIDTH-1:0] id_ex_reg_a_addr;
wire [REG_ADDR_WIDTH-1:0] id_ex_reg_b_addr;
wire [INSTRUCTION_WIDTH-1:0] id_ex_instruction;
wire [OPCODE_WIDTH-1:0] id_ex_opcode;
wire [FUNCTION_WIDTH-1:0] id_ex_function;
wire id_ex_mem_data_rd_en;
wire id_ex_mem_data_wr_en;
wire id_ex_write_back_mux_sel;
wire id_ex_reg_rd_en;
wire id_ex_reg_wr_en;
wire [REG_ADDR_WIDTH-1:0] id_ex_reg_wr_addr;
wire [DATA_WIDTH-1:0] id_ex_constant;
//wire id_ex_imm_inst;
wire [DATA_WIDTH-1:0] id_ex_data_alu_a;
wire [DATA_WIDTH-1:0] id_ex_data_alu_b;
wire [PC_WIDTH-1:0] id_ex_new_pc;
wire [PC_OFFSET_WIDTH-1:0] id_ex_pc_offset;
wire id_ex_branch_inst;
wire id_ex_jump_inst;
wire id_ex_jump_use_r;

// -----------------------------------------------------------------------------
// ex_mem Wires
// -----------------------------------------------------------------------------
wire ex_mem_data_rd_en;
wire ex_mem_data_wr_en;
wire [DATA_WIDTH-1:0] ex_mem_data_write;
wire [DATA_WIDTH-1:0] ex_mem_alu_data;
wire [DATA_WIDTH-1:0] ex_mem_reg_data;
wire ex_mem_reg_wr_en;
wire [REG_ADDR_WIDTH-1:0] ex_mem_reg_wr_addr;
wire ex_mem_write_back_mux_sel;
wire ex_mem_select_new_pc;
wire [PC_WIDTH-1:0] ex_mem_new_pc;
wire [INSTRUCTION_WIDTH-1:0] ex_mem_instruction;

wire fetch_select_new_pc;
wire [PC_WIDTH-1:0] fetch_new_pc;

// -----------------------------------------------------------------------------
// mem_wb wires
// -----------------------------------------------------------------------------
wire mem_wb_write_back_mux_sel;
wire [DATA_WIDTH-1:0] mem_wb_mem_data;
wire [DATA_WIDTH-1:0] mem_wb_alu_data;
wire mem_wb_reg_wr_en;
wire [REG_ADDR_WIDTH-1:0] mem_wb_reg_wr_addr;
wire [INSTRUCTION_WIDTH-1:0] mem_wb_instruction;

// -----------------------------------------------------------------------------
// wb wires
// -----------------------------------------------------------------------------
wire wb_write_enable;
wire [DATA_WIDTH-1:0] wb_write_data;
wire [REG_ADDR_WIDTH-1:0] wb_reg_wr_addr;



// -----------------------------------------------------------------------------
// Instruction Fetch modules
// -----------------------------------------------------------------------------
// Program Counter top level (including PC mux)
top_fetch
#(
   .PC_DATA_WIDTH(PC_WIDTH),
   .INSTRUCTION_WIDTH(DATA_WIDTH),
   .PC_INITIAL_ADDRESS(PC_INITIAL_ADDRESS)
)
instruction_fetch_u0
(
   .clk(clk),
   .rst_n(rst_n),

   .stall(stall),
   // .flush(flush),

   // .inst_mem_data_in(instruction),
   .select_new_pc_in(fetch_select_new_pc),
   .new_pc_in(fetch_new_pc),

   // .new_pc_out(if_id_new_pc),
   .pc_out(new_pc),
   // .instruction_reg_out(if_id_instruction),
   .inst_mem_addr_out(instr_addr)
);

// IF/ID Pipeline registers
if_id_reg
#(
   .INSTRUCTION_WIDTH(DATA_WIDTH),
   .PC_DATA_WIDTH(PC_WIDTH)
)
if_id_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .stall(stall),
   .flush(flush),
   .inst_mem_data_in(instruction),
   .pc_in(new_pc),

   .new_pc_out(if_id_new_pc),
   .instruction_reg_out(if_id_instruction)
);

// -----------------------------------------------------------------------------
// Instruction Decode modules
// -----------------------------------------------------------------------------
instruction_decode
#(
    .PC_WIDTH(PC_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
    .REG_ADDR_WIDTH(REG_ADDR_WIDTH),
    .OPCODE_WIDTH(OPCODE_WIDTH),
    .FUNCTION_WIDTH(FUNCTION_WIDTH),
    .IMEDIATE_WIDTH(IMEDIATE_WIDTH),
    .PC_OFFSET_WIDTH(PC_OFFSET_WIDTH)
)
instruction_decode_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .new_pc_in(if_id_new_pc),
   .instruction_in(if_id_instruction),

   .wb_write_enable(wb_write_enable),
   .wb_write_data(wb_write_data),
   .wb_reg_wr_addr(wb_reg_wr_addr),

   .select_new_pc_in(ex_mem_select_new_pc),

//   .alu_src_out(alu_src),
   .reg_rd_addr1_out(id_ex_reg_a_addr),
   .reg_rd_addr2_out(id_ex_reg_b_addr),
   .instruction_out(id_ex_instruction),
   .opcode_out(id_ex_opcode),
   .inst_function_out(id_ex_function),
   .mem_data_rd_en_out(id_ex_mem_data_rd_en),
   .mem_data_wr_en_out(id_ex_mem_data_wr_en),
   .write_back_mux_sel_out(id_ex_write_back_mux_sel),
//   .reg_rd_en_out(id_ex_reg_rd_en),
   .reg_wr_en_out(id_ex_reg_wr_en),
   .reg_wr_addr_out(id_ex_reg_wr_addr),
   .constant_out(id_ex_constant),
   .imm_inst_out(id_ex_imm_inst),
   .data_alu_a_out(id_ex_data_alu_a),
   .data_alu_b_out(id_ex_data_alu_b),
   .new_pc_out(id_ex_new_pc),
   .pc_offset_out(id_ex_pc_offset),
   .branch_inst_out(id_ex_branch_inst),
   .jump_inst_out(id_ex_jump_inst),
   .jump_use_r_out(id_ex_jump_use_r),

   .rd_inst_ena(instr_rd_en),
   .stall_out(stall),
   .general_flush(flush)
);

// -----------------------------------------------------------------------------
// Execute modules
// -----------------------------------------------------------------------------
execute_address_calculate
#(
   .DATA_WIDTH(DATA_WIDTH),
   .PC_WIDTH(PC_WIDTH),
   .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
   .OPCODE_WIDTH(OPCODE_WIDTH),
   .FUNCTION_WIDTH(FUNCTION_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH),
   .PC_OFFSET_WIDTH(PC_OFFSET_WIDTH)
)
execute_address_calculate_u0
(
   .clk(clk),
   .rst_n(rst_n),

   .flush(flush),

   .alu_opcode_in(id_ex_opcode),
   .alu_function_in(id_ex_function),
   .data_alu_a_in(id_ex_data_alu_a),
   .data_alu_b_in(id_ex_data_alu_b),
   .reg_a_addr_in(id_ex_reg_a_addr),
   .reg_b_addr_in(id_ex_reg_b_addr),
   .constant_in(id_ex_constant),
   .imm_inst_in(id_ex_imm_inst),
   .write_back_mux_sel_in(id_ex_write_back_mux_sel),
//   .reg_rd_en_in(id_ex_reg_rd_en),
   .reg_wr_en_in(id_ex_reg_wr_en),
   .reg_wr_addr_in(id_ex_reg_wr_addr),
   .new_pc_in(id_ex_new_pc),
   .mem_data_rd_en_in(id_ex_mem_data_rd_en),
   .mem_data_wr_en_in(id_ex_mem_data_wr_en),
   .pc_offset_in(id_ex_pc_offset),
   .branch_inst_in(id_ex_branch_inst),
   .jmp_inst_in(id_ex_jump_inst),
   .jmp_use_r_in(id_ex_jump_use_r),
   .instruction_in(id_ex_instruction),

   .ex_mem_reg_data(ex_mem_reg_data),//input
   .ex_mem_reg_addr(ex_mem_reg_wr_addr),//input
   .ex_mem_reg_wr_ena(ex_mem_reg_wr_en),//input
   .wb_reg_data(wb_write_data),
   .wb_reg_addr(wb_reg_wr_addr),
   .wb_reg_wr_ena(wb_write_enable),

   .mem_data_rd_en_out(ex_mem_data_rd_en), //data memory read enable
   .mem_data_wr_en_out(ex_mem_data_wr_en), //data memory write enable
   .mem_data_out(ex_mem_data_write),
   .alu_data_out(ex_mem_alu_data),
   .reg_wr_en_out(ex_mem_reg_wr_en),
   .reg_wr_addr_out(ex_mem_reg_wr_addr),
   .write_back_mux_sel_out(ex_mem_write_back_mux_sel),
   .select_new_pc_out(ex_mem_select_new_pc),
   .new_pc_out(ex_mem_new_pc),
   .instruction_out(ex_mem_instruction),

   .fetch_new_pc_out(fetch_new_pc),
   .fetch_select_new_pc_out(fetch_select_new_pc)
);

assign data_addr = ex_mem_alu_data;
assign data_rd_en = ex_mem_data_rd_en;
assign data_wr_en = ex_mem_data_wr_en;
assign data_write = ex_mem_data_write;

assign ex_mem_reg_data = ex_mem_alu_data;

// -----------------------------------------------------------------------------
// Memory Access modules
// -----------------------------------------------------------------------------
memory_access
#(
   .DATA_WIDTH(DATA_WIDTH),
   .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH)
 )
memory_access_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .write_back_mux_sel_in(ex_mem_write_back_mux_sel),
   .alu_data_in(ex_mem_alu_data),
   .reg_wr_en_in(ex_mem_reg_wr_en),
   .reg_wr_addr_in(ex_mem_reg_wr_addr),
   .instruction_in(ex_mem_instruction),

   .write_back_mux_sel_out(mem_wb_write_back_mux_sel),
   .alu_data_out(mem_wb_alu_data),
   .reg_wr_en_out(mem_wb_reg_wr_en),
   .reg_wr_addr_out(mem_wb_reg_wr_addr),
   .instruction_out(mem_wb_instruction)
);



// -----------------------------------------------------------------------------
// Write-back multiplexer
// -----------------------------------------------------------------------------
write_back
#(
   .DATA_WIDTH(DATA_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH)
 )
write_back_u0
(
   .mem_data_in(data_read),
   .alu_data_in(mem_wb_alu_data),
   .reg_wr_en_in(mem_wb_reg_wr_en),
   .reg_wr_addr_in(mem_wb_reg_wr_addr),
   .write_back_mux_sel(mem_wb_write_back_mux_sel),
   .reg_wr_addr_out(wb_reg_wr_addr),
   .reg_wr_data_out(wb_write_data),
   .reg_wr_en_out(wb_write_enable)
);


endmodule
