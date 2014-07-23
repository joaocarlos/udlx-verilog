
# NC-Sim Command File
# TOOL:	ncsim(64)	12.10-p001
#
#
# You can restore this configuration with:
#
#      irun -f ../srclist/udlx_test.srclist -access +rwc -timescale 1ns/1ps -s -input /proj/hercules/work/linton/dlx/udlx-verilog/sim/run/top.tcl
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
probe -create -database waves top_tb.top_u0.dlx_processor_u0.if_id_instruction top_tb.top_u0.dlx_processor_u0.id_ex_instruction top_tb.top_u0.dlx_processor_u0.ex_mem_instruction top_tb.top_u0.dlx_processor_u0.mem_wb_instruction top_tb.top_u0.bootloader_u0.boot_mem_addr top_tb.top_u0.bootloader_u0.boot_mem_rd_data top_tb.top_u0.bootloader_u0.boot_mem_rd_en top_tb.top_u0.bootloader_u0.boot_mode top_tb.top_u0.bootloader_u0.clk top_tb.top_u0.bootloader_u0.count top_tb.top_u0.bootloader_u0.inst_mem_addr top_tb.top_u0.bootloader_u0.inst_mem_wr_data top_tb.top_u0.bootloader_u0.inst_mem_wr_en top_tb.top_u0.bootloader_u0.next_state top_tb.top_u0.bootloader_u0.rst_n top_tb.top_u0.bootloader_u0.state top_tb.top_u0.clk_rst_mngr_u0.clk_div2 top_tb.top_u0.clk_rst_mngr_u0.clk_div4 top_tb.top_u0.clk_rst_mngr_u0.clk_div8 top_tb.top_u0.clk_rst_mngr_u0.clk_div8_proc top_tb.top_u0.clk_rst_mngr_u0.clk_in top_tb.top_u0.clk_rst_mngr_u0.clk_out top_tb.top_u0.clk_rst_mngr_u0.counter top_tb.top_u0.clk_rst_mngr_u0.en_clk_div8 top_tb.top_u0.clk_rst_mngr_u0.rst_async_n top_tb.top_u0.clk_rst_mngr_u0.rst_sync_n top_tb.top_u0.clk_rst_mngr_u0.synch_rst_reg1_n top_tb.top_u0.clk_rst_mngr_u0.synch_rst_reg2_n top_tb.top_u0.data_memory_controll_u0.bank_address top_tb.top_u0.data_memory_controll_u0.bus_busy top_tb.top_u0.data_memory_controll_u0.clk top_tb.top_u0.data_memory_controll_u0.col_address top_tb.top_u0.data_memory_controll_u0.count_state top_tb.top_u0.data_memory_controll_u0.data_in top_tb.top_u0.data_memory_controll_u0.data_out top_tb.top_u0.data_memory_controll_u0.data_out_valid top_tb.top_u0.data_memory_controll_u0.data_rd_en top_tb.top_u0.data_memory_controll_u0.data_rd_en_reg top_tb.top_u0.data_memory_controll_u0.data_wr_en top_tb.top_u0.data_memory_controll_u0.dram_addr top_tb.top_u0.data_memory_controll_u0.dram_ba top_tb.top_u0.data_memory_controll_u0.dram_cas_n top_tb.top_u0.data_memory_controll_u0.dram_cke top_tb.top_u0.data_memory_controll_u0.dram_clk top_tb.top_u0.data_memory_controll_u0.dram_cs_n top_tb.top_u0.data_memory_controll_u0.dram_dq_in top_tb.top_u0.data_memory_controll_u0.dram_dq_out top_tb.top_u0.data_memory_controll_u0.dram_dqm top_tb.top_u0.data_memory_controll_u0.dram_ras_n top_tb.top_u0.data_memory_controll_u0.dram_we_n top_tb.top_u0.data_memory_controll_u0.next_state top_tb.top_u0.data_memory_controll_u0.row_address top_tb.top_u0.data_memory_controll_u0.rst_n top_tb.top_u0.data_memory_controll_u0.sdram_command top_tb.top_u0.data_memory_controll_u0.state top_tb.top_u0.mux_sram_u0.boot_mem_addr top_tb.top_u0.mux_sram_u0.boot_mem_rd_data top_tb.top_u0.mux_sram_u0.boot_mem_wr_en top_tb.top_u0.mux_sram_u0.boot_mode top_tb.top_u0.mux_sram_u0.inst_mem_addr top_tb.top_u0.mux_sram_u0.inst_mem_rd_data top_tb.top_u0.mux_sram_u0.inst_mem_rd_en top_tb.top_u0.mux_sram_u0.inst_mem_wr_data top_tb.top_u0.mux_sram_u0.inst_mem_wr_en top_tb.top_u0.mux_sram_u0.sram_mem_addr top_tb.top_u0.mux_sram_u0.sram_mem_rd_data top_tb.top_u0.mux_sram_u0.sram_mem_rd_en top_tb.top_u0.mux_sram_u0.sram_mem_wr_data top_tb.top_u0.mux_sram_u0.sram_mem_wr_en top_tb.rom_u0.address top_tb.rom_u0.clk top_tb.rom_u0.data top_tb.rom_u0.rd_ena top_tb.rom_u0.rst_n top_tb.top_u0.sram_ctrl_u0.addr top_tb.top_u0.sram_ctrl_u0.addr_plus2 top_tb.top_u0.sram_ctrl_u0.clk top_tb.top_u0.sram_ctrl_u0.next_state top_tb.top_u0.sram_ctrl_u0.rd_data top_tb.top_u0.sram_ctrl_u0.rd_data_concat top_tb.top_u0.sram_ctrl_u0.rd_data_reg top_tb.top_u0.sram_ctrl_u0.rd_en top_tb.top_u0.sram_ctrl_u0.rst_n top_tb.top_u0.sram_ctrl_u0.sram_addr top_tb.top_u0.sram_ctrl_u0.sram_ce_n top_tb.top_u0.sram_ctrl_u0.sram_lb_n top_tb.top_u0.sram_ctrl_u0.sram_oe_n top_tb.top_u0.sram_ctrl_u0.sram_rd_data top_tb.top_u0.sram_ctrl_u0.sram_ub_n top_tb.top_u0.sram_ctrl_u0.sram_we_n top_tb.top_u0.sram_ctrl_u0.sram_wr_data top_tb.top_u0.sram_ctrl_u0.state top_tb.top_u0.sram_ctrl_u0.wr_data top_tb.top_u0.sram_ctrl_u0.wr_en
probe -create -database waves top_tb.sp_ram_u0.address top_tb.sp_ram_u0.clk top_tb.sp_ram_u0.mem top_tb.sp_ram_u0.rd_data top_tb.sp_ram_u0.rd_ena top_tb.sp_ram_u0.wr_data top_tb.sp_ram_u0.wr_ena
probe -create -database waves top_tb.top_u0.boot_mem_addr top_tb.top_u0.boot_mem_wr_data top_tb.top_u0.boot_mem_wr_en top_tb.top_u0.boot_mode top_tb.top_u0.boot_rom_addr top_tb.top_u0.boot_rom_rd_data top_tb.top_u0.boot_rom_rd_en top_tb.top_u0.clk top_tb.top_u0.clk_div2 top_tb.top_u0.clk_div4 top_tb.top_u0.clk_div8 top_tb.top_u0.clk_div8_proc top_tb.top_u0.clk_out top_tb.top_u0.data_addr_proc top_tb.top_u0.data_rd_en_proc top_tb.top_u0.data_read_proc top_tb.top_u0.data_wr_en_proc top_tb.top_u0.data_write_proc top_tb.top_u0.dram_addr top_tb.top_u0.dram_ba top_tb.top_u0.dram_cas_n top_tb.top_u0.dram_cke top_tb.top_u0.dram_clk top_tb.top_u0.dram_cs_n top_tb.top_u0.dram_dq_in top_tb.top_u0.dram_dq_out top_tb.top_u0.dram_dqm top_tb.top_u0.dram_ras_n top_tb.top_u0.dram_we_n top_tb.top_u0.gpio_o top_tb.top_u0.inst_mem_addr_proc top_tb.top_u0.inst_mem_rd_data_proc top_tb.top_u0.inst_mem_rd_en_proc top_tb.top_u0.rst_n top_tb.top_u0.rst_sync_n top_tb.top_u0.sram_addr top_tb.top_u0.sram_ce_n top_tb.top_u0.sram_lb_n top_tb.top_u0.sram_mem_addr top_tb.top_u0.sram_mem_rd_data top_tb.top_u0.sram_mem_rd_en top_tb.top_u0.sram_mem_wr_data top_tb.top_u0.sram_mem_wr_en top_tb.top_u0.sram_oe_n top_tb.top_u0.sram_rd_data top_tb.top_u0.sram_ub_n top_tb.top_u0.sram_we_n top_tb.top_u0.sram_wr_data top_tb.top_u0.we_gpio top_tb.top_u0.wr_data_sdram top_tb.top_u0.wr_en_sdram
probe -create -database waves top_tb.top_u0.dlx_processor_u0.alu_data top_tb.top_u0.dlx_processor_u0.branch_inst top_tb.top_u0.dlx_processor_u0.clk top_tb.top_u0.dlx_processor_u0.constant top_tb.top_u0.dlx_processor_u0.data_addr top_tb.top_u0.dlx_processor_u0.data_alu_a top_tb.top_u0.dlx_processor_u0.data_alu_b top_tb.top_u0.dlx_processor_u0.data_rd_en top_tb.top_u0.dlx_processor_u0.data_read top_tb.top_u0.dlx_processor_u0.data_wr_en top_tb.top_u0.dlx_processor_u0.data_write top_tb.top_u0.dlx_processor_u0.decode_flush top_tb.top_u0.dlx_processor_u0.ex_mem_alu_data top_tb.top_u0.dlx_processor_u0.ex_mem_data_rd_en top_tb.top_u0.dlx_processor_u0.ex_mem_data_wr_en top_tb.top_u0.dlx_processor_u0.ex_mem_data_write top_tb.top_u0.dlx_processor_u0.ex_mem_new_pc top_tb.top_u0.dlx_processor_u0.ex_mem_reg_data top_tb.top_u0.dlx_processor_u0.ex_mem_reg_wr_addr top_tb.top_u0.dlx_processor_u0.ex_mem_reg_wr_en top_tb.top_u0.dlx_processor_u0.ex_mem_select_new_pc top_tb.top_u0.dlx_processor_u0.ex_mem_write_back_mux_sel top_tb.top_u0.dlx_processor_u0.fetch_new_pc top_tb.top_u0.dlx_processor_u0.fetch_select_new_pc top_tb.top_u0.dlx_processor_u0.flush top_tb.top_u0.dlx_processor_u0.flush_in top_tb.top_u0.dlx_processor_u0.id_ex_branch_inst top_tb.top_u0.dlx_processor_u0.id_ex_constant top_tb.top_u0.dlx_processor_u0.id_ex_data_alu_a top_tb.top_u0.dlx_processor_u0.id_ex_data_alu_b top_tb.top_u0.dlx_processor_u0.id_ex_function top_tb.top_u0.dlx_processor_u0.id_ex_imm_inst top_tb.top_u0.dlx_processor_u0.id_ex_jump_inst top_tb.top_u0.dlx_processor_u0.id_ex_jump_use_r top_tb.top_u0.dlx_processor_u0.id_ex_mem_data_rd_en top_tb.top_u0.dlx_processor_u0.id_ex_mem_data_wr_en top_tb.top_u0.dlx_processor_u0.id_ex_new_pc top_tb.top_u0.dlx_processor_u0.id_ex_opcode top_tb.top_u0.dlx_processor_u0.id_ex_pc_offset top_tb.top_u0.dlx_processor_u0.id_ex_reg_a_addr top_tb.top_u0.dlx_processor_u0.id_ex_reg_b_addr top_tb.top_u0.dlx_processor_u0.id_ex_reg_rd_en top_tb.top_u0.dlx_processor_u0.id_ex_reg_wr_addr top_tb.top_u0.dlx_processor_u0.id_ex_reg_wr_en top_tb.top_u0.dlx_processor_u0.id_ex_write_back_mux_sel top_tb.top_u0.dlx_processor_u0.if_id_new_pc top_tb.top_u0.dlx_processor_u0.imm_inst top_tb.top_u0.dlx_processor_u0.inst_function top_tb.top_u0.dlx_processor_u0.instr_addr top_tb.top_u0.dlx_processor_u0.instr_rd_en top_tb.top_u0.dlx_processor_u0.instruction top_tb.top_u0.dlx_processor_u0.jump_inst top_tb.top_u0.dlx_processor_u0.jump_use_r top_tb.top_u0.dlx_processor_u0.mem_data top_tb.top_u0.dlx_processor_u0.mem_data_rd_en top_tb.top_u0.dlx_processor_u0.mem_data_wr_en top_tb.top_u0.dlx_processor_u0.mem_wb_alu_data top_tb.top_u0.dlx_processor_u0.mem_wb_mem_data top_tb.top_u0.dlx_processor_u0.mem_wb_reg_wr_addr top_tb.top_u0.dlx_processor_u0.mem_wb_reg_wr_en top_tb.top_u0.dlx_processor_u0.mem_wb_write_back_mux_sel top_tb.top_u0.dlx_processor_u0.new_pc top_tb.top_u0.dlx_processor_u0.opcode top_tb.top_u0.dlx_processor_u0.pc_offset top_tb.top_u0.dlx_processor_u0.reg_rd_addr1 top_tb.top_u0.dlx_processor_u0.reg_rd_addr2 top_tb.top_u0.dlx_processor_u0.reg_wr_addr top_tb.top_u0.dlx_processor_u0.reg_wr_en top_tb.top_u0.dlx_processor_u0.rst_n top_tb.top_u0.dlx_processor_u0.stall top_tb.top_u0.dlx_processor_u0.wb_reg_wr_addr top_tb.top_u0.dlx_processor_u0.wb_write_data top_tb.top_u0.dlx_processor_u0.wb_write_enable top_tb.top_u0.dlx_processor_u0.write_back_mux_sel
probe -create -database waves top_tb.top_u0.dlx_processor_u0.instruction_decode_u0.register_bank_u0.reg_file
probe -create -database waves top_tb.rom_u0.mem

simvision -input top.tcl.svcf
