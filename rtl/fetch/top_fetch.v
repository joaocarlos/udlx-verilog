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
// FILE NAME        : pc.v
// AUTHOR(s)        : jaocarlos
// MANTAINER        : joaocarlos
// AUTHOR'S E-MAIL  : joaocarlos@ieee.org
// -----------------------------------------------------------------------------
// KEYWORDS: program counter, pc, dlx
// -----------------------------------------------------------------------------
// PURPOSE:
// -----------------------------------------------------------------------------
module top_fetch
#(
    parameter PC_DATA_WIDTH = 20,
    parameter INST_DATA_WIDTH = 32,
    parameter INST_ADDR_WIDTH = 20,
    parameter PC_INITIAL_ADDRESS = 20'h0
)(
    input clk_in,                                       // CPU core clock
    input clk_en_in,                                    // [+++] CPU clock enable to suspend program counter
    input rst_n_in,                                     // CPU core reset active low
    input [INST_DATA_WIDTH-1:0] inst_mem_data_in,       // SRAM input data
    input select_new_pc_in,                             // Signal used for branch not taken
    input [PC_DATA_WIDTH-1:0] new_pc_in,                // New value of Program Counter

    output reg [PC_DATA_WIDTH-1:0] new_pc_out,          // Updated value of the Program Counter
    output [INST_DATA_WIDTH-1:0] instruction_reg_out,   // CPU core fetched instruction
    output reg [INST_ADDR_WIDTH-1:0] inst_mem_addr_out  // Instruction SRAM address bus
);

    reg [PC_DATA_WIDTH-1:0] pc_mux_data;
    reg [PC_DATA_WIDTH-1:0] pc_adder_data;

    // -------------------------------------------------------------
    // Multiplex to select new PC value
    // -------------------------------------------------------------
    always@(*)
    begin
        case(select_new_pc_in)
            '1' : mux_pc_data = new_pc_in;
            '0' : mux_pc_data = pc_adder_data;
        endcase
    end

    // -------------------------------------------------------------
    // Program Counter adder
    // [+++] Introduzed a clock enable signal in order to pause PC
    // To-do: Could it be full combinational?
    // -------------------------------------------------------------
    always@(posedge clk)
    begin
        if(clk_en_in) // May be linked to a general clock enable signal
        begin
            pc_adder_data <= inst_mem_addr_out + 20'd2;
        end
    end

    // -------------------------------------------------------------
    // Program Counter register
    // -------------------------------------------------------------
    always@(posedge clk or negedge rst_n)
    begin
        if(rst_n)
        begin
            inst_mem_addr_out <= PC_INITIAL_ADDRESS;
        end else
        begin
            inst_mem_addr_out <= pc_mux_data;
        end
    end

endmodule