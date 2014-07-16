module tosco_tb;

parameter DATA_WIDTH = 32;
parameter DATA_ADDR_WIDTH = 32;
parameter INST_ADDR_WIDTH = 20;
parameter DQM_WIDTH = 4;
parameter BA_WIDTH = 2;
reg clk, rst_n;


wire boot_rom_rd_en;
wire [INST_ADDR_WIDTH-1:0] boot_rom_addr;
wire [DATA_WIDTH-1:0] boot_rom_rd_data;
//sram interface
wire sram_ub_n;
wire sram_lb_n;
wire sram_ce_n;
wire sram_we_n;
wire sram_oe_n;
wire [INST_ADDR_WIDTH-1:0] sram_addr;
wire [DATA_WIDTH-1:0] sram_wr_data;
wire [DATA_WIDTH-1:0] sram_rd_data;
//SPRAM interface
wire [DATA_WIDTH-1:0] dram_dq_in;       // sdram data bus in 32 bits
wire [DATA_WIDTH-1:0] dram_dq;       // sdram data bus  out 32 bits
wire [DATA_WIDTH-1:0] dram_dq_out;       // sdram data bus  out 32 bits
wire [INST_ADDR_WIDTH-1:0] dram_addr;     // sdram address bus 12 bits
wire [DQM_WIDTH-1:0] dram_dqm;      // sdram data mask
wire dram_we_n;     // sdram write enable
wire dram_cas_n;    // sdram column address strobe
wire dram_ras_n;    // sdram row address strobe
wire dram_cs_n;     // sdram chip select
wire [BA_WIDTH-1:0] dram_ba;       // sdram bank address
wire dram_clk;      // sdram clock
wire dram_cke;
//clk rst manager
wire rst_sync_n;
wire clk_out;
wire clk_div2;
wire clk_div4;
wire clk_div8;

//Registers
assign dram_dq = &dram_dqm ?  {DATA_WIDTH {1'bZ}} : dram_dq_out;
assign dram_dq_in = dram_dq;

top
      #(
         .DATA_WIDTH(DATA_WIDTH),
         .DATA_ADDR_WIDTH(DATA_ADDR_WIDTH),
         .INST_ADDR_WIDTH(INST_ADDR_WIDTH)
      )
      top_u0
      (/*autoport*/
         .clk(clk),
         .rst_n(rst_n),
         //boot rom memory interface
         .boot_rom_rd_en(boot_rom_rd_en),
         .boot_rom_addr(boot_rom_addr),
         .boot_rom_rd_data(boot_rom_rd_data),
         //sram interface
         .sram_ub_n(sram_ub_n),
         .sram_lb_n(sram_lb_n),
         .sram_ce_n(sram_ce_n),
         .sram_we_n(sram_we_n),
         .sram_oe_n(sram_oe_n),
         .sram_addr(sram_addr),
         .sram_wr_data(sram_wr_data),
         .sram_rd_data(sram_rd_data),
         //SPRAM interface
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
         .dram_cke(dram_cke),
         .rst_sync_n(rst_sync_n),
         .clk_out(clk_out),
         .clk_div2(clk_div2),
         .clk_div4(clk_div4),
         .clk_div8(clk_div8)
      );


sp_ram
#(
   .DATA_WIDTH(16),
   .ADDR_WIDTH(10)
)
sp_ram_u0
(
   .clk(clk_div4),
   .rd_ena(!sram_ce_n&sram_we_n),
   .wr_ena(!sram_ce_n&!sram_we_n),
   .address(sram_addr),
   .wr_data(sram_wr_data),
   .rd_data(sram_rd_data)
);

mt48lc8m16a2
  #(
    .data_bits(DATA_ADDR_WIDTH/2),
    .addr_bits(DATA_ADDR_WIDTH)
  )
  sdram_memory_2
  (/*autoinst*/
    .Dq(dram_dq[31:16]),
    .Addr(dram_addr),
    .Ba(dram_ba),
    .Clk(dram_clk),
    .Cke(dram_cke),
    .Cs_n(dram_cs_n),
    .Ras_n(dram_ras_n),
    .Cas_n(dram_cas_n),
    .We_n(dram_we_n),
    .Dqm(dram_dqm)
  );

mt48lc8m16a2
  #(
    .data_bits(DATA_ADDR_WIDTH/2),
    .addr_bits(DATA_ADDR_WIDTH)
  )
  sdram_memory_1
  (/*autoinst*/
    .Dq(dram_dq[15:0]),
    .Addr(dram_addr),
    .Ba(dram_ba),
    .Clk(dram_clk),
    .Cke(dram_cke),
    .Cs_n(dram_cs_n),
    .Ras_n(dram_ras_n),
    .Cas_n(dram_cas_n),
    .We_n(dram_we_n),
    .Dqm(dram_dqm)
  );

rom
#(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(10)
)
rom_u0
(
   .clk(clk_div8),
   .rst_n(rst_sync_n),
   .rd_ena(boot_rom_rd_en),
   .address(boot_rom_addr),
   .data(boot_rom_rd_data)
);

initial begin
 clk = 0;
end

always begin
   #10  clk = ~clk;
end

initial begin
rst_n = 1;
#10;
rst_n = 0;
#30;
@(posedge clk);
#1
rst_n = 1;
end

endmodule
