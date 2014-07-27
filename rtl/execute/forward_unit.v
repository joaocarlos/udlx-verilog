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
// PURPOSE     : Provide forwarding functionality to uDLX core
// -----------------------------------------------------------------------------
module forward_unit
#(
   parameter DATA_WIDTH = 32,
   parameter REG_ADDR_WIDTH = 5
 )
 (
   input [DATA_WIDTH-1:0] data_alu_a_in,
   input [DATA_WIDTH-1:0] data_alu_b_in,
   input [REG_ADDR_WIDTH-1:0] addr_alu_a_in,
   input [REG_ADDR_WIDTH-1:0] addr_alu_b_in,
   input [DATA_WIDTH-1:0] ex_mem_reg_a_data_in,
   input [DATA_WIDTH-1:0] ex_mem_reg_b_data_in,
   input [REG_ADDR_WIDTH-1:0] ex_mem_reg_a_addr_in,
   input [REG_ADDR_WIDTH-1:0] ex_mem_reg_b_addr_in,
   input ex_mem_reg_a_wr_ena_in,
   input ex_mem_reg_b_wr_ena_in,
   input [DATA_WIDTH-1:0] wb_reg_a_data_in,
   input [DATA_WIDTH-1:0] wb_reg_b_data_in,
   input [REG_ADDR_WIDTH-1:0] wb_reg_a_addr_in,
   input [REG_ADDR_WIDTH-1:0] wb_reg_b_addr_in,
   input wb_reg_a_wr_ena_in,
   input wb_reg_b_wr_ena_in,
      
   output reg [DATA_WIDTH-1:0] alu_a_mux_sel_out,
   output reg [DATA_WIDTH-1:0] alu_b_mux_sel_out
);

   // Port-A ALU input
   always@(*)begin
      // Forwarding data from MEM -> EXE
      if((addr_alu_a_in == ex_mem_reg_a_addr_in) & ex_mem_reg_a_wr_ena_in)begin
         alu_a_mux_sel_out <= ex_mem_reg_a_data_in;
      end
      else if((addr_alu_a_in == ex_mem_reg_b_addr_in) & ex_mem_reg_b_wr_ena_in)begin
         alu_a_mux_sel_out <= ex_mem_reg_b_data_in;
      end
      // Forwarding data from WB -> EXE
      else if((addr_alu_a_in == wb_reg_a_addr_in) & wb_reg_a_wr_ena_in)begin
         alu_a_mux_sel_out <= wb_reg_a_data_in;
      end
      else  if((addr_alu_a_in == wb_reg_b_addr_in) & wb_reg_b_wr_ena_in)begin
         alu_a_mux_sel_out <= wb_reg_b_data_in;
      end
      // No forwarding
      else begin
         alu_a_mux_sel_out <= data_alu_a_in;
      end
   end


   // Port-B ALU input
   always@(*)begin
      // Forwarding data from MEM -> EXE
      if((addr_alu_b_in == ex_mem_reg_a_addr_in) & ex_mem_reg_a_wr_ena_in)begin
         alu_b_mux_sel_out <= ex_mem_reg_a_data_in;
      end
      else if((addr_alu_b_in == ex_mem_reg_b_addr_in) & ex_mem_reg_b_wr_ena_in)begin
         alu_b_mux_sel_out <= ex_mem_reg_b_data_in;
      end
      // Forwarding data from WB -> EXE
      else if((addr_alu_b_in == wb_reg_a_addr_in) & wb_reg_a_wr_ena_in)begin
         alu_b_mux_sel_out <= wb_reg_a_data_in;
      end
      else if((addr_alu_b_in == wb_reg_b_addr_in) & wb_reg_b_wr_ena_in)begin
         alu_b_mux_sel_out <= wb_reg_b_data_in;
      end
      // No forwarding
      else begin
         alu_b_mux_sel_out <= data_alu_b_in;
      end
   end


endmodule
