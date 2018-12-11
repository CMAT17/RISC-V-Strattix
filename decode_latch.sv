import rv32i_types::*;

module decode_latch
(
	input logic clk,
				latch_enable,
                flush,
	input rv32i_word rs1_data,
					 rs2_data,
	input rv32i_word i_imm,
					 b_imm,
					 u_imm,
					 j_imm,
					 s_imm,
	input rv32i_ctrl_word ctrl_word,
	output rv32i_ctrl_word ctrl_word_out,
	output rv32i_word rs1_data_out,
					  rs2_data_out,
	output rv32i_word i_imm_out,
					  b_imm_out,
					  u_imm_out,
					  j_imm_out,
					  s_imm_out
);

register I_imm
(
	.clk  (clk),
	.flush(flush),
	.load (latch_enable),
	.in   (i_imm),
	.out  (i_imm_out)
);

register B_imm
(
	.clk (clk),
	.flush(flush),
	.load(latch_enable),
	.in  (b_imm),
	.out (b_imm_out)
);

register U_imm
(
	.clk (clk),
	.flush(flush),
	.load(latch_enable),
	.in  (u_imm),
	.out (u_imm_out)
);

register J_imm
(
	.clk (clk),
	.flush(flush),
	.load(latch_enable),
	.in  (j_imm),
	.out (j_imm_out)
);

register S_imm
(
	.clk (clk),
	.flush(flush),
	.load(latch_enable),
	.in  (s_imm),
	.out (s_imm_out)
);

register RS1_data
(
	.clk (clk),
	.flush(flush),
	.load(latch_enable),
	.in  (rs1_data),
	.out (rs1_data_out)
);

register RS2_data
(
	.clk (clk),
	.flush(flush),
	.load(latch_enable),
	.in  (rs2_data),
	.out (rs2_data_out)
);

control_reg ctrl_reg
(
	.clk (clk),
	.load(latch_enable),
    .flush(flush),
	.in  (ctrl_word),
	.out (ctrl_word_out)
);

endmodule : decode_latch// decode_latch
