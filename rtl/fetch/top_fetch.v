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
// FILE NAME  : top_fetch.v
// KEYWORDS   : instruction fetch, program counter, pc, dlx
// -----------------------------------------------------------------------------
// PURPOSE:
// -----------------------------------------------------------------------------
module top_fetch
#(
    parameter PC_DATA_WIDTH = 20,
    parameter INSTRUCTION_WIDTH = 32,
    parameter PC_INITIAL_ADDRESS = 20'h0
)(
    input clk,                                                // CPU core clock
    input rst_n,                                              // CPU core reset active low
    input en,
    input stall,                                              // Indicates a stall insertion on the datapath
    // input flush,                                              // Force flush in pipeline registers

    // input [INSTRUCTION_WIDTH-1:0] inst_mem_data_in,           // SRAM input data
    input select_new_pc_in,                                   // Signal used for branch not taken
    input [PC_DATA_WIDTH-1:0] new_pc_in,                      // New value of Program Counter

    // output reg [PC_DATA_WIDTH-1:0] new_pc_out,                // Updated value of the Program Counter
    output [PC_DATA_WIDTH-1:0] pc_out,                    // Value of the Program Counter
    // output reg [INSTRUCTION_WIDTH-1:0] instruction_reg_out,   // CPU core fetched instruction
    output [PC_DATA_WIDTH-1:0] inst_mem_addr_out,              // Instruction SRAM address bus
    input boot_mode
);


reg [PC_DATA_WIDTH-1:0] pc;
reg [PC_DATA_WIDTH-1:0] pc_mux_data;
reg [PC_DATA_WIDTH-1:0] pc_adder_data;

// -------------------------------------------------------------
// Multiplex to select new PC value
// -------------------------------------------------------------
always@(*)
begin
  case(select_new_pc_in)
    0 : pc_mux_data = pc_adder_data;
    1 : pc_mux_data = new_pc_in;
  endcase
end

// -------------------------------------------------------------
// Program Counter adder
// -------------------------------------------------------------
always@(*)
begin
  pc_adder_data = pc + 20'd4;
end

// -------------------------------------------------------------
// Program Counter regireg [FUNCTION_WIDTH-1:0] inst_function,ster
// -------------------------------------------------------------
assign inst_mem_addr_out = pc;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pc <= PC_INITIAL_ADDRESS;
    end 
    else if (boot_mode) begin
        pc <= PC_INITIAL_ADDRESS;
    end
    else if((!stall)&en) begin
        pc <= pc_mux_data;
    end
end

assign pc_out = pc;

// -------------------------------------------------------------
// Pipeline Registers
// The if_id pipe needs only this
// ++TODO: Plance this procedure into a module.
// -------------------------------------------------------------
// always@(posedge clk or negedge rst_n)begin
//    if(!rst_n) begin
//       new_pc_out <= 0;
//       instruction_reg_out <= 0;
//    end else if(!stall)begin
//       new_pc_out <= pc;
//       if(flush)begin
//          instruction_reg_out <= 0;
//       end
//       else begin
//          instruction_reg_out <= inst_mem_data_in;
//       end
//    end
// end


endmodule
