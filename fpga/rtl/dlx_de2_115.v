//==================================================================================================
//  Filename      : dlx_de2_115.v
//  Created On    : 2014-06-27 09:44:21
//  Last Modified : 2014-06-27 10:51:13
//  Revision      : 
//  Author        : Linton Esteves
//  Company       : LSITEC
//  Email         : linton.esteves@lsitec.org
//
//  Description   : 
//
//
//==================================================================================================

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
//SDRAM
inout  [31:0] 	DRAM_DQ,			//	SDRAM Data bus 16 Bits
output [12:0]  DRAM_ADDR,		//	SDRAM Address bus 12 Bits
output [3:0]	DRAM_DQM,		//	SDRAM Data Mask
output			DRAM_WE_N,		//	SDRAM Write Enable
output			DRAM_CAS_N,		//	SDRAM Column Address Strobe
output			DRAM_RAS_N,		//	SDRAM Row Address Strobe
output			DRAM_CS_N,		//	SDRAM Chip Select
output [1:0]	DRAM_BA,			//	SDRAM Bank Address
output			DRAM_CLK,		//	SDRAM Clock
output			DRAM_CKE,		//	SDRAM Clock Enable
//SRAM
output      [19:0]    SRAM_ADDR,
output                SRAM_CE_N,
inout        [15:0]   SRAM_DQ,
output                SRAM_LB_N,
output                SRAM_OE_N,
output                SRAM_UB_N,
output                SRAM_WE_N,
);

endmodule
