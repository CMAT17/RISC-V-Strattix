//import rv32i_types::*;

module I_cache_control
(
	input clk,
	input logic pmem_resp,
	input logic cmem_read,
	input logic hit, hit_way_1,
	input logic lru_way,
	input logic valid_bit_dataout,
	//input logic flush_hit,
	//input logic flush_miss,
	//input logic [23:0] tag_array_dataout,
	input logic [31:0] cmem_address,
	//input logic [31:0] prefetch_address_in,
	//input logic prefetch_valid,
		
	output logic cache_write, valid_bit_datain,
	output logic cmem_resp,
	output logic pmem_read,
	//output logic [31:0] pmem_address
	//output logic pmem_addr_select,
	output logic way_select, 
	//output logic data_array_datain_sel,
	output logic unleash_cmem_rdata
	//output logic[31:0] hit_l1_count_out,
	//output logic[31:0] miss_l1_count_out
	//output logic update_prefetch_buffer,
	//output logic unleash_prefetch_address
);

logic miss_inc, hit_inc, inc_phys, flush_phys ,phys_out;

enum int unsigned {
	/* List of states */
	idle,
	busy,
	//update_from_prefetch,
	//prefetch_lookup,
	//prefetch_update,
	miss_physlookup,
	miss_update
	
} state, next_state;

/*
counter_reg hit_l1_count
(
	.clk  (clk),
	.inc  (hit_inc),
	.flush(flush_hit),
	.out  (hit_l1_count_out)
);

counter_reg miss_l1_count
(
	.clk  (clk),
	.inc  (miss_inc),
	.flush(flush_miss),
	.out  (miss_l1_count_out)
);
*/

always_comb
begin : state_action_logic
	/* Default */
	//miss_inc = 1'b0;
	//hit_inc = 1'b0;
	cmem_resp = 1'b0;
	cache_write = 1'b0;
	valid_bit_datain = 1'b0;
	pmem_read = 1'b0;
	//pmem_address = {32{1'b0}};
	//pmem_addr_select = 1'b0;
	way_select = 1'b0;
	//data_array_datain_sel = 1'b0;
	unleash_cmem_rdata = 1'b0;
	//update_prefetch_buffer = 1'b0;
	//unleash_prefetch_address = 1'b0;
	
	case(state)
		idle: begin
			if(hit && cmem_read) begin
				//hit_inc = 1'b1;
				cmem_resp = 1'b1;
				way_select = hit_way_1;
			end
		end
		
		busy: /* DO NOTHING */;

		/*
		update_from_prefetch: begin
			way_select = lru_way;
			cache_write = 1'b1;
			valid_bit_datain = 1'b1;
			data_array_datain_sel = 1'b1;
		end

		prefetch_lookup: begin
			pmem_addr_select = 1'b1;
			pmem_read = 1'b1;
			// choosing to count this as a compulsory miss
			//miss_inc = 1'b1;
		end

		prefetch_update: begin
			pmem_addr_select = 1'b1;
			update_prefetch_buffer = 1'b1;
			pmem_read = 1'b1;
		end
		*/
		
		miss_physlookup: begin
			//pmem_address = {cmem_address[31:5], {5{1'b0}}}
			//pmem_addr_select = 1'b0;
			pmem_read = 1'b1;
			//unleash_prefetch_address = 1'b1;
			//miss_inc = 1'b1;
		end
		
		miss_update: begin
			way_select = lru_way;
			cache_write = 1'b1;
			valid_bit_datain = 1'b1;
			//data_array_datain_sel = 1'b0;
			//pmem_addr_select = 1'b0;
			pmem_read = 1'b1;
			//unleash_prefetch_address = 1'b1;
		end
		
		default: /* Do nothing */;
		
	endcase
end

always_comb
begin : next_state_logic

	next_state = state;
	case(state)
		idle: if(!hit && (cmem_read)) next_state = busy;
		
		busy: begin
			if(hit) next_state = idle;
			//else if(prefetch_address_in == cmem_address && prefetch_valid == 1'b1) next_state = update_from_prefetch;
			//else next_state = prefetch_lookup;
			else next_state = miss_physlookup;
		end

		/*
		update_from_prefetch: next_state = idle;

		prefetch_lookup: if(pmem_resp) next_state = prefetch_update;

		//prefetch_update: next_state = miss_physlookup;
		prefetch_update: next_state = idle;
		*/		

		miss_physlookup: if(pmem_resp) next_state = miss_update;
		
		miss_update: next_state = idle;
		//miss_update: next_state = prefetch_lookup;
		
		default: begin
			$display("hit default idle transition - shouldn't have");
			next_state = idle;
		end
		
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
   /* Assignment of next state on clock edge */
	state <= next_state;
end

endmodule : I_cache_control

