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
// FILE NAME   : opcodes.v
// KEYWORDS    : dlx, functions, opcodes, parameters
// -----------------------------------------------------------------------------
// PURPOSE: Provide all instructions operation codes and functions
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// I-Type Instructions
// -----------------------------------------------------------------------------
localparam LW_OPCODE = 6'h23;
localparam SW_OPCODE = 6'h2B;
localparam BRFL_OPCODE = 6'h09;
localparam ADDI_OPCODE = 6'h08;
localparam SUBI_OPCODE = 6'h10;
localparam ANDI_OPCODE = 6'h0c;//6'h12;
localparam ORI_OPCODE = 6'h13;
localparam BEQZ_OPCODE = 6'h04;
localparam BNEZ_OPCODE = 6'h05;


// -----------------------------------------------------------------------------
// R-Type Instructions OpCode
// -----------------------------------------------------------------------------
localparam R_TYPE_OPCODE = 6'h00;

// -----------------------------------------------------------------------------
// R-Type Instructions Functions
// -----------------------------------------------------------------------------
localparam ADD_FUNCTION = 6'h20;
localparam SUB_FUNCTION = 6'h22;
localparam AND_FUNCTION = 6'h24;
localparam NOR_FUNCTION = 6'h27;
localparam OR_FUNCTION = 6'h25;
localparam DIV_FUNCTION = 6'h1A;
localparam MULT_FUNCTION = 6'h18;
localparam CMP_FUNCTION = 6'h1C;
localparam NOT_FUNCTION = 6'h1D;
localparam JR_FUNCTION = 6'h08;
localparam JALR_FUNCTION = 6'h09;


// -----------------------------------------------------------------------------
// J-Type Instructions OpCode
// -----------------------------------------------------------------------------
localparam JPC_OPCODE = 6'h02;
localparam JAL_OPCODE = 6'h03;
localparam CALL_OPCODE = 6'h3E; //identico ao JAL
localparam RET_OPCODE = 6'h3F; //JR para enderço R[31]
