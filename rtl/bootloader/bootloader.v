module bootloader
        #(
            parameter DATA_WIDTH = 32,
            parameter ADDR_WIDTH = 20
        )
        (/*autoport*/
            input clk,
            input rst_n,
            // boot memory ports interface
            output reg boot_mem_rd_en,
            output reg [ADDR_WIDTH-1:0] boot_mem_addr,
            input [DATA_WIDTH-1:0] boot_mem_rd_data,
            // inst memory ports interface
            output reg inst_mem_wr_en,
            output reg [DATA_WIDTH-1:0] inst_mem_wr_data,
            output reg [ADDR_WIDTH-1:0] inst_mem_addr,

            output reg boot_mode

        );
//*******************************************************
//Internal
//*******************************************************
//Local Parameters
localparam INIT_BOOT = 0,
           READ_BOOT = 1,
           WRITE_INST = 2,
           END_BOOT = 3;
localparam COUNT_WIDTH = ADDR_WIDTH;
localparam STATE_WIDTH = 2;
localparam SRAM_SIZE = 'h120;
//Wires

//Registers
reg [STATE_WIDTH-1:0]   state, 
                        next_state;

reg [COUNT_WIDTH-1:0] count;


//*******************************************************
//General Purpose Signals
//*******************************************************
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state = INIT_BOOT;
    end
    else begin
        state = next_state;
    end
end

always @(*) begin
   next_state = state;
   case (state)
      INIT_BOOT:
         next_state = READ_BOOT;
      READ_BOOT:
         next_state = WRITE_INST;
      WRITE_INST:
         if (count == SRAM_SIZE)
            next_state = END_BOOT;
         else begin
            next_state = READ_BOOT;
         end
   endcase     
end

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      count <= {COUNT_WIDTH{1'b0}};
   end
   else begin
      if (inst_mem_wr_en) begin
         count <= count + 1'b1;
      end
   end
end

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      boot_mode <= 1'b1;
   end
   else begin
      if (state == END_BOOT)
         boot_mode <= 1'b0;
   end
end

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      boot_mem_rd_en <= 1'b0;
   end
   else begin
      if (state == READ_BOOT) begin
         boot_mem_rd_en <= 1'b1;
      end
      else begin
         boot_mem_rd_en <= 1'b0;
      end
   end
end

always @(*) begin
     boot_mem_addr = count;
     inst_mem_wr_data = boot_mem_rd_data;
end

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      inst_mem_addr <= {ADDR_WIDTH{1'b0}};
      inst_mem_wr_en <= 1'b0;
   end
   else begin
      if (state == WRITE_INST) begin
         inst_mem_addr <= {count,2'b00};
         inst_mem_wr_en <= 1'b1;
      end
      else begin
         inst_mem_addr <= {ADDR_WIDTH{1'b0}};
         inst_mem_wr_en <= 1'b0;
      end
   end
end


//*******************************************************
//Outputs
//*******************************************************

//*******************************************************
//Instantiations
//*******************************************************

endmodule
