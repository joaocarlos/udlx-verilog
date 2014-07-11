module data_memory_controll
#(
   parameter DATA_WIDTH = 32,
   parameter DATA_ADDR_WIDTH = 32      
)
(/*autoport*/

   input clk,
   input rst_n,
   output data_rd_en,
   output data_wr_en,
   output [DATA_ADDR_WIDTH-1:0] data_addr,
   input [DATA_WIDTH-1:0] data_in,
   output [DATA_WIDTH-1:0] data_out,
   //SDRAM
   inout  [31:0]  dram_dq,       // sdram data bus 16 bits
   output [12:0]  dram_addr,     // sdram address bus 12 bits
   output [3:0]   dram_dqm,      // sdram data mask
   output         dram_we_n,     // sdram write enable
   output         dram_cas_n,    // sdram column address strobe
   output         dram_ras_n,    // sdram row address strobe
   output         dram_cs_n,     // sdram chip select
   output [1:0]   dram_ba,       // sdram bank address
   output         dram_clk,      // sdram clock
   output         dram_cke      // sdram clock enable
);
//*******************************************************
//Internal
//*******************************************************
//Local Parameters

//Wires

//Registers

//*******************************************************
//General Purpose Signals
//*******************************************************

//*******************************************************
//Outputs
//*******************************************************

//*******************************************************
//Instantiations
//*******************************************************

endmodule