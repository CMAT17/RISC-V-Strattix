onerror {resume}
quietly WaveActivateNextPane {} 0
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9887875 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 357
configure wave -valuecolwidth 38
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
WaveRestoreZoom {9842324 ps} {9930325 ps}
