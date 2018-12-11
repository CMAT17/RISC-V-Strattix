import rv32i_types::*;

module control_rom
(
	input rv32i_opcode opcode,
	input logic[2:0] funct3,
	input logic[6:0] funct7,
	input logic[4:0] src_reg1,
					 src_reg2,
					 dest_reg,
	input rv32i_word curr_pc,
					 pc_plus4,

	output rv32i_ctrl_word ctrl_word
);
always_comb
begin
	ctrl_word.curr_pc = curr_pc;
    ctrl_word.pc_plus4 = pc_plus4;

    /* Instruction unpacking */
    ctrl_word.opcode = opcode;
	 ctrl_word.funct3 = funct3;
    ctrl_word.aluop = alu_ops'(funct3);
    ctrl_word.cmpop = branch_funct3_t'(funct3);

    /* Mux Selects */
    //TODO: Determine bit-widths
    ctrl_word.regfilemux_sel = 3'b0;
    ctrl_word.alumux1_sel = 1'b0;
    ctrl_word.alumux2_sel = 3'b0;
    ctrl_word.marmux_sel = 1'b0;
    ctrl_word.mdrmux_sel = 3'b0;
    ctrl_word.cmpmux_sel = 1'b0;
	 ctrl_word.pc_branch_jump_sel = 2'b00;
	
    /* Loads */
    ctrl_word.load_regfile = 1'b0;

    /* Memory Ops */
    ctrl_word.mem_read = 1'b0;
    ctrl_word.mem_write = 1'b0;
    //ctrl_word.mem_byte_enable = 4'b1111;
    ctrl_word.mem_byte_enable = 2'b00;


    /* Register Information */
    ctrl_word.source_reg1 = src_reg1;
    ctrl_word.source_reg2 = src_reg2;
    ctrl_word.dest_reg = dest_reg;


    /* Actions for each instruction */
    case(opcode)
    	op_auipc :
    		begin
    			ctrl_word.load_regfile = 1'b1;
    			ctrl_word.alumux1_sel = 1'b1;
    			ctrl_word.alumux2_sel = 3'b001;
    			ctrl_word.aluop = alu_add;
				ctrl_word.source_reg1 = 5'hX;
				ctrl_word.source_reg2 = 5'hX;
                $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
    		end
    	op_lui :
    		begin 
    			ctrl_word.load_regfile = 1'b1;
    			ctrl_word.regfilemux_sel = 3'd2;
				ctrl_word.source_reg1 = 5'hX;
				ctrl_word.source_reg2 = 5'hX;
                $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
    		end
    	op_imm :
    		begin
    			if(funct3 == 3'b010) //SLTI
    			begin : SLTI
    				ctrl_word.load_regfile = 1'b1;
    				ctrl_word.cmpop = branch_funct3_t'(blt);
    				ctrl_word.regfilemux_sel = 3'b001;
    				ctrl_word.cmpmux_sel = 1'b1;
					ctrl_word.source_reg2 = 5'hX;
    			end
    			else if(funct3 == 3'b011) //SLTIU
    			begin : SLTIU
    				ctrl_word.load_regfile = 1'b1;
    				ctrl_word.cmpop = branch_funct3_t'(bltu);
    				ctrl_word.regfilemux_sel = 3'b001;
    				ctrl_word.cmpmux_sel = 1'b1;
					ctrl_word.source_reg2 = 5'hX;
    			end
    			else if ((funct3 == 3'b101) &&(funct7[5] == 1'b1)) //SRAI
    			begin : SRAI
    				ctrl_word.load_regfile = 1'b1;
    				ctrl_word.aluop = alu_sra; 
					ctrl_word.source_reg2 = 5'hX;
    			end
    			else //Kitchen Sink
    			begin : OTHER_IMM
    				ctrl_word.load_regfile = 1'b1;
    				ctrl_word.aluop = alu_ops'(funct3);
					ctrl_word.source_reg2 = 5'hX;
    			end
                $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
    		end

    	op_reg :
    		begin
    			if((funct3 == 3'b000) && (funct7[5] == 1'b1)) //SUB
    			begin : SUB
    				ctrl_word.load_regfile = 1'b1;
    				ctrl_word.alumux2_sel = 3'd5;
    				ctrl_word.aluop = alu_sub;
    			end
    			else if((funct3 == 3'b101) && (funct7[5] == 1'b1)) //SRA
    			begin : SRA
    				ctrl_word.load_regfile = 1'b1;
    				ctrl_word.alumux2_sel = 3'd5;
    				ctrl_word.aluop = alu_sra;
    			end
    			else if(funct3 == 3'b010) //SLT
    			begin : SLT
    				ctrl_word.load_regfile = 1'b1;
    				ctrl_word.cmpop = branch_funct3_t'(blt);
    				ctrl_word.regfilemux_sel = 3'b001;
    			end
    			else if(funct3 == 3'b011) //SLTU
    			begin : SLTU
    				ctrl_word.load_regfile = 1'b1;
    				ctrl_word.cmpop = branch_funct3_t'(bltu);
    				ctrl_word.regfilemux_sel = 3'b001;
    			end
    			else //Kitchen Sink
    			begin : OTHER_REG
    				ctrl_word.load_regfile = 1'b1;
    				ctrl_word.alumux2_sel = 3'd5;
    				ctrl_word.aluop = alu_ops'(funct3);
    			end
                $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
    		end
    	op_load :
    		begin
				if(funct3 == load_funct3_t'(lw)) //LW
				begin : LW
					ctrl_word.aluop = alu_add;
					ctrl_word.marmux_sel = 1'b1;
					ctrl_word.mem_read = 1'b1;
					ctrl_word.regfilemux_sel = 3'd3;
					ctrl_word.load_regfile = 1'b1;
					//ctrl_word.source_reg2 = 5'hX;
                    $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
				end
				
				else if(funct3 == load_funct3_t'(lh)) //LH
				begin : LH
					ctrl_word.aluop = alu_add;
					ctrl_word.marmux_sel = 1'b1;
					ctrl_word.mem_read = 1'b1;
					ctrl_word.regfilemux_sel = 3'd3;
					ctrl_word.load_regfile = 1'b1;
					ctrl_word.mdrmux_sel = 3'd1;
					//ctrl_word.source_reg2 = 5'hX;
                    $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
				end
				
            else if(funct3 == load_funct3_t'(lhu)) //LHU
				begin : LHU
					ctrl_word.aluop = alu_add;
					ctrl_word.marmux_sel = 1'b1;
					ctrl_word.mem_read = 1'b1;
					ctrl_word.regfilemux_sel = 3'd3;
					ctrl_word.load_regfile = 1'b1;
					ctrl_word.mdrmux_sel = 3'd2;
					//ctrl_word.source_reg2 = 5'hX;
                    $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
				end
				
            else if(funct3 == load_funct3_t'(lb)) //LB
				begin : LB
					ctrl_word.aluop = alu_add;
					ctrl_word.marmux_sel = 1'b1;
					ctrl_word.mem_read = 1'b1;
					ctrl_word.regfilemux_sel = 3'd3;
					ctrl_word.load_regfile = 1'b1;
					ctrl_word.mdrmux_sel = 3'd3;
					//ctrl_word.source_reg2 = 5'hX;
                    $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
				end
				
            else 
				begin : LBU //if(funct3 == load_funct3_t'(lb)) //LBU
					ctrl_word.aluop = alu_add;
					ctrl_word.marmux_sel = 1'b1;
					ctrl_word.mem_read = 1'b1;
					ctrl_word.regfilemux_sel = 3'd3;
					ctrl_word.load_regfile = 1'b1;
					ctrl_word.mdrmux_sel = 3'd4;
					//ctrl_word.source_reg2 = 5'hX;
                    $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
				end
    		end
    	op_store :
    		begin
				if(funct3 == store_funct3_t'(sw)) //SW
            begin : SW
					ctrl_word.aluop = alu_add;
					ctrl_word.marmux_sel = 1'b1;
					ctrl_word.alumux2_sel = 3'd3;
					ctrl_word.mem_write = 1'b1;
					//ctrl_word.mem_byte_enable = 4'b1111;
					ctrl_word.mem_byte_enable = 2'b00;
                    $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
				end
				
            else if(funct3 == store_funct3_t'(sh)) //SH
            begin : SH
					ctrl_word.aluop = alu_add;
					ctrl_word.marmux_sel = 1'b1;
					ctrl_word.alumux2_sel = 3'd3;
					ctrl_word.mem_write = 1'b1;
					//ctrl_word.mem_byte_enable = 4'b0011;
					ctrl_word.mem_byte_enable = 2'b01;
                    $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
				end
				
            else //if(funct3 == store_funct3_t'(sb)) //SB
            begin : SB
					ctrl_word.aluop = alu_add;
					ctrl_word.marmux_sel = 1'b1;
					ctrl_word.alumux2_sel = 3'd3;
					ctrl_word.mem_write = 1'b1;
					//ctrl_word.mem_byte_enable = 4'b0001;
					ctrl_word.mem_byte_enable = 2'b10;
                    $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
				end	
    		end
    	op_br : 
    		begin
				ctrl_word.pc_branch_jump_sel = 2'b11;
    			ctrl_word.alumux1_sel = 1'b1;
    			ctrl_word.alumux2_sel = 3'd2;
    			ctrl_word.aluop = alu_add;
				ctrl_word.dest_reg = 5'hX;
                $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
    		end

    	op_jal : 
    		begin
    			ctrl_word.alumux1_sel = 1'b1;
    			ctrl_word.alumux2_sel = 3'd4;
    			ctrl_word.pc_branch_jump_sel = 2'b01;
    			ctrl_word.load_regfile = 1'b1;
    			ctrl_word.aluop = alu_add;
    			ctrl_word.regfilemux_sel = 3'd4;
				ctrl_word.source_reg1 = 5'hX;
				ctrl_word.source_reg2 = 5'hX;
                $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
    		end
    	op_jalr : 
    		begin
    			ctrl_word.pc_branch_jump_sel = 2'd2;
    			ctrl_word.load_regfile = 1'b1;
    			ctrl_word.aluop = alu_add;
    			ctrl_word.regfilemux_sel = 3'd4;
				ctrl_word.source_reg2 = 5'hX;
                $display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
    		end

    	default : 
    			begin
    				ctrl_word = 0;
    				$display("opcode: %b\n funct3: %b\n PC: %x\n", opcode, funct3, curr_pc);
    			end
    endcase

end

endmodule : control_rom //control_rom
