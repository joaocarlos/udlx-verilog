
# NC-Sim Command File
# TOOL:	ncsim	12.10-p001
#
#
# You can restore this configuration with:
#
#      irun -timescale 1ns/10ps -f ../srclist/udlx_test.srclist -access +rwc -s -input /home/joaocarlos/workinprogress/udlx32/sim/run/test_processor.tcl
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 1
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves tosco_tb.dlx_processor_u0.instruction tosco_tb.dlx_processor_u0.if_id_instruction tosco_tb.dlx_processor_u0.id_ex_instruction tosco_tb.dlx_processor_u0.ex_mem_instruction tosco_tb.dlx_processor_u0.mem_wb_instruction tosco_tb.dlx_processor_u0.clk tosco_tb.dlx_processor_u0.data_addr tosco_tb.dlx_processor_u0.data_rd_en tosco_tb.dlx_processor_u0.data_read tosco_tb.dlx_processor_u0.data_wr_en tosco_tb.dlx_processor_u0.data_write tosco_tb.dlx_processor_u0.instr_addr tosco_tb.dlx_processor_u0.instr_rd_en tosco_tb.dlx_processor_u0.rst_n tosco_tb.dlx_processor_u0.instruction_fetch_u0.clk tosco_tb.dlx_processor_u0.instruction_fetch_u0.rst_n tosco_tb.dlx_processor_u0.instruction_fetch_u0.select_new_pc_in tosco_tb.dlx_processor_u0.instruction_fetch_u0.pc_mux_data tosco_tb.dlx_processor_u0.instruction_fetch_u0.pc_adder_data tosco_tb.dlx_processor_u0.instruction_fetch_u0.pc tosco_tb.dlx_processor_u0.instruction_fetch_u0.new_pc_in tosco_tb.dlx_processor_u0.instruction_fetch_u0.inst_mem_addr_out tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_data_out tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_function_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_opcode_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_inst_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.clk tosco_tb.dlx_processor_u0.execute_address_calculate_u0.constant_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.data_alu_a_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.data_alu_b_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.imm_inst_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.jmp_inst_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.jmp_use_r_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.mem_data_out tosco_tb.dlx_processor_u0.execute_address_calculate_u0.new_pc_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.reg_a_addr_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.reg_b_addr_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.rst_n tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.clk tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.i tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.rd_reg1_addr tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.rd_reg1_data_out tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.rd_reg2_addr tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.rd_reg2_data_out tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.reg_file tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.rst_n tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.write_address tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.write_data tosco_tb.dlx_processor_u0.instruction_decode_u0.register_bank_u0.write_enable tosco_tb.dlx_processor_u0.instruction_decode_u0.control_u0.id_ex_mem_data_rd_en tosco_tb.dlx_processor_u0.instruction_decode_u0.control_u0.id_ex_reg_wr_addr tosco_tb.dlx_processor_u0.instruction_decode_u0.control_u0.if_id_rd_reg_a_addr tosco_tb.dlx_processor_u0.instruction_decode_u0.control_u0.if_id_rd_reg_a_en tosco_tb.dlx_processor_u0.instruction_decode_u0.control_u0.if_id_rd_reg_b_addr tosco_tb.dlx_processor_u0.instruction_decode_u0.control_u0.if_id_rd_reg_b_en tosco_tb.dlx_processor_u0.instruction_decode_u0.control_u0.inst_rd_en tosco_tb.dlx_processor_u0.instruction_decode_u0.control_u0.load_hazard tosco_tb.dlx_processor_u0.instruction_decode_u0.control_u0.select_new_pc tosco_tb.dlx_processor_u0.instruction_decode_u0.control_u0.stall tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.alu_data_out tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.alu_result_reg tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.and_result tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.or_result tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.sub_result tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.sum_result tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.zero_cmp tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.branch_val tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.jmp_val tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.pc_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.pc_out tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.reg_a_data_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.reg_b_data_in tosco_tb.dlx_processor_u0.write_back_u0.alu_data_in tosco_tb.dlx_processor_u0.write_back_u0.mem_data_in tosco_tb.dlx_processor_u0.write_back_u0.reg_wr_addr_in tosco_tb.dlx_processor_u0.write_back_u0.reg_wr_addr_out tosco_tb.dlx_processor_u0.write_back_u0.reg_wr_data_out tosco_tb.dlx_processor_u0.write_back_u0.reg_wr_en_in tosco_tb.dlx_processor_u0.write_back_u0.reg_wr_en_out tosco_tb.dlx_processor_u0.write_back_u0.write_back_mux_sel tosco_tb.rom_u0.address tosco_tb.rom_u0.clk tosco_tb.rom_u0.data tosco_tb.rom_u0.mem tosco_tb.rom_u0.rd_ena tosco_tb.sp_ram_u0.address tosco_tb.sp_ram_u0.clk tosco_tb.sp_ram_u0.mem tosco_tb.sp_ram_u0.rd_data tosco_tb.sp_ram_u0.rd_ena tosco_tb.sp_ram_u0.wr_data tosco_tb.sp_ram_u0.wr_ena
probe -create -database waves tosco_tb.dlx_processor_u0.if_id_reg_u0.instruction_reg_out
probe -create -database waves tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.branch_inst_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.branch_result_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.jmp_inst_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.jmp_use_r_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.pc_jump tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.pc_offset_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.branch_control_u0.select_new_pc_out
probe -create -database waves tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.alu_function_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.alu_opcode_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.alu_data_b_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.alu_data_a_in tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.flags_reg tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.flag_over_underflow tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.flag_error tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.flag_equal tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.flag_above tosco_tb.dlx_processor_u0.execute_address_calculate_u0.alu_u0.alu_branch_result_out

simvision -input test_processor.tcl.svcf
