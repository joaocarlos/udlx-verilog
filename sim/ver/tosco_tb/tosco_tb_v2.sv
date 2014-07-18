module tosco_tb_v2;


reg clk, rst_n;


localparam DATA_WIDTH = 32;
localparam INST_ADDR_WIDTH = 20;
localparam ADDR_WIDTH = 20;
localparam DATA_ADDR_WIDTH = 32;
localparam SRAM_ADDR_WIDTH = 20;
localparam SRAM_DATA_WIDTH = 16;
localparam SDRAM_DATA_WIDTH = 32;
localparam SDRAM_ADDR_WIDTH = 20;
localparam SDRAM_DQM_WIDTH = 4;
localparam SDRAM_BA_WIDTH = 2;

wire data_rd_en;
wire data_wr_en;
wire [DATA_WIDTH-1:0] data_read;
wire [DATA_WIDTH-1:0] data_write;

wire instr_rd_en;
wire [INST_ADDR_WIDTH-1:0] instr_addr;
wire [DATA_WIDTH-1:0] instruction;

wire boot_mem_rd_en;
wire inst_mem_wr_en;

wire [ADDR_WIDTH-1:0] data_addr;
wire [DATA_WIDTH-1:0] data_out;
wire [DATA_WIDTH-1:0] data_in;
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

//boot
wire boot_mode;
wire boot_mem_wr_en;
wire [ADDR_WIDTH-1:0] boot_mem_addr;
wire [DATA_WIDTH-1:0] boot_mem_rd_data;
wire [DATA_WIDTH-1:0] boot_mem_wr_data;
// dlx ports interface
wire inst_mem_rd_en;
wire [DATA_WIDTH-1:0] inst_mem_wr_data;
wire [DATA_WIDTH-1:0] inst_mem_rd_data;
wire [ADDR_WIDTH-1:0] inst_mem_addr;
//sram insterface
wire sram_mem_wr_en;
wire sram_mem_rd_en;
wire [DATA_WIDTH-1:0] sram_mem_wr_data;
wire [DATA_WIDTH-1:0] sram_mem_rd_data;
wire [ADDR_WIDTH-1:0] sram_mem_addr;

wire inst_mem_rd_en_proc;
wire [19:0] inst_mem_addr_proc;
wire [31:0] inst_mem_rd_data_proc;
wire data_rd_en_proc;
wire data_wr_en_proc;
wire [19:0] data_addr_proc;
wire [31:0] data_read_proc;
wire [31:0] data_write_proc;

clk_rst_mngr
clk_rst_mngr_u0
   (
   .clk_in(clk),
   .rst_async_n(rst_n),
   .en_clk_div8(!boot_mode),
   .rst_sync_n(rst_sync_n),
   .clk_out(clk_out),
   .clk_div2(clk_div2),
   .clk_div4(clk_div4),
   .clk_div8(clk_div8),
   .clk_div8_proc(clk_div8_proc)
  );




dlx_processor
#(
   .DATA_WIDTH(DATA_WIDTH),
   .INST_ADDR_WIDTH(INST_ADDR_WIDTH),
   .DATA_ADDR_WIDTH(DATA_ADDR_WIDTH)
)
dlx_processor_u0
(
   .clk(clk_div8_proc),
   .rst_n(rst_sync_n),

   .instr_rd_en(inst_mem_rd_en_proc),
   .instr_addr(inst_mem_addr_proc),
   .instruction(inst_mem_rd_data_proc),

   .data_rd_en(data_rd_en_proc),
   .data_wr_en(data_wr_en_proc),
   .data_addr(data_addr_proc),
   .data_read(data_read_proc),
   .data_write(data_write_proc)
);

data_memory_controll
  #(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(ADDR_WIDTH),
   .SDRAM_DATA_WIDTH(SDRAM_DATA_WIDTH),
   .SDRAM_ADDR_WIDTH(SDRAM_ADDR_WIDTH)

  )
  memory_controll
  (/*autoport*/
   .clk(clk_out),
   .rst_n(rst_sync_n),
   .data_rd_en(data_rd_en_proc),
   .data_wr_en(data_wr_en_proc),
   .data_addr(data_addr_proc),
   .data_out(data_read_proc),
   .data_in(data_write_proc),
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

//Registers
assign dram_dq = &dram_dqm ?  {SDRAM_DATA_WIDTH {1'bZ}} : dram_dq_out;
assign dram_dq_in = dram_dq;

bootloader
#(
.DATA_WIDTH(DATA_WIDTH),
.ADDR_WIDTH(ADDR_WIDTH)
)
boot_loader_u0
(/*autoport*/
.clk(clk_div8),
.rst_n(rst_sync_n),
.boot_mode(boot_mode),
.boot_mem_rd_en(boot_mem_rd_en),
.boot_mem_addr(boot_mem_addr),
.boot_mem_rd_data(boot_mem_rd_data),

.inst_mem_wr_en(inst_mem_wr_en),
.inst_mem_wr_data(inst_mem_wr_data),
.inst_mem_addr(inst_mem_addr)
);

mux_sram
#(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(ADDR_WIDTH)
)
   mux_sram_u0
(/*autoport*/
   // boot ports interface
   .boot_mode(boot_mode),
   .boot_mem_wr_en(inst_mem_wr_en),
   .boot_mem_addr(inst_mem_addr),
   .boot_mem_rd_data(inst_mem_wr_data),
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

wire [19:0] sram_addr;
wire [31:0] sram_wr_data;
wire [31:0] sram_rd_data;

sram_fsm sram_fsm_u0(

    .clk(clk_div4),
    .rst_n(rst_sync_n),

    .wr_en(sram_mem_wr_en),
    .rd_en(sram_mem_rd_en),
    .wr_data(sram_mem_wr_data),
    .addr(sram_mem_addr),
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
    .data_bits(16),
    .addr_bits(SDRAM_ADDR_WIDTH)
  )
  sdram_memory_2
  (/*autoinst*/
    .Dq(dram_dq[31:16]),
    .Addr(dram_addr),
    .Ba(dram_ba),
    .Clk(clk_out),
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

rom
#(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(10)
)
rom_u0
(
   .clk(clk_div8),
   .rst_n(rst_sync_n),
   .rd_ena(boot_mem_rd_en),
   .address(boot_mem_addr),
   .data(boot_mem_rd_data)
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
