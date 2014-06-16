module tosco_tb;


reg clk, rst_n;


localparam DATA_WIDTH = 32;
localparam INST_ADDR_WIDTH = 20;
localparam DATA_ADDR_WIDTH = 32;


wire data_rd_en;
wire data_wr_en;
wire [DATA_WIDTH-1:0] data_read;
wire [DATA_WIDTH-1:0] data_write;
wire [DATA_ADDR_WIDTH-1:0] data_addr;

wire instr_rd_en;
wire [INST_ADDR_WIDTH-1:0] instr_addr;
wire [DATA_WIDTH-1:0] instruction;

dlx_processor
#(
   .DATA_WIDTH(DATA_WIDTH),
   .INST_ADDR_WIDTH(INST_ADDR_WIDTH),
   .DATA_ADDR_WIDTH(DATA_ADDR_WIDTH)
)
dlx_processor_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .instr_rd_en(instr_rd_en),
   .instr_addr(instr_addr),
   .instruction(instruction),
   .data_rd_en(data_rd_en),
   .data_wr_en(data_wr_en),
   .data_addr(data_addr),
   .data_read(data_read),
   .data_write(data_write)
);



rom
#(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(10)
)
rom_u0
(
   .clk(clk),
   .rst_n(rst_n),
   .rd_ena(instr_rd_en),
   .address(instr_addr[15:2]),
   .data(instruction)
);


sp_ram
#(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(10)
)
sp_ram_u0
(
   .clk(clk),
   .rd_ena(data_rd_en),
   .wr_ena(data_wr_en),
   .address(data_addr[DATA_ADDR_WIDTH-1:2]),
   .wr_data(data_write),
   .rd_data(data_read)
);



initial begin
 clk = 0;
end
   
always begin
   #10  clk = ~clk;
end

initial begin
rst_n = 1;
#10;
rst_n = 0;
#30;
@(posedge clk);
#1
rst_n = 1;
end

endmodule
