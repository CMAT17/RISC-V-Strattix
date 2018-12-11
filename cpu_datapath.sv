import rv32i_types::*;

module cpu_datapath
(
	input logic clk,

	input logic mem_resp_i,
				mem_resp_d,

	input logic [31:0] mem_rdata_i,
					   mem_rdata_d,
	//				   hit_l2_count_out,
	//				   hit_l1_d_count_out,
	//				   hit_l1_i_count_out,
	//				   miss_l2_count_out,
	//				   miss_l1_d_count_out,
	//				   miss_l1_i_count_out,

	output logic mem_read_i,
				 mem_read_d,
				 mem_write_i,
				 mem_write_d,

	//			 flush_hit_l1_i,
	//			 flush_hit_l1_d,
	//			 flush_hit_l2,
	//			 flush_miss_l1_i,
	//			 flush_miss_l1_d,
	//			 flush_miss_l2,

	output logic [3:0] mem_byte_enable_i,
					   mem_byte_enable_d,

	output logic [31:0] mem_wdata_i,
					    mem_wdata_d,
						mem_address_i,
						mem_address_d
);

rv32i_word alumux1_out, alumux2_out, regfilemux_out, cmpmux_out, marmux_out, alu_out, mdrmux_out, br_en_zext_out;
logic cmp_out,exec_br_en_out, reserved_addr_space;
logic latch_en, fetch_latch_en, decode_latch_en, exec_latch_en, mem_latch_en;
logic flush_fetch, flush_decode, flush_exec;
logic [2:0] exec_control_sel_br_en_out, execbubbleflushmux_out;
logic[2:0] funct3;
logic[6:0] funct7;

logic [1:0] pcmux_sel, alignment;
logic [31:0] rs2_data;
logic [31:0] rs1_data_forward, rs2_data_forward, fwdrs1mux_out, fwdrs2mux_out;
logic fwd_rs1_mux_sel, fwd_rs2_mux_sel;

rv32i_word reg1_data_out, reg2_data_out, 
		   decode_rs1_data_out, decode_rs2_data_out,
		   exec_rs2_data_out, exec_alu_data_out,
		   mem_mdr_out, mem_br_en_zext_out, mem_alu_data_out;

rv32i_word pc_out, pc_plus4, pcmux_out;
rv32i_word fetch_curr_pc_out, fetch_pc_plus4_out;

rv32i_word mem_rdata_d_lh, mem_rdata_d_lhu, mem_rdata_d_lb, mem_rdata_d_lbu;


rv32i_opcode fetch_opcode;
rv32i_ctrl_word decode_ctrl, decode_ctrl_out, exec_ctrl_out, mem_ctrl_out, execbubblemux_out, decodebubblemux_out;
logic[4:0] fetch_source_reg1, fetch_source_reg2, fetch_dest_reg;
rv32i_word fetch_i_imm,fetch_j_imm, fetch_b_imm, fetch_s_imm, fetch_u_imm,
		   decode_i_imm, decode_j_imm, decode_b_imm, decode_s_imm, decode_u_imm,
		   decode_i_imm_out, decode_j_imm_out, decode_b_imm_out, decode_s_imm_out, decode_u_imm_out,
		   exec_u_imm_out,
		   mem_u_imm_out;

/*
logic		flush_branch_count, branch_count_inc,
			flush_branch_mispred_count, branch_mispred_count_inc,
			flush_stall_mem_dep_count, stall_mem_dep_count_inc,
			flush_stall_dec_wb_dep_count, stall_dec_wb_dep_count_inc;

rv32i_word  branch_count_out,
			branch_mispred_count_out,
			stall_mem_dep_count_out,
			stall_dec_wb_dep_count_out,
			countermux_out;
*/

/* DATA FORWARDING AND STALLING */
logic hazard_stall_signal, regwr_hazard_signal;

