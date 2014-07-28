`timescale 1ns / 1ps
module data_memory_controll
      #(
         parameter DATA_WIDTH = 32,
         parameter ADDR_WIDTH = 32,
         parameter SDRAM_DATA_WIDTH = 32,
         parameter SDRAM_ADDR_WIDTH = 20,
         parameter SDRAM_DQM_WIDTH = 4,
         parameter SDRAM_BA_WIDTH = 2,
         parameter SDRAM_CLOCK = 25
            
            
      )
      (/*autoport*/
         input clk,
         input rst_n,
      //   input enable, //removed the clock gate
         input data_rd_en,
         input data_wr_en,
         input [ADDR_WIDTH-1:0] data_addr,
         output reg [DATA_WIDTH-1:0] data_out,
         input [DATA_WIDTH-1:0] data_in,
         output reg data_out_valid,
         output reg bus_busy,
         //SDRAM
         input  [SDRAM_DATA_WIDTH-1:0]  dram_dq_in,       // sdram data bus 16 bits
         output  [SDRAM_DATA_WIDTH-1:0]  dram_dq_out,       // sdram data bus 16 bits
         output reg [SDRAM_ADDR_WIDTH-1:0]  dram_addr,     // sdram address bus 12 bits
         output reg [SDRAM_DQM_WIDTH-1:0]   dram_dqm,      // sdram data mask
         output reg dram_we_n,     // sdram write enable
         output reg dram_cas_n,    // sdram column address strobe
         output reg dram_ras_n,    // sdram row address strobe
         output reg dram_cs_n,     // sdram chip select
         output reg [SDRAM_BA_WIDTH-1:0]   dram_ba,       // sdram bank address
         output dram_clk,      // sdram clock
         output reg dram_cke      // sdram clock enable
      );
//*******************************************************
//Internal
//*******************************************************
//Local Parameters
//SDRAM fixed configuration
localparam BURST_LENGH = 3'd0; //burst lenght
localparam BURST_TYPE = 2'd0; //burst type
localparam LATENCY_MODE = 3'b010; //latency mode
localparam OPERATION_MODE = 2'b00; //operation mode
localparam WRITE_OPERATION_MODE = 1'b1; //write operation mode
localparam CAS_LATENCY = 2;
localparam READ_LATENCY = 3;
localparam WRITE_LATENCY = 3;
localparam ACTIVATE_LATENCY = 2;
localparam PRECHARGE_LATENCY = 1;
localparam INIT_LATENCY = 16;

localparam  NOP_CMD = 1,
            READ_CMD = 2,
            WRITE_CMD = 3,
            PRECHARGE_CMD = 4,
            ACTIVATE_CMD = 0,
            INIT_CMD = 6,
            AUTO_REFRESH_CMD = 5,
            PRECHARGE_ALL_CMD = 7,
            MODE_REGISTER_CMD = 8,
            SELF_REFRESH_CMD = 9,
            SELF_REFRESH_EXIT_CMD = 10,
            READ_AUTO_CMD = 1,
            WRITE_AUTO_CMD = 11;

localparam SDRAM_COMMAND_WIDTH = 4;

localparam STATE_WIDTH = 4;

localparam  INITIALIZE_SDRAM = 0,
            LOAD_MODE_REGISTER = 1,
            IDLE = 2,
            READ_DATA = 3,
            WRITE_DATA = 4,
            ACTIVATE_BANK = 5,
            PRECHARGE = 6,
            READ_DATA_ACT = 7, 
            WRITE_DATA_ACT = 8;
localparam COUNT_WIDTH = 5;
//Wires
wire [12:0] row_address;
wire [1:0] bank_address;
wire [9:0] col_address;
 
//Registers
reg [SDRAM_COMMAND_WIDTH-1:0] sdram_command;

reg [COUNT_WIDTH-1:0] count_state; // atualizar depois

//*******************************************************
//General Purpose Signals
//*******************************************************
reg [STATE_WIDTH-1:0] state, 
                      next_state;

reg data_rd_en_reg;
reg data_wr_en_reg;

reg [ADDR_WIDTH-1:0] data_addr_reg;
reg [DATA_WIDTH-1:0] data_in_reg;

//IS4216320B
assign bank_address = data_addr_reg[13:12];
assign row_address = data_addr_reg[26:14];
assign col_address = data_addr_reg[11:2];

//MT48LC8M16A2
//assign bank_address = data_addr_reg[12:11]; //2
//assign row_address = data_addr_reg[24:13]; //12
//assign col_address = data_addr_reg[10:2]; //9


//assign bank_address = data_addr_reg[12:11];
//assign row_address = data_addr_reg[10:1];
//assign col_address = {1'b0, data_addr_reg[0]};
assign dram_dq_out = data_in_reg;


always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      data_addr_reg <= {ADDR_WIDTH{1'b0}};
      data_in_reg <= {DATA_WIDTH{1'b0}};
   end
   else if ((state == IDLE) && (data_rd_en || data_wr_en)) begin
      data_addr_reg <= data_addr;
      data_in_reg <= data_in;
   end
end

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      state <= INITIALIZE_SDRAM;
   end
   else begin
      state <= next_state;
   end
end

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      data_rd_en_reg <= 1'b0;
      data_wr_en_reg <= 1'b0;
   end
   else begin
      if (state == IDLE) begin
         data_rd_en_reg <= data_rd_en;
         data_wr_en_reg <= data_wr_en;
      end
      else if ((state == PRECHARGE)&& (count_state == 0))  begin
         data_rd_en_reg <= 1'b0;
         data_wr_en_reg <= 1'b0;
      end
   end
end

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      data_out_valid <= 1'b0;
      data_out <= {DATA_WIDTH{1'b0}};
   end
   else begin
      if ((state == READ_DATA ) && count_state == 2) begin
         data_out_valid <= 1'b1;
         data_out <= dram_dq_in;
      end
      else begin
         data_out_valid <= 1'b0;
      end
   end
end

always @(*) begin
   if (state == IDLE)
      bus_busy = 1'b0;
   else begin
      bus_busy = 1'b1;
   end
end

always @(*) begin
   next_state = state;
   sdram_command = NOP_CMD;
   case (state)
      INITIALIZE_SDRAM: begin
         if (count_state == 0)
            sdram_command = NOP_CMD;
         else if (count_state == 5'd1)
            sdram_command = PRECHARGE_ALL_CMD;
         else if (count_state == 5'd2)
            sdram_command = AUTO_REFRESH_CMD;
         else if (count_state == 5'd3)
            sdram_command = NOP_CMD;
         else if (count_state == 5'd4)
            sdram_command = AUTO_REFRESH_CMD;
         else if (count_state == 5'd5)
            sdram_command = NOP_CMD;
         else if (count_state == 5'd6)
            sdram_command = AUTO_REFRESH_CMD;
         else if (count_state == 5'd7)
            sdram_command = NOP_CMD;
         else if (count_state == 5'd8)
            sdram_command = AUTO_REFRESH_CMD;
         else if (count_state == 5'd9)
            sdram_command = NOP_CMD;
         else if (count_state == 5'd10)
            sdram_command = AUTO_REFRESH_CMD;
         else if (count_state == 5'd11)
            sdram_command = NOP_CMD;
         else if (count_state == 5'd12)
            sdram_command = AUTO_REFRESH_CMD;
         else if (count_state == 5'd13)
            sdram_command = NOP_CMD;
         else if (count_state == 5'd14)
            sdram_command = AUTO_REFRESH_CMD;
         else if (count_state == 5'd15)
            sdram_command = NOP_CMD;
         else if (count_state == 5'd16) begin
            sdram_command = AUTO_REFRESH_CMD;
            next_state = LOAD_MODE_REGISTER;
         end
      end
      LOAD_MODE_REGISTER: begin
         sdram_command = MODE_REGISTER_CMD;
         next_state = IDLE;
      end
      IDLE: begin
         sdram_command = NOP_CMD;
         if (data_rd_en || data_wr_en_reg) begin
            next_state = ACTIVATE_BANK;
         end
      end
      ACTIVATE_BANK: begin
         if (count_state == 5'd0)
            sdram_command = ACTIVATE_CMD;
         else if (count_state == ACTIVATE_LATENCY) begin      
            if (data_rd_en_reg) begin
               next_state = READ_DATA;
            end
            else begin
               next_state = WRITE_DATA;
            end
         end
         else 
            sdram_command = NOP_CMD;
      end
      WRITE_DATA: begin
         if (count_state == 5'd0)
            sdram_command = WRITE_CMD;
         else if (count_state == WRITE_LATENCY) begin         
            next_state = PRECHARGE; 
            sdram_command = NOP_CMD;
         end
         else 
            sdram_command = NOP_CMD;
      end
      READ_DATA: begin
         if (count_state == 5'd0)
            sdram_command = READ_CMD;
         else if (count_state == READ_LATENCY) begin         
            next_state = PRECHARGE;
            sdram_command = NOP_CMD;
         end
         else 
            sdram_command = NOP_CMD;
      end
      PRECHARGE: begin
         if (count_state == 5'd0)
            sdram_command = PRECHARGE_CMD;
         else if (count_state == PRECHARGE_LATENCY) begin         
            next_state = IDLE;
            sdram_command = NOP_CMD;
         end
         else 
            sdram_command = NOP_CMD;
      end
   endcase
end

always @(*) begin
   case (state)
      READ_DATA: begin 
         if (sdram_command == READ_CMD) 
            dram_dqm = 4'b0000;
         else begin
            dram_dqm = 4'b1111;
         end
      end
      WRITE_DATA: dram_dqm = 4'b0000;  
      default : dram_dqm = 4'b1111;
   endcase
end


// cke, cs, cas, ras and we logic
always @(*) begin
   case (sdram_command)
      NOP_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b1;
         dram_cas_n = 1'b1;
         dram_we_n = 1'b1;
         dram_ba = 2'b00; //dont care
         dram_addr = {SDRAM_ADDR_WIDTH{1'b0}};//dont care
         dram_cke = 1'b1;
      end
      READ_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b1;
         dram_cas_n = 1'b0;
         dram_we_n = 1'b1;
         dram_ba = bank_address; //valid
         dram_addr[12:11] = 0;//col_address; //valid
         dram_addr[10] = 1'b0;
         dram_addr[9:0] = col_address; //valid
         dram_cke = 1'b1;
      end
      READ_AUTO_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b1;
         dram_cas_n = 1'b0;
         dram_we_n = 1'b1;
         dram_ba = 2'b00; //valid
         dram_addr[12:11] = 2'd0; //valid
         dram_addr[10] = 1'b1;
         dram_addr[9:0] = 10'd0; //valid
         dram_cke = 1'b1;
      end
      WRITE_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b1;
         dram_cas_n = 1'b0;
         dram_we_n = 1'b0;
         dram_ba = bank_address; //valid
         dram_addr[12:11] = 0;//col_address; //valid
         dram_addr[10] = 1'b0;
         dram_addr[9:0] = col_address; //valid
         dram_cke = 1'b1;
      end
      WRITE_AUTO_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b1;
         dram_cas_n = 1'b0;
         dram_we_n = 1'b0;
         dram_ba = 2'b00; //valid
         dram_addr[12:11] = 2'd0; //valid   
         dram_addr[10] = 1'b1;
         dram_addr[9:0] = 10'd0; //valid
         dram_cke = 1'b1;
      end
      //precharge all banks
      PRECHARGE_ALL_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b0;
         dram_cas_n = 1'b1;
         dram_we_n = 1'b0;
         dram_ba = 2'b00; //dont care
         dram_addr[12:11] = 2'd0; //dont care
         dram_addr[10] = 1'b1;
         dram_addr[9:0] = 10'd0; //dont care
         dram_cke = 1'b1;
      end
      //precharge selected bank
      PRECHARGE_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b0;
         dram_cas_n = 1'b1;
         dram_we_n = 1'b0;
         dram_ba = bank_address; //valid
         dram_addr[12:11] = 2'd0; //dont care
         dram_addr[10] = 1'b0;
         dram_addr[9:0] = 10'd0; //dont care
         dram_cke = 1'b1;
      end
      MODE_REGISTER_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b0;
         dram_cas_n = 1'b0;
         dram_we_n = 1'b0;
         dram_ba = 2'b00; //dont care
         dram_addr[2:0] = BURST_LENGH; //burst lenght
         dram_addr[3] = BURST_TYPE; //burst type
         dram_addr[6:4] = LATENCY_MODE; //latency mode
         dram_addr[8:7] = OPERATION_MODE; //operation mode
         dram_addr[9] = WRITE_OPERATION_MODE; //write operation mode
         dram_addr[10] = 1'b0; //dont care
         dram_cke = 1'b1;
      end
      ACTIVATE_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b0;
         dram_cas_n = 1'b1;
         dram_we_n = 1'b1;
         dram_ba = bank_address; //valid
         dram_addr[12:11] = col_address; //valid
         dram_addr[10] = 1'b0;
         dram_addr[12:0] = row_address; //valid
         dram_cke = 1'b1;
      end
      AUTO_REFRESH_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b0;
         dram_cas_n = 1'b0;
         dram_we_n = 1'b1;
         dram_ba = 2'b00; //valid
         dram_addr = {SDRAM_ADDR_WIDTH {1'd0}}; // dont care
         dram_cke = 1'b1;
      end
      SELF_REFRESH_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b0;
         dram_cas_n = 1'b0;
         dram_we_n = 1'b1;
         dram_ba = 2'b00; //valid
         dram_addr = {SDRAM_ADDR_WIDTH {1'd0}}; // dont care
         dram_cke = 1'b0;
      end
      SELF_REFRESH_EXIT_CMD: begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b1;
         dram_cas_n = 1'b1;
         dram_we_n = 1'b1;
         dram_ba = 2'b00; //valid
         dram_addr = {SDRAM_ADDR_WIDTH {1'd0}}; // dont care
         dram_cke = 1'b1;
      end
      default begin
         dram_cs_n = 1'b0;
         dram_ras_n = 1'b1;
         dram_cas_n = 1'b1;
         dram_we_n = 1'b1;
         dram_ba = 2'b00; //dont care
         dram_addr = {SDRAM_ADDR_WIDTH{1'b0}};//dont care
         dram_cke = 1'b1;
      end
   endcase
end

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      count_state <= 5'd0;
   end
   else begin
      case (state)
         INITIALIZE_SDRAM: begin
            if (count_state == INIT_LATENCY) begin
               count_state <= 5'd0;
            end
            else begin
               count_state <= count_state + 5'd1;
            end
         end
         ACTIVATE_BANK: begin
             if (count_state == ACTIVATE_LATENCY) begin
               count_state <= 5'd0;
            end
            else begin
               count_state <= count_state + 5'd1;
            end
         end
         READ_DATA: begin
             if (count_state == READ_LATENCY) begin
               count_state <= 5'd0;
            end
            else begin
               count_state <= count_state + 5'd1;
            end
         end
         WRITE_DATA: begin
             if (count_state == WRITE_LATENCY) begin
               count_state <= 5'd0;
            end
            else begin
               count_state <= count_state + 5'd1;
            end
         end
         PRECHARGE: begin
             if (count_state == PRECHARGE_LATENCY) begin
               count_state <= 5'd0;
            end
            else begin
               count_state <= count_state + 5'd1;
            end
         end
         IDLE:
            count_state <= 5'd0;
      endcase
   end
end

//*******************************************************
//Outputs
//*******************************************************
assign dram_clk = clk;
//*******************************************************
//Instantiations
//*******************************************************

endmodule
