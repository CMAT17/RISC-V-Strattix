module l2_cache
(
	input logic clk,

	//L1 -> L2
	input logic l2cmem_read,
				l2cmem_write,
	input logic[255:0] l2cmem_wdata,
	input logic [31:0] l2cmem_address,

	//Pmem -> l2
	input logic pmem_resp,
	input logic[255:0] pmem_rdata,
	//input logic flush_hit,
	//input logic flush_miss,
	input logic block_l2,
	
	//L2 -> L1
	output logic l2cmem_resp,
	output logic[255:0] l2cmem_rdata,

	//L2 -> Pmem 
	output logic pmem_read,
				 pmem_write,
	output logic [255:0] pmem_wdata,		 
	output logic [31:0] pmem_address
	//output logic [31:0] hit_l2_count_out,
   	//output logic [31:0] miss_l2_count_out
);
logic hit,
	  dirty_bit_in,
	  dirty_bit_out,
	  valid_bit_in,
	  pmem_address_sel,
	  dirty_write_sel,
	  cache_write,
	  l2cmem_resp_internal;

logic[3:0] which_way_hit;
logic[2:0] lru_way;
logic[1:0] way_select;

logic unleash_l2cmem_wdata,
	  unleash_l2cmem_rdata,
      unleash_l2cmem_address,
      unleash_pmem_address,
	  unleash_pmem_rdata;

l2_cache_datapath_revamped cache_datapath
(
	.clk             	 (clk),
	.cache_write     	 (cache_write),
	.l2cmem_resp     	 (l2cmem_resp_internal),
	.pmem_rdata      	 (pmem_rdata),
	.l2cmem_wdata    	 (l2cmem_wdata),
	.l2cmem_address  	 (l2cmem_address),
	.valid_bit_in    	 (valid_bit_in),
	.dirty_bit_in    	 (dirty_bit_in),
	.way_select      	 (way_select),
	.pmem_address_sel	 (pmem_address_sel),
	.dirty_write_sel 	 (dirty_write_sel),
	.unleash_l2cmem_wdata(unleash_l2cmem_wdata),
	.unleash_l2cmem_rdata(unleash_l2cmem_rdata),
	.unleash_pmem_rdata	 (unleash_pmem_rdata),
    .unleash_l2cmem_address(unleash_l2cmem_address),
    .unleash_pmem_address(unleash_pmem_address),
	.pmem_resp			 (pmem_resp),

	.dirty_bit_out   	 (dirty_bit_out),
	.l2cmem_rdata    	 (l2cmem_rdata),
	.pmem_wdata      	 (pmem_wdata),
	.pmem_address    	 (pmem_address),
	.which_way_hit   	 (which_way_hit),
	.hit             	 (hit),
	.lru_way         	 (lru_way)
);

l2_cache_control cache_control
(
	.clk            	 (clk),
	.pmem_resp      	 (pmem_resp),
	.l2cmem_read    	 (l2cmem_read),
	.l2cmem_write   	 (l2cmem_write),
	.hit            	 (hit),
	//.flush_miss			 (flush_miss),
	//.flush_hit			 (flush_hit),
	.which_way_hit  	 (which_way_hit),
	.lru_way        	 (lru_way),
	.dirty_bit_out  	 (dirty_bit_out),
	.l2cmem_address 	 (l2cmem_address),
	.ewb_blocking		 (block_l2),

	.cache_write    	 (cache_write),
	.dirty_bit_in   	 (dirty_bit_in),
	.valid_bit_in   	 (valid_bit_in),
	.l2cmem_resp    	 (l2cmem_resp_internal),
	.pmem_write     	 (pmem_write),
	.pmem_read      	 (pmem_read),
	.pmem_addr_sel  	 (pmem_address_sel),
	.way_select     	 (way_select),
	.dirty_write_sel	 (dirty_write_sel),
	.unleash_l2cmem_wdata(unleash_l2cmem_wdata),
	.unleash_l2cmem_rdata(unleash_l2cmem_rdata),
	.unleash_pmem_rdata	 (unleash_pmem_rdata),
    .unleash_l2cmem_address(unleash_l2cmem_address),
    .unleash_pmem_address(unleash_pmem_address)
	//.hit_l2_count_out    (hit_l2_count_out),
	//.miss_l2_count_out   (miss_l2_count_out)
);

assign l2cmem_resp = l2cmem_resp_internal;

endmodule : l2_cache // l2_cache
