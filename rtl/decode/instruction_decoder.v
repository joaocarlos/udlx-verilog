//==================================================================================================
//  Filename      : instruction_decoder.v
//  Created On    : 2014-06-06 21:35:39
//  Last Modified : 2014-06-06 22:35:43
//  Revision      : 
//  Author        : Linton Thiago Costa Esteves
//  Company       : Universidade Federal da Bahia - UFBA
//  Email         : lintonthiago@gmail.com
//
//  Description   : 
//
//
//==================================================================================================
module instruction_decoder
        #(
            parameter INSTRUCTION_WIDTH = 32,
            parameter OPCODE_WIDTH = 6,
            parameter FUNCTION_WIDTH = 5,
            parameter REG_ADDR_WIDTH = 5,
            parameter IMEDIATE_WIDTH = 16,
            parameter PC_OFFSET_WIDTH = 26
        )
        (/*autoport*/
            input [INSTRUCTION_WIDTH-1:0] instruction_in,
            output [OPCODE_WIDTH-1:0] opcode,
            output reg [FUNCTION_WIDTH-1:0] inst_function,
            output reg [REG_ADDR_WIDTH-1:0] read_address1_out,
            output reg [REG_ADDR_WIDTH-1:0] read_address2_out,
            output reg [REG_ADDR_WIDTH-1:0] reg_wr_addr_out,
            output reg reg_wr_en_out,
            output reg [IMEDIATE_WIDTH-1:0] immediate_out,
            output reg imm_inst_out,
            output reg [PC_OFFSET_WIDTH-1:0] pc_offset,
            output reg mem_data_rd_en_out,
            output reg mem_data_wr_en_out,
            output reg write_back_mux_sel_out,
            output reg branch_inst_out,
            output reg jump_inst_out,
            output reg jump_use_r_out
        );
