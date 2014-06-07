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
// FILE NAME        : reigster_bank.v
// AUTHOR(s)        : jaocarlos
// MANTAINER        : joaocarlos
// AUTHOR'S E-MAIL  : joaocarlos@ieee.org
// -----------------------------------------------------------------------------
// KEYWORDS: register file, register bank, dlx
// -----------------------------------------------------------------------------
// PURPOSE: Stores data being handled by the processor
// -----------------------------------------------------------------------------
module register_bank
#(
    parameter REG_BANK_ADDR_WIDTH = 4,
    parameter REG_DATA_WIDTH = 32
)
(
    input clk,                                          // CPU core clock
    input rst_n,                                        // CPU core reset active low
    input [REG_BANK_ADDR_WIDTH-1:0] rd_reg1_addr,       // Source register address
    input [REG_BANK_ADDR_WIDTH-1:0] rd_reg2_addr,       // Source register address

    input [REG_DATA_WIDTH-1:0] mem_wb_reg_data,         // Data to be writen
    input [REG_BANK_ADDR_WIDTH-1:0] mem_wb_reg_addr,    // Target write address
    input mem_wb_reg_en,                                // Write enable signal

    output [REG_DATA_WIDTH-1:0] rd_reg1_data_out,       // Data output to ALU input port A
    output [REG_DATA_WIDTH-1:0] rd_reg2_data_out        // Data output to ALU input port B
);

    reg [REG_DATA_WIDTH-1:0]    reg_file [0:(2**REG_BANK_ADDR_WIDTH)-1];

    assign rd_data_a = reg_file[rd_reg1_addr];
    assign rd_data_b = reg_file[rd_reg2_addr];

    integer   i;
    always @(posedge clk) begin
        if (~rst_n)
        begin
            for (i = 0; i < 2**REG_BANK_ADDR_WIDTH; i = i + 1)
            begin
                reg_file[i] <= 0;
            end
        end else
        begin
            if (mem_wb_reg_en) reg_file[mem_wb_reg_addr] <= mem_wb_reg_data;
        end // else: !if(~rst_n)
    end

endmodule