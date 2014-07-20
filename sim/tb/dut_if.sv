// +----------------------------------------------------------------------------
// Universidade Federal da Bahia
//------------------------------------------------------------------------------
// PROJECT: UDLX Processor
//------------------------------------------------------------------------------
// FILE NAME: dut_if.v
// -----------------------------------------------------------------------------
// PURPOSE:  DUT Interface.
// -----------------------------------------------------------------------------

interface dut_if (input bit clk);

    `include "../tb/defines.sv"
    `include "../../rtl/common/opcodes.v"

//---------------------------------------//
//---------- Monitor Signals ------------//
//---------------------------------------//
    logic boot_mode;
    logic instr_rd_en;
    logic data_rd_en;
    logic data_wr_en;
    logic [DATA_WIDTH-1:0] instruction;
    logic [DATA_WIDTH-1:0] data_read;
    logic [DATA_WIDTH-1:0] data_write;
    logic [DATA_ADDR_WIDTH-1:0] data_addr;
    logic [DATA_WIDTH-1:0] regs [0:(2**ADDRESS_WIDTH)-1];
    logic reg_rd_en1_out;
    logic reg_rd_en2_out;
    logic reg_wr_en_out;
    logic imm_inst_out;
    logic mem_data_rd_en_out;
    logic mem_data_wr_en_out;
    logic write_back_mux_sel_out;
    logic branch_inst_out;
    logic jump_inst_out;
    logic jump_use_r_out;
    bit clk_dlx;

    property activate_control_signals_lw0;
        @(posedge clk_dlx)
        (instruction[31:26] == LW_OPCODE) |-> ##[1:2] ((reg_rd_en1_out) and
                                                       (reg_wr_en_out) and
                                                       (imm_inst_out) and
                                                       (mem_data_rd_en_out) and
                                                       (write_back_mux_sel_out));
    endproperty

    property activate_control_signals_rt0;
        @(posedge clk_dlx)
        ((instruction[31:26] == R_TYPE_OPCODE) and instruction[5:0] !== 6'b0) |-> ##[0:2] (
                                                       (reg_rd_en1_out) and
                                                       (reg_rd_en2_out) and
                                                       (reg_wr_en_out));
    endproperty

    property activate_control_signals_add0;
        @(posedge clk_dlx)
        ((instruction[31:26] == ADDI_OPCODE) or
         (instruction[31:26] == SUBI_OPCODE) or
         (instruction[31:26] == ANDI_OPCODE) or
         (instruction[31:26] == ORI_OPCODE)) |-> ##[1:2] ((reg_rd_en1_out) and
                                                       (reg_wr_en_out) and
                                                       (imm_inst_out));
    endproperty

    property activate_control_signals_sw0;
        @(posedge clk_dlx)
        (instruction[31:26] == SW_OPCODE) |-> ##[1:2] ((reg_rd_en1_out) and
                                                       (reg_rd_en2_out) and
                                                       (imm_inst_out) and
                                                       (mem_data_wr_en_out));
    endproperty

    property activate_control_signals_beq0;
        @(posedge clk_dlx)
        ((instruction[31:26] == BEQZ_OPCODE) or
         (instruction[31:26] == BNEZ_OPCODE) or
         (instruction[31:26] == BRFL_OPCODE)) |-> ##[1:2] ((reg_rd_en1_out) and
                                                       (imm_inst_out) and
                                                       (branch_inst_out));
    endproperty

    property activate_control_signals_jr0;
        @(posedge clk_dlx)
        (instruction[31:26] == JR_OPCODE) |-> ##[1:2] ((reg_rd_en1_out) and
                                                       (jump_inst_out) and
                                                       (jump_use_r_out));
    endproperty

    property activate_control_signals_jpc0;
        @(posedge clk_dlx)
        (instruction[31:26] == JPC_OPCODE) |-> ##[1:2] jump_inst_out;
    endproperty

    assert property (activate_control_signals_lw0);
    assert property (activate_control_signals_rt0);
    assert property (activate_control_signals_add0);
    assert property (activate_control_signals_sw0);
    assert property (activate_control_signals_beq0);
    assert property (activate_control_signals_jr0);
    assert property (activate_control_signals_jpc0);

endinterface
