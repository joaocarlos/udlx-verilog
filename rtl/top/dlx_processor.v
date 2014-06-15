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
wire [REG_ADDR_WIDTH-1:0] id_exe_reg_a_addr_in;
wire [REG_ADDR_WIDTH-1:0] id_exe_reg_b_addr_in;
wire [INSTRUCTION_WIDTH-1:0] id_exe_instruction_out;
wire [OPCODE_WIDTH-1:0] id_exe_opcode_out;
wire [FUNCTION_WIDTH-1:0] id_exe_inst_function_out;
wire id_exe_mem_data_wr_en_out;
wire id_exe_write_back_mux_sel;
wire id_exe_reg_rd_en_out;
wire id_exe_reg_wr_en_out;
wire [DATA_ADDR_WIDTH-1:0] id_exe_reg_wr_addr_out;
wire id_exe_constant_out;
//wire id_exe_imm_inst_out;
wire [DATA_WIDTH-1:0] id_exe_data_alu_a_out;
wire [DATA_WIDTH-1:0] id_exe_data_alu_b_out;
wire [PC_WIDTH-1:0] id_exe_new_pc_out;
wire [PC_OFFSET_WIDTH-1:0] id_exe_pc_offset_out;
wire id_exe_branch_inst_out;
wire id_exe_jump_inst_out;



//exe_mem wires
wire exe_mem_data_rd_en;
wire exe_mem_data_wr_en;
wire [DATA_WIDTH-1:0] exe_mem_data_write;
wire [DATA_WIDTH-1:0] exe_mem_alu_data;
wire exe_mem_reg_wr_en;
wire [REG_ADDR_WIDTH-1:0] exe_mem_reg_wr_addr;
wire exe_mem_write_back_mux_sel;
wire exe_mem_select_new_pc;
wire [PC_WIDTH-1:0] exe_mem_new_pc;


//mem_wb wires
wire mem_wb_write_back_mux_sel_out;
wire [DATA_WIDTH-1:0] mem_wb_alu_data_out;
wire mem_wb_reg_wr_en;
wire [REG_ADDR_WIDTH-1:0] mem_wb_reg_wr_addr;


//wb wires
wire wb_write_enable;
wire [DATA_WIDTH-1:0] wb_write_data;



// INSTRUCTION FETCH
top_fetch
#(
   .PC_DATA_WIDTH(PC_WIDTH),
   .INST_DATA_WIDTH(DATA_WIDTH),
   .PC_INITIAL_ADDRESS(PC_INITIAL_ADDRESS)
)
instruction_fetch_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .inst_mem_data_in(instruction),
   .select_new_pc_in(select_new_pc_in),
   .new_pc_in(new_pc_in),
   
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
   .new_pc_in(if_id_new_pc_),
   .instruction_reg_in(if_id_instruction),

   .wb_write_enable(wb_write_enable),
   .wb_write_data(wb_write_data),

//   .alu_src_out(alu_src_out),
   .read_address1_out(id_exe_reg_a_addr_in),
   .read_address2_out(id_exe_reg_b_addr_in),
   .instruction_out(id_exe_instruction_out),
   .opcode_out(id_exe_opcode_out),
   .inst_function_out(id_exe_inst_function_out),
   .mem_data_wr_en_out(id_exe_mem_data_wr_en_out),
   .write_back_mux_sel_out(id_exe_write_back_mux_sel),
//   .reg_rd_en_out(id_exe_reg_rd_en_out),
   .reg_wr_en_out(id_exe_reg_wr_en_out),
   .reg_wr_addr_out(id_exe_reg_wr_addr_out),
   .constant_out(id_exe_constant_out),
   .imm_inst_out(id_exe_imm_inst_out),
   .data_alu_a_out(id_exe_data_alu_a_out),
   .data_alu_b_out(id_exe_data_alu_b_out),
   .new_pc_out(id_exe_new_pc_out),
   .pc_offset_out(id_exe_pc_offset_out),
   .branch_inst_out(id_exe_branch_inst_out),
   .jump_inst_out(id_exe_jump_inst_out)
);

// EXECUTE

execute_address_calculate
#(
   .DATA_WIDTH(DATA_WIDTH),
   .PC_WIDTH(PC_WIDTH),
   .OPCODE_WIDTH(OPCODE_WIDTH),
   .FUNCTION_WIDTH(FUNCTION_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH)
)
execute_address_calculate_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .alu_opcode_in(id_exe_alu_opcode),
   .alu_function_in(id_exe_alu_function),
   .data_alu_a_in(id_exe_data_alu_a),
   .data_alu_b_in(id_exe_data_alu_b),
   .reg_a_addr_in(id_exe_reg_a_addr),
   .reg_b_addr_in(id_exe_reg_b_addr),
   .constant_in(id_exe_constant),
   .imm_inst_in(id_exe_imm_inst),
   .write_back_mux_sel_in(id_exe_write_back_mux_sel),
//   .reg_rd_en_in(id_exe_reg_rd_en),
   .reg_wr_en_in(id_exe_reg_wr_en),
   .reg_wr_addr_in(id_exe_reg_wr_addr),
   .new_pc_in(id_exe_new_pc),
   .mem_data_rd_en_in(id_exe_mem_data_rd_en),
   .mem_data_wr_en_in(id_exe_mem_data_wr_en),
   .branch_inst_in(id_exe_branch_inst),
   .jmp_inst_in(id_exe_jmp_inst),
   .jmp_use_r_in(id_exe_jmp_use_r),

   .mem_data_rd_en_out(exe_mem_data_rd_en), //data memory read enable
   .mem_data_wr_en_out(exe_mem_data_wr_en), //data memory write enable
   .mem_data_out(exe_mem_data_write),
   .alu_data_out(exe_mem_alu_data),
   .reg_wr_en_out(exe_mem_reg_wr_en),
   .reg_wr_addr_out(exe_mem_reg_wr_addr),
   .write_back_mux_sel_out(exe_mem_write_back_mux_sel),
   .select_new_pc_out(exe_mem_select_new_pc),
   .new_pc_out(exe_mem_new_pc)
);

assign data_addr = exe_mem_alu_data;
assign data_rd_en = exe_mem_data_rd_en; 
assign data_wr_en = exe_mem_data_wr_en;
assign data_write = exe_mem_data_write;


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
   .write_back_mux_sel_in(ex_mem_write_back_mux_sel_in),
   .alu_data_in(ex_mem_alu_data),
   .reg_wr_en_in(ex_mem_reg_wr_en_in),
   .reg_wr_addr_in(exe_mem_wr_reg_addr),

   .write_back_mux_sel_out(mem_wb_write_back_mux_sel_out),
   .alu_data_out(mem_wb_alu_data_out),
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
   .mem_data_in(mem_wb_mem_data_in),
   .alu_data_in(mem_wb_alu_data_in),
   .reg_wr_en_in(mem_wb_reg_en_in),
   .reg_wr_addr_in(mem_wb_reg_addr_in),
   .write_back_mux_sel(write_back_mux_sel),
   .reg_wr_addr_out(reg_wr_addr_out),
   .reg_wr_data_out(wb_write_data),
   .reg_wr_en_out(wb_write_enable)
);


endmodule
