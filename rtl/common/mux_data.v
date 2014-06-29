module mux_data
#(
   parameter DATA_WIDTH = 32
 )
(
   input [DATA_WIDTH-1:0] data_a_in,
   input [DATA_WIDTH-1:0] data_b_in,
   input mux_sel_in,
   output [DATA_WIDTH-1:0] data_out
);

   assign data_out = mux_sel_in ? data_b_in : data_a_in;

endmodule
