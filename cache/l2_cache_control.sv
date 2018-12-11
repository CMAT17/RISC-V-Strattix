module l2_cache_control
(
	input clk,
	input logic pmem_resp,
	input logic l2cmem_read, l2cmem_write,
	input logic hit,
	//input logic flush_miss,
	//			flush_hit,
	input logic [3:0] which_way_hit,
	input logic [2:0] lru_way,
	input logic dirty_bit_out, //valid_bit_out,
	//input logic [23:0] tag_array_dataout,
	input logic [31:0] l2cmem_address,

	input logic ewb_blocking,
	
	output logic cache_write, dirty_bit_in, valid_bit_in,
	output logic l2cmem_resp,
	output logic pmem_write, pmem_read,
	//output logic [31:0] pmem_address
	output logic pmem_addr_sel,
	output logic[1:0] way_select, 
	output logic dirty_write_sel,
	output logic unleash_l2cmem_wdata,
				 unleash_l2cmem_rdata,
				 unleash_pmem_rdata,
                 unleash_l2cmem_address,
                 unleash_pmem_address
	//output logic [31:0] hit_l2_count_out,
	//output logic [31:0] miss_l2_count_out
);
//logic hit_inc, miss_inc;
logic [1:0] hit_way_select, lru_way_select;


/*
 * BIT TODO: MAKE WAY_SELECT LESS UGLY
 */

/*
counter_reg hit_l2_count
(
	.clk  (clk),
	.inc  (hit_inc),
	.flush(flush_hit),
	.out  (hit_l2_count_out)
);

counter_reg miss_l2_count
(
	.clk  (clk),
	.inc  (miss_inc),
	.flush(flush_miss),
	.out  (miss_l2_count_out)
);
*/

enum int unsigned {
	/* List of states */
	idle,
	busy,
	miss_writeback,
    miss_writeback2,
	miss_physlookup,
    miss_physlookup2,
	miss_update,
	procrastinate,
	keep_procrastinating,
	not_busy_so_just_lazy,
	wait_1,
	blocking
	
} state, next_state;

always_comb
begin : state_action_logic
	/* Default */
	//hit_inc = 1'b0;
	//miss_inc = 1'b0;
	l2cmem_resp = 1'b0;
	cache_write = 1'b0;
	valid_bit_in = 1'b0;
	dirty_bit_in = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	//pmem_address = {32{1'b0}};
	pmem_addr_sel = 1'b0;
	way_select = 2'b0;
	dirty_write_sel = 1'b0;
	unleash_l2cmem_wdata = 1'b0;
	unleash_l2cmem_rdata = 1'b0;
	unleash_pmem_rdata = 1'b0;
    unleash_l2cmem_address = 1'b0;
    unleash_pmem_address = 1'b0;
	
	case(lru_way) //TODO: fugly as hell, pls fix
		3'b000: lru_way_select = 2'b00;
		3'b001: lru_way_select = 2'b00;
		3'b010: lru_way_select = 2'b01;
		3'b011: lru_way_select = 2'b01;
		3'b100: lru_way_select = 2'b10;
		3'b110: lru_way_select = 2'b10;
		3'b101: lru_way_select = 2'b11;
		3'b111: lru_way_select = 2'b11;
		default: lru_way_select = 2'bX;
	endcase

	case(which_way_hit)
		4'b1000: hit_way_select = 2'b00;
		4'b0100: hit_way_select = 2'b01;
		4'b0010: hit_way_select = 2'b10;
		4'b0001: hit_way_select = 2'b11;
		default: hit_way_select = 2'bX;
	endcase
	
	case(state)
		idle: unleash_l2cmem_address=1'b1;

		procrastinate: begin
			unleash_l2cmem_wdata = 1'b1;
			unleash_l2cmem_rdata = 1'b1;
			if(!hit) begin	
				way_select = lru_way_select;
			end
		end

		keep_procrastinating: begin
			unleash_l2cmem_wdata = 1'b1;
			unleash_l2cmem_rdata = 1'b1;
			if(!hit) begin
				way_select = lru_way_select;
			end
		end
		
		busy: begin
			if(hit && (l2cmem_read || l2cmem_write)) begin
				if(l2cmem_write) begin
					$display("hit inner logic of cache writes");
					cache_write = 1'b1;
					valid_bit_in = 1'b1;
					dirty_bit_in = 1'b1;
					dirty_write_sel = 1'b1;
				end
				unleash_l2cmem_rdata = 1'b1;
				l2cmem_resp = 1'b1;
				//hit_inc = 1'b1; 
				//way_select dependent on which_way_hit
				way_select = hit_way_select;
			end
			else if (!hit) begin	
				way_select = lru_way_select;
			end
		end

		not_busy_so_just_lazy: begin
			way_select = hit_way_select;
			l2cmem_resp = 1'b1;
		end
		
		miss_writeback: begin
			//pmem_address = {tag_array_dataout, cmem_address[7:5], {5{1'b0}}};
			pmem_addr_sel = 1'b1;
			//pmem_write = 1'b1;
			way_select = lru_way_select;
            unleash_pmem_address = 1'b1;
		end

        miss_writeback2: begin
			pmem_addr_sel = 1'b1;
			pmem_write = 1'b1;
			way_select = lru_way_select;
            unleash_pmem_address = 1'b1;
        end

		//wait_1: begin ///* DO NOTHGING*/;	
		//	way_select = lru_way_select;
		//end
		
		miss_physlookup: begin
			//pmem_address = {cmem_address[31:5], {5{1'b0}}};
			//unleash_pmem_rdata = 1'b1;
			pmem_addr_sel = 1'b0;
            unleash_pmem_address = 1'b1;
			pmem_read = 1'b1;
			//miss_inc = 1'b1;
		end
        miss_physlookup2: begin
			pmem_addr_sel = 1'b0;
            unleash_pmem_address = 1'b1;
			pmem_read = 1'b1;
			//miss_inc = 1'b1;
        end
		
		miss_update: begin
			//way_select dependent on lru_way
			//unleash_pmem_rdata = 1'b1;
			way_select = lru_way_select;
			cache_write = 1'b1;
			valid_bit_in = 1'b1;
			dirty_bit_in = 1'b0;
		end
		
		default: /* Do nothing */;
		
	endcase
end

always_comb
begin : next_state_logic

	next_state = state;
	case(state)
		idle: begin
			if(l2cmem_read || l2cmem_write) next_state = procrastinate;
			else next_state = idle;
		end
	
		procrastinate: next_state = keep_procrastinating;

		keep_procrastinating: next_state = busy;
		
		busy: begin
			if(ewb_blocking) next_state = busy;
			else if(hit) next_state = not_busy_so_just_lazy;
			else if(dirty_bit_out) next_state = miss_writeback;
			else  next_state = miss_physlookup;
		end
	
		not_busy_so_just_lazy: next_state = idle;

        
		miss_writeback: if(!ewb_blocking) next_state = miss_writeback2;
		
		miss_writeback2: if(!ewb_blocking) next_state = miss_physlookup; //wait_1;
		
		//wait_1: next_state = miss_physlookup;
		
		miss_physlookup: next_state = miss_physlookup2;
		miss_physlookup2: if(pmem_resp) next_state = miss_update;
		
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

endmodule : l2_cache_control // l2_cache_control
