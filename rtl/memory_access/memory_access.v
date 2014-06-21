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
// FILE NAME  : memory_access.v
// KEYWORDS   : dlx, memory access, sdram, data memory
// -----------------------------------------------------------------------------
// PURPOSE: Top level module of Memory Access stage
// -----------------------------------------------------------------------------
module memory_access
#(
   parameter DATA_WIDTH = 32,
   parameter INSTRUCTION_WIDTH = 32,
   parameter REG_ADDR_WIDTH = 5
  )
(
   input clk,
   input rst_n,
   input write_back_mux_sel_in,
   input [DATA_WIDTH-1:0] alu_data_in,
   input reg_wr_en_in,
   input [REG_ADDR_WIDTH-1:0] reg_wr_addr_in,
   input [INSTRUCTION_WIDTH-1:0] instruction_in,

   output reg write_back_mux_sel_out,
   output reg [DATA_WIDTH-1:0] alu_data_out,
   output reg reg_wr_en_out,
   output reg [REG_ADDR_WIDTH-1:0] reg_wr_addr_out,
   output reg [INSTRUCTION_WIDTH-1:0] instruction_out
);



always@(posedge clk or negedge rst_n) begin
   if(~rst_n) begin
      write_back_mux_sel_out <= 0;
      alu_data_out <= 0;
      reg_wr_en_out <= 0;
      reg_wr_addr_out <= 0;
      instruction_out <= 0;
   end
   else begin
      write_back_mux_sel_out <= write_back_mux_sel_in;
      alu_data_out <= alu_data_in;
      reg_wr_en_out <= reg_wr_en_in;
      reg_wr_addr_out <= reg_wr_addr_in;
      instruction_out <= instruction_in;
   end
end

endmodule
