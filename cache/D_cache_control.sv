//import rv32i_types::*;

module D_cache_control
(
	input clk,
	input logic pmem_resp,
	input logic cmem_read, cmem_write,
	input logic hit, hit_way_1,
	input logic lru_way,
	input logic dirty_bit_dataout, valid_bit_dataout,
	//input logic flush_hit,
	//input logic flush_miss,
	//input logic [23:0] tag_array_dataout,
	input logic [31:0] cmem_address,
		
	output logic cache_write, dirty_bit_datain, valid_bit_datain,
	output logic cmem_resp,
	output logic pmem_write, pmem_read,
	//output logic [31:0] pmem_address
	output logic pmem_addr_select,
	output logic way_select, 
	output logic dirty_write_underway,
	output logic unleash_pmem_wdata,
	output logic unleash_cmem_rdata
	//output logic[31:0] hit_l1_count_out,
	//output logic[31:0] miss_l1_count_out
);

logic miss_inc, hit_inc, inc_phys, flush_phys,phys_out;

enum int unsigned {
	/* List of states */
	idle,
	busy,
	miss_writeback,
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
	dirty_bit_datain = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	//pmem_address = {32{1'b0}};
	pmem_addr_select = 1'b0;
	way_select = hit_way_1;
	dirty_write_underway = 1'b0;
	unleash_pmem_wdata = 1'b0;
	unleash_cmem_rdata = 1'b0;
	flush_phys = 1'b0;
	inc_phys = 1'b0;
	
	case(state)
		idle: begin
			if(hit && cmem_read) begin
				//hit_inc = 1'b1;
				cmem_resp = 1'b1;
				way_select = hit_way_1;
			end
			if(hit && cmem_write) begin
				unleash_cmem_rdata = 1'b1;
				//hit_inc = 1'b1;
			end
		end
		
		busy: begin
			if(hit && cmem_write) begin
				cache_write = 1'b1;
				valid_bit_datain = 1'b1;
				dirty_bit_datain = 1'b1;
				dirty_write_underway = 1'b1;
				cmem_resp = 1'b1;
				way_select = hit_way_1;
			end
			else begin
				way_select = lru_way;
				unleash_pmem_wdata = 1'b1;
			end
		end
		
		miss_writeback: begin
			//pmem_address = {tag_array_dataout, cmem_address[7:5], {5{1'b0}}};
			if(pmem_resp)
				inc_phys = 1'b1;
			pmem_addr_select = 1'b1;
			pmem_write = 1'b1;
			way_select = lru_way;
		end
		
		miss_physlookup: begin
			//pmem_address = {cmem_address[31:5], {5{1'b0}}};
			flush_phys = 1'b1;
			pmem_addr_select = 1'b0;
			pmem_read = 1'b1;
			//miss_inc = 1'b1;
		end
		
		miss_update: begin
			way_select = lru_way;
			cache_write = 1'b1;
			valid_bit_datain = 1'b1;
			dirty_bit_datain = 1'b0;
			pmem_read = 1'b1;
		end
		
		default: /* Do nothing */;
		
	endcase
end

always_comb
begin : next_state_logic

	next_state = state;
	case(state)
		idle: if((!hit && (cmem_read || cmem_write)) || (hit && cmem_write)) next_state = busy;
		
		busy: begin
			if(hit) next_state = idle;
			else if(dirty_bit_dataout) next_state = miss_writeback;
			else  next_state = miss_physlookup;
		end
		
		miss_writeback: if(pmem_resp && phys_out == 1) next_state = miss_physlookup;
		
		miss_physlookup: if(pmem_resp) next_state = miss_update;
		
		miss_update: next_state = busy;
		
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


counter_reg #(1) phys_lookup
(
	.clk  (clk),
	.inc  (inc_phys),
	.flush(flush_phys),
	.out  (phys_out)
);

endmodule : D_cache_control

