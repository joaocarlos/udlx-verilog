//==================================================================================================
//  Filename      : signal_extend.v
//  Created On    : 2014-06-06 21:35:43
//  Last Modified : 2014-06-06 22:04:31
//  Revision      : 
//  Author        : Linton Thiago Costa Esteves
//  Company       : Universidade Federal da Bahia - UFBA
//  Email         : lintonthiago@gmail.com
//
//  Description   : 
//
//
//==================================================================================================

module signal_extend
                    #(
                        parameter OUT_DATA_WIDTH = 32,
                        parameter IN_DATA_WIDTH = 16
                    )
                    (
                        input [IN_DATA_WIDTH-1:0] signal_in,
                        input [OUT_DATA_WIDTH-1:0] signal_out
                    );

//verificar se vai extender o sinal apenas de uma forma
assign signal_out = {{(OUT_DATA_WIDTH-IN_DATA_WIDTH){signal_in[IN_DATA_WIDTH-1]}},signal_in};

endmodule
