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
// FILE NAME        : alu.v
// AUTHOR(s)        : jaocarlos
// MANTAINER        : joaocarlos
// AUTHOR'S E-MAIL  : joaocarlos@ieee.org
// -----------------------------------------------------------------------------
// KEYWORDS: arithmetic, logic, alu, dlx
// -----------------------------------------------------------------------------
// PURPOSE:
// -----------------------------------------------------------------------------
module alu
#(
   parameter DATA_WIDTH = 32,
   parameter OPCODE_WIDTH = 6,
   parameter FUNCTION_WIDTH = 6
)
(
   input [DATA_WIDTH-1:0] alu_data_in_a,   // Input data from register file port A
   input [DATA_WIDTH-1:0] alu_data_in_b,   // Input data from register file port A
   input [OPCODE_WIDTH-1:0] alu_opcode,   // Instruction opcode
   input [FUNCTION_WIDTH-1:0] alu_function,   // Instruction function

   output reg alu_branch_result,
   output [DATA_WIDTH-1:0] alu_data_out    // ALU output result data

);

   reg [DATA_WIDTH:0] alu_result_reg;

`include "opcodes.v"

wire [DATA_WIDTH-1:0] sum_result;
wire [DATA_WIDTH-1:0] sub_result;
wire [DATA_WIDTH-1:0] and_result;
wire [DATA_WIDTH-1:0] or_result;

assign sum_result = alu_data_in_a + alu_data_in_b;
assign sub_result = alu_data_in_a - alu_data_in_b;
assign and_result = alu_data_in_a && alu_data_in_b;
assign or_result = alu_data_in_a || alu_data_in_b;

assign zero_cmp = alu_data_in_a == 0;

assign alu_data_out = alu_result_reg;


always@(*)
begin
   alu_result_reg = {DATA_WIDTH{1'b0}};
   if(alu_opcode==R_TYPE_OPCODE)begin
      case (alu_function)
         ADD_FUNCTION :
            alu_result_reg = sum_result;
         SUB_FUNCTION :
            alu_result_reg = sub_result;
         AND_FUNCTION :
            alu_result_reg = and_result;
         OR_FUNCTION :
            alu_result_reg = or_result;
         MULT_FUNCTION :
            alu_result_reg = alu_data_in_a * alu_data_in_b;
         DIV_FUNCTION :
            alu_result_reg = alu_data_in_a / alu_data_in_b;
         CMP_FUNCTION :
            alu_result_reg = alu_data_in_a - alu_data_in_b;
         NOT_FUNCTION :
            alu_result_reg = ~alu_data_in_b;
         default :
            alu_result_reg = {DATA_WIDTH{1'b0}};
      endcase
   end
   else begin
      case (alu_opcode)
         ADDI_OPCODE,LW_OPCODE,SW_OPCODE:
            alu_result_reg = sum_result;
         SUBI_OPCODE :
            alu_result_reg = sub_result;
         ANDI_OPCODE :
            alu_result_reg = and_result;
         ORI_OPCODE :
            alu_result_reg = or_result;
         default :
            alu_result_reg = {DATA_WIDTH{1'b0}};
      endcase
   end
 end


always@(*) begin
  case (alu_opcode)
     BEQZ_OPCODE :
        alu_branch_result = zero_cmp;
     BNEZ_OPCODE :
        alu_branch_result = ~zero_cmp;
     default :
        alu_branch_result = {DATA_WIDTH{1'b0}};
  endcase
end


endmodule
