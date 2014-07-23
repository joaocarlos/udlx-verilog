`include "../../fpga/rtl/dlx_de2_115_defines.v"

module top_tb;

parameter DATA_WIDTH = 32;
parameter DATA_ADDR_WIDTH = 20;
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
reg clk_proc;
reg clk_sram;
wire [DATA_WIDTH-1:0] gpio_o;
wire we_gpio;
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
         .clk_proc(clk_proc),
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
         .gpio_o(gpio_o),
         .we_gpio(we_gpio)
      );


sp_ram
#(
   .DATA_WIDTH(16),
   .ADDR_WIDTH(10)
)
sp_ram_u0
(
   .clk(clk_sram),
   .rd_ena(!sram_ce_n&sram_we_n),
   .wr_ena(!sram_ce_n&!sram_we_n),
   .address(sram_addr),
   .wr_data(sram_wr_data),
   .rd_data(sram_rd_data)
);


wire clk_dl;

assign #3 clk_dl =  dram_clk;

mt48lc8m16a2
  #(
    .data_bits(DATA_WIDTH/2),
    .addr_bits(DATA_ADDR_WIDTH)
  )
  sdram_memory_2
  (/*autoinst*/
    .Dq(dram_dq[31:16]),
    .Addr(dram_addr),
    .Ba(dram_ba),
    .Clk(clk_dl),
    .Cke(dram_cke),
    .Cs_n(dram_cs_n),
    .Ras_n(dram_ras_n),
    .Cas_n(dram_cas_n),
    .We_n(dram_we_n),
    .Dqm(dram_dqm)
  );

mt48lc8m16a2
  #(
    .data_bits(DATA_WIDTH/2),
    .addr_bits(DATA_ADDR_WIDTH)
  )
  sdram_memory_1
  (/*autoinst*/
    .Dq(dram_dq[15:0]),
    .Addr(dram_addr),
    .Ba(dram_ba),
    .Clk(clk_dl),
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
   .clk(clk_proc),
   .rst_n(rst_n),
   .rd_ena(boot_rom_rd_en),
   .address(boot_rom_addr),
   .data(boot_rom_rd_data)
);

initial begin
 clk = 0;
 clk_proc =0;
 clk_sram = 0;
end

always begin
   #100  clk = ~clk;
end

always begin
   #1000  clk_proc = ~clk_proc;
end


always begin
   #10  clk_sram = ~clk_sram;
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

reg [7:0]  display_1,
            display_2,
            display_3,
            display_4,
            display_5,
            display_6,
            display_7,
            display_8;

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      display_1 =  7'b1000000;
      display_2 =  7'b1000000;
      display_3 =  7'b1000000;
      display_4 =  7'b1000000;
      display_5 =  7'b1000000;
      display_6 =  7'b1000000;
      display_7 =  7'b1000000;
      display_8 =  7'b1000000;
   end
    else if (we_gpio) begin
       case (gpio_o[3:0])
         4'h0: display_1 = 7'b1000000;
         4'h1: display_1 = 7'b1111001;
         4'h2: display_1 = 7'b0100100;
         4'h3: display_1 = 7'b0110000;
         4'h4: display_1 = 7'b0011001;
         4'h5: display_1 = 7'b0010010;
         4'h6: display_1 = 7'b0000010;
         4'h7: display_1 = 7'b1111000;
         4'h8: display_1 = 7'b0000000;
         4'h9: display_1 = 7'b0011000;
         4'hA: display_1 = 7'b0001000;
         4'hB: display_1 = 7'b0000011;
         4'hC: display_1 = 7'b1000110;
         4'hD: display_1 = 7'b0100001;
         4'hE: display_1 = 7'b0000110;
         4'hF: display_1 = 7'b0001110;
         default: display_1 = 7'b0110110;
       endcase
       case (gpio_o[7:4])
         4'h0: display_2 = 7'b1000000;
         4'h1: display_2 = 7'b1111001;
         4'h2: display_2 = 7'b0100100;
         4'h3: display_2 = 7'b0110000;
         4'h4: display_2 = 7'b0011001;
         4'h5: display_2 = 7'b0010010;
         4'h6: display_2 = 7'b0000010;
         4'h7: display_2 = 7'b1111000;
         4'h8: display_2 = 7'b0000000;
         4'h9: display_2 = 7'b0011000;
         4'hA: display_2 = 7'b0001000;
         4'hB: display_2 = 7'b0000011;
         4'hC: display_2 = 7'b1000110;
         4'hD: display_2 = 7'b0100001;
         4'hE: display_2 = 7'b0000110;
         4'hF: display_2 = 7'b0001110;
         default: display_2 = 7'b0110110;
       endcase
       case (gpio_o[11:8])
         4'h0: display_3 = 7'b1000000;
         4'h1: display_3 = 7'b1111001;
         4'h2: display_3 = 7'b0100100;
         4'h3: display_3 = 7'b0110000;
         4'h4: display_3 = 7'b0011001;
         4'h5: display_3 = 7'b0010010;
         4'h6: display_3 = 7'b0000010;
         4'h7: display_3 = 7'b1111000;
         4'h8: display_3 = 7'b0000000;
         4'h9: display_3 = 7'b0011000;
         4'hA: display_3 = 7'b0001000;
         4'hB: display_3 = 7'b0000011;
         4'hC: display_3 = 7'b1000110;
         4'hD: display_3 = 7'b0100001;
         4'hE: display_3 = 7'b0000110;
         4'hF: display_3 = 7'b0001110;
         default: display_3 = 7'b0110110;
       endcase
       case (gpio_o[15:12])
         4'h0: display_4 = 7'b1000000;
         4'h1: display_4 = 7'b1111001;
         4'h2: display_4 = 7'b0100100;
         4'h3: display_4 = 7'b0110000;
         4'h4: display_4 = 7'b0011001;
         4'h5: display_4 = 7'b0010010;
         4'h6: display_4 = 7'b0000010;
         4'h7: display_4 = 7'b1111000;
         4'h8: display_4 = 7'b0000000;
         4'h9: display_4 = 7'b0011000;
         4'hA: display_4 = 7'b0001000;
         4'hB: display_4 = 7'b0000011;
         4'hC: display_4 = 7'b1000110;
         4'hD: display_4 = 7'b0100001;
         4'hE: display_4 = 7'b0000110;
         4'hF: display_4 = 7'b0001110;
         default: display_4 = 7'b0110110;
       endcase
       case (gpio_o[19:16])
         4'h0: display_5 = 7'b1000000;
         4'h1: display_5 = 7'b1111001;
         4'h2: display_5 = 7'b0100100;
         4'h3: display_5 = 7'b0110000;
         4'h4: display_5 = 7'b0011001;
         4'h5: display_5 = 7'b0010010;
         4'h6: display_5 = 7'b0000010;
         4'h7: display_5 = 7'b1111000;
         4'h8: display_5 = 7'b0000000;
         4'h9: display_5 = 7'b0011000;
         4'hA: display_5 = 7'b0001000;
         4'hB: display_5 = 7'b0000011;
         4'hC: display_5 = 7'b1000110;
         4'hD: display_5 = 7'b0100001;
         4'hE: display_5 = 7'b0000110;
         4'hF: display_5 = 7'b0001110;
         default: display_5 = 7'b0110110;
       endcase
       case (gpio_o[23:20])
         4'h0: display_6 = 7'b1000000;
         4'h1: display_6 = 7'b1111001;
         4'h2: display_6 = 7'b0100100;
         4'h3: display_6 = 7'b0110000;
         4'h4: display_6 = 7'b0011001;
         4'h5: display_6 = 7'b0010010;
         4'h6: display_6 = 7'b0000010;
         4'h7: display_6 = 7'b1111000;
         4'h8: display_6 = 7'b0000000;
         4'h9: display_6 = 7'b0011000;
         4'hA: display_6 = 7'b0001000;
         4'hB: display_6 = 7'b0000011;
         4'hC: display_6 = 7'b1000110;
         4'hD: display_6 = 7'b0100001;
         4'hE: display_6 = 7'b0000110;
         4'hF: display_6 = 7'b0001110;
         default: display_6 = 7'b0110110;
       endcase
       case (gpio_o[27:24])
         4'h0: display_7 = 7'b1000000;
         4'h1: display_7 = 7'b1111001;
         4'h2: display_7 = 7'b0100100;
         4'h3: display_7 = 7'b0110000;
         4'h4: display_7 = 7'b0011001;
         4'h5: display_7 = 7'b0010010;
         4'h6: display_7 = 7'b0000010;
         4'h7: display_7 = 7'b1111000;
         4'h8: display_7 = 7'b0000000;
         4'h9: display_7 = 7'b0011000;
         4'hA: display_7 = 7'b0001000;
         4'hB: display_7 = 7'b0000011;
         4'hC: display_7 = 7'b1000110;
         4'hD: display_7 = 7'b0100001;
         4'hE: display_7 = 7'b0000110;
         4'hF: display_7 = 7'b0001110;
         default: display_7 = 7'b0110110;
       endcase
       case (gpio_o[31:28])
         4'h0: display_8 = 7'b1000000;
         4'h1: display_8 = 7'b1111001;
         4'h2: display_8 = 7'b0100100;
         4'h3: display_8 = 7'b0110000;
         4'h4: display_8 = 7'b0011001;
         4'h5: display_8 = 7'b0010010;
         4'h6: display_8 = 7'b0000010;
         4'h7: display_8 = 7'b1111000;
         4'h8: display_8 = 7'b0000000;
         4'h9: display_8 = 7'b0011000;
         4'hA: display_8 = 7'b0001000;
         4'hB: display_8 = 7'b0000011;
         4'hC: display_8 = 7'b1000110;
         4'hD: display_8 = 7'b0100001;
         4'hE: display_8 = 7'b0000110;
         4'hF: display_8 = 7'b0001110;
         default: display_8 = 7'b0110110;
       endcase
   end
end
endmodule
