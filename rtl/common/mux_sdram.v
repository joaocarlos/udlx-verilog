module mux_sdram
#(
   parameter DATA_WIDTH = 32,
   parameter ADDR_WIDTH = 32
      
)
(/*autoport*/
   // inputs
   input wr_en,
   input [DATA_WIDTH-1:0] wr_data,
   input [ADDR_WIDTH-1:0] wr_address,
   // outputs
   output reg wr_en_sdram,
   output reg [DATA_WIDTH-1:0] wr_data_gpio,
   output reg [DATA_WIDTH-1:0] wr_data_sdram
);
//*******************************************************
//Outputs
//*******************************************************

always @(*) begin
   if (wr_en) begin
      if(wr_address[ADDR_WIDTH-1]==1) begin
         wr_data_gpio = wr_data;
         wr_en_sdram = 0;
         wr_data_sdram = {DATA_WIDTH{1'b0}};
      end
      else begin
         wr_data_gpio = {DATA_WIDTH{1'b0}};
         wr_en_sdram = 1;
         wr_data_sdram = wr_data;
      end
   end
   else begin
      wr_data_gpio = {DATA_WIDTH{1'b0}};
      wr_en_sdram = 0;
      wr_data_sdram = {DATA_WIDTH{1'b0}};
   end
end
endmodule