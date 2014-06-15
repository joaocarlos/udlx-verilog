//==================================================================================================
//  Filename      : memory_access.v
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

module memory_access
#(
    parameter DATA_WIDTH = 32,
    parameter REG_ADDR_WIDTH = 5
  )
(
  input clk,
  input rst_n,
  input write_back_mux_sel_in,
  input [DATA_WIDTH-1:0] alu_data_in,
  input reg_wr_en_in,
  input [REG_ADDR_WIDTH-1:0] reg_wr_addr_in,

  output reg write_back_mux_sel_out,
  output reg [DATA_WIDTH-1:0] alu_data_out,
  output reg reg_wr_en_out,
  output reg [REG_ADDR_WIDTH-1:0] reg_wr_addr_out
);



always@(posedge clk or negedge rst_n) begin
   if(~rst_n) begin
      write_back_mux_sel_out <= 0;
      alu_data_out <= 0;
      reg_wr_en_out <= 0;
      reg_wr_addr_out <= 0;
   end
   else begin
      write_back_mux_sel_out <= write_back_mux_sel_in;
      alu_data_out <= alu_data_in;
      reg_wr_en_out <= reg_wr_en_in;
      reg_wr_addr_out <= reg_wr_addr_in;
   end
end

endmodule
