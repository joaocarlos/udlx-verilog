module mux_sram
#(
   parameter DATA_WIDTH = 32,
   parameter ADDR_WIDTH = 20
      
)
(/*autoport*/
   // boot ports interface
   input boot_mode,
   input boot_mem_wr_en,
   input [ADDR_WIDTH-1:0] boot_mem_addr,
   input [DATA_WIDTH-1:0] boot_mem_rd_data,
   // dlx ports interface
   input inst_mem_wr_en,
   input inst_mem_rd_en,
   input [DATA_WIDTH-1:0] inst_mem_wr_data,
   output reg [DATA_WIDTH-1:0] inst_mem_rd_data,
   input [ADDR_WIDTH-1:0] inst_mem_addr,
   //sram insterface
   output reg sram_mem_wr_en,
   output reg sram_mem_rd_en,
   output reg [DATA_WIDTH-1:0] sram_mem_wr_data,
   input [DATA_WIDTH-1:0] sram_mem_rd_data,
   output reg [ADDR_WIDTH-1:0] sram_mem_addr
);
//*******************************************************
//Outputs
//*******************************************************

always @(*) begin
   if (boot_mode) begin
      sram_mem_wr_en = boot_mem_wr_en;
      sram_mem_rd_en = 1'b0;
      sram_mem_wr_data = boot_mem_rd_data;
      sram_mem_addr = boot_mem_addr;
		inst_mem_rd_data = {DATA_WIDTH{1'b0}};
   end
   else begin
      sram_mem_wr_en = inst_mem_wr_en;
      sram_mem_rd_en = inst_mem_rd_en;
      sram_mem_wr_data = inst_mem_wr_data;
      inst_mem_rd_data = sram_mem_rd_data;
      sram_mem_addr = inst_mem_addr;
   end
end

endmodule