//import rv3i2i_types::*;

module eviction_write_buffer_control
(
	input clk,
	input logic pmem_resp,
	input logic l2_read,
				l2_write,
				l2pmem_read,
				l2pmem_write,
				ewb_valid,
	input logic [31:0] l2_address,
	input logic [31:0] ewb_address,
				//l2_reading_evict_buffer,

	//output logic read_evicted_line,
	output logic send_evicted_line_pmem,
	output logic complete_eviction,
	output logic blocking
	//output logic evb_resp
);

logic evb_resp;

enum int unsigned {
	/* List of states */
	idle, //not able to evict (L2 doing memory operations first) or no line in eviction write buffer
	busy, //evicting
	invalidate_buffer_line,
	wait_1
	//wait_l2_read_completion
	
	
} state, next_state;


always_comb
begin : state_action_logic
	/* Default */
	send_evicted_line_pmem = 1'b0;
	complete_eviction = 1'b0;
	blocking = 1'b0;
	//evb_resp = 1'b0;
	
	case(state)
	
		idle: /* DO NOTHING */;

		busy: begin
			send_evicted_line_pmem = 1'b1;
			blocking = 1'b1;
		end

		//wait_l2_read_completion: begin
		//end

		invalidate_buffer_line: begin
			complete_eviction = 1'b1;
			blocking = 1'b1;
			//evb_resp = 1'b1;
		end
		
		wait_1: ;
		
		default: /* DO NOTHING */;
		
	endcase
end

always_comb
begin : next_state_logic

	next_state = state;
	case(state)
		
		idle: begin
			if((!l2pmem_read && !l2pmem_write && ewb_valid) || 
			   (l2pmem_read && (l2_address[31:5] == ewb_address[31:5]) && ewb_valid) ||
			   (l2pmem_write && ewb_valid)) next_state = busy;
			else next_state = idle; 
		end
		
		busy: begin
			//if(pmem_resp && l2_reading_evict_buffer) next_state = wait_for_l2_read_completion;
			if(pmem_resp) next_state = invalidate_buffer_line;
			else next_state = busy;
		end

		/*
		wait_for_l2_read_completion: begin
			if(l2_reading_evict_buffer) next_state = wait_for_l2_read_completion;
			else next_state = invalidate;
		end
		*/

		invalidate_buffer_line: begin
			next_state = wait_1;
		end
		
		wait_1 : begin
			next_state = idle;
		end
		
		default: begin
			next_state = idle;
		end
		
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
   /* Assignment of next state on clock edge */
	state <= next_state;
end

endmodule : eviction_write_buffer_control