staller staller
(
	.decode_regld		(decode_ctrl_out.load_regfile),
    .exec_regld			(exec_ctrl_out.load_regfile),
    .mem_regld			(mem_ctrl_out.load_regfile),
    .decode_rs1			(decode_ctrl_out.source_reg1),
    .decode_rs2			(decode_ctrl_out.source_reg2),
	.fetch_rs1			(fetch_source_reg1),
	.fetch_rs2			(fetch_source_reg2),
	.decode_rd			(decode_ctrl_out.dest_reg),
    .exec_rd			(exec_ctrl_out.dest_reg),
    .mem_rd				(mem_ctrl_out.dest_reg),
	.fetch_opcode		(fetch_opcode),
	.decode_opcode		(decode_ctrl_out.opcode),
    .exec_opcode		(exec_ctrl_out.opcode),
    .mem_opcode			(mem_ctrl_out.opcode),
	.exec_funct3		(exec_ctrl_out.funct3),
	.mem_funct3			(mem_ctrl_out.funct3),
    .exec_alu_out		(exec_alu_data_out),
	.exec_zext_br_en_out(br_en_zext_out),
	.exec_u_imm_out		(exec_u_imm_out),
    .mem_alu_out		(mem_alu_data_out),
	.mem_zext_br_en_out(mem_br_en_zext_out),
    .mem_rdata_out		(mem_mdr_out),
	.mem_u_imm_out		(mem_u_imm_out),
    .rs2_fwd_sel		(fwd_rs2_mux_sel),
    .rs1_fwd_sel		(fwd_rs1_mux_sel),
    .hazard_stall_signal(hazard_stall_signal),
	.regwr_hazard_signal(regwr_hazard_signal),
    .rs1_data_forward	(rs1_data_forward),
    .rs2_data_forward	(rs2_data_forward)
);

/* FETCH STAGE */

assign mem_read_d = exec_ctrl_out.mem_read; // & !reserved_addr_space;
assign mem_write_d = exec_ctrl_out.mem_write; // & !reserved_addr_space;
assign latch_en = ~((mem_read_d | mem_write_d) & ~mem_resp_d);
assign fetch_latch_en = mem_resp_i & latch_en & hazard_stall_signal & regwr_hazard_signal;
assign pc_plus4 = pc_out + 4;
assign mem_address_i = pc_out;
assign mem_write_i = 1'b0;
assign mem_read_i = 1'b1;
//assign mem_byte_enable_i = 4'b1111;
assign mem_byte_enable_i = 2'b00;
assign mem_wdata_i = 31'hx;

