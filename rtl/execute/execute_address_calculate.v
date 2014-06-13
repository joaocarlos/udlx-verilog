//==================================================================================================
//  Filename      : instruction_decoder.v
//  Created On    : 2014-06-06 21:35:39
//  Last Modified : 2014-06-06 22:35:43
//  Revision      : 
//  Author        : Victor Valente de Araujo
//  Company       : Universidade Federal da Bahia - UFBA
//  Email         : lintonthiago@gmail.com
//
//  Description   : 
//
//
//==================================================================================================
module execute_address_calculate
#(
   DATA_WIDTH = 32,
   PC_WIDTH = 32,
   OPCODE_WIDTH = 6,
   FUNCTION_WIDTH = 6, 
   W_REG_ADDR_WIDTH = 5
)
(
   input clk,
   input rst_n,
   input alu_src_in,
   input [ALU_OPCODE-1:0] alu_opcode_in,
   input [DATA_WIDTH-1:0] data_alu_a_in,
   input [DATA_WIDTH-1:0] data_alu_b_in,
   input [DATA_WIDTH-1:0] constant_in,
   input write_back_mux_sel_in,
   input w_reg_wr_en_in,
   input [PC_WIDTH:0] new_pc_in,
   input mem_data_wr_en_in,
   input [REG_ADDR_WIDTH-1:0] w_reg_addr_in,
   input brach_inst_in,
   input jmp_inst_in,
   input [DATA_WIDTH-1:0] exe_mem_data_in,
   input [DATA_WIDTH-1:0] mem_wb_data_in,
   output mem_data_wr_en_out,
   output [DATA_WIDTH-1:0] alu_b_data_in_out,
   output [DATA_WIDTH-1:0] alu_data_out,
   output write_back_mux_sel_out,
   output w_reg_wr_en_out,
   output [W_REG_ADDR_WIDTH-1:0] w_reg_addr_out,
   output branch_inst_out,
   output alu_zero_out,
   output jmp_inst_out
);
//*******************************************************
//Internal
//*******************************************************
//Local Parameters

//Wires

//Registers

//*******************************************************
//General Purpose Signals
//*******************************************************

//*******************************************************
//Outputs
//*******************************************************
//ranges dependem das instruções a serem definidas


//BRANCH CONTROL
//

//FOWARDING UNITS
//EQUIVALENT TO MULTIPLEXERS
//

//ALU
//


endmodule
