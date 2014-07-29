
# NC-Sim Command File
# TOOL:	ncsim(64)	12.10-p001
#
#
# You can restore this configuration with:
#
#      irun -f ../srclist/udlx_test.srclist -access +rwc -vtimescale 1ns/10ps -s -input /home/users/ljesus/cadence/Laue_project/udlx-verilog-master/sim/run/dlx_verif.tcl
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
probe -create -database waves udlx_tb.top_u0.dlx_processor_u0.boot_mode udlx_tb.top_u0.dlx_processor_u0.clk udlx_tb.top_u0.dlx_processor_u0.data_addr udlx_tb.top_u0.dlx_processor_u0.data_rd_en udlx_tb.top_u0.dlx_processor_u0.data_read udlx_tb.top_u0.dlx_processor_u0.data_wr_en udlx_tb.top_u0.dlx_processor_u0.data_write udlx_tb.top_u0.dlx_processor_u0.enable udlx_tb.top_u0.dlx_processor_u0.instr_rd_en udlx_tb.top_u0.dlx_processor_u0.rst_n udlx_tb.top_u0.dlx_processor_u0.instruction udlx_tb.dut_if.activate_control_signals_sw0 udlx_tb.dut_if.clk_dlx udlx_tb.dut_if.activate_control_signals_rt0 udlx_tb.dut_if.activate_control_signals_add0 udlx_tb.dut_if.activate_control_signals_beq0 udlx_tb.dut_if.activate_control_signals_brfl0 udlx_tb.dut_if.activate_control_signals_jal0 udlx_tb.dut_if.activate_control_signals_jalcal0 udlx_tb.dut_if.activate_control_signals_jpc0 udlx_tb.dut_if.activate_control_signals_jr0 udlx_tb.dut_if.activate_control_signals_lw0 udlx_tb.dut_if.activate_control_signals_muldiv0 udlx_tb.dut_if.activate_control_signals_ret0 udlx_tb.dut_if.activate_sdram_rd_signals0 udlx_tb.dut_if.activate_sdram_wr_signals0 udlx_tb.dut_if.boot_mode udlx_tb.dut_if.branch_inst_out udlx_tb.dut_if.branch_use_r_out udlx_tb.dut_if.clk udlx_tb.dut_if.clk_dl udlx_tb.dut_if.clk_env udlx_tb.dut_if.data_addr udlx_tb.dut_if.data_rd_en udlx_tb.dut_if.data_read udlx_tb.dut_if.data_wr_en udlx_tb.dut_if.data_write udlx_tb.dut_if.dram_addr udlx_tb.dut_if.dram_cas_n udlx_tb.dut_if.dram_cke udlx_tb.dut_if.dram_cs_n udlx_tb.dut_if.dram_ras_n udlx_tb.dut_if.dram_we_n udlx_tb.dut_if.imm_inst_out udlx_tb.dut_if.instr_rd_en udlx_tb.dut_if.instruction udlx_tb.dut_if.jump_inst_out udlx_tb.dut_if.jump_use_r_out udlx_tb.dut_if.mem_data_rd_en_out udlx_tb.dut_if.mem_data_wr_en_out udlx_tb.dut_if.reg_a_wr_en_out udlx_tb.dut_if.reg_b_wr_en_out udlx_tb.dut_if.reg_rd_en1_out udlx_tb.dut_if.reg_rd_en2_out udlx_tb.dut_if.regs udlx_tb.dut_if.rst_n udlx_tb.dut_if.sdram_dlx_addr_cmp0 udlx_tb.dut_if.write_back_mux_sel_out udlx_tb.top_u0.bootloader_u0.boot_mem_addr udlx_tb.top_u0.bootloader_u0.boot_mem_rd_data udlx_tb.top_u0.bootloader_u0.boot_mem_rd_en udlx_tb.top_u0.bootloader_u0.boot_mode udlx_tb.top_u0.bootloader_u0.clk udlx_tb.top_u0.bootloader_u0.count udlx_tb.top_u0.bootloader_u0.inst_mem_addr udlx_tb.top_u0.bootloader_u0.inst_mem_wr_data udlx_tb.top_u0.bootloader_u0.inst_mem_wr_en udlx_tb.top_u0.bootloader_u0.next_state udlx_tb.top_u0.bootloader_u0.rst_n udlx_tb.top_u0.bootloader_u0.state udlx_tb.top_u0.data_memory_controll_u0.bus_busy udlx_tb.top_u0.data_memory_controll_u0.clk udlx_tb.top_u0.data_memory_controll_u0.data_addr udlx_tb.top_u0.data_memory_controll_u0.data_in udlx_tb.top_u0.data_memory_controll_u0.data_out udlx_tb.top_u0.data_memory_controll_u0.data_out_valid udlx_tb.top_u0.data_memory_controll_u0.data_rd_en udlx_tb.top_u0.data_memory_controll_u0.data_wr_en udlx_tb.top_u0.data_memory_controll_u0.dram_addr udlx_tb.top_u0.data_memory_controll_u0.dram_ba udlx_tb.top_u0.data_memory_controll_u0.dram_cas_n udlx_tb.top_u0.data_memory_controll_u0.dram_cke udlx_tb.top_u0.data_memory_controll_u0.dram_clk udlx_tb.top_u0.data_memory_controll_u0.dram_cs_n udlx_tb.top_u0.data_memory_controll_u0.dram_dq_in udlx_tb.top_u0.data_memory_controll_u0.dram_dq_out udlx_tb.top_u0.data_memory_controll_u0.dram_dqm udlx_tb.top_u0.data_memory_controll_u0.dram_ras_n udlx_tb.top_u0.data_memory_controll_u0.dram_we_n udlx_tb.top_u0.data_memory_controll_u0.rst_n udlx_tb.top_u0.dlx_processor_u0.instr_addr

simvision -input dlx_verif.tcl.svcf
