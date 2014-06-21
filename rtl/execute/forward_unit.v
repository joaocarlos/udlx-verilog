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
// FILE NAME   : forward_unit.v
// KEYWORDS    : dlx, forwarding, hazzard
// -----------------------------------------------------------------------------
// PURPOSE: Provide forwarding functionality to uDLX core
// -----------------------------------------------------------------------------
module forward_unit
#(
   parameter DATA_WIDTH = 32,
   parameter REG_ADDR_WIDTH = 5
 )
 (
   input [DATA_WIDTH-1:0] data_alu_a,
   input [DATA_WIDTH-1:0] data_alu_b,
   input [REG_ADDR_WIDTH-1:0] addr_alu_a,
   input [REG_ADDR_WIDTH-1:0] addr_alu_b,
   input [DATA_WIDTH-1:0] ex_mem_data,
   input [REG_ADDR_WIDTH-1:0] ex_mem_reg_addr,
   input ex_mem_reg_wr_ena,
   input [DATA_WIDTH-1:0] wb_reg_data,
   input [REG_ADDR_WIDTH-1:0] wb_reg_addr,
   input wb_reg_wr_ena,
   output reg [DATA_WIDTH-1:0] alu_a_mux_sel,
   output reg [DATA_WIDTH-1:0] alu_b_mux_sel
);

//a ALU input
always@(*)begin
   if((addr_alu_a==ex_mem_reg_addr)&ex_mem_reg_wr_ena)begin
      alu_a_mux_sel <= ex_mem_data;
   end
   else if((addr_alu_a==wb_reg_addr)&wb_reg_wr_ena)begin
      alu_a_mux_sel <= wb_reg_data;
   end
   else begin
      alu_a_mux_sel <= data_alu_a;
   end
end


// b ALU input
always@(*)begin
   if((addr_alu_b==ex_mem_reg_addr)&ex_mem_reg_wr_ena)begin
      alu_b_mux_sel <= ex_mem_data;
   end
   else if((addr_alu_b==wb_reg_addr)&wb_reg_wr_ena)begin
      alu_b_mux_sel <= wb_reg_data;
   end
   else begin
      alu_b_mux_sel <= data_alu_b;
   end
end


endmodule
