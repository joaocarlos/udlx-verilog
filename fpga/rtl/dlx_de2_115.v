//==================================================================================================
//  Filename      : dlx_de2_115.v
//  Created On    : 2014-06-27 09:44:21
//  Last Modified : 2014-07-22 08:30:36
//  Revision      : 
//  Author        : Linton Esteves
//  Company       : LSITEC
//  Email         : linton.esteves@lsitec.org
//
//  Description   : 
//
//
//==================================================================================================

`include "dlx_de2_115_defines.v"

module dlx_de2_115 (
input CLOCK_50,
input CLOCK_27,
input [3:0] KEY,
input [17:0] SW,
//UART
input UART_RXD,
output UART_TXD,
//LED
output [17:0] LEDR,
output [8:0] LEDG,
//7SEG
output [6:0] HEX0,
output [6:0] HEX1,
output [6:0] HEX2,
output [6:0] HEX3,
output [6:0] HEX4,
output [6:0] HEX5,
output [6:0] HEX6,
output [6:0] HEX7,
//LCD
output LCD_RW,
output LCD_EN,
output LCD_RS,
output [7:0] LCD_DATA,
output LCD_ON,
output LCD_BLON,
//GPIO
inout [33:0] GPIO,
// output [35:0] GPIO_0,
// input  [35:0] GPIO_1,
//SRAM
`ifdef EXTERNAL_SRAM
output      [19:0]    SRAM_ADDR,
output                SRAM_CE_N,
inout        [15:0]   SRAM_DQ,
output                SRAM_LB_N,
output                SRAM_OE_N,
output                SRAM_UB_N,
output                SRAM_WE_N,
`endif
//SDRAM
inout  [31:0]  DRAM_DQ,       // SDRAM Data bus 16 Bits
output [12:0]  DRAM_ADDR,     // SDRAM Address bus 12 Bits
output [3:0]   DRAM_DQM,      // SDRAM Data Mask
output         DRAM_WE_N,     // SDRAM Write Enable
output         DRAM_CAS_N,    // SDRAM Column Address Strobe
output         DRAM_RAS_N,    // SDRAM Row Address Strobe
output         DRAM_CS_N,     // SDRAM Chip Select
output [1:0]   DRAM_BA,       // SDRAM Bank Address
output         DRAM_CLK,      // SDRAM Clock
output         DRAM_CKE//,    // SDRAM Clock Enable

);

parameter DATA_WIDTH = 32;
parameter DATA_ADDR_WIDTH = 20;
parameter INST_ADDR_WIDTH = 20;
parameter DQM_WIDTH = 4;
parameter BA_WIDTH = 2;

wire boot_rom_rd_en;
wire [INST_ADDR_WIDTH-1:0] boot_rom_addr;
wire [DATA_WIDTH-1:0] boot_rom_rd_data;
//clk rst manager
wire rst_sync_n;
wire clk_out;
wire clk_div2;
wire clk_div4;
wire clk_div8;
wire clk_40;
wire rst_n;


reg [6:0]  display_1, 
            display_2, 
            display_3, 
            display_4, 
            display_5, 
            display_6, 
            display_7,
            display_8;
`ifndef EXTERNAL_SRAM
wire SRAM_UB_N;
wire SRAM_LB_N;
wire SRAM_CE_N;
wire SRAM_WE_N;
wire SRAM_OE_N;
wire [INST_ADDR_WIDTH-1:0] SRAM_ADDR;
`endif
wire [DATA_WIDTH-1:0] SRAM_WR_DATA;
wire [DATA_WIDTH-1:0] SRAM_RD_DATA;
wire we_gpio;

wire [DATA_WIDTH-1:0] dram_dq_in;       // sdram data bus in 32 bits
wire [DATA_WIDTH-1:0] dram_dq_out;       // sdram data bus  out 32 bits

reg [31:0] count;
wire clk_1;

assign rst_n = KEY[0];

`ifdef EXTERNAL_SRAM
   assign SRAM_DQ = !SRAM_OE_N ?  {DATA_WIDTH {1'bZ}} : SRAM_WR_DATA;
   assign SRAM_RD_DATA = SRAM_DQ;
`endif

assign DRAM_DQ = &DRAM_DQM ?  {DATA_WIDTH {1'bZ}} : dram_dq_out;
assign dram_dq_in = DRAM_DQ;

wire [3:0] mode;

`ifdef USE_SDRAM
      assign mode = 'ha;
`else
      assign mode = 'hb;
`endif

`ifdef TEST_ONLY_SRAM
reg [DATA_WIDTH-1:0] gpio_o;
reg sram_mem_wr_en;
reg sram_mem_rd_en;
reg [DATA_WIDTH-1:0] sram_mem_wr_data;
wire [DATA_WIDTH-1:0] sram_mem_rd_data;
reg [INST_ADDR_WIDTH-1:0] sram_mem_addr;
reg [20:0] sram_count;
reg sram_mem_rd_en_reg;




always @(posedge clk_div8 or negedge rst_n) begin
   if (!rst_n) begin
      sram_count <= 32'd0;
   end
   else begin
      sram_count <= sram_count + 1'b1;
      if(sram_count == 50)begin
          sram_mem_wr_en = 1;
          sram_mem_rd_en = 0;
          sram_mem_addr = count;
          sram_mem_wr_data =  count + 32'd1;
      end
      else if (sram_count == 55) begin
          sram_mem_wr_en = 0;
          sram_mem_rd_en = 1;
          sram_mem_addr = count;
          sram_mem_wr_data =  32'd0;
      end
      else if (sram_count == 56) begin
          sram_mem_wr_en = 0;
          sram_mem_rd_en = 0;
          sram_mem_addr = 0;
          sram_mem_wr_data =  32'd0;
      end

   end
end

assign LEDR[0] = sram_mem_rd_en;
assign LEDR[1] = sram_mem_wr_en;

assign  we_gpio = 1'b1;

always @(posedge clk_div8 or negedge rst_n) begin
   if (!rst_n) begin
      gpio_o <= 32'd0;
      sram_mem_rd_en_reg <= 0; 
   end
   else begin
      sram_mem_rd_en_reg <= sram_mem_rd_en;
      if (sram_mem_rd_en_reg)
         gpio_o <= sram_mem_rd_data;
   end
end

always @(posedge clk_div8 or negedge rst_n) begin
    if (!rst_n) begin
       count <= 0;
    end
    else begin
      if (sram_count[20] && (sram_count[19:0] == 0))
       count <= count + 4;
    end
 end 

sram_ctrl 
   sram_ctrl_u0
   (
   .clk(clk_out),
   .rst_n(rst_n),
   .wr_en(sram_mem_wr_en),
   .rd_en(sram_mem_rd_en),
   .wr_data(sram_mem_wr_data),
   .addr({1'b0,sram_mem_addr[19:0]}),
   .rd_data(sram_mem_rd_data),
   .sram_ub_n(SRAM_UB_N),
   .sram_lb_n(SRAM_LB_N),
   .sram_ce_n(SRAM_CE_N),
   .sram_we_n(SRAM_WE_N),
   .sram_oe_n(SRAM_OE_N),
   .sram_addr(SRAM_ADDR),
   .sram_wr_data(SRAM_WR_DATA),
   .sram_rd_data(SRAM_RD_DATA)
   );  

// clk_rst_mngr
//    clk_rst_mngr_u0
//    (
//    .clk_in(clk_10),
//    .rst_async_n(rst_n),
//    .en_clk_div8(0),
//    .rst_sync_n(rst_sync_n),
//    .clk_out(clk_out),
//    .clk_div2(clk_div2),
//    .clk_div4(clk_div4),
//    .clk_div8(clk_div8),
//    .clk_div8_proc(clk_div8_proc)
//    );

`else
wire [DATA_WIDTH-1:0] gpio_o;

   top
      #(
         .DATA_WIDTH(DATA_WIDTH),
         .DATA_ADDR_WIDTH(DATA_ADDR_WIDTH),
         .INST_ADDR_WIDTH(INST_ADDR_WIDTH)
      )
      top_u0
      (/*autoport*/
         .clk(clk_10),
         .clk_proc(clk_1),
         .rst_n(rst_n),
         //boot rom memory interface
         .boot_rom_rd_en(boot_rom_rd_en),
         .boot_rom_addr(boot_rom_addr),
         .boot_rom_rd_data(boot_rom_rd_data),
         //sram interface
         .sram_ub_n(SRAM_UB_N),
         .sram_lb_n(SRAM_LB_N),
         .sram_ce_n(SRAM_CE_N),
         .sram_we_n(SRAM_WE_N),
         .sram_oe_n(SRAM_OE_N),
         .sram_addr(SRAM_ADDR),
         .sram_wr_data(SRAM_WR_DATA),
         .sram_rd_data(SRAM_RD_DATA),
         //SPRAM interface
         .dram_dq_in(dram_dq_in),       // sdram data bus in 32 bits
         .dram_dq_out(dram_dq_out),       // sdram data bus  out 32 bits
         .dram_addr(DRAM_ADDR),     // sdram address bus 12 bits
         .dram_dqm(DRAM_DQM),      // sdram data mask
         .dram_we_n(DRAM_WE_N),     // sdram write enable
         .dram_cas_n(DRAM_CAS_N),    // sdram column address strobe
         .dram_ras_n(DRAM_RAS_N),    // sdram row address strobe
         .dram_cs_n(DRAM_CS_N),     // sdram chip select
         .dram_ba(DRAM_BA),       // sdram bank address
         .dram_clk(DRAM_CLK),      // sdram clock
         .dram_cke(DRAM_CKE),
         // .rst_sync_n(rst_sync_n),
         // .clk_out(clk_out),
         // .clk_div2(clk_div2),
         // .clk_div4(clk_div4),
         // .clk_div8(clk_div8),
         .gpio_o(gpio_o),
         .we_gpio(we_gpio)
      );

boot_rom 
rom_u0
(
   .clk(clk_1),
   .rst_n(rst_n),
   .rd_ena(boot_rom_rd_en),
   .address(boot_rom_addr),
   .data(boot_rom_rd_data)
);

`endif
   

clk_40 
   clk_40_u0  (
      .inclk0(CLOCK_50),
      .c0(clk_40) 
   );
clk_10mhz 
   clk_10_u0  (
      .inclk0(CLOCK_50),
      .c0(clk_10) 
   );
clk_1mhz
   clk_1_u0  (
      .inclk0(CLOCK_50),
      .c0(clk_1) 
   );

// rom
//    rom_u0
//    (
//       .address(boot_rom_addr),
//       .clock(clk_div4),
//       .data(32'd0),
//       .rden(boot_rom_rd_en),
//       .wren(1'b0),     
//       .q(boot_rom_rd_data)
//    );



`ifndef EXTERNAL_SRAM
   sp_ram
   #(
      .DATA_WIDTH(16),
      .ADDR_WIDTH(10)
   )
   sp_ram_u0
   (
      .clk(clk_out),
      .rd_ena(!SRAM_CE_N&SRAM_WE_N),
      .wr_ena(!SRAM_CE_N&!SRAM_WE_N),
      .address(SRAM_ADDR),
      .wr_data(SRAM_WR_DATA),
      .rd_data(SRAM_RD_DATA)
   );
`endif
   

assign HEX0 = rst_n ? display_1 : 7'd0;
assign HEX1 = rst_n ? display_2 : 7'd0;
assign HEX2 = rst_n ? display_3 : 7'd0;
assign HEX3 = rst_n ? display_4 : 7'd0;
assign HEX4 = rst_n ? display_5 : 7'd0;
assign HEX5 = rst_n ? display_6 : 7'd0;
assign HEX6 = rst_n ? display_7 : 7'd0;
assign HEX7 = rst_n ? display_8 : 7'd0;





always @(posedge clk_1 or negedge rst_n) begin
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
       case (gpio_o[31:28])//mode[3:0])
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
