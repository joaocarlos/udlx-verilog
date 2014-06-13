//==================================================================================================
//  Filename      : instruction_decoder.v
//  Created On    : 2014-06-06 21:35:39
//  Last Modified : 2014-06-06 22:35:43
//  Revision      : 
//  Author        : Linton Thiago Costa Esteves
//  Company       : Universidade Federal da Bahia - UFBA
//  Email         : lintonthiago@gmail.com
//
//  Description   : 
//
//
//==================================================================================================
module instruction_decoder
        #(
            INSTRUCTION_WIDTH = 32,
	    OPCODE_WIDTH = 6,
	    FUNCTION_WIDTH = 5,
            REG_ADDR_WIDTH = 5,
            IMEDIATE_WIDTH = 16,
	    PC_OFFSET_WIDTH = 26
        )
        (/*autoport*/
            input [INSTRUCTION_WIDTH-1:0] instruction_in,
	    output [OPCODE_WIDTH-1:0] opcode,
	    output reg [FUNCTION_WIDTH-1:0] inst_function,
            output reg [REG_ADDR_WIDTH-1:0] read_address1_out,
            output reg [REG_ADDR_WIDTH-1:0] read_address2_out,
            output reg [REG_ADDR_WIDTH-1:0] w_reg_addr_out,
	    output reg w_reg_wr_en_out,
            output reg [IMEDIATE_WIDTH-1:0] immediate_out,
	    output reg [PC_OFFSET_WIDTH-1:0] pc_offset,
	    output reg mem_data_wr_en_out,
	    output reg write_back_mux_sel_out,
	    output reg branch_inst_out,
	    output reg jump_inst_out
        );
//*******************************************************
//Internal
//*******************************************************
//Local Parameters
`include "opcodes.v"


assign opcode = instruction_in[31:26];

always @(*) begin
   case (opcode)
      TYPE_R_OPCODE: begin
         inst_function = instruction_in[5:0];
         read_address1_out = instruction_in[25:21];
         read_address2_out = instruction_in[20:16];
         w_reg_addr_out = instruction_in[15:11];
         w_reg_wr_en_out = 1'b1;
         immediate_out = 0;
         pc_offset = 0;
         mem_data_wr_en_out = 1'b0;
         write_back_mux_sel_out = 1'b0;
         branch_inst_out = 1'b0;
         jump_inst_out = 1'b0;
	 end
      ADDI_OPCODE,SUBI_OPCODE,ANDI_OPCODE,ORI_OPCODE: begin
         read_address1_out = instruction_in[25:21];
         read_address2_out = 0;
	 w_reg_addr_out = instruction_in[20:16];
         w_reg_wr_en_out = 1'b1;
         immediate_out = instruction_in[15:0];
         pc_offset = 0;
         mem_data_wr_en_out = 1'b0;
         write_back_mux_sel_out = 1'b0;
         branch_inst_out = 1'b0;
         jump_inst_out = 1'b0;
      end
      LW_OPCODE: begin
         read_address1_out = instruction_in[25:21];
         read_address2_out = 0;
	 w_reg_addr_out = instruction_in[20:16];
         w_reg_wr_en_out = 1'b1;
         immediate_out = instruction_in[15:0];
         pc_offset = 0;
         mem_data_wr_en_out = 1'b0;
         write_back_mux_sel_out = 1'b1;
         branch_inst_out = 1'b0;
         jump_inst_out = 1'b0;
      end
      SW_OPCODE: begin
         read_address1_out = instruction_in[25:21];
         read_address2_out = 0;
	 w_reg_addr_out = instruction_in[20:16];
         w_reg_wr_en_out = 1'b0;
         immediate_out = instruction_in[15:0];
         pc_offset = 0;
         mem_data_wr_en_out = 1'b1;
         write_back_mux_sel_out = 1'b0;
         branch_inst_out = 1'b0;
         jump_inst_out = 1'b0;
      end
      BEQZ,BNEZ,BRFL: begin
         read_address1_out = instruction_in[25:21];
         read_address2_out = 0;
	 w_reg_addr_out = instruction_in[20:16];
         w_reg_wr_en_out = 1'b0;
         immediate_out = instruction_in[15:0];
         pc_offset = 0;
         mem_data_wr_en_out = 1'b0;
         write_back_mux_sel_out = 1'b0;
         branch_inst_out = 1'b1;
         jump_inst_out = 1'b0;
      end
      JR: begin
         read_address1_out = instruction_in[25:21];
         read_address2_out = 0;
	 w_reg_addr_out = instruction_in[20:16];//not used
         w_reg_wr_en_out = 1'b0;
         immediate_out = instruction_in[15:0];//not used
         pc_offset = 0;
         mem_data_wr_en_out = 1'b0;
         write_back_mux_sel_out = 1'b0;
         branch_inst_out = 1'b0;
         jump_inst_out = 1'b1;
      end
	 JPC: begin //TODO ver instrucoes call e eret
	 read_address1_out = 0;
         read_address2_out = 0;
	 w_reg_addr_out = 0;
         w_reg_wr_en_out = 1'b0;
         immediate_out = 0;
         pc_offset = instruction_in[25:0];
         mem_data_wr_en_out = 1'b0;
         write_back_mux_sel_out = 1'b0;
         branch_inst_out = 1'b0;
         jump_inst_out = 1'b1;
      end
      default : begin
         inst_function = 0;
         read_address1_out = 0;
         read_address2_out = 0;
         w_reg_addr_out = 0;
         w_reg_wr_en_out = 1'b0;
         immediate_out = 0;
         pc_offset = 0;
         mem_data_wr_en_out = 1'b0;
         write_back_mux_sel_out = 1'b0;
         branch_inst_out = 1'b0;
         jump_inst_out = 1'b0;
      end
   endcase
end


endmodule
