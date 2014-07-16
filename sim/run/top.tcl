
# NC-Sim Command File
# TOOL:	ncsim(64)	12.10-p001
#
#
# You can restore this configuration with:
#
#      irun -access +rwc -f ../srclist/udlx_test.srclist -timescale 1ns/1ps -s -input /proj/hercules/work/linton/dlx/udlx-verilog/sim/run/top.tcl
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
probe -create -database waves tosco_tb.top_u0.bootloader_u0.boot_mem_addr tosco_tb.top_u0.bootloader_u0.boot_mem_rd_data tosco_tb.top_u0.bootloader_u0.boot_mem_rd_en tosco_tb.top_u0.bootloader_u0.boot_mode tosco_tb.top_u0.bootloader_u0.clk tosco_tb.top_u0.bootloader_u0.count tosco_tb.top_u0.bootloader_u0.inst_mem_addr tosco_tb.top_u0.bootloader_u0.inst_mem_wr_data tosco_tb.top_u0.bootloader_u0.inst_mem_wr_en tosco_tb.top_u0.bootloader_u0.next_state tosco_tb.top_u0.bootloader_u0.rst_n tosco_tb.top_u0.bootloader_u0.state tosco_tb.top_u0.clk_rst_mngr_u0.clk_div2 tosco_tb.top_u0.clk_rst_mngr_u0.clk_div4 tosco_tb.top_u0.clk_rst_mngr_u0.clk_div8 tosco_tb.top_u0.clk_rst_mngr_u0.clk_div8_proc tosco_tb.top_u0.clk_rst_mngr_u0.clk_in tosco_tb.top_u0.clk_rst_mngr_u0.clk_out tosco_tb.top_u0.clk_rst_mngr_u0.counter tosco_tb.top_u0.clk_rst_mngr_u0.en_clk_div8 tosco_tb.top_u0.clk_rst_mngr_u0.rst_async_n tosco_tb.top_u0.clk_rst_mngr_u0.rst_sync_n tosco_tb.top_u0.clk_rst_mngr_u0.synch_rst_reg1_n tosco_tb.top_u0.clk_rst_mngr_u0.synch_rst_reg2_n tosco_tb.top_u0.data_memory_controll_u0.bank_address tosco_tb.top_u0.data_memory_controll_u0.bus_busy tosco_tb.top_u0.data_memory_controll_u0.clk tosco_tb.top_u0.data_memory_controll_u0.col_address tosco_tb.top_u0.data_memory_controll_u0.count_state tosco_tb.top_u0.data_memory_controll_u0.data_addr tosco_tb.top_u0.data_memory_controll_u0.data_in tosco_tb.top_u0.data_memory_controll_u0.data_out tosco_tb.top_u0.data_memory_controll_u0.data_out_valid tosco_tb.top_u0.data_memory_controll_u0.data_rd_en tosco_tb.top_u0.data_memory_controll_u0.data_rd_en_reg tosco_tb.top_u0.data_memory_controll_u0.data_wr_en tosco_tb.top_u0.data_memory_controll_u0.dram_addr tosco_tb.top_u0.data_memory_controll_u0.dram_ba tosco_tb.top_u0.data_memory_controll_u0.dram_cas_n tosco_tb.top_u0.data_memory_controll_u0.dram_cke tosco_tb.top_u0.data_memory_controll_u0.dram_clk tosco_tb.top_u0.data_memory_controll_u0.dram_cs_n tosco_tb.top_u0.data_memory_controll_u0.dram_dq_in tosco_tb.top_u0.data_memory_controll_u0.dram_dq_out tosco_tb.top_u0.data_memory_controll_u0.dram_dqm tosco_tb.top_u0.data_memory_controll_u0.dram_ras_n tosco_tb.top_u0.data_memory_controll_u0.dram_we_n tosco_tb.top_u0.data_memory_controll_u0.next_state tosco_tb.top_u0.data_memory_controll_u0.row_address tosco_tb.top_u0.data_memory_controll_u0.rst_n tosco_tb.top_u0.data_memory_controll_u0.sdram_command tosco_tb.top_u0.data_memory_controll_u0.state tosco_tb.top_u0.dlx_processor_u0.alu_data tosco_tb.top_u0.dlx_processor_u0.branch_inst tosco_tb.top_u0.dlx_processor_u0.clk tosco_tb.top_u0.dlx_processor_u0.constant tosco_tb.top_u0.dlx_processor_u0.data_addr tosco_tb.top_u0.dlx_processor_u0.data_alu_a tosco_tb.top_u0.dlx_processor_u0.data_alu_b tosco_tb.top_u0.dlx_processor_u0.data_rd_en tosco_tb.top_u0.dlx_processor_u0.data_read tosco_tb.top_u0.dlx_processor_u0.data_wr_en tosco_tb.top_u0.dlx_processor_u0.data_write tosco_tb.top_u0.dlx_processor_u0.decode_flush tosco_tb.top_u0.dlx_processor_u0.ex_mem_alu_data tosco_tb.top_u0.dlx_processor_u0.ex_mem_data_rd_en tosco_tb.top_u0.dlx_processor_u0.ex_mem_data_wr_en tosco_tb.top_u0.dlx_processor_u0.ex_mem_data_write tosco_tb.top_u0.dlx_processor_u0.ex_mem_instruction tosco_tb.top_u0.dlx_processor_u0.ex_mem_new_pc tosco_tb.top_u0.dlx_processor_u0.ex_mem_reg_data tosco_tb.top_u0.dlx_processor_u0.ex_mem_reg_wr_addr tosco_tb.top_u0.dlx_processor_u0.ex_mem_reg_wr_en tosco_tb.top_u0.dlx_processor_u0.ex_mem_select_new_pc tosco_tb.top_u0.dlx_processor_u0.ex_mem_write_back_mux_sel tosco_tb.top_u0.dlx_processor_u0.fetch_new_pc tosco_tb.top_u0.dlx_processor_u0.fetch_select_new_pc tosco_tb.top_u0.dlx_processor_u0.flush tosco_tb.top_u0.dlx_processor_u0.flush_in tosco_tb.top_u0.dlx_processor_u0.id_ex_branch_inst tosco_tb.top_u0.dlx_processor_u0.id_ex_constant tosco_tb.top_u0.dlx_processor_u0.id_ex_data_alu_a tosco_tb.top_u0.dlx_processor_u0.id_ex_data_alu_b tosco_tb.top_u0.dlx_processor_u0.id_ex_function tosco_tb.top_u0.dlx_processor_u0.id_ex_imm_inst tosco_tb.top_u0.dlx_processor_u0.id_ex_instruction tosco_tb.top_u0.dlx_processor_u0.id_ex_jump_inst tosco_tb.top_u0.dlx_processor_u0.id_ex_jump_use_r tosco_tb.top_u0.dlx_processor_u0.id_ex_mem_data_rd_en tosco_tb.top_u0.dlx_processor_u0.id_ex_mem_data_wr_en tosco_tb.top_u0.dlx_processor_u0.id_ex_new_pc tosco_tb.top_u0.dlx_processor_u0.id_ex_opcode tosco_tb.top_u0.dlx_processor_u0.id_ex_pc_offset tosco_tb.top_u0.dlx_processor_u0.id_ex_reg_a_addr tosco_tb.top_u0.dlx_processor_u0.id_ex_reg_b_addr tosco_tb.top_u0.dlx_processor_u0.id_ex_reg_rd_en tosco_tb.top_u0.dlx_processor_u0.id_ex_reg_wr_addr tosco_tb.top_u0.dlx_processor_u0.id_ex_reg_wr_en tosco_tb.top_u0.dlx_processor_u0.id_ex_write_back_mux_sel tosco_tb.top_u0.dlx_processor_u0.if_id_instruction tosco_tb.top_u0.dlx_processor_u0.if_id_new_pc tosco_tb.top_u0.dlx_processor_u0.imm_inst tosco_tb.top_u0.dlx_processor_u0.inst_function tosco_tb.top_u0.dlx_processor_u0.instr_addr tosco_tb.top_u0.dlx_processor_u0.instr_rd_en tosco_tb.top_u0.dlx_processor_u0.instruction tosco_tb.top_u0.dlx_processor_u0.jump_inst tosco_tb.top_u0.dlx_processor_u0.jump_use_r tosco_tb.top_u0.dlx_processor_u0.mem_data tosco_tb.top_u0.dlx_processor_u0.mem_data_rd_en tosco_tb.top_u0.dlx_processor_u0.mem_data_wr_en tosco_tb.top_u0.dlx_processor_u0.mem_wb_alu_data tosco_tb.top_u0.dlx_processor_u0.mem_wb_instruction tosco_tb.top_u0.dlx_processor_u0.mem_wb_mem_data tosco_tb.top_u0.dlx_processor_u0.mem_wb_reg_wr_addr tosco_tb.top_u0.dlx_processor_u0.mem_wb_reg_wr_en tosco_tb.top_u0.dlx_processor_u0.mem_wb_write_back_mux_sel tosco_tb.top_u0.dlx_processor_u0.new_pc tosco_tb.top_u0.dlx_processor_u0.opcode tosco_tb.top_u0.dlx_processor_u0.pc_offset tosco_tb.top_u0.dlx_processor_u0.reg_rd_addr1 tosco_tb.top_u0.dlx_processor_u0.reg_rd_addr2 tosco_tb.top_u0.dlx_processor_u0.reg_wr_addr tosco_tb.top_u0.dlx_processor_u0.reg_wr_en tosco_tb.top_u0.dlx_processor_u0.rst_n tosco_tb.top_u0.dlx_processor_u0.stall tosco_tb.top_u0.dlx_processor_u0.wb_reg_wr_addr tosco_tb.top_u0.dlx_processor_u0.wb_write_data tosco_tb.top_u0.dlx_processor_u0.wb_write_enable tosco_tb.top_u0.dlx_processor_u0.write_back_mux_sel tosco_tb.top_u0.mux_sram_u0.boot_mem_addr tosco_tb.top_u0.mux_sram_u0.boot_mem_rd_data tosco_tb.top_u0.mux_sram_u0.boot_mem_wr_en tosco_tb.top_u0.mux_sram_u0.boot_mode tosco_tb.top_u0.mux_sram_u0.inst_mem_addr tosco_tb.top_u0.mux_sram_u0.inst_mem_rd_data tosco_tb.top_u0.mux_sram_u0.inst_mem_rd_en tosco_tb.top_u0.mux_sram_u0.inst_mem_wr_data tosco_tb.top_u0.mux_sram_u0.inst_mem_wr_en tosco_tb.top_u0.mux_sram_u0.sram_mem_addr tosco_tb.top_u0.mux_sram_u0.sram_mem_rd_data tosco_tb.top_u0.mux_sram_u0.sram_mem_rd_en tosco_tb.top_u0.mux_sram_u0.sram_mem_wr_data tosco_tb.top_u0.mux_sram_u0.sram_mem_wr_en tosco_tb.top_u0.sram_fsm_u0.addr tosco_tb.top_u0.sram_fsm_u0.addr_plus2 tosco_tb.top_u0.sram_fsm_u0.addr_reg tosco_tb.top_u0.sram_fsm_u0.clk tosco_tb.top_u0.sram_fsm_u0.next_state tosco_tb.top_u0.sram_fsm_u0.rd_data tosco_tb.top_u0.sram_fsm_u0.rd_data_concat tosco_tb.top_u0.sram_fsm_u0.rd_data_reg tosco_tb.top_u0.sram_fsm_u0.rd_en tosco_tb.top_u0.sram_fsm_u0.rst_n tosco_tb.top_u0.sram_fsm_u0.sram_addr tosco_tb.top_u0.sram_fsm_u0.sram_ce_n tosco_tb.top_u0.sram_fsm_u0.sram_lb_n tosco_tb.top_u0.sram_fsm_u0.sram_oe_n tosco_tb.top_u0.sram_fsm_u0.sram_rd_data tosco_tb.top_u0.sram_fsm_u0.sram_ub_n tosco_tb.top_u0.sram_fsm_u0.sram_we_n tosco_tb.top_u0.sram_fsm_u0.sram_wr_data tosco_tb.top_u0.sram_fsm_u0.state tosco_tb.top_u0.sram_fsm_u0.wr_data tosco_tb.top_u0.sram_fsm_u0.wr_data_reg tosco_tb.top_u0.sram_fsm_u0.wr_en
probe -create -database waves tosco_tb.rom_u0.address tosco_tb.rom_u0.clk tosco_tb.rom_u0.data tosco_tb.rom_u0.mem tosco_tb.rom_u0.rd_ena tosco_tb.rom_u0.rst_n
probe -create -database waves tosco_tb.top_u0.boot_mem_addr tosco_tb.top_u0.boot_mem_wr_data tosco_tb.top_u0.boot_mem_wr_en tosco_tb.top_u0.boot_mode tosco_tb.top_u0.boot_rom_addr tosco_tb.top_u0.boot_rom_rd_data tosco_tb.top_u0.boot_rom_rd_en tosco_tb.top_u0.clk tosco_tb.top_u0.clk_div2 tosco_tb.top_u0.clk_div4 tosco_tb.top_u0.clk_div8 tosco_tb.top_u0.clk_div8_proc tosco_tb.top_u0.clk_out tosco_tb.top_u0.data_addr_proc tosco_tb.top_u0.data_rd_en_proc tosco_tb.top_u0.data_read_proc tosco_tb.top_u0.data_wr_en_proc tosco_tb.top_u0.data_write_proc tosco_tb.top_u0.dram_addr tosco_tb.top_u0.dram_ba tosco_tb.top_u0.dram_cas_n tosco_tb.top_u0.dram_cke tosco_tb.top_u0.dram_clk tosco_tb.top_u0.dram_cs_n tosco_tb.top_u0.dram_dq_in tosco_tb.top_u0.dram_dq_out tosco_tb.top_u0.dram_dqm tosco_tb.top_u0.dram_ras_n tosco_tb.top_u0.dram_we_n tosco_tb.top_u0.inst_mem_addr_proc tosco_tb.top_u0.inst_mem_rd_data_proc tosco_tb.top_u0.inst_mem_rd_en_proc tosco_tb.top_u0.rst_n tosco_tb.top_u0.rst_sync_n tosco_tb.top_u0.sram_addr tosco_tb.top_u0.sram_ce_n tosco_tb.top_u0.sram_lb_n tosco_tb.top_u0.sram_mem_addr tosco_tb.top_u0.sram_mem_rd_data tosco_tb.top_u0.sram_mem_rd_en tosco_tb.top_u0.sram_mem_wr_data tosco_tb.top_u0.sram_mem_wr_en tosco_tb.top_u0.sram_oe_n tosco_tb.top_u0.sram_rd_data tosco_tb.top_u0.sram_ub_n tosco_tb.top_u0.sram_we_n tosco_tb.top_u0.sram_wr_data

simvision -input top.tcl.svcf
