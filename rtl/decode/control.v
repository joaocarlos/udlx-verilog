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
(/*autoport*/
   input id_ex_mem_data_rd_en,
   input id_ex_reg_wr_addr,
   input if_id_rd_reg_a_en,
   input if_id_rd_reg_b_en,
   input if_id_rd_reg_a_addr,
   input if_id_rd_reg_b_addr,
   input select_new_pc,

   output reg inst_rd_en,
   output reg stall,
   output reg general_flush,
   output reg decode_flush
);

//*******************************************************
//Internal
//*******************************************************
//Local Parameters
//Wires

wire load_hazard;

//Registers

assign load_hazard = id_ex_mem_data_rd_en&
                     (((id_ex_reg_wr_addr==if_id_rd_reg_a_addr)&if_id_rd_reg_a_en)|
		     ((id_ex_reg_wr_addr==if_id_rd_reg_b_addr)&if_id_rd_reg_b_en));

always@(*)begin
   if(select_new_pc)begin
      inst_rd_en = 1;
      stall = 0;
      general_flush = 1;
      decode_flush = 1;
   end
   else if(load_hazard)begin
      inst_rd_en = 0;
      stall = 1;
      general_flush = 0;
      decode_flush = 1;
   end
   else begin
      inst_rd_en = 1;
      stall = 0;
      general_flush = 0;
      decode_flush = 0;
   end
end

endmodule
