module sram_fsm (
    
	 input clk,
	 input rst_n,
	 
    input wr_en,
    input rd_en,
    input [31:0] wr_data,
    input [20:0] addr,
    output [31:0] rd_data,

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
parameter ST_READ_0  = 2;
parameter ST_READ_1  = 3;

reg [1:0] state;
reg [1:0] next_state;

reg [20:0] addr_reg;
reg [15:0] wr_data_reg;
reg [31:0] rd_data_reg;
wire [20:0] addr_plus2;
wire [31:0] rd_data_concat;

assign sram_ub_n = 1'b0;
assign sram_lb_n = 1'b0;

assign addr_plus2 = addr_reg+2;


assign rd_data_concat = {sram_rd_data,rd_data_reg[15:0]};

assign rd_data = (state==ST_READ_1)?rd_data_concat:rd_data_reg;

always@(posedge clk, negedge rst_n)begin
   if(!rst_n)begin
       addr_reg <= 0;
       wr_data_reg <= 0;

       sram_ce_n <= 0;
       sram_we_n <= 0;
       sram_oe_n <= 0;
       sram_addr <= 0;
       sram_wr_data <= 0;
   end
   else begin
      case(next_state)
			ST_IDLE: begin
				addr_reg <= addr;
				wr_data_reg <= wr_data[31:16];
				if(wr_en)begin //write
					sram_ce_n <= 1'b0;
					sram_we_n <= 1'b0;
					sram_oe_n <= 1'b1;
					sram_addr <= addr[20:1];
					sram_wr_data <= wr_data[15:0];
				end
				else if (rd_en) begin//read
					sram_ce_n <= 1'b0;
					sram_we_n <= 1'b1;
					sram_oe_n <= 1'b0;
					sram_addr <= addr[20:1];
				end
				else begin
					sram_ce_n <= 1'b1;
					sram_we_n <= 1'b1;
					sram_oe_n <= 1'b0;
				end
			end
			ST_WRITE_0: begin
				sram_ce_n <= 1'b0;
				sram_we_n <= 1'b0;
				sram_oe_n <= 1'b1;
				sram_addr <= addr_plus2[20:1];
				sram_wr_data <= wr_data_reg;
			end
			ST_READ_0: begin
				sram_ce_n <= 1'b0;
				sram_we_n <= 1'b1;
				sram_oe_n <= 1'b0;
				sram_addr <= addr_plus2[20:1];

				rd_data_reg[15:0] <= sram_rd_data;
			end
			ST_READ_1: begin
				sram_ce_n <= 1'b1;
				sram_we_n <= 1'b1;
				sram_oe_n <= 1'b0;
				
				rd_data_reg[31:16] <= sram_rd_data;
			end
			default: begin
				addr_reg <= addr;
				wr_data_reg <= wr_data[31:16];
				if(wr_en)begin //write
					sram_ce_n <= 1'b0;
					sram_we_n <= 1'b0;
					sram_oe_n <= 1'b1;
					sram_addr <= addr[20:1];
					sram_wr_data <= wr_data[15:0];
				end
				else if (rd_en) begin//read
					sram_ce_n <= 1'b0;
					sram_we_n <= 1'b1;
					sram_oe_n <= 1'b0;
					sram_addr <= addr[20:1];
				end
				else begin
					sram_ce_n <= 1'b1;
					sram_we_n <= 1'b1;
					sram_oe_n <= 1'b0;
				end
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
       if(wr_en)
          next_state = ST_WRITE_0;
       else if(rd_en)
          next_state = ST_READ_0;
       else
          next_state = ST_IDLE;
      end
      ST_WRITE_0: begin
         next_state = ST_IDLE;
      end
      ST_READ_0: begin
         next_state = ST_READ_1;
      end
      ST_READ_1: begin
         next_state = ST_IDLE;
      end
      default:begin
         next_state = ST_IDLE;
      end
   endcase
end



endmodule
