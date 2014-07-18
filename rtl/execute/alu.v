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
// FILE NAME   : alu.v
// KEYWORDS    : arithmetic, logic, alu, dlx
// -----------------------------------------------------------------------------
// PURPOSE     : Provide logical and arithmetical opperations.
// -----------------------------------------------------------------------------
module alu
#(
   parameter DATA_WIDTH = 32,
   parameter OPCODE_WIDTH = 6,
   parameter FUNCTION_WIDTH = 6,
   parameter FLAGS_WIDTH = 4
)
(
   input clk,
   input rst,
   input [DATA_WIDTH-1:0] alu_data_a_in,        // Input data from register file port A
   input [DATA_WIDTH-1:0] alu_data_b_in,        // Input data from register file port A
   input [OPCODE_WIDTH-1:0] alu_opcode_in,      // Instruction opcode
   input [FUNCTION_WIDTH-1:0] alu_function_in,  // Instruction function

   output reg alu_branch_result_out,
   output [DATA_WIDTH-1:0] alu_data_out         // ALU output result data

);

   reg [DATA_WIDTH:0] alu_result_reg;
   reg flag_over_underflow;
   reg flag_above;
   reg flag_equal;
   reg flag_error;
   reg [FLAGS_WIDTH-1:0] flags_reg;


   `include "opcodes.v"

   wire [DATA_WIDTH-1:0] sum_result;
   wire [DATA_WIDTH-1:0] sub_result;
   wire [DATA_WIDTH-1:0] and_result;
   wire [DATA_WIDTH-1:0] or_result;


   assign sum_result = alu_data_a_in + alu_data_b_in;
   assign sub_result = alu_data_a_in - alu_data_b_in;
   assign and_result = alu_data_a_in && alu_data_b_in;
   assign or_result  = alu_data_a_in || alu_data_b_in;
   assign zero_cmp   = alu_data_a_in == {DATA_WIDTH{1'b0}};

   assign alu_data_out = alu_result_reg;


   always@(*)
   begin
      alu_result_reg = {DATA_WIDTH{1'b0}};
      if(alu_opcode_in == R_TYPE_OPCODE)begin
         case (alu_function_in)
            ADD_FUNCTION :
               alu_result_reg = sum_result;
            SUB_FUNCTION, CMP_FUNCTION :
               alu_result_reg = sub_result;
            AND_FUNCTION :
               alu_result_reg = and_result;
            OR_FUNCTION :
               alu_result_reg = or_result;
            MULT_FUNCTION :
               alu_result_reg = alu_data_a_in * alu_data_b_in;
            DIV_FUNCTION :
               alu_result_reg = alu_data_a_in / alu_data_b_in;
            // CMP_FUNCTION :
            //    alu_result_reg = alu_data_a_in - alu_data_b_in;
            NOT_FUNCTION :
               alu_result_reg = ~alu_data_b_in;
            default :
               alu_result_reg = {DATA_WIDTH{1'b0}};
         endcase
      end
      else begin
         case (alu_opcode_in)
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
     case (alu_opcode_in)
         BEQZ_OPCODE :
            alu_branch_result_out = zero_cmp;
         BNEZ_OPCODE :
            alu_branch_result_out = ~zero_cmp;
         BRFL_OPCODE :
            alu_branch_result_out = flags_reg == alu_data_b_in[3:0];
        default :
           alu_branch_result_out = {DATA_WIDTH{1'b0}};
     endcase
   end

   // ---------------------------------------------------------
   // Flag Setup
   // ---------------------------------------------------------
   always@(*)
   begin
      flag_over_underflow = 1'b0;
      flag_above = 1'b0;
      flag_equal = 1'b0;
      flag_error = 1'b0;
      if(alu_opcode_in == R_TYPE_OPCODE) begin
         case (alu_function_in)
            ADD_FUNCTION,SUB_FUNCTION,MULT_FUNCTION,DIV_FUNCTION :
            begin
               // Test overflow for arithmetic functions
               if(alu_data_a_in[DATA_WIDTH-1] == alu_data_b_in[DATA_WIDTH-1] && alu_result_reg[DATA_WIDTH-1] != alu_data_a_in[DATA_WIDTH-1]) begin
                  flag_over_underflow = 1'b1;
               end
               if(alu_opcode_in == DIV_FUNCTION) begin
                  if(alu_data_b_in == {DATA_WIDTH{1'b0}}) begin
                     flag_error = 1'b1;
                  end
               end
            end
            CMP_FUNCTION :
            begin
               if(alu_result_reg == {DATA_WIDTH{1'b0}}) begin
                  flag_equal = 1'b1;
               end
               // Missing tests if operators have different signals
               if(alu_data_a_in > alu_data_b_in && alu_data_a_in[15] == alu_data_b_in[15]) begin
                  flag_above = 1'b1;
               end
            end
            default :
               flag_error = 1'b1;
         endcase
      end
    end

    always@(posedge clk or negedge rst) begin
      if(~rst) begin
         flags_reg <= {FLAGS_WIDTH{1'b0}};
      end else
         flags_reg <= {flag_over_underflow,flag_above,flag_equal,flag_error};
    end
endmodule
