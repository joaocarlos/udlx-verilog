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
// FILE NAME        : register_bank.v
// AUTHOR(s)        : lintaum
// MANTAINER        : lintaum, joaocarlos
// AUTHOR'S E-MAIL  : lintonthiago@gmail.com
// -----------------------------------------------------------------------------
// KEYWORDS: decoder, registers, dlx
// -----------------------------------------------------------------------------
// PURPOSE: General Purpose Registers of uDLX core
// -----------------------------------------------------------------------------
module register_bank
#(
   DATA_WIDTH = 32,
   ADDRESS_WIDTH = 4
)
(/*autoport*/
   input clk,
   input rst_n,
   input [ADDRESS_WIDTH-1:0] rd_reg1_addr,
   input [ADDRESS_WIDTH-1:0] rd_reg2_addr,
   input [ADDRESS_WIDTH-1:0] mem_wb_reg_addr,
   input mem_wb_reg_en,
   input [DATA_WIDTH-1:0] mem_wb_reg_data,
   output [DATA_WIDTH-1:0] rd_reg1_data_out,
   output [DATA_WIDTH-1:0] rd_reg2_data_out
);

   // ------------------------------------------------------
   // Internal
   // ------------------------------------------------------
   // Local Parameters

   // Wires

   // Registers
   reg [DATA_WIDTH-1:0] reg_file [0:(2**ADDRESS_WIDTH)-1];

   // Variables
   integer i;

   // ------------------------------------------------------
   // General Purpose Registers
   // ------------------------------------------------------
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         for (i = 0; i < 2**ADDRESS_WIDTH; i = i + 1) begin:reset_memory
            mem <= {DATA_WIDTH{1'b0}};
         end
      end
      else begin
         if (write_enable)
            mem[mem_wb_reg_addr] <= mem_wb_reg_data;
      end
   end

   // ------------------------------------------------------
   // Output registers
   // ------------------------------------------------------

   assign rd_reg2_data_out = (mem_wb_reg_en&(mem_wb_reg_addr==rd_reg2_addr))
                             reg_file[rd_reg2_addr];
   assign rd_reg1_data_out = (mem_wb_reg_en&(mem_wb_reg_addr==rd_reg1_addr))
                             reg_file[rd_reg1_addr];

endmodule
