import rv32i_types::*;

module staller
(
    input logic exec_regld,
                mem_regld,
					 decode_regld,

    input logic [4:0] decode_rs1,
                      decode_rs2,
							 fetch_rs1,
							 fetch_rs2,
                      exec_rd,
                      mem_rd,
							 decode_rd,

    input rv32i_opcode fetch_opcode,
					   decode_opcode,
					   exec_opcode,
                       mem_opcode,

	input logic[2:0] exec_funct3,
					 mem_funct3,

    input logic [31:0] exec_alu_out,
					   exec_zext_br_en_out,
					   exec_u_imm_out,
                       mem_alu_out,
					   mem_zext_br_en_out,
                       mem_rdata_out,
					   mem_u_imm_out,

    output logic rs2_fwd_sel,
                 rs1_fwd_sel,
                 hazard_stall_signal,
					  regwr_hazard_signal,

    output logic [31:0] rs1_data_forward,
                        rs2_data_forward
);

always_comb begin
hazard_stall_signal = 1'b1;
regwr_hazard_signal = 1'b1;
rs1_fwd_sel = 1'b0;
rs2_fwd_sel = 1'b0;
rs1_data_forward = 32'bX;
rs2_data_forward = 32'bX;
	 
	// activates stalling for decode stage and upstream
	if ((fetch_rs1 == mem_rd) 
	    & ((fetch_rs1 != exec_rd) | !exec_regld)
		& ((fetch_rs1 != decode_rd) | !decode_regld)
		& mem_rd != 5'd0 & mem_regld == 1'b1)
	begin
		 regwr_hazard_signal = 0;
	end

	else /*DO NOTHING*/;

	if ((fetch_rs2 == mem_rd) 
	    & ((fetch_rs2 != exec_rd) | !exec_regld)
		& ((fetch_rs2 != decode_rd) | !decode_regld)
		& mem_rd != 5'd0 & mem_regld == 1'b1 & fetch_opcode != op_imm)
	begin	
		regwr_hazard_signal = 0;
	end

	else /*DO NOTHING*/;

	if (((fetch_rs1 == exec_rd & fetch_rs2 == decode_rd) |
	    (fetch_rs1 == decode_rd & fetch_rs2 == exec_rd)) 
		& (decode_rd != exec_rd) & exec_regld & decode_regld 
		& decode_opcode == op_load & exec_rd != 5'b0)
	begin
		regwr_hazard_signal = 0;
	end

	else /*DO NOTHING*/;
	
/*
	if (	((fetch_rs1 == mem_rd) 
	    	& ((fetch_rs1 != exec_rd) | !exec_regld)
			& ((fetch_rs1 != decode_rd) | !decode_regld)
			& mem_rd != 5'd0 & mem_regld == 1'b1)
		||	((fetch_rs2 == mem_rd) 
	    	& ((fetch_rs2 != exec_rd) | !exec_regld)
			& ((fetch_rs2 != decode_rd) | !decode_regld)
			& mem_rd != 5'd0 & mem_regld == 1'b1 & fetch_opcode != op_imm)
		||	(((fetch_rs1 == exec_rd & fetch_rs2 == decode_rd) |
	    	(fetch_rs1 == decode_rd & fetch_rs2 == exec_rd)) 
			& (decode_rd != exec_rd) & exec_regld & decode_regld 
			& decode_opcode == op_load & exec_rd != 5'b0)
	   )
	begin
		regwr_hazard_signal = 0;
	end
*/

	 
    // activates stalling for exec stage and upstream
    if (exec_opcode == op_load & (decode_rs1 == exec_rd | decode_rs2 == exec_rd ) & exec_rd != 5'd0)
        hazard_stall_signal = 0;

	else /*DO NOTHING*/;

    // data forwarding alu_out for RS1 from execution stage
    if (exec_regld & decode_rs1 == exec_rd & exec_rd != 5'd0 
		& ((exec_opcode == op_imm & exec_funct3 != 3'b010 & exec_funct3 != 3'b011)
		| (exec_opcode == op_reg & exec_funct3 != 3'b010 & exec_funct3 != 3'b011)
        | exec_opcode == op_auipc)) 
	begin
        rs1_data_forward = exec_alu_out;
        rs1_fwd_sel = 1;
    end

	else /*DO NOTHING*/;

	// data forwarding u_imm_out for RS1 from execution stage for LUI
    if (exec_regld & decode_rs1 == exec_rd & exec_rd != 5'd0 & exec_opcode == op_lui) 
	begin
        rs1_data_forward = exec_u_imm_out;
        rs1_fwd_sel = 1;
    end

	else /*DO NOTHING*/;

    // data forwarding alu_out for RS2 from execution stage
    if (exec_regld & decode_rs2 == exec_rd & exec_rd != 5'd0
		& ((exec_opcode == op_imm & exec_funct3 != 3'b010 & exec_funct3 != 3'b011)
		| (exec_opcode == op_reg & exec_funct3 != 3'b010 & exec_funct3 != 3'b011)
        | exec_opcode == op_lui | exec_opcode == op_auipc) 
		& decode_opcode != op_imm) 
	begin
        rs2_data_forward = exec_alu_out;
        rs2_fwd_sel = 1;
    end

	else /*DO NOTHING*/;

	// data forwarding u_imm_out for RS2 from execution stage for LUI
    if (exec_regld & decode_rs2 == exec_rd & exec_rd != 5'd0 & exec_opcode == op_lui & decode_opcode != op_imm) 
	begin
        rs2_data_forward = exec_u_imm_out;
        rs2_fwd_sel = 1;
	end

	else /*DO NOTHING*/;

	// data forwarding zext_br_en_out for RS1 from execution stage for SLT/SLTU
    if (exec_regld & decode_rs1 == exec_rd & exec_rd != 5'd0 
		& ((exec_opcode == op_imm & (exec_funct3 == 3'b010 | exec_funct3 == 3'b011))
		| (exec_opcode == op_reg & (exec_funct3 == 3'b010 | exec_funct3 == 3'b011)))) 
	begin
        rs1_data_forward = exec_zext_br_en_out;
        rs1_fwd_sel = 1;
    end

	else /*DO NOTHING*/;

    // data forwarding zext_br_en_out for RS2 from execution stage for SLT/SLTU
    if (exec_regld & decode_rs2 == exec_rd & exec_rd != 5'd0 
		& ((exec_opcode == op_imm & (exec_funct3 == 3'b010 | exec_funct3 == 3'b011))
		| (exec_opcode == op_reg & (exec_funct3 == 3'b010 | exec_funct3 == 3'b011)))
		& decode_opcode != op_imm) 
	begin
        rs2_data_forward = exec_zext_br_en_out;
        rs2_fwd_sel = 1;
    end
	
	else /*DO NOTHING*/;

    // data forwarding rdata_out for RS1 from memory load/store
    if (mem_regld & decode_rs1 == mem_rd & mem_rd != 5'd0 & (mem_opcode == op_load | mem_opcode == op_store)
        & (decode_rs1 != exec_rd | ~exec_regld)) 
	begin
        rs1_data_forward = mem_rdata_out;
        rs1_fwd_sel = 1;
    end

	else /*DO NOTHING*/;

    // data forwarding rdata_out for RS2 from memory load/store
    if (mem_regld & decode_rs2 == mem_rd & mem_rd != 5'd0 & (mem_opcode == op_load | mem_opcode == op_store)
        & (decode_rs2 != exec_rd | ~exec_regld)) 
	begin
        rs2_data_forward = mem_rdata_out;
        rs2_fwd_sel = 1;
    end

	else /*DO NOTHING*/;

    // data forwarding alu_out for RS1 from memory stage
    if (mem_regld & decode_rs1 == mem_rd & mem_rd != 5'd0 
		& ((mem_opcode == op_imm & mem_funct3 != 3'b010 & mem_funct3 != 3'b011) 
		| (mem_opcode == op_reg & mem_funct3 != 3'b010 & mem_funct3 != 3'b011)
        | mem_opcode == op_lui | mem_opcode == op_auipc) 
		& (decode_rs1 != exec_rd | ~exec_regld)) 
	begin
        rs1_data_forward = mem_alu_out;
        rs1_fwd_sel = 1;
    end

	else /*DO NOTHING*/;

	// data forwarding u_imm_out for RS1 from memory stage for LUI
    if (mem_regld & decode_rs1 == mem_rd & mem_rd != 5'd0 & mem_opcode == op_lui 
		& (decode_rs1 != exec_rd | ~exec_regld)) 
	begin
        rs1_data_forward = mem_u_imm_out;
        rs1_fwd_sel = 1;
    end

	else /*DO NOTHING*/;

    // data forwarding alu_out for RS2 from memory stage
    if (mem_regld & decode_rs2 == mem_rd & mem_rd != 5'd0 
		& ((mem_opcode == op_imm & mem_funct3 != 3'b010 & mem_funct3 != 3'b011) 
		| (mem_opcode == op_reg & mem_funct3 != 3'b010 & mem_funct3 != 3'b011)
        | mem_opcode == op_lui | mem_opcode == op_auipc) 
		& (decode_rs2 != exec_rd | ~exec_regld) & decode_opcode != op_imm) 
	begin
        rs2_data_forward = mem_alu_out;
        rs2_fwd_sel = 1;
    end

	else /*DO NOTHING*/;

	// data forwarding u_imm_out for RS2 from memory stage for LUI
    if (mem_regld & decode_rs2 == mem_rd & mem_rd != 5'd0 & mem_opcode == op_lui 
		& (decode_rs2 != exec_rd | ~exec_regld) & decode_opcode != op_imm) 
	begin
        rs2_data_forward = mem_u_imm_out;
        rs2_fwd_sel = 1;
    end

	else /*DO NOTHING*/;

	// data forwarding zext_br_en_out for RS1 from memory stage for SLT/SLTU
    if (mem_regld & decode_rs1 == mem_rd & mem_rd != 5'd0 
		& ((mem_opcode == op_imm & (mem_funct3 == 3'b010 | mem_funct3 == 3'b011))
		| (mem_opcode == op_reg & (mem_funct3 == 3'b010 | mem_funct3 == 3'b011)))
		& (decode_rs1 != exec_rd | ~exec_regld)) 
	begin
        rs1_data_forward = mem_zext_br_en_out;
        rs1_fwd_sel = 1;
    end
	
	else /*DO NOTHING*/;

    // data forwarding zext_br_en_out for RS2 from memory stage for SLT/SLTU
    if (mem_regld & decode_rs2 == mem_rd & mem_rd != 5'd0 
		& ((mem_opcode == op_imm & (mem_funct3 == 3'b010 | mem_funct3 == 3'b011))
		| (mem_opcode == op_reg & (mem_funct3 == 3'b010 | mem_funct3 == 3'b011)))
		& (decode_rs2 != exec_rd | ~exec_regld) & decode_opcode != op_imm) 
	begin
        rs2_data_forward = mem_zext_br_en_out;
        rs2_fwd_sel = 1;
    end
	
	else /*DO NOTHING*/;

end

endmodule : staller
