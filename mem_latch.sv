import rv32i_types::*;

module mem_latch
(
	input logic clk,
	input logic latch_enable,
	input rv32i_ctrl_word ctrl_word,
	input rv32i_word mdr_in,
					 u_imm,
					 br_en_zext,
					 alu_data,

	output rv32i_word mdr_out,
					  u_imm_out,
					  br_en_zext_out,
					  alu_data_out,
	output rv32i_ctrl_word ctrl_word_out
);

register U_imm
(
	.clk (clk),
	.load(latch_enable),
	.in  (u_imm),
	.out (u_imm_out)
);

register BR_en_zext
(
	.clk (clk),
	.load(latch_enable),
	.in  (br_en_zext),
	.out (br_en_zext_out)
);

register mdr
(
	.clk (clk),
	.load(latch_enable),
	.in  (mdr_in),
	.out (mdr_out)
);

control_reg ctrl_reg
(
	.clk (clk),
	.load(latch_enable),
    .flush(1'b0),
	.in  (ctrl_word),
	.out (ctrl_word_out)
);

register ALU_data
(
	.clk (clk),
	.load(latch_enable),
	.in  (alu_data),
	.out (alu_data_out)
);

endmodule : mem_latch// mem_latch
