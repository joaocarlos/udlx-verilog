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
// FILE NAME        : branch_control.v
// AUTHOR(s)        : Victor Valente
// MANTAINER        : Victor Valente
// AUTHOR'S E-MAIL  : 
// -----------------------------------------------------------------------------
// KEYWORDS: branch control, dlx
// -----------------------------------------------------------------------------
// PURPOSE:
// -----------------------------------------------------------------------------
module branch_control
#(
   parameter DATA_WIDTH = 32,
   parameter PC_WIDTH = 6,
   parameter PC_OFFSET_WIDTH = 25
)
(
   input jmp_inst,
   input jmp_use_r,
   input branch_inst,
   input branch_result,
   input [PC_WIDTH-1:0] pc_in,
   input [DATA_WIDTH-1:0] reg_a_data_in,
   input [DATA_WIDTH-1:0] reg_b_data_in,
   input [PC_OFFSET_WIDTH-1:0] pc_offset,

   output select_new_pc,
   output [PC_WIDTH-1:0] pc_out

);

wire [DATA_WIDTH-1:0] jmp_val;
wire [DATA_WIDTH-1:0] branch_val;
wire [PC_WIDTH-1:0] pc_jump;

assign pc_jump = {pc_in[31:28],pc_offset,{2{1'b0}}};

assign select_new_pc = jmp_inst|(branch_inst&branch_result);

assign branch_val = pc_in + reg_b_data_in;

assign jmp_val = jmp_use_r?reg_a_data_in:pc_jump;

assign pc_out = jmp_inst?jmp_val:branch_val;

endmodule
