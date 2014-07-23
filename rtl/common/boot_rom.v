module boot_rom
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

localparam MEM_SIZE = 'hFFF;

reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1] ;

always@(posedge clk)begin
   if(!rst_n)begin
      data <= 0;
   end
   else if(rd_ena)begin
      data <= mem[address];
   end
end

`ifdef FPGA
  `ifdef USE_SDRAM
    initial begin
      $readmemh("../../sim/tests/use_sdram.hex", mem);
    end 
  `else
    initial begin
      $readmemh("../../sim/tests/code_test0.hex", mem);
    end 
  `endif
`else
  initial begin
    $readmemh("../tests/code_test0.hex", mem);
  end
`endif

endmodule
