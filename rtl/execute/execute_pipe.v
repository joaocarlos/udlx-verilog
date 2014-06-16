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
// FILE NAME        : execute_pipe.v
// AUTHOR(s)        : victor.valente
// MANTAINER        : victor.valente
// AUTHOR'S E-MAIL  :
// -----------------------------------------------------------------------------
// KEYWORDS: dlx, execute, pipeline, registers
// -----------------------------------------------------------------------------
// PURPOSE: Execute-Memory pipeline registers
// -----------------------------------------------------------------------------
module execute_pipe
#(
   parameter PC_WIDTH = 20,
   parameter DATA_WIDTH = 32,
   parameter REG_ADDR_WIDTH = 5
)
(
   input clk,
   input rst_n,
   //memory signals
   input mem_data_rd_en_in,
   input mem_data_wr_en_in,
   input [DATA_WIDTH-1:0] mem_data_in,
   input [DATA_WIDTH-1:0] alu_data_in, //w_mem_wr_data_in and w_reg_data
   //register signals
   input reg_wr_en_in,
   input [REG_ADDR_WIDTH-1:0] reg_wr_addr_in,
   input write_back_mux_sel_in,
   input select_new_pc_in,
   input [PC_WIDTH-1:0] new_pc_in,

   output reg mem_data_rd_en_out,
   output reg mem_data_wr_en_out,
   output reg [DATA_WIDTH-1:0] mem_data_out,
   output reg [DATA_WIDTH-1:0] alu_data_out, //w_mem_wr_data_out and w_reg_data
   output reg reg_wr_en_out,
   output reg [REG_ADDR_WIDTH-1:0] reg_wr_addr_out,
   output reg write_back_mux_sel_out,
   output reg select_new_pc_out,
   output reg [PC_WIDTH-1:0] new_pc_out
);

always@(posedge clk, negedge rst_n)begin
   if(!rst_n)begin
      mem_data_rd_en_out <= 0;
      mem_data_wr_en_out <= 0;
      mem_data_out <= 0;
//      mem_addr_out <= 0;
      alu_data_out <= 0;
      reg_wr_en_out <= 0;
      reg_wr_addr_out <= 0;
      write_back_mux_sel_out <= 0;
      select_new_pc_out <= 0;
      new_pc_out <= 0;
   end
   else begin
      mem_data_rd_en_out <= mem_data_rd_en_in;
      mem_data_wr_en_out <= mem_data_wr_en_in;
      mem_data_out <= mem_data_in;
//      mem_addr_out <= mem_addr_in;
      alu_data_out <= alu_data_in;
      reg_wr_en_out <= reg_wr_en_in;
      reg_wr_addr_out <= reg_wr_addr_in;
      write_back_mux_sel_out <= write_back_mux_sel_in;
      select_new_pc_out <= select_new_pc_in;
      new_pc_out <= new_pc_in;
   end
end


endmodule
