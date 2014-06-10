//==================================================================================================
//  Filename      : control.v
//  Created On    : 2014-06-06 21:35:29
//  Last Modified : 2014-06-06 22:39:04
//  Revision      : 
//  Author        : Linton Thiago Costa Esteves
//  Company       : Universidade Federal da Bahia - UFBA
//  Email         : lintonthiago@gmail.com
//
//  Description   : 
//
//
//==================================================================================================

module control
				#(
				)
				(/*autoport*/
					input decoded_inst_in,
					output alu_src_out,
					output alu_opcode_out,
					output mem_data_wr_en_out,
					output write_back_mux_sel_out,
					output w_reg_wr_en_out,
					output data_alu_a_out,
					output data_alu_b_out,
					output new_pc_out,
					output branch_inst_out,
					output jmp_inst_out
				);

//*******************************************************
//Internal
//*******************************************************
//Local Parameters
`include "general_parameters.v"
//Wires

//Registers

//*******************************************************
//General Purpose Signals
//*******************************************************
case (decoded_inst_in)

   default : /* default */;
endcase
//*******************************************************
//Outputs
//*******************************************************

//*******************************************************
//Instantiations
//*******************************************************

endmodule