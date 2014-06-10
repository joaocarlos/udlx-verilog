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
   parameter DATA_WITH = 32,
   parameter OPCODE_WIDTH = 3
)
(
   input [DATA_WITH-1:0] alu_data_in_a,   // Input data from register file port A
   input [DATA_WITH-1:0] alu_data_in_b,   // Input data from register file port A
   input [OPCODE_WIDTH-1:0] alu_opcode,   // Instruction opcode

   output [DATA_WITH-1:0] alu_data_out    // ALU output result data

   );

   reg [DATA_WITH:0] alu_result_reg;

   always@(*)
   begin
      alu_result_reg = {DATA_WITH{1'b0}};
      case (alu_opcode)
         `ADD :
            alu_result_reg = alu_data_in_a + alu_data_in_b;
         `SUB :
            alu_result_reg = alu_data_in_a - alu_data_in_b;
         `AND :
            alu_result_reg = alu_data_in_a && alu_data_in_b;
         `OR :
            alu_result_reg = alu_data_in_a || alu_data_in_b;
         `MULT :
            alu_result_reg = alu_data_in_a * alu_data_in_b;
         `DIV :
            alu_result_reg = alu_data_in_a / alu_data_in_b;
         `CMP :
            alu_result_reg = alu_data_in_a - alu_data_in_b;
         `NOT :
            alu_result_reg = ~alu_data_in_b;
         default :
            alu_result_reg = {DATA_WITH{1'b0}};

      endcase
   end
endmodule