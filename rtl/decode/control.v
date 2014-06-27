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
// FILE NAME   : control.v
// -----------------------------------------------------------------------------
// KEYWORDS    : dlx, decoder, instruction, forwarding, hazzard, flush, stall
// -----------------------------------------------------------------------------
// PURPOSE     : Master core control signals generator.
// -----------------------------------------------------------------------------
module control
#(
   parameter REG_ADDR_WIDTH = 5
)
(/*autoport*/
   input id_ex_mem_data_rd_en,
   input [REG_ADDR_WIDTH-1:0] id_ex_reg_wr_addr,
   input if_id_rd_reg_a_en,
   input if_id_rd_reg_b_en,
   input [REG_ADDR_WIDTH-1:0] if_id_rd_reg_a_addr,
   input [REG_ADDR_WIDTH-1:0] if_id_rd_reg_b_addr,
   input select_new_pc,

   output reg inst_rd_en,
   output reg stall,
   output reg general_flush,
   output reg decode_flush
);

// -----------------------------------------------------------------------------
// Internal
// -----------------------------------------------------------------------------
// Wires
wire load_hazard;

// Detext RAW hazzard
assign load_hazard = id_ex_mem_data_rd_en &
                     (((id_ex_reg_wr_addr==if_id_rd_reg_a_addr)&if_id_rd_reg_a_en)|
                     ((id_ex_reg_wr_addr==if_id_rd_reg_b_addr)&if_id_rd_reg_b_en));

always@(*)begin
   // Branch Taken
   if(select_new_pc)begin
      inst_rd_en = 1;
      stall = 0;
      general_flush = 1;
      decode_flush = 1;
   end
   // RAW Hazzard detected
   else if(load_hazard)begin
      inst_rd_en = 0;
      stall = 1;
      general_flush = 0;
      decode_flush = 1;
   end
   else begin
      inst_rd_en = 1;
      stall = 0;
      general_flush = 0;
      decode_flush = 0;
   end
end

endmodule
