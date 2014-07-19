module rom
#(
   parameter DATA_WIDTH = 32,
   parameter ADDR_WIDTH = 32
)
(
   input clk,
   input rst_n,
   input rd_ena,
   input [ADDR_WIDTH-1:0] address,
   output reg [DATA_WIDTH-1:0] data
);

//localparam MEM_SIZE = 2**ADDR_WIDTH;
localparam MEM_SIZE = 'd1024;

reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1] ;

always@(posedge clk)begin
   if(!rst_n)begin
      data <= 0;
   end
   else if(rd_ena)begin
      data <= mem[address];
   end
end

initial begin
  $readmemh("../tests/code_test0.hex", mem);
end

endmodule
