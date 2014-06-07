//==================================================================================================
//  Filename      : register_bank.v
//  Created On    : 2014-06-06 21:35:51
//  Last Modified : 2014-06-06 22:04:38
//  Revision      : 
//  Author        : Linton Thiago Costa Esteves
//  Company       : Universidade Federal da Bahia - UFBA
//  Email         : lintonthiago@gmail.com
//
//  Description   : 
//
//
//==================================================================================================
module register_bank
               #(
                  DATA_WIDTH = 32,
                  MEMORY_SIZE = 16,
                  ADDRESS_WIDTH = 4
               )
               (/*autoport*/
                  input clk,
                  input rst_n,
                  input [ADDRESS_WIDTH-1:0] read_address_1,
                  input [ADDRESS_WIDTH-1:0] read_address_2,
                  input [ADDRESS_WIDTH-1:0] write_address,
                  input write_enable,
                  input [DATA_WIDTH-1:0] write_data,
                  output [DATA_WIDTH-1:0] read_data_1,
                  output [DATA_WIDTH-1:0] read_data_2
               );
//*******************************************************
//Internal
//*******************************************************
//Local Parameters

//Wires

//Registers
reg [DATA_WIDTH-1:0] mem [0:MEMORY_SIZE-1];

integer i;
//*******************************************************
//General Purpose Signals
//*******************************************************
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      for (i = 0; i < MEMORY_SIZE; i = i + 1) begin:reset_memory
         mem <= {DATA_WIDTH{1'b0}};
      end
   end
   else begin
      if (write_enable)
         mem[write_address] <= write_data;
   end
end
//*******************************************************
//Outputs
//*******************************************************

assign read_data_2 = mem[read_address_2];
assign read_data_1 = mem[read_address_1];

endmodule
