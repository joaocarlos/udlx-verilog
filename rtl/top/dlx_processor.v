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
   DATA_WIDTH = 32,
   ADDR_WIDTH = 32
)
(/*autoport*/
   input clk,
   input rst_n,
   input enable,
   output instr_rd_en,
   output [ADDR_WIDTH-1:0] instr_addr,
   input [DATA_WIDTH-1:0] instruction,
   output data_rd_en,
   output data_wr_en,
   output [ADDR_WIDTH-1:0] data_addr,
   input [DATA_WIDTH-1:0] data_read,
   input [DATA_WIDTH-1:0] data_write
);


//  Description   : 
//
//
//==================================================================================================
module instruction_decoder
        #(
            INSTRUCTION_WIDTH = 32,
            REG_ADDR_WIDTH = 5,
            IMEDIATE_WIDTH = 16,
            DECODED_INST_WIDTH = 4
        )
        (/*autoport*/
            input [INSTRUCTION_WIDTH-1:0] instruction_in,
            output [REG_ADDR_WIDTH-1:0] read_address1_out,
            output [REG_ADDR_WIDTH-1:0] read_address2_out,
            output [REG_ADDR_WIDTH-1:0] write_address_out,
            output [IMEDIATE_WIDTH-1:0] immediate_out,
            output [DECODED_INST_WIDTH-1:0] decoded_inst_out   
        );
//*******************************************************
//Internal
//*******************************************************
//Local Parameters
`include "general_parameters.v"

//Wires

//Registers

//*******************************************************
//General Purpose Signals
//*******************************************************

//*******************************************************
//Outputs
//*******************************************************
//ranges dependem das instruções a serem definidas

always @(*) begin




// INSTRUCTION FETCH
//
instruction_fetch
#(
   .ADDR_WIDTH(ADDR_WIDTH), 
   .DATA_WIDTH(DATA_WIDTH)
)
instruction_fetch_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .inst_mem_data_in(inst_mem_data_in),
   .select_new_pc_in(select_new_pc_in),
   .new_pc_in(new_pc_in),
   .new_pc_out(new_pc_out),
   .instruction_reg_out(instruction_reg_out),
   .inst_mem_addr_out(inst_mem_addr_out)
);

top_fetch
#(
   .PC_DATA_WIDTH(PC_DATA_WIDTH),
   .INST_DATA_WIDTH(INST_DATA_WIDTH),
   .INST_ADDR_WIDTH(INST_ADDR_WIDTH),
   .PC_INITIAL_ADDRESS(PC_INITIAL_ADDRESS),
)
instruction_fetch_u0
(
   .clk_in(clk_in),
   .clk_en_in(clk_en_in),
   .rst_n_in(rst_n_in),
   .inst_mem_data_in(inst_mem_data_in),
   .select_new_pc_in(select_new_pc_in),
   .new_pc_in(new_pc_in),
   
   .new_pc_out(new_pc_out),
   .instruction__out(instruction__out),
   .inst_mem_addr_out(inst_mem_addr_out)
);

// INSTRUCTION DECODE
//
instruction_decode
#(
   .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH),
   .IMEDIATE_WIDTH(IMEDIATE_WIDTH),
   .DECODED_INST_WIDTH(DECODED_INST_WIDTH)
)
instruction_decode_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .instruction_reg_in(instruction_reg_in),
   .new_pc_in(new_pc_in),
   .wb_write_enable(wb_write_enable),
   .wb_write_data(wb_write_data),
   .alu_src_out(alu_src_out),
   .read_address1_out(read_address1_out),
   .read_address2_out(read_address2_out),
   .instruction_out(instruction_out),
   .opcode_out(opcode_out),
   .inst_function_out(inst_function_out),
   .mem_data_wr_en_out(mem_data_wr_en_out),
   .write_back_mux_sel_out(write_back_mux_sel_out),
   .w_reg_wr_en_out(w_reg_wr_en_out),
   .w_reg_addr_out(w_reg_addr_out),
   .constant_out(constant_out),
   .data_alu_a_out(data_alu_a_out),
   .data_alu_b_out(data_alu_b_out),
   .new_pc_out(new_pc_out),
   .pc_offset_out(pc_offset_out),
   .branch_inst_out(branch_inst_out),
   .jump_inst_out(jump_inst_out)
);

// EXECUTE
//
execute_address_calculate
#(
   .TBD_WIDTH(TBD_WIDTH),
   .DATA_WIDTH(DATA_WIDTH),
   .ALU_OPCODE(ALU_OPCODE),
   .W_REG_ADDR_WIDTH(W_REG_ADDR_WIDTH)
)
execute_address_calculate_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .alu_src_in(alu_src_in),
   .alu_opcode_in(alu_opcode_in),
   .data_alu_a_in(data_alu_a_in),
   .data_alu_b_in(data_alu_b_in),
   .constant_in(constant_in),
   .write_back_mux_sel_in(write_back_mux_sel_in),
   .w_reg_wr_en_in(w_reg_wr_en_in),
   .new_pc_in(new_pc_in),
   .mem_data_wr_en_in(mem_data_wr_en_in),
   .w_reg_addr_in(w_reg_addr_in),
   .brach_inst_in(brach_inst_in),
   .jmp_inst_in(jmp_inst_in),
   .exe_mem_data_in(exe_mem_data_in),
   .mem_wb_data_in(mem_wb_data_in),
   .mem_data_wr_en_out(mem_data_wr_en_out),
   .alu_b_data_in_out(alu_b_data_in_out),
   .alu_data_out(alu_data_out),
   .write_back_mux_sel_out(write_back_mux_sel_out),
   .w_reg_wr_en_out(w_reg_wr_en_out),
   .w_reg_addr_out(w_reg_addr_out),
   .branch_inst_out(branch_inst_out),
   .alu_zero_out(alu_zero_out),
   .jmp_inst_out(jmp_inst_out)
);

// MEMORY ACCESS
//



// WRITE BACK
//
write_back
#(
   .DATA_WIDTH(DATA_WIDTH),
   .REG_ADDR_WIDTH(REG_ADDR_WIDTH),
   
(
write_back_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .mem_data_in(mem_data_in),
   .alu_data_in(alu_data_in),
   .w_reg_en_in(w_reg_en_in),
   .w_reg_addr_in(w_reg_addr_in),
   .write_back_mux_sel(write_back_mux_sel),
   .w_reg_addr_out(w_reg_addr_out),
   .reg_data_out(reg_data_out),
   .w_reg_en_out(w_reg_en_out)
);


endmodule
