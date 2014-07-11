module inst_memory_controll
      #(
         parameter INST_DATA_WIDTH = 32,
         parameter INST_ADDR_DATA_WIDTH = 20,
         parameter SRAM_DATA_WIDTH = 16,
         parameter SRAM_ADDR_WIDTH = 20
            
      )
      (/*autoport*/
         input    clk,
         input    rst_n,
      //   input enable, //removed the clock gate
         input    instr_rd_en,
         input    [INST_ADDR_WIDTH-1:0] instr_addr,
         output   [INST_DATA_WIDTH-1:0] instruction,
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