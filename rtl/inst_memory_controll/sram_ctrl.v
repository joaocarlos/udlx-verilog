module sram_ctrl (
    
    input clk,
    input rst_n,
    input clk_proc,
    
    input wr_en,
    input rd_en,
    input [31:0] wr_data,
    input [20:0] addr,
    output reg [31:0] rd_data,

    output sram_ub_n,
    output sram_lb_n,
    output reg sram_ce_n,
    output reg sram_we_n,
    output reg sram_oe_n,
    output reg [19:0] sram_addr,
    output reg [15:0] sram_wr_data,
    input [15:0] sram_rd_data
  );

parameter ST_IDLE    = 0;
parameter ST_WRITE_0 = 1;
parameter ST_WRITE_1 = 2;
parameter ST_READ_0  = 3;
parameter ST_READ_1  = 4;
parameter ST_READ_2  = 5;

reg [2:0] state;
reg [2:0] next_state;

reg [2:0]  counter;

reg [31:0] rd_data_reg;
wire [20:0] addr_plus2;

reg wr_data_dly;
reg rd_data_dly;
reg wr_detc;
//wire rd_detc;
reg clk_proc_pulse;
reg clk_proc_dly;

//wire [31:0] rd_data_concat;

assign sram_ub_n = 1'b0;
assign sram_lb_n = 1'b0;

assign addr_plus2 = addr+2;


//assign rd_data_concat = {sram_rd_data,rd_data_reg[15:0]};

always@(posedge clk, negedge rst_n)begin
  if(!rst_n)begin
    rd_data <= 0;
  end
  else begin
    if(state == ST_IDLE)begin
      rd_data <= rd_data_reg;
    end
  end
end

always@(posedge clk, negedge rst_n)begin
   if(!rst_n)begin
      wr_data_dly <= 1'b0;
      clk_proc_dly <= 1'b0;
      wr_detc <= 1'b0;
      clk_proc_pulse <= 1'b0;
   end
   else begin
      wr_data_dly <= wr_en;
      wr_detc <= wr_en & !wr_data_dly;
      clk_proc_dly <= clk_proc;
      clk_proc_pulse <= clk_proc & !clk_proc_dly;
   end
end

always@(posedge clk, negedge rst_n)begin
   if(!rst_n)begin
      rd_data_reg <= 32'd0;
      sram_ce_n = 1'b0;
      sram_we_n = 1'b0;
      sram_oe_n = 1'b1;
      sram_wr_data = 0;
      sram_addr = 0;
   end
   else begin
      case(state)
	 ST_IDLE: begin
            if(wr_detc)begin //write
               sram_ce_n <= 1'b0;
               sram_we_n <= 1'b0;
               sram_oe_n <= 1'b1;
               sram_wr_data <= wr_data[15:0];
               sram_addr <= addr[20:1];
            end
            else if (rd_en && clk_proc_pulse) begin//read
               sram_ce_n <= 1'b0;
               sram_we_n <= 1'b1;
               sram_oe_n <= 1'b0;
               sram_addr <= addr[20:1];
            end
            else begin
               sram_ce_n <= 1'b1;
               sram_we_n <= 1'b1;
               sram_oe_n <= 1'b1;
               sram_addr <= 20'd0;
               sram_wr_data <= 16'd0;
            end
	 end
         ST_WRITE_0: begin
            sram_ce_n <= 1'b1;
            sram_we_n <= 1'b1;
            sram_oe_n <= 1'b1;
	    sram_wr_data <= 0;
            sram_addr <= 0;
	 end
         ST_WRITE_1: begin
            sram_ce_n <= 1'b0;
            sram_we_n <= 1'b0;
            sram_oe_n <= 1'b1;
	    sram_wr_data <= wr_data[31:16];
            sram_addr <= addr_plus2[20:1];
	 end
         ST_READ_0: begin
            sram_ce_n <= 1'b1;
            sram_we_n <= 1'b1;
            sram_oe_n <= 1'b0;
            sram_addr <= 0;
         end
         ST_READ_1: begin
            sram_ce_n <= 1'b0;
            sram_we_n <= 1'b1;
            sram_oe_n <= 1'b0;
            sram_addr <= addr_plus2[20:1];
            rd_data_reg[15:0] <= sram_rd_data;
         end
         ST_READ_2: begin
            sram_ce_n <= 1'b1;
            sram_we_n <= 1'b1;
            sram_oe_n <= 1'b0;
            sram_addr <= addr_plus2[20:1];
            rd_data_reg[31:16] <= sram_rd_data;
	 end
         default: begin
            sram_ce_n <= 1'b1;
            sram_we_n <= 1'b1;
            sram_oe_n <= 1'b1;
            rd_data_reg <= rd_data_reg;
         end
      endcase
   end
end

always@(posedge clk, negedge rst_n)begin
   if(!rst_n)begin
      state <= ST_IDLE;
   end
   else begin
      state <= next_state;
   end
end


always@(*)begin
   case (state)
      ST_IDLE: begin
       if(wr_detc)
          next_state = ST_WRITE_0;
       else if(rd_en && clk_proc_pulse)
          next_state = ST_READ_0;
       else
          next_state = ST_IDLE;
      end
      ST_WRITE_0: begin
         next_state = ST_WRITE_1;
      end
      ST_WRITE_1: begin
         next_state = ST_IDLE;
      end
      ST_READ_0: begin
         next_state = ST_READ_1;
      end
      ST_READ_1: begin
         next_state = ST_READ_2;
      end
      ST_READ_2: begin
        next_state = ST_IDLE;
      end
      default:begin
         next_state = ST_IDLE;
      end
   endcase
end



endmodule
