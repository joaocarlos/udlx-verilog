module rom
#(
   parameter DATA_WIDTH = 32,
   parameter ADDR_WIDTH = 32
)
(
   input clk,
   input rd_ena,
   input [ADDR_WIDTH-1:0] address,
   output reg [DATA_WIDTH-1:0] data
);

localparam MEM_SIZE = 2**ADDR_WIDTH;

reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1] ;

always@(posedge clk)begin
   if(rd_ena)begin
      data <= mem[address];
   end
end

initial begin
  $readmemb("../tests/code.txt", mem);
end

endmodule
