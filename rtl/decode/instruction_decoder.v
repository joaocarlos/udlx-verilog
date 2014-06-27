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
// FILE NAME    : instruction_decoder.v
// -----------------------------------------------------------------------------
// KEYWORDS     : dlx, decoder, instruction
// -----------------------------------------------------------------------------
// PURPOSE      : uDLX instruction decoder unit.
// -----------------------------------------------------------------------------
module instruction_decoder
#(
   parameter INSTRUCTION_WIDTH = 32,
   parameter OPCODE_WIDTH = 6,
   parameter FUNCTION_WIDTH = 5,
   parameter REG_ADDR_WIDTH = 5,
   parameter IMEDIATE_WIDTH = 16,
   parameter PC_OFFSET_WIDTH = 26
)
( /*autoport*/
   input [INSTRUCTION_WIDTH-1:0] instruction_in,
   output [OPCODE_WIDTH-1:0] opcode,
   output reg [FUNCTION_WIDTH-1:0] inst_function,
   output reg [REG_ADDR_WIDTH-1:0] reg_rd_addr1_out,
   output reg [REG_ADDR_WIDTH-1:0] reg_rd_addr2_out,
   output reg reg_rd_en1_out,
   output reg reg_rd_en2_out,
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
// -----------------------------------------------------------------------------
// Internal
// -----------------------------------------------------------------------------
// Local Parameters

`include "opcodes.v"

   // Gather intruction OpCode
   assign opcode = instruction_in[31:26];

   always @(*) begin
      if(instruction_in=={INSTRUCTION_WIDTH{1'b0}})begin // NOP Instruction condigion
         inst_function = 0;
         reg_rd_addr1_out = 0;
         reg_rd_addr2_out = 0;
         reg_rd_en1_out = 0;
         reg_rd_en2_out = 0;
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
            //  -------- ----- ----- ---- ----- ------
            // | Opcode | RS1 | RS2 | RD | N/A | Func |
            //  -------- ----- ----- ---- ----- ------
            //      6      5     5     5    5      6
            R_TYPE_OPCODE: begin
               inst_function = instruction_in[5:0];
               reg_rd_addr1_out = instruction_in[25:21];
               reg_rd_addr2_out = instruction_in[20:16];
               reg_rd_en1_out = 1;
               reg_rd_en2_out = 1;
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
            //  -------- ----- ---- -----------
            // | Opcode | RS1 | RD | Immediate |
            //  -------- ----- ---- -----------
            //      6      5     5       16
            ADDI_OPCODE,SUBI_OPCODE,ANDI_OPCODE,ORI_OPCODE: begin
               reg_rd_addr1_out = instruction_in[25:21];
               reg_rd_addr2_out = 0;
               reg_rd_en1_out = 1;
               reg_rd_en2_out = 0;
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
            //  -------- ----- ---- -----------
            // | Opcode | RS1 | RD | Immediate |
            //  -------- ----- ---- -----------
            //      6      5     5       16
            LW_OPCODE: begin
               reg_rd_addr1_out = instruction_in[25:21];
               reg_rd_addr2_out = 0;
               reg_rd_en1_out = 1;
               reg_rd_en2_out = 0;
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
            // end
            end
            //  -------- ----- ----- -----------
            // | Opcode | RS1 | RS2 | Immediate |
            //  -------- ----- ----- -----------
            //      6      5     5       16
            SW_OPCODE: begin
               reg_rd_addr1_out = instruction_in[25:21];
               reg_rd_addr2_out = instruction_in[20:16];
               reg_rd_en1_out = 1;
               reg_rd_en2_out = 1;
               reg_wr_addr_out = 0;
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
            //  -------- ----- ---- -----------
            // | Opcode | RS1 | RD | Immediate |
            //  -------- ----- ---- -----------
            //      6      5     5       16
            BEQZ_OPCODE,BNEZ_OPCODE,BRFL_OPCODE: begin
               reg_rd_addr1_out = instruction_in[25:21];
               reg_rd_addr2_out = 0;
               reg_rd_en1_out = 1;
               reg_rd_en2_out = 0;
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
            //  -------- ----- ----- -----------
            // | Opcode | RS1 | N/A | Immediate |
            //  -------- ----- ----- -----------
            //      6      5     5       16
            JR_OPCODE: begin
               reg_rd_addr1_out = instruction_in[25:21];
               reg_rd_addr2_out = 0;
               reg_rd_en1_out = 1;
               reg_rd_en2_out = 0;
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
            //  -------- ----- -----
            // | Opcode | PC Offset |
            //  -------- -----------
            //      6        26
            JPC_OPCODE: begin // TODO ver instrucoes call e eret
               reg_rd_addr1_out = 0;
               reg_rd_addr2_out = 0;
               reg_rd_en1_out = 0;
               reg_rd_en2_out = 0;
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
               reg_rd_addr1_out = 0;
               reg_rd_addr2_out = 0;
               reg_rd_en1_out = 0;
               reg_rd_en2_out = 0;
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