//*******************************************************
//Internal
//*******************************************************
//Local Parameters
`include "opcodes.v"


assign opcode = instruction_in[31:26];

always @(*) begin
   if(instruction_in=={INSTRUCTION_WIDTH{1'b0}})begin //NOP INSTRUCTION
      inst_function = 0;
      read_address1_out = 0;
      read_address2_out = 0;
      reg_wr_addr_out = 0;
      reg_wr_en_out = 1'b0;
      immediate_out = 0;
      imm_inst_out = 1'b0;
      pc_offset = 0;
      mem_data_rd_en_out = 1'b0;
      mem_data_wr_en_out = 1'b0;
      write_back_mux_sel_out = 1'b0;
      branch_inst_out = 1'b0;
      jump_inst_out = 1'b0;
      jump_use_r_out = 1'b0;
   end
   else begin
      case (opcode)
         R_TYPE_OPCODE: begin
            inst_function = instruction_in[5:0];
            read_address1_out = instruction_in[25:21];
            read_address2_out = instruction_in[20:16];
            reg_wr_addr_out = instruction_in[15:11];
            reg_wr_en_out = 1'b1;
            immediate_out = 0;
            imm_inst_out = 1'b0;
            pc_offset = 0;
            mem_data_rd_en_out = 1'b0;
            mem_data_wr_en_out = 1'b0;
            write_back_mux_sel_out = 1'b0;
            branch_inst_out = 1'b0;
            jump_inst_out = 1'b0;
            jump_use_r_out = 1'b0;
            end
         ADDI_OPCODE,SUBI_OPCODE,ANDI_OPCODE,ORI_OPCODE: begin
            read_address1_out = instruction_in[25:21];
            read_address2_out = 0;
            reg_wr_addr_out = instruction_in[20:16];
            reg_wr_en_out = 1'b1;
            immediate_out = instruction_in[15:0];
            imm_inst_out = 1'b1;
            pc_offset = 0;
            mem_data_rd_en_out = 1'b0;
            mem_data_wr_en_out = 1'b0;
            write_back_mux_sel_out = 1'b0;
            branch_inst_out = 1'b0;
            jump_inst_out = 1'b0;
            jump_use_r_out = 1'b0;
         end
         LW_OPCODE: begin
            read_address1_out = instruction_in[25:21];
            read_address2_out = 0;
            reg_wr_addr_out = instruction_in[20:16];
            reg_wr_en_out = 1'b1;
            immediate_out = instruction_in[15:0];
            imm_inst_out = 1'b1;
            pc_offset = 0;
            mem_data_rd_en_out = 1'b1;
            mem_data_wr_en_out = 1'b0;
            write_back_mux_sel_out = 1'b1;
            branch_inst_out = 1'b0;
            jump_inst_out = 1'b0;
            jump_use_r_out = 1'b0;
         end
         SW_OPCODE: begin
            read_address1_out = instruction_in[25:21];
            read_address2_out = 0;
            reg_wr_addr_out = instruction_in[20:16];
            reg_wr_en_out = 1'b0;
            immediate_out = instruction_in[15:0];
            imm_inst_out = 1'b1;
            pc_offset = 0;
            mem_data_rd_en_out = 1'b0;
            mem_data_wr_en_out = 1'b1;
            write_back_mux_sel_out = 1'b0;
            branch_inst_out = 1'b0;
            jump_inst_out = 1'b0;
            jump_use_r_out = 1'b0;
         end
         BEQZ_OPCODE,BNEZ_OPCODE,BRFL_OPCODE: begin
            read_address1_out = instruction_in[25:21];
            read_address2_out = 0;
            reg_wr_addr_out = instruction_in[20:16];
            reg_wr_en_out = 1'b0;
            immediate_out = instruction_in[15:0];
            imm_inst_out = 1'b1;
            pc_offset = 0;
            mem_data_rd_en_out = 1'b0;
            mem_data_wr_en_out = 1'b0;
            write_back_mux_sel_out = 1'b0;
            branch_inst_out = 1'b1;
            jump_inst_out = 1'b0;
            jump_use_r_out = 1'b0;
         end
         JR_OPCODE: begin
            read_address1_out = instruction_in[25:21];
            read_address2_out = 0;
            reg_wr_addr_out = instruction_in[20:16];//not used
            reg_wr_en_out = 1'b0;
            immediate_out = instruction_in[15:0];//not used
            imm_inst_out = 1'b0;
            pc_offset = 0;
            mem_data_rd_en_out = 1'b0;
            mem_data_wr_en_out = 1'b0;
            write_back_mux_sel_out = 1'b0;
            branch_inst_out = 1'b0;
            jump_inst_out = 1'b1;
            jump_use_r_out = 1'b1;
         end
         JPC_OPCODE: begin //TODO ver instrucoes call e eret
            read_address1_out = 0;
            read_address2_out = 0;
            reg_wr_addr_out = 0;
            reg_wr_en_out = 1'b0;
            immediate_out = 0;
            imm_inst_out = 1'b0;
            pc_offset = instruction_in[25:0];
            mem_data_rd_en_out = 1'b0;
            mem_data_wr_en_out = 1'b0;
            write_back_mux_sel_out = 1'b0;
            branch_inst_out = 1'b0;
            jump_inst_out = 1'b1;
            jump_use_r_out = 1'b0;
         end
         default : begin
            inst_function = 0;
            read_address1_out = 0;
            read_address2_out = 0;
            reg_wr_addr_out = 0;
            reg_wr_en_out = 1'b0;
            immediate_out = 0;
            imm_inst_out = 1'b0;
            pc_offset = 0;
            mem_data_rd_en_out = 1'b0;
            mem_data_wr_en_out = 1'b0;
            write_back_mux_sel_out = 1'b0;
            branch_inst_out = 1'b0;
            jump_inst_out = 1'b0;
            jump_use_r_out = 1'b0;
         end
      endcase
   end
end


endmodule
