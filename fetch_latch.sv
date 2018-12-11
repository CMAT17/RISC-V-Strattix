import rv32i_types::*;

module fetch_latch
(
	input logic clk,
	input logic flush,
	input logic latch_enable,

	//PC
	input rv32i_word pc_plus4_in,
	input rv32i_word pc_in, 


	output rv32i_word curr_pc_out,
	output rv32i_word pc_plus4_out,

	//IR 
	input rv32i_word i_rdata,
	output [2:0] funct3,
    output [6:0] funct7,
    output rv32i_opcode opcode,
    output [31:0] i_imm,
    output [31:0] s_imm,
    output [31:0] b_imm,
    output [31:0] u_imm,
    output [31:0] j_imm,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd 
);
logic load_ir;
logic load_pc;
logic load_pcp4;

assign load_ir = latch_enable;
assign load_pc = latch_enable;
assign load_pcp4 = latch_enable;

register PC_Plus4
(
	.clk  (clk),
	.flush(flush),
	.load (load_pcp4),
	.in   (pc_plus4_in),
	.out  (pc_plus4_out)
);

register PC
(
	.clk  (clk),
	.flush(flush),
	.load (load_pc),
	.in   (pc_in),
	.out  (curr_pc_out)
);

ir IR
(
	.clk   (clk),
	.flush (flush),
	.load  (load_ir),
	.in    (i_rdata),
	.funct3(funct3),
	.funct7(funct7),
	.opcode(opcode),
	.i_imm (i_imm),
	.s_imm (s_imm),
	.b_imm (b_imm),
	.u_imm (u_imm),
	.j_imm (j_imm),
	.rs1   (rs1),
	.rs2   (rs2),
	.rd    (rd)
);

endmodule : fetch_latch// fetch_latch
