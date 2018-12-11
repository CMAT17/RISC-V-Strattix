module cpu_cache_toplevel
(
	input logic clk,
	input logic pmem_resp,
	input logic[255:0] pmem_rdata,

	output logic pmem_read,
	output logic pmem_write,
	output logic [31:0] pmem_address,
	output logic [255:0] pmem_wdata
);

//logic flush_hit_l1_i, flush_hit_l1_d, flush_hit_l2,
//	  flush_miss_l1_i, flush_miss_l1_d, flush_miss_l2;

logic mem_resp_i;
logic mem_read_i, mem_write_i;
//logic [3:0] mem_byte_enable_i;
logic [1:0] mem_byte_enable_i;
logic [31:0] mem_address_i, mem_wdata_i, mem_rdata_i;

logic mem_resp_d;
logic mem_read_d, mem_write_d;
//logic [3:0] mem_byte_enable_d;
logic [1:0] mem_byte_enable_d;
logic [31:0] mem_address_d, mem_wdata_d, mem_rdata_d;

// signals between arbiter and L1 caches
logic [255:0] amem_wdata_d,
			  arbiter_mem_wdata,
			  l2cmem_rdata;
logic [31:0] amem_address_i,
			 amem_address_d,
			 arbiter_mem_address,
			 l2cmem_address;
	/*
			 hit_l1_i_count_out,
			 hit_l1_d_count_out,
			 hit_l2_count_out,
			 miss_l1_i_count_out,
			 miss_l1_d_count_out,
			 miss_l2_count_out;
	*/

logic amem_resp_i,
	  amem_resp_d,
	  amem_write_d,
	  amem_read_i,
	  amem_read_d,
	  arbiter_mem_read,
	  arbiter_mem_write,
	  l2cmem_resp,
	  l2cmem_read,
	  l2cmem_write;

//signals between L2 and physical memory
logic l2pmem_write,
	   l2pmem_read,
	  l2pmem_resp;

//signals between eviction write buffer and L2
logic [255:0] l2pmem_wdata;
logic [31:0] l2pmem_address;
logic block_l2;

//signals between eviction write buffer and physical memory
logic [31:0] ewb_address;
logic ewb_pmem_resp;


//signals for prefetch buffer (interactions with L1 mostly)
/*
logic prefetch_valid, update_prefetch_buffer;
logic [31:0] prefetch_addr_to_l1,
			 prefetch_addr_from_l1;
logic [255:0] prefetch_data;
*/

//CPU datapath
cpu_datapath cpu
(
	.clk              	(clk),
	.mem_resp_i       	(mem_resp_i),
	.mem_resp_d       	(mem_resp_d),
	.mem_rdata_i      	(mem_rdata_i),
	.mem_rdata_d      	(mem_rdata_d),
	.mem_read_i       	(mem_read_i),
	.mem_read_d       	(mem_read_d),
	.mem_write_i      	(mem_write_i),
	.mem_write_d      	(mem_write_d),
	.mem_byte_enable_i	(mem_byte_enable_i),
	.mem_byte_enable_d	(mem_byte_enable_d),
	.mem_wdata_i      	(mem_wdata_i),
	.mem_wdata_d      	(mem_wdata_d),
	.mem_address_i    	(mem_address_i),
	.mem_address_d    	(mem_address_d)
	//.hit_l2_count_out   (hit_l2_count_out),
	//.hit_l1_d_count_out (hit_l1_d_count_out),
	//.hit_l1_i_count_out (hit_l1_i_count_out),
	//.miss_l2_count_out  (miss_l2_count_out),
	//.miss_l1_d_count_out(miss_l1_d_count_out),
	//.miss_l1_i_count_out(miss_l1_i_count_out),
	//.flush_hit_l2       (flush_hit_l2),
	//.flush_hit_l1_i     (flush_hit_l1_i),
	//.flush_hit_l1_d     (flush_hit_l1_d),
	//.flush_miss_l1_i    (flush_miss_l1_i),
	//.flush_miss_l1_d    (flush_miss_l1_d),
	//.flush_miss_l2      (flush_miss_l2)
);

//Instruction Cache blackbox
I_cache instr_cache
(
	.clk         	  		(clk),
	.pmem_resp   	  		(amem_resp_i),
	.pmem_rdata  	  		(l2cmem_rdata),
	.cmem_read   	  		(mem_read_i),
	//.flush_hit	 	  		(flush_hit_l1_i),
	//.flush_miss	 	  		(flush_miss_l1_i),
	.mem_byte_enable  		(mem_byte_enable_i),
	.cmem_address	  		(mem_address_i),
	//.prefetch_valid	  		(prefetch_valid),
	//.prefetch_address_in	(prefetch_addr_to_l1),
	//.prefetch_data			(prefetch_data),

	.cmem_resp   	  		(mem_resp_i),
	.cmem_rdata  	 		(mem_rdata_i),
	.pmem_read   	  		(amem_read_i),
	.pmem_address	  		(amem_address_i)
	//.hit_l1_count_out 		(hit_l1_i_count_out),
	//.miss_l1_count_out		(miss_l1_i_count_out)
	//.prefetch_address_out	(prefetch_addr_from_l1),
	//.update_prefetch_buffer	(update_prefetch_buffer)
);

