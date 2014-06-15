module sp_ram
#(
   parameter DATA_WIDTH = 32,
   parameter ADDR_WIDTH = 32
)
(
   input clk,
   input rd_ena,
   input wr_ena,
   input [ADDR_WIDTH-1:0] address,
   input [DATA_WIDTH-1:0] wr_data,
   output reg [DATA_WIDTH-1:0] rd_data
);

localparam MEM_SIZE = 2**ADDR_WIDTH;

reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];


always@(posedge clk)begin 
   if(wr_ena) begin
      mem[address] <= wr_data;
   end
   if(rd_ena) begin
      rd_data <= mem[address];
   end
end

endmodule
