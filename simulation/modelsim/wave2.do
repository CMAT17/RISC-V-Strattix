onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/pmem_resp
add wave -noupdate /mp3_tb/pmem_read
add wave -noupdate /mp3_tb/pmem_write
add wave -noupdate /mp3_tb/pmem_address
add wave -noupdate /mp3_tb/pmem_wdata
add wave -noupdate /mp3_tb/pmem_rdata
add wave -noupdate /mp3_tb/write_data
add wave -noupdate /mp3_tb/write_address
add wave -noupdate /mp3_tb/write
add wave -noupdate /mp3_tb/halt
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/dut/cpu/mem_wdata_d
add wave -noupdate -expand /mp3_tb/dut/cpu/Regfile/data
add wave -noupdate /mp3_tb/dut/cpu/PC/data
add wave -noupdate /mp3_tb/dut/cpu/staller/exec_regld
add wave -noupdate /mp3_tb/dut/cpu/staller/mem_regld
add wave -noupdate /mp3_tb/dut/cpu/staller/decode_rs1
add wave -noupdate /mp3_tb/dut/cpu/staller/decode_rs2
add wave -noupdate /mp3_tb/dut/cpu/staller/exec_rd
add wave -noupdate /mp3_tb/dut/cpu/staller/mem_rd
add wave -noupdate /mp3_tb/dut/cpu/staller/exec_opcode
add wave -noupdate /mp3_tb/dut/cpu/staller/mem_opcode
add wave -noupdate /mp3_tb/dut/cpu/staller/exec_funct3
add wave -noupdate /mp3_tb/dut/cpu/staller/mem_funct3
add wave -noupdate /mp3_tb/dut/cpu/staller/exec_alu_out
add wave -noupdate /mp3_tb/dut/cpu/staller/exec_zext_br_en_out
add wave -noupdate /mp3_tb/dut/cpu/staller/mem_alu_out
add wave -noupdate /mp3_tb/dut/cpu/staller/mem_zext_br_en_out
add wave -noupdate /mp3_tb/dut/cpu/staller/mem_rdata_out
add wave -noupdate /mp3_tb/dut/cpu/staller/rs2_fwd_sel
add wave -noupdate /mp3_tb/dut/cpu/fwdrs2mux/a
add wave -noupdate /mp3_tb/dut/cpu/fwdrs2mux/b
add wave -noupdate /mp3_tb/dut/cpu/fwdrs2mux/f
add wave -noupdate /mp3_tb/dut/cpu/staller/rs1_fwd_sel
add wave -noupdate /mp3_tb/dut/cpu/fwdrs1mux/a
add wave -noupdate /mp3_tb/dut/cpu/fwdrs1mux/b
add wave -noupdate /mp3_tb/dut/cpu/fwdrs1mux/f
add wave -noupdate /mp3_tb/dut/cpu/staller/hazard_stall_signal
add wave -noupdate /mp3_tb/dut/cpu/staller/rs1_data_forward
add wave -noupdate /mp3_tb/dut/cpu/staller/rs2_data_forward
add wave -noupdate /mp3_tb/dut/cpu/REG_fetch/curr_pc_out
add wave -noupdate /mp3_tb/dut/cpu/REG_fetch/opcode
add wave -noupdate /mp3_tb/dut/cpu/REG_fetch/rs1
add wave -noupdate /mp3_tb/dut/cpu/REG_fetch/rs2
add wave -noupdate /mp3_tb/dut/cpu/REG_decode/ctrl_word_out.curr_pc
add wave -noupdate /mp3_tb/dut/cpu/REG_decode/ctrl_word_out.opcode
add wave -noupdate /mp3_tb/dut/cpu/REG_decode/ctrl_word_out.source_reg1
add wave -noupdate /mp3_tb/dut/cpu/REG_decode/ctrl_word_out.source_reg2
add wave -noupdate /mp3_tb/dut/cpu/REG_decode/ctrl_word_out.dest_reg
add wave -noupdate /mp3_tb/dut/cpu/REG_decode/rs1_data_out
add wave -noupdate /mp3_tb/dut/cpu/REG_decode/rs2_data_out
add wave -noupdate /mp3_tb/dut/cpu/REG_exec/ctrl_word_out.curr_pc
add wave -noupdate /mp3_tb/dut/cpu/REG_exec/ctrl_word_out.opcode
add wave -noupdate /mp3_tb/dut/cpu/REG_exec/ctrl_word_out.dest_reg
add wave -noupdate /mp3_tb/dut/cpu/REG_exec/rs2_data_out
add wave -noupdate /mp3_tb/dut/cpu/REG_exec/alu_data_out
add wave -noupdate /mp3_tb/dut/cpu/REG_mem/ctrl_word_out.curr_pc
add wave -noupdate /mp3_tb/dut/cpu/REG_mem/ctrl_word_out.opcode
add wave -noupdate /mp3_tb/dut/cpu/REG_mem/ctrl_word_out.source_reg1
add wave -noupdate /mp3_tb/dut/cpu/REG_mem/ctrl_word_out.source_reg2
add wave -noupdate /mp3_tb/dut/cpu/REG_mem/ctrl_word_out.dest_reg
add wave -noupdate /mp3_tb/dut/cpu/REG_mem/alu_data_out
add wave -noupdate /mp3_tb/dut/cpu/REG_mem/mdr_out
add wave -noupdate /mp3_tb/dut/evb/evb_datapath/write
add wave -noupdate /mp3_tb/dut/evb/evb_datapath/complete_eviction
add wave -noupdate /mp3_tb/dut/evb/evb_datapath/wdata_in
add wave -noupdate /mp3_tb/dut/evb/evb_datapath/address_in
add wave -noupdate /mp3_tb/dut/evb/evb_datapath/wdata_out
add wave -noupdate /mp3_tb/dut/evb/evb_datapath/address_out
add wave -noupdate /mp3_tb/dut/evb/evb_datapath/valid_out
add wave -noupdate /mp3_tb/dut/evb/evb_datapath/data
add wave -noupdate /mp3_tb/dut/evb/l2pmem_address
add wave -noupdate /mp3_tb/dut/evb/l2pmem_wdata
add wave -noupdate /mp3_tb/dut/evb/l2_read
add wave -noupdate /mp3_tb/dut/evb/l2_write
add wave -noupdate /mp3_tb/dut/evb/pmem_resp
add wave -noupdate /mp3_tb/dut/evb/blocking
add wave -noupdate /mp3_tb/dut/evb/send_ewb_to_pmem
add wave -noupdate /mp3_tb/dut/evb/ewb_pmem_wdata
add wave -noupdate /mp3_tb/dut/evb/ewb_pmem_address
add wave -noupdate /mp3_tb/dut/evb/complete_eviction
add wave -noupdate /mp3_tb/dut/evb/ewb_valid
add wave -noupdate -expand /mp3_tb/dut/l2cache/cache_datapath/data_array0/data
add wave -noupdate /mp3_tb/dut/l2cache/cache_datapath/data_array1/data
add wave -noupdate /mp3_tb/dut/l2cache/cache_datapath/data_array2/data
add wave -noupdate /mp3_tb/dut/l2cache/cache_datapath/data_array3/data
add wave -noupdate /mp3_tb/dut/l2cache/cache_datapath/dirty_array0/data
add wave -noupdate /mp3_tb/dut/l2cache/cache_datapath/dirty_array1/data
add wave -noupdate /mp3_tb/dut/l2cache/cache_datapath/dirty_array2/data
add wave -noupdate /mp3_tb/dut/l2cache/cache_datapath/dirty_array3/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5682146 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 357
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2865212 ps} {3849588 ps}
