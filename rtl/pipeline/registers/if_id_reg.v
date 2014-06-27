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
// FILE NAME   : if_id.v
// KEYWORDS    : instruction fetch, decode, pipeline, register
// -----------------------------------------------------------------------------
// PURPOSE     : Fetch/Decode pipeline registers
// -----------------------------------------------------------------------------
module if_id_reg
#(
    parameter PC_DATA_WIDTH = 20,
    parameter INSTRUCTION_WIDTH = 32
)(
   input clk,    // Clock
   input rst_n,  // Asynchronous reset active low
   input stall,                                              // Indicates a stall insertion on the datapath
   input flush,                                              // Force flush in pipeline registers
   input [INSTRUCTION_WIDTH-1:0] inst_mem_data_in,           // SRAM input data
   input [PC_DATA_WIDTH-1:0] pc_in,                          // Value of Program Counter

   output reg [PC_DATA_WIDTH-1:0] new_pc_out,                // Updated value of the Program Counter
   output reg [INSTRUCTION_WIDTH-1:0] instruction_reg_out    // CPU core fetched instruction
);
always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
      new_pc_out <= 0;
      instruction_reg_out <= 0;
   end else if(!stall)begin
      new_pc_out <= pc_in;
      if(flush)begin
         instruction_reg_out <= 0;
      end
      else begin
         instruction_reg_out <= inst_mem_data_in;
      end
   end
end

endmodule