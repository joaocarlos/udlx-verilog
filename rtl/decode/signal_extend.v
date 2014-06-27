// +----------------------------------------------------------------------------
// GNU General Public License
// -----------------------------------------------------------------------------
// This file is part of uDLX (micro-DeLuX) soft IP-core.
//
// uDLX is free soft IP-core: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// uDLX soft core is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with uDLX. If not, see <http://www.gnu.org/licenses/>.
// +----------------------------------------------------------------------------
// PROJECT: uDLX core Processor
// ------------------------------------------------------------------------------
// FILE NAME   : signal_extend.v
// -----------------------------------------------------------------------------
// KEYWORDS    : dlx, decoder, signal extend, immediate
// -----------------------------------------------------------------------------
// PURPOSE     : Extends a 16-bit halfword into a 32-bit word
// -----------------------------------------------------------------------------
module signal_extend
#(
   parameter OUT_DATA_WIDTH = 32,
   parameter IN_DATA_WIDTH = 16
)(
   input [IN_DATA_WIDTH-1:0] signal_in,
   input [OUT_DATA_WIDTH-1:0] signal_out
);

// Verificar se vai extender o sinal apenas de uma forma
// Instruções do tipo JPC usam palavras de 26 bits na entrada (TODO: extender de 26 bits para 32, verificando o OpCode)
assign signal_out = {{(OUT_DATA_WIDTH-IN_DATA_WIDTH){signal_in[IN_DATA_WIDTH-1]}},signal_in};

endmodule
