//==================================================================================================
//  Filename      : write_back.v
//  Created On    : 2014-06-06 21:35:43
//  Last Modified : 2014-06-06 22:04:31
//  Revision      : 
//  Author        : Victor Valente de Araujo
//  Company       : Universidade Federal da Bahia - UFBA
//  Email         : @gmail.com
//
//  Description   : 
//
//
//==================================================================================================

module write_back
#(
    DATA_WIDTH = 32,
    REG_ADDR_WIDTH = 5
(
  input [DATA_WIDTH-1:0] mem_data_in,
  input [DATA_WIDTH-1:0] alu_data_in,
  input w_reg_en_in,
  input [REG_ADDR_WIDTH-1:0] w_reg_addr_in,
  input write_back_mux_sel,
  output [REG_ADDR_WIDTH-1:0] w_reg_addr_out,
  output [DATA_WIDTH-1:0] reg_data_out,
  output w_reg_en_out
);

//verificar se vai extender o sinal apenas de uma forma

assign reg_data_out = write_back_mux_sel?mem_data_in:alu_data_in;
assign w_reg_en_out = w_reg_en_in;
assign w_reg_addr_out = w_reg_addr_in;

endmodule
