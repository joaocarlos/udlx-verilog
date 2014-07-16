`timescale 1ns / 1ps
module data_memory_controller_tb;
//*******************************************************
//Internal
//*******************************************************
//Local Parameters


parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 20;
parameter SDRAM_DATA_WIDTH = 32;
parameter SDRAM_ADDR_WIDTH = 20;
parameter SDRAM_DQM_WIDTH = 4;
parameter SDRAM_BA_WIDTH = 2;
//Wires

reg    clk;
reg    rst_n;
reg data_rd_en;
reg data_wr_en;
reg [ADDR_WIDTH-1:0] data_addr;
wire [DATA_WIDTH-1:0] data_out;
reg [DATA_WIDTH-1:0] data_in;
//SRAM
wire  [SDRAM_DATA_WIDTH-1:0]  dram_dq;       // sdram data bus 16 bits
wire  [SDRAM_DATA_WIDTH-1:0]  dram_dq_in;       // sdram data bus 16 bits
wire  [SDRAM_DATA_WIDTH-1:0]  dram_dq_out;       // sdram data bus 16 bits
wire [SDRAM_ADDR_WIDTH-1:0]  dram_addr;     // sdram address bus 12 bits
wire [SDRAM_DQM_WIDTH-1:0]   dram_dqm;      // sdram data mask
wire         dram_we_n;     // sdram write enable
wire         dram_cas_n;    // sdram column address strobe
wire         dram_ras_n;    // sdram row address strobe
wire         dram_cs_n;     // sdram chip select
wire [SDRAM_BA_WIDTH-1:0]   dram_ba;       // sdram bank address
wire         dram_clk;      // sdram clock
wire         dram_cke;     // sdram clock enable



//Registers
assign dram_dq = &dram_dqm ?  {SDRAM_DATA_WIDTH {1'bZ}} : dram_dq_out;
assign dram_dq_in = dram_dq;

//*******************************************************
//General Purpose Signals
//*******************************************************

initial begin
   clk = 0;
   #2
   rst_n = 1;
   #2
   rst_n = 0;
   #2
   rst_n = 1;
end

always begin
   clk = #1 ~clk;
end

initial begin
  #10
  data_rd_en = 0;
  data_wr_en = 0;
  data_addr = 0;
  data_in = 32'd0;
  wait(memory_controll.bus_busy == 0); //initialize sdram
  @(posedge clk)
  data_wr_en = 1;
  data_addr = 788;
  data_in = 32'habcdef98;
  @(posedge clk)
  data_wr_en = 0;  
  #5
  wait(memory_controll.bus_busy == 0); //write
  @(posedge clk)
  data_wr_en = 1;
  data_addr = 1985;
  data_in = 32'h01234567;
  @(posedge clk)
  data_wr_en = 0;
  #5
  wait(memory_controll.bus_busy == 0); //write
  @(posedge clk)
  data_rd_en = 1;
  data_addr = 788;
  @(posedge clk)
  data_rd_en = 0;
  #5
  wait(memory_controll.bus_busy == 0); //read
  @(posedge clk)
  data_rd_en = 1;
  data_addr = 1985;
  @(posedge clk)
  data_rd_en = 0;
  #5
  wait(memory_controll.bus_busy == 0); //read
  #50
  $stop();

end

//*******************************************************
//Instantiations
//*******************************************************

data_memory_controll
  #(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(ADDR_WIDTH),
   .SDRAM_DATA_WIDTH(SDRAM_DATA_WIDTH),
   .SDRAM_ADDR_WIDTH(SDRAM_ADDR_WIDTH)
       
  )
  memory_controll
  (/*autoport*/
	.clk(clk),
	.rst_n(rst_n),
	.data_rd_en(data_rd_en),
	.data_wr_en(data_wr_en),
	.data_addr(data_addr),
	.data_out(data_out),
	.data_in(data_in),
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

mt48lc8m16a2
  #(
    .data_bits(16),
    .addr_bits(SDRAM_ADDR_WIDTH)
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
    .data_bits(16),
    .addr_bits(SDRAM_ADDR_WIDTH)
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
  
endmodule