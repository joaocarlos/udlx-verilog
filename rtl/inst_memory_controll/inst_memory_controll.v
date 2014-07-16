module inst_memory_controll
#(
   parameter DATA_WIDTH = 32,
   parameter DATA_ADDR_WIDTH = 32,      
   parameter SRAM_ADDR_WIDTH = 20,     
   parameter SRAM_DATA_WIDTH = 16      
)
(/*autoport*/

   input clk,
   input rst_n,
   output data_rd_en,
   output data_wr_en,
   output [DATA_ADDR_WIDTH-1:0] data_addr,
   input [DATA_WIDTH-1:0] data_in,
   output [DATA_WIDTH-1:0] data_out,
   //SRAM
   output   [SRAM_ADDR_WIDTH-1:0]    sram_addr,
   output   sram_ce_n,
   inout    [SRAM_DATA_WIDTH-1:0]   sram_dq,
   output   sram_lb_n,
   output   sram_oe_n,
   output   sram_ub_n,
   output   sram_we_n
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