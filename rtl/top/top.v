module top
      #(
         parameter DATA_WIDTH = 32,
         parameter DATA_ADDR_WIDTH = 32,
         parameter INST_ADDR_WIDTH = 20,
         parameter DQM_WIDTH = 4,
         parameter BA_WIDTH = 2
      )
      (/*autoport*/
         input clk,
         input rst_n,
         input clk_proc,
         //boot rom memory interface
         output boot_rom_rd_en,
         output [INST_ADDR_WIDTH-1:0] boot_rom_addr,
         input [DATA_WIDTH-1:0] boot_rom_rd_data,
         //sram interface
         output sram_ub_n,
         output sram_lb_n,
         output sram_ce_n,
         output sram_we_n,
         output sram_oe_n,
         output [DATA_ADDR_WIDTH-1:0] sram_addr,
         output [DATA_WIDTH-1:0] sram_wr_data,
         input [DATA_WIDTH-1:0] sram_rd_data,
         //SPRAM interface
         input [DATA_WIDTH-1:0] dram_dq_in,       // sdram data bus in 32 bits
         output [DATA_WIDTH-1:0] dram_dq_out,       // sdram data bus  out 32 bits
         output [INST_ADDR_WIDTH-1:0] dram_addr,     // sdram address bus 12 bits
         output [DQM_WIDTH-1:0] dram_dqm,      // sdram data mask
         output dram_we_n,     // sdram write enable
         output dram_cas_n,    // sdram column address strobe
         output dram_ras_n,    // sdram row address strobe
         output dram_cs_n,     // sdram chip select
         output [BA_WIDTH-1:0] dram_ba,       // sdram bank address
         output dram_clk,      // sdram clock
         output dram_cke,
         output [DATA_WIDTH-1:0] gpio_o,
         output we_gpio

      );

//*******************************************************
//Internal
//*******************************************************
//Local Parameters

//Wires
//clk reset manager
wire boot_mode;

wire clk_div8_proc;
//processor   
wire inst_mem_rd_en_proc;
wire [INST_ADDR_WIDTH-1:0] inst_mem_addr_proc;
wire [DATA_WIDTH-1:0] inst_mem_rd_data_proc;
wire data_rd_en_proc;
wire data_wr_en_proc;
wire [DATA_ADDR_WIDTH-1:0] data_addr_proc;
wire [DATA_WIDTH-1:0] data_read_proc;
wire [DATA_WIDTH-1:0] data_write_proc;
//sram controll insterface
wire sram_mem_wr_en;
wire sram_mem_rd_en;
wire [DATA_WIDTH-1:0] sram_mem_wr_data;
wire [DATA_WIDTH-1:0] sram_mem_rd_data;
wire [INST_ADDR_WIDTH-1:0] sram_mem_addr;
//bootloader
wire boot_mem_wr_en;
wire [INST_ADDR_WIDTH-1:0] boot_mem_addr;
wire [DATA_WIDTH-1:0] boot_mem_wr_data;
//sdram mux
wire wr_en_sdram;
wire [DATA_WIDTH-1:0] wr_data_sdram;


dlx_processor
   #(
   .DATA_WIDTH(DATA_WIDTH),
   .INST_ADDR_WIDTH(INST_ADDR_WIDTH),
   .DATA_ADDR_WIDTH(DATA_ADDR_WIDTH)
   )
