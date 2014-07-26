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
// FILE NAME   : write_back.v
// KEYWORDS    : write-back, multiplexer, combinational, dlx
// -----------------------------------------------------------------------------
// PURPOSE: Selects the data which will be stores in register file.
// -----------------------------------------------------------------------------

module write_back
#(
   parameter DATA_WIDTH = 32,
   parameter REG_ADDR_WIDTH = 5
 )
(
   input [DATA_WIDTH-1:0] mem_data_in,
   input [DATA_WIDTH-1:0] alu_data_in,
   input [DATA_WIDTH-1:0] hi_data_in,
//   input reg_wr_en_in,
//   input [REG_ADDR_WIDTH-1:0] reg_wr_addr_in,
   input [REG_ADDR_WIDTH-1:0] reg_a_wr_addr_in,
   input [REG_ADDR_WIDTH-1:0] reg_b_wr_addr_in,
   input reg_a_wr_en_in,
   input reg_b_wr_en_in,
   input write_back_mux_sel,

   output [REG_ADDR_WIDTH-1:0] reg_a_wr_addr_out,
   output [REG_ADDR_WIDTH-1:0] reg_b_wr_addr_out,
   output [DATA_WIDTH-1:0] reg_a_wr_data_out,
   output [DATA_WIDTH-1:0] reg_b_wr_data_out,
   output reg_a_wr_en_out,
   output reg_b_wr_en_out
);

//verificar se vai extender o sinal apenas de uma forma

assign reg_a_wr_data_out = write_back_mux_sel?mem_data_in:alu_data_in;
assign reg_b_wr_data_out = hi_data_in;
assign reg_a_wr_en_out = reg_a_wr_en_in;
assign reg_b_wr_en_out = reg_b_wr_en_in;
assign reg_a_wr_addr_out = reg_a_wr_addr_in;
assign reg_b_wr_addr_out = reg_b_wr_addr_in;

endmodule
