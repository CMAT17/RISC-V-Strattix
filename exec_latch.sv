import rv32i_types::*;

module exec_latch
(
	input logic clk,
				latch_enable,
                flush,
	input rv32i_word rs2_data,
					 alu_data,
	input logic [2:0] control_sel_br_en, 
	input rv32i_word u_imm,
	input rv32i_ctrl_word ctrl_word,
	output rv32i_ctrl_word ctrl_word_out,
	output rv32i_word rs2_data_out,
	output rv32i_word u_imm_out,
	output rv32i_word alu_data_out,
	output logic [2:0] control_sel_br_en_out
);

register RS2_data
(
	.clk (clk),
	.load(latch_enable),
	.in  (rs2_data),
	.out (rs2_data_out)
);

register ALU_data
(
	.clk (clk),
	.load(latch_enable),
	.in  (alu_data),
	.out (alu_data_out)
);

register U_imm
(
	.clk (clk),
	.load(latch_enable),
	.in  (u_imm),
	.out (u_imm_out)
);

register #(3) Control_sel_br_en
(
	.clk (clk),
	.load(latch_enable),
	.in  (control_sel_br_en),
	.out (control_sel_br_en_out)
);


//assign ctrl_word.br_en = br_en; //If doesn't work, find way to splice in br_en to the control word.

control_reg ctrl_reg
(
	.clk (clk),
	.load(latch_enable),
    .flush(flush),
	.in  (ctrl_word),
	.out (ctrl_word_out)
);

endmodule :  exec_latch
