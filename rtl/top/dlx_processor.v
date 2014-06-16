//==================================================================================================
//  Filename      : dlx_processor.v
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

//  Description   : 
//
//
//==================================================================================================

//*******************************************************
//Internal
//*******************************************************
//Local Parameters
//`include "general_parameters.v"

//Wires

//if_id wires
wire [PC_WIDTH-1:0] if_id_new_pc;
wire [INSTRUCTION_WIDTH-1:0] if_id_instruction;
//wire [PC_WIDTH-1:0] instr_addr;


//id_exe wires
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



//ex_mem wires
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


//mem_wb wires
wire mem_wb_write_back_mux_sel;
wire [DATA_WIDTH-1:0] mem_wb_mem_data;
wire [DATA_WIDTH-1:0] mem_wb_alu_data;
wire mem_wb_reg_wr_en;
wire [REG_ADDR_WIDTH-1:0] mem_wb_reg_wr_addr;


//wb wires
wire wb_write_enable;
wire [DATA_WIDTH-1:0] wb_write_data;
wire [REG_ADDR_WIDTH-1:0] wb_reg_wr_addr;



// INSTRUCTION FETCH
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
   .inst_mem_data_in(instruction),
   .select_new_pc_in(ex_mem_select_new_pc),
   .new_pc_in(ex_mem_new_pc),
   
   .new_pc_out(if_id_new_pc),
   .instruction_reg_out(if_id_instruction),
   .inst_mem_addr_out(instr_addr)
);

//TODO
assign instr_rd_en = 1;


// INSTRUCTION DECODE
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
//   .alu_src_out(alu_src),
   .read_address1_out(id_ex_reg_a_addr),
   .read_address2_out(id_ex_reg_b_addr),
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
   .jump_use_r_out(id_ex_jump_use_r)
);

// EXECUTE

execute_address_calculate
#(
   .DATA_WIDTH(DATA_WIDTH),
   .PC_WIDTH(PC_WIDTH),
   .OPCODE_WIDTH(OPCODE_WIDTH),
   .FUNCTION_WIDTH(FUNCTION_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH),
    .PC_OFFSET_WIDTH(PC_OFFSET_WIDTH)
)
execute_address_calculate_u0
(
   .clk(clk),
   .rst_n(rst_n),
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
   .new_pc_out(ex_mem_new_pc)
);

assign data_addr = ex_mem_alu_data;
assign data_rd_en = ex_mem_data_rd_en; 
assign data_wr_en = ex_mem_data_wr_en;
assign data_write = ex_mem_data_write;

assign ex_mem_reg_data = ex_mem_alu_data;

// MEMORY ACCESS
//
memory_access
#(
   .DATA_WIDTH(DATA_WIDTH),
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

   .write_back_mux_sel_out(mem_wb_write_back_mux_sel),
   .alu_data_out(mem_wb_alu_data),
   .reg_wr_en_out(mem_wb_reg_wr_en),
   .reg_wr_addr_out(mem_wb_reg_wr_addr)
);



// WRITE BACK
//
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
