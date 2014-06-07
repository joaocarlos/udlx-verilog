//==================================================================================================
//  Filename      : register_bank.v
//  Created On    : 2014-06-06 20:59:31
//  Last Modified : 2014-06-06 21:00:50
//  Revision      : 
//
//  Description   : 
//
//
//==================================================================================================
module register_bank    
                        #(
                            DATA_WIDTH = 32,
                            MEMORY_SIZE = 16,
                            ADDRESS_WIDTH = 4
                        )
                        (
                            input clk,
                            input rst_n,
                            input [ADDRESS_WIDTH-1:0] read_address_1,
                            input [ADDRESS_WIDTH-1:0] read_address_2,
                            input [ADDRESS_WIDTH-1:0] write_address,
                            input write_enable,
                            input [DATA_WIDTH-1:0] write_data,
                            output [DATA_WIDTH-1:0] read_data_1,
                            output [DATA_WIDTH-1:0] read_data_2
                        );

reg [DATA_WIDTH-1:0] mem [0:MEMORY_SIZE-1];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < MEMORY_SIZE; i = i + 1) begin:reset_memory
            mem <= {DATA_WIDTH{1'b0}};
        end
    end
    else begin
        if (write_enable)
            mem[write_address] <= write_data;
    end
end

assign read_data_2 = mem[read_address_2];
assign read_data_1 = mem[read_address_1];

endmodule