dlx_processor_u0
   (
   .clk(clk_proc),
   .rst_n(rst_n),
   .enable(1'b1),

   .instr_rd_en(inst_mem_rd_en_proc),
   .instr_addr(inst_mem_addr_proc),
   .instruction(inst_mem_rd_data_proc),

   .data_rd_en(data_rd_en_proc),
   .data_wr_en(data_wr_en_proc),
   .data_addr(data_addr_proc),
   .data_read(data_read_proc),
   .data_write(data_write_proc),
   .boot_mode(boot_mode)
   );

mux_sram
   #(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(INST_ADDR_WIDTH)
   )
   mux_sram_u0
   (/*autoport*/
   // boot ports interface
   .boot_mode(boot_mode),
   .boot_mem_wr_en(boot_mem_wr_en),
   .boot_mem_addr(boot_mem_addr),
   .boot_mem_rd_data(boot_mem_wr_data),
   // dlx ports interface
   .inst_mem_wr_en(1'b0),
   .inst_mem_rd_en(inst_mem_rd_en_proc),
   .inst_mem_wr_data(32'd0),
   .inst_mem_rd_data(inst_mem_rd_data_proc),
   .inst_mem_addr(inst_mem_addr_proc),
   //sram insterface
   .sram_mem_wr_en(sram_mem_wr_en),
   .sram_mem_rd_en(sram_mem_rd_en),
   .sram_mem_wr_data(sram_mem_wr_data),
   .sram_mem_rd_data(sram_mem_rd_data),
   .sram_mem_addr(sram_mem_addr)
   );

bootloader 
   #(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(INST_ADDR_WIDTH)
   )
   bootloader_u0
   (/*autoport*/
   .clk(clk_proc),
   .rst_n(rst_n),
   .boot_mode(boot_mode),
   .boot_mem_rd_en(boot_rom_rd_en),
   .boot_mem_addr(boot_rom_addr),
   .boot_mem_rd_data(boot_rom_rd_data),

   .inst_mem_wr_en(boot_mem_wr_en),
   .inst_mem_wr_data(boot_mem_wr_data),
   .inst_mem_addr(boot_mem_addr)
   );

sram_ctrl 
   sram_ctrl_u0
   (
   .clk(clk),
   .rst_n(rst_n),
   .clk_proc(clk_proc),
   .wr_en(sram_mem_wr_en),
   .rd_en(sram_mem_rd_en),
   .wr_data(sram_mem_wr_data),
   .addr({1'b0,sram_mem_addr[19:0]}),
   .rd_data(sram_mem_rd_data),
   .sram_ub_n(sram_ub_n),
   .sram_lb_n(sram_lb_n),
   .sram_ce_n(sram_ce_n),
   .sram_we_n(sram_we_n),
   .sram_oe_n(sram_oe_n),
   .sram_addr(sram_addr),
   .sram_wr_data(sram_wr_data),
   .sram_rd_data(sram_rd_data)
   );

mux_sdram
#(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(DATA_ADDR_WIDTH)
      
)
mux_sdram_u0
(/*autoport*/
   // inputs
   .wr_en(data_wr_en_proc),
   .wr_data(data_write_proc),
   .wr_address(data_addr_proc),
   // output
   .wr_en_sdram(wr_en_sdram),
   .wr_data_gpio(gpio_o),
   .we_gpio(we_gpio),
   .wr_data_sdram(wr_data_sdram)
);

data_memory_controll
  #(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(DATA_ADDR_WIDTH),
   .SDRAM_DATA_WIDTH(DATA_WIDTH),
   .SDRAM_ADDR_WIDTH(DATA_WIDTH)

  )
  data_memory_controll_u0
  (/*autoport*/
   .clk(clk),
   .rst_n(rst_n),
   .data_rd_en(data_rd_en_proc),
   .data_wr_en(wr_en_sdram),
   .data_addr(data_addr_proc),
   .data_out(data_read_proc),
   .data_in(wr_data_sdram),
   //SDRAM
   .dram_dq_in(dram_dq_in),       // sdram data bus in 32 bits
   .dram_dq_out(dram_dq_out),       // sdram data bus  out 32 bits
   .dram_addr(dram_addr),     // sdram address bus 12 bits
   .dram_dqm(dram_dqm),      // sdram data mask
   .dram_we_n(dram_we_n),     // sdram write enable
   .dram_cas_n(dram_cas_n),    // sdram column address strobe
   .dram_ras_n(dram_ras_n),    // sdram row address strobe
   .dram_cs_n(dram_cs_n),     // sdram chip select
   .dram_ba(dram_ba),       // sdram bank address
   .dram_clk(dram_clk),      // sdram clock
   .dram_cke(dram_cke)      // sdram clock enable
  );

endmodule
