//==================================================================================================
//  Filename      : instruction_decoder.v
//  Created On    : 2014-06-06 21:35:39
//  Last Modified : 2014-06-08 08:38:50
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
            REG_ADDR_WIDTH = 5,
            IMEDIATE_WIDTH = 16,
            DECODED_INST_WIDTH = 4
        )
        (/*autoport*/
            input [INSTRUCTION_WIDTH-1:0] instruction_in,
            output [REG_ADDR_WIDTH-1:0] read_address1_out,
            output [REG_ADDR_WIDTH-1:0] read_address2_out,
            output [REG_ADDR_WIDTH-1:0] write_address_out,
            output [IMEDIATE_WIDTH-1:0] immediate_out,
            output [DECODED_INST_WIDTH-1:0] decoded_inst_out   
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
always @(*) begin
   case (instruction_in[31:26])
      R_INST:begin
         
      end
      I_INST:begin
         
      end
      J_INST: begin
         
      end
      default : begin
         
      end
   endcase
end

//*******************************************************
//Outputs
//*******************************************************
//ranges dependem das instruções a serem definidas

always @(*) begin
      case (decoded_inst_out)
         R_INST: begin
            read_address1_out = {1'b0, instruction_in[25:22]};//4
            read_address2_out = instruction_in[21:17];//5
            immediate_out = 0;
            write_address_out = instruction_in[16:11];//5
         end
         I_INST: begin
            read_address1_out = instruction_in[27:23];//5
            read_address2_out = 0;
            immediate_out = instruction_in[15:0];//16
            write_address_out = instruction_in[22:16];//7 ???
         end
         J_INST: begin
            read_address1_out = 0;
            read_address2_out = 0;
            immediate_out = instruction_in[27:0];//28
            write_address_out = 0;
         end
         default : begin        
            read_address1_out = 0;
            read_address2_out = 0;
            immediate_out = 0;
            write_address_out = 0;
         end
      endcase
end


endmodule
