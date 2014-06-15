//==================================================================================================
//  Filename      : forward_unit.v
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

module forward_unit
#(
   parameter DATA_WIDTH = 32,
   parameter REG_ADDR_WIDTH = 5
 )
 (
   input [DATA_WIDTH-1:0] data_alu_a,
   input [DATA_WIDTH-1:0] data_alu_b,
   input [REG_ADDR_WIDTH-1:0] addr_alu_a,
   input [REG_ADDR_WIDTH-1:0] addr_alu_b,
   input [DATA_WIDTH-1:0] ex_mem_data,
   input [REG_ADDR_WIDTH-1:0] ex_mem_reg_addr,
   input ex_mem_reg_wr_ena,
   input [DATA_WIDTH-1:0] mem_wb_data,
   input [REG_ADDR_WIDTH-1:0] mem_wb_reg_addr,
   input mem_wb_reg_wr_ena,
   input write_back_mux_sel,
   output reg [DATA_WIDTH-1:0] alu_a_mux_sel,
   output reg [DATA_WIDTH-1:0] alu_b_mux_sel
);

//a ALU input
always@(*)begin
   if((addr_alu_a==ex_mem_data)&ex_mem_reg_wr_ena)begin
      alu_a_mux_sel <= ex_mem_data;
   end
   else if((addr_alu_a==mem_wb_reg_addr)&mem_wb_reg_wr_ena)begin
      alu_a_mux_sel <= mem_wb_data;
   end
   else begin
      alu_a_mux_sel <= data_alu_a;
   end
end


// b ALU input
always@(*)begin
   if((addr_alu_b==ex_mem_data)&ex_mem_reg_wr_ena)begin
      alu_b_mux_sel <= ex_mem_data;
   end
   else if((addr_alu_b==mem_wb_reg_addr)&mem_wb_reg_wr_ena)begin
      alu_b_mux_sel <= mem_wb_data;
   end
   else begin
      alu_b_mux_sel <= data_alu_b;
   end
end


endmodule