assign flush_fetch = (pcmux_sel != 2'b00);

mux4 pcmux
(
	.sel(pcmux_sel),//Get the right pcmux_sel
	.a  (pc_plus4),
	.b  (exec_alu_data_out), //GET right alu_out
	.c  ((exec_alu_data_out & 32'hFFFFFFFE)), //GET right alu_out
	.f  (pcmux_out)
);

mux4 #(.width(2)) pcmuxselmux 
(
	//.sel(exec_ctrl_out.pc_branch_jump_sel),
	.sel(exec_control_sel_br_en_out[2:1]),
	.a(2'b00),
	.b(2'b01),
	.c(2'b10),
	//.d({1'b0,exec_br_en_out}),
	.d({1'b0,exec_control_sel_br_en_out[0]}),
	.f(pcmux_sel)
);

pc_register PC
(
	.clk (clk),
	.load(fetch_latch_en),
	.in  (pcmux_out),
	.out (pc_out)
);

fetch_latch REG_fetch
(
	.clk         (clk),
	.flush		 (flush_fetch),
	.latch_enable(fetch_latch_en),
	.pc_plus4_in (pc_plus4),
	.pc_in       (pc_out),
	.curr_pc_out (fetch_curr_pc_out),
	.pc_plus4_out(fetch_pc_plus4_out),
	.i_rdata     (mem_rdata_i),
	.funct3      (funct3),
	.funct7      (funct7),
	.opcode      (fetch_opcode),
	.i_imm       (fetch_i_imm),
	.s_imm       (fetch_s_imm),
	.b_imm       (fetch_b_imm),
	.u_imm       (fetch_u_imm),
	.j_imm       (fetch_j_imm),
	.rs1         (fetch_source_reg1),
	.rs2         (fetch_source_reg2),
	.rd          (fetch_dest_reg)
);
/* DECODE STAGE */

assign decode_latch_en = mem_resp_i & latch_en & hazard_stall_signal;
assign flush_decode = (pcmux_sel != 2'b00);

control_rom decode_block
(
	.opcode   (fetch_opcode),
	.funct3   (funct3),
	.funct7   (funct7),
	.src_reg1 (fetch_source_reg1),
	.src_reg2 (fetch_source_reg2),
	.dest_reg (fetch_dest_reg),
	.curr_pc  (fetch_curr_pc_out),
	.pc_plus4 (fetch_pc_plus4_out),
	.ctrl_word(decode_ctrl)
);

regfile Regfile
(
	.clk  (clk),
	.load (mem_ctrl_out.load_regfile), 
	.in   (regfilemux_out),
	.src_a(fetch_source_reg1),
	.src_b(fetch_source_reg2),
	.dest (mem_ctrl_out.dest_reg), 
	.reg_a(reg1_data_out),
	.reg_b(reg2_data_out)
);

mux2 #(.width($bits(rv32i_ctrl_word))) decodebubblemux
(
	.sel(regwr_hazard_signal),
	.a  (0),
	.b  (decode_ctrl),
	.f  (decodebubblemux_out)
);

decode_latch REG_decode
(
	.clk          (clk),
	.latch_enable (decode_latch_en),
    .flush        (flush_decode),
	.rs1_data     (reg1_data_out),
	.rs2_data     (reg2_data_out),
	.i_imm        (fetch_i_imm),
	.b_imm        (fetch_b_imm),
	.u_imm        (fetch_u_imm),
	.j_imm        (fetch_j_imm),
	.s_imm        (fetch_s_imm),
	.ctrl_word    (decodebubblemux_out),
	.ctrl_word_out(decode_ctrl_out),
	.rs1_data_out (decode_rs1_data_out),
	.rs2_data_out (decode_rs2_data_out),
	.i_imm_out    (decode_i_imm_out),
	.b_imm_out    (decode_b_imm_out),
	.u_imm_out    (decode_u_imm_out),
	.j_imm_out    (decode_j_imm_out),
	.s_imm_out    (decode_s_imm_out)
);
/* EXEC STAGE */

assign exec_latch_en = mem_resp_i & latch_en;
//assign flush_exec = ~hazard_stall_signal & mem_resp_d;
assign flush_exec = 0;

mux2 fwdrs1mux
(
    .sel(fwd_rs1_mux_sel),
    .a  (decode_rs1_data_out),
    .b  (rs1_data_forward),
    .f  (fwdrs1mux_out)
);

mux2 fwdrs2mux
(
    .sel(fwd_rs2_mux_sel),
    .a  (decode_rs2_data_out),
    .b  (rs2_data_forward),
    .f  (fwdrs2mux_out)
);

mux2 alumux1
(
	.sel(decode_ctrl_out.alumux1_sel),
	.a  (fwdrs1mux_out),
	.b  (decode_ctrl_out.curr_pc),
	.f  (alumux1_out)
);

mux8 alumux2
(
	.sel(decode_ctrl_out.alumux2_sel),
	.a  (decode_i_imm_out),
	.b  (decode_u_imm_out),
	.c  (decode_b_imm_out),
	.d  (decode_s_imm_out),
	.e  (decode_j_imm_out),
	.f  (fwdrs2mux_out),
	.res(alumux2_out)
);

mux2 cmpmux
(
	.sel(decode_ctrl_out.cmpmux_sel),
	.a  (fwdrs2mux_out),
	.b  (decode_i_imm_out),
	.f  (cmpmux_out)
);

alu ALU
(
	.aluop(decode_ctrl_out.aluop),
	.a    (alumux1_out),
	.b    (alumux2_out),
	.f    (alu_out)
);

cmp CMP
(
	.cmpop  (decode_ctrl_out.cmpop),
	.a      (fwdrs1mux_out),
	.b      (cmpmux_out),
	.cmp_out(cmp_out)
);

mux2 #(.width($bits(rv32i_ctrl_word))) execbubblemux
(
	.sel(hazard_stall_signal),
	.a  (0),
	.b  (decode_ctrl_out),
	.f  (execbubblemux_out)
);

mux2 #(3) execbubbleflushmux
(
	.sel(hazard_stall_signal),
	.a	(3'b000),
	.b	({decode_ctrl_out.pc_branch_jump_sel, cmp_out}),
	.f	(execbubbleflushmux_out)
);

exec_latch REG_exec
(
	.clk          (clk),
	.latch_enable (exec_latch_en),
    .flush        (flush_exec),
	.rs2_data     (fwdrs2mux_out),
	.alu_data     (alu_out),
	.control_sel_br_en        (execbubbleflushmux_out),
	.u_imm        (decode_u_imm_out),
	.ctrl_word    (execbubblemux_out),
	.ctrl_word_out(exec_ctrl_out),
	.rs2_data_out (exec_rs2_data_out),
	.u_imm_out    (exec_u_imm_out),
	.alu_data_out (exec_alu_data_out),
	.control_sel_br_en_out	  (exec_control_sel_br_en_out)
);

/* MEM STAGE */

assign mem_latch_en = mem_resp_i & latch_en; //change later for stalling
//assign rs2_data = exec_rs2_data_out;
assign mem_wdata_d = exec_rs2_data_out;
assign mem_byte_enable_d = exec_ctrl_out.mem_byte_enable; //change for h/b alignment
//assign mem_rdata_d_lh = {{16{mem_rdata_d[15]}}, mem_rdata_d[15:0]};
//assign mem_rdata_d_lhu = {{16{1'b0}}, mem_rdata_d[15:0]};
//assign mem_rdata_d_lb = {{24{mem_rdata_d[7]}}, mem_rdata_d[7:0]};
//assign mem_rdata_d_lbu = {{24{1'b0}}, mem_rdata_d[7:0]};
assign alignment = mem_address_d[1:0];

/*
mux4 store_size_mux
(
	.sel(exec_ctrl_out.mem_byte_enable),
	.a({rs2_data[31:24], rs2_data[23:16], rs2_data[15:8], rs2_data[7:0]}),
	.b({{16{1'b0}}, rs2_data[15:8], rs2_data[7:0]}),
	.c({{24{1'b0}}, rs2_data[7:0]}),
	.f(mem_wdata_d)
);
*/

mux2 marmux
(
	.sel(exec_ctrl_out.marmux_sel),
	.a  (exec_ctrl_out.curr_pc),
	.b  (exec_alu_data_out),
	.f  (mem_address_d)
);
/* Retarded Counter Section */
/* 0xF Hit_L1_I
 * 0xE Miss_L1_I
 * 0xD Hit_L1_D
 * 0xC Miss_L1_D
 * 0xB Hit_L2
 * 0xA Miss_L2
 * 0x9 Branch_count
 * 0x8 Branch_mispred_count
 * 0x7 Stall_mem_dep_count
 * 0x6 Stall_dec_wb_dep_count
 */

/*
assign flush_hit_l1_i = (exec_ctrl_out.opcode == op_store) & (reserved_addr_space) & (exec_alu_data_out[3:0] == 4'hF);
assign flush_miss_l1_i = (exec_ctrl_out.opcode == op_store) & (reserved_addr_space) & (exec_alu_data_out[3:0] == 4'hE);
assign flush_hit_l1_d = (exec_ctrl_out.opcode == op_store) & (reserved_addr_space) & (exec_alu_data_out[3:0] == 4'hD);
assign flush_miss_l1_d = (exec_ctrl_out.opcode == op_store) & (reserved_addr_space) & (exec_alu_data_out[3:0] == 4'hC);
assign flush_hit_l2 = (exec_ctrl_out.opcode == op_store) & (reserved_addr_space) & (exec_alu_data_out[3:0] == 4'hB);
assign flush_miss_l2 = (exec_ctrl_out.opcode == op_store) & (reserved_addr_space) & (exec_alu_data_out[3:0] == 4'hA);


assign reserved_addr_space = exec_alu_data_out[31] & exec_alu_data_out[30] & exec_alu_data_out[29] & exec_alu_data_out[28] &
							 exec_alu_data_out[27] & exec_alu_data_out[26] & exec_alu_data_out[25] & exec_alu_data_out[24] &
							 exec_alu_data_out[23] & exec_alu_data_out[22] & exec_alu_data_out[21] & exec_alu_data_out[20] &
							 exec_alu_data_out[19] & exec_alu_data_out[18] & exec_alu_data_out[17] & exec_alu_data_out[16] &
							 exec_alu_data_out[15] & exec_alu_data_out[14] & exec_alu_data_out[13] & exec_alu_data_out[12] &
							 exec_alu_data_out[11] & exec_alu_data_out[10] & exec_alu_data_out[9 ] & exec_alu_data_out[8 ] &
							 exec_alu_data_out[7 ] & exec_alu_data_out[6 ] & exec_alu_data_out[5 ] & exec_alu_data_out[4 ] ;

assign flush_branch_count = (exec_ctrl_out.opcode == op_store) & (reserved_addr_space) & (exec_alu_data_out[3:0] == 4'h9);
assign branch_count_inc = exec_ctrl_out.opcode == op_br; 


//TODO: should be number of unique branches in br pred
counter_reg branch_count 
(
	.clk  (clk),
	.inc  (branch_count_inc),//TODO
	.flush(flush_branch_count),
	.out  (branch_count_out)
);

assign flush_branch_mispred_count = (exec_ctrl_out.opcode == op_store) & (reserved_addr_space) & (exec_alu_data_out[3:0] == 4'h8);
assign branch_mispred_count_inc = flush_decode;

counter_reg branch_mispred_count
(
	.clk  (clk),
	.inc  (branch_mispred_count_inc),
	.flush(flush_branch_mispred_count),
	.out  (branch_mispred_count_out)
);

//Load followed by dependent instruction stall (WB -> EXEC forward)

assign flush_stall_mem_dep_count = (exec_ctrl_out.opcode == op_store) & (reserved_addr_space) & (exec_alu_data_out[3:0] == 4'h7);
assign stall_mem_dep_count_inc = (hazard_stall_signal == 1'b0);

counter_reg stall_mem_dep_count
(
	.clk  (clk),
	.inc  (stall_mem_dep_count_inc),
	.flush(flush_stall_mem_dep_count),
	.out  (stall_mem_dep_count_out)
);

assign flush_stall_dec_wb_dep_count = (exec_ctrl_out.opcode == op_store) & (reserved_addr_space) & (exec_alu_data_out[3:0] == 4'h6);
assign stall_dec_wb_dep_count_inc = (regwr_hazard_signal == 1'b0);

//Write to regfile at same time of read from regfile
counter_reg stall_dec_wb_dep_count
(
	.clk  (clk),
	.inc  (stall_dec_wb_dep_count_inc),
	.flush(flush_stall_dec_wb_dep_count),
	.out  (stall_dec_wb_dep_count_out)
);
*/


mux2 lh_align_mux
(
	.sel(alignment != 0),
	.a	({{16{mem_rdata_d[15]}}, mem_rdata_d[15:0]}),
	.b	({{16{mem_rdata_d[31]}}, mem_rdata_d[31:16]}),
	.f	(mem_rdata_d_lh)
);

mux2 lhu_align_mux
(
	.sel(alignment != 0),
	.a	({{16{1'b0}}, mem_rdata_d[15:0]}),
	.b	({{16{1'b0}}, mem_rdata_d[31:16]}),
	.f	(mem_rdata_d_lhu)
);


/*
mux4 lh_align_mux
(
	.sel(alignment),
	.a	({{16{mem_rdata_d[15]}}, mem_rdata_d[15:0]}),
	.c	({{16{mem_rdata_d[31]}}, mem_rdata_d[31:16]}),
	.f	(mem_rdata_d_lh)
);

mux4 lhu_align_mux
(
	.sel(alignment),
	.a	({{16{1'b0}}, mem_rdata_d[15:0]}),
	.c	({{16{1'b0}}, mem_rdata_d[31:16]}),
	.f	(mem_rdata_d_lhu)
);
*/

mux4 lb_align_mux
(
	.sel(alignment),
	.a	({{24{mem_rdata_d[7]}}, mem_rdata_d[7:0]}),
	.b	({{24{mem_rdata_d[15]}}, mem_rdata_d[15:8]}),
	.c	({{24{mem_rdata_d[23]}}, mem_rdata_d[23:16]}),
	.d	({{24{mem_rdata_d[31]}}, mem_rdata_d[31:24]}),
	.f	(mem_rdata_d_lb)
);

mux4 lbu_align_mux
(
	.sel(alignment),
	.a	({{24{1'b0}}, mem_rdata_d[7:0]}),
	.b	({{24{1'b0}}, mem_rdata_d[15:8]}),
	.c	({{24{1'b0}}, mem_rdata_d[23:16]}),
	.d	({{24{1'b0}}, mem_rdata_d[31:24]}),
	.f	(mem_rdata_d_lbu)
);

/*
mux16 countermux
(
	.sel(exec_alu_data_out[3:0]),
	.entry6(stall_dec_wb_dep_count_out),
	.entry7(stall_mem_dep_count_out),
	.entry8(branch_mispred_count_out),
	.entry9(branch_count_out),
	.entryA(miss_l2_count_out),
	.entryB(hit_l2_count_out),
	.entryC(miss_l1_d_count_out),
	.entryD(hit_l1_d_count_out),
	.entryE(miss_l1_i_count_out),
	.entryF(hit_l1_i_count_out),
	.res   (countermux_out)
);
*/

mux8 mdrmux 
(
	//.sel({exec_ctrl_out.mdrmux_sel[2] | reserved_addr_space, exec_ctrl_out.mdrmux_sel[1] & !reserved_addr_space, exec_ctrl_out.mdrmux_sel[0] | reserved_addr_space}),
	.sel(exec_ctrl_out.mdrmux_sel),
	.a  (mem_rdata_d),
	.b	(mem_rdata_d_lh),
	.c  (mem_rdata_d_lhu),
	.d  (mem_rdata_d_lb),
	.e  (mem_rdata_d_lbu),
	//.f  (countermux_out),
	.res(mdrmux_out)
);

zext #(.width(32)) br_en_zext
(
	//.in (exec_ctrl_out.br_en)
	.in(exec_control_sel_br_en_out[0]),
	.out(br_en_zext_out)
);

mem_latch REG_mem
(
	.clk           (clk),
	.latch_enable	(mem_latch_en),
	.ctrl_word     (exec_ctrl_out),
	.mdr_in        (mdrmux_out),
	.u_imm         (exec_u_imm_out),
	.alu_data      (exec_alu_data_out),
	.br_en_zext    (br_en_zext_out),

	.mdr_out       (mem_mdr_out),
	.u_imm_out     (mem_u_imm_out),
	.br_en_zext_out(mem_br_en_zext_out),
	.alu_data_out  (mem_alu_data_out),
	.ctrl_word_out (mem_ctrl_out)
);

/* WRITEBACK STAGE */

mux8 regfilemux
(
	.sel(mem_ctrl_out.regfilemux_sel),
	.a  (mem_alu_data_out),
	.b  (mem_br_en_zext_out),
	.c  (mem_u_imm_out),
	.d  (mem_mdr_out),
	.e  (mem_ctrl_out.pc_plus4),
	.res(regfilemux_out)
);

endmodule : cpu_datapath