//Arbiter
arbiter l1_cache_arbiter
(
	.l1_read_i   	 (amem_read_i),
	.l1_write_d  	 (amem_write_d),
	.l1_read_d   	 (amem_read_d),
	.l1_address_i	 (amem_address_i),
	.l1_address_d	 (amem_address_d),
	.l1_wdata_d  	 (amem_wdata_d),
	.l2_resp     	 (l2cmem_resp),

	.l2_resp_i   	 (amem_resp_i),
	.l2_resp_d   	 (amem_resp_d),
	.l2_read     	 (arbiter_mem_read),
	.l2_write    	 (arbiter_mem_write),
	.l2_address  	 (arbiter_mem_address),
	.l2_wdata    	 (arbiter_mem_wdata)
);

//Data Cache blackbox
D_cache data_cache
(
	.clk         	  (clk),
	.pmem_resp   	  (amem_resp_d),
	.pmem_rdata  	  (l2cmem_rdata),
	.cmem_read   	  (mem_read_d),
	.cmem_write  	  (mem_write_d),
	//.flush_hit		  (flush_hit_l1_d),
	//.flush_miss		  (flush_miss_l1_d),
	.mem_byte_enable  (mem_byte_enable_d),
	.cmem_address	  (mem_address_d),
	.cmem_wdata  	  (mem_wdata_d),

	.cmem_resp   	  (mem_resp_d),
	.cmem_rdata  	  (mem_rdata_d),
	.pmem_read   	  (amem_read_d),
	.pmem_write  	  (amem_write_d),
	.pmem_address	  (amem_address_d),
	.pmem_wdata  	  (amem_wdata_d)
	//.hit_l1_count_out (hit_l1_d_count_out),
	//.miss_l1_count_out(miss_l1_d_count_out)
);

/*
prefetch_buffer prefetch
(
	.clk		 (clk),
	.update 	 (update_prefetch_buffer),
	.address_in	 (prefetch_addr_from_l1),
	.data_in	 (l2cmem_rdata),
	
	.address_out (prefetch_addr_to_l1),
	.data_out	 (prefetch_data),
	.valid_out	 (prefetch_valid)
);
*/

l2_cache l2cache
(
	.clk              (clk),
	.l2cmem_read      (arbiter_mem_read),
	.l2cmem_write     (arbiter_mem_write),
	.l2cmem_wdata     (arbiter_mem_wdata),
	.l2cmem_address   (arbiter_mem_address),
	.pmem_resp        (l2pmem_resp),
	.pmem_rdata       (pmem_rdata),
	//.flush_hit	      (flush_hit_l2),
	//.flush_miss	      (flush_miss_l2),
	.block_l2	      (block_l2),

	.l2cmem_resp      (l2cmem_resp),
	.l2cmem_rdata     (l2cmem_rdata),
	.pmem_read        (l2pmem_read),
	.pmem_write       (l2pmem_write),
	.pmem_wdata       (l2pmem_wdata),
	.pmem_address	  (l2pmem_address)
	//.hit_l2_count_out (hit_l2_count_out),
	//.miss_l2_count_out(miss_l2_count_out)
);
assign pmem_read = l2pmem_read;
mux2 pmem_address_mux
(
	.sel(block_l2),
	.a	(l2pmem_address),
	.b	(ewb_address),
	.f	(pmem_address)
);

decoder2 pmem_resp_mux
(
	.sel(block_l2),
	.a	(pmem_resp),
	.y	(l2pmem_resp),
	.z	(ewb_pmem_resp)
);

eviction_write_buffer evb
(
	.clk				(clk),
	.l2pmem_address		(l2pmem_address),
	.l2pmem_wdata		(l2pmem_wdata),
	.l2_read			(arbiter_mem_read),
	.l2_write			(arbiter_mem_write),
	.pmem_resp			(ewb_pmem_resp),
	.l2pmem_write		(l2pmem_write),
	.l2pmem_read		(l2pmem_read),

	.blocking			(block_l2),
	.send_ewb_to_pmem	(pmem_write),
	.ewb_pmem_wdata		(pmem_wdata),
	.ewb_pmem_address	(ewb_address)
);

endmodule : cpu_cache_toplevel // top_level
