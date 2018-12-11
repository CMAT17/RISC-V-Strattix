import rv32i_types::*;

module I_cache
(
	input clk,
	input logic pmem_resp,				// phys_mem finished requested operation
   	input logic [255:0] pmem_rdata,		// read data FROM phys_mem
	input logic cmem_read,				// cpu trying to perform read cache_mem
	//input logic flush_hit,
	//input logic flush_miss,
	//input [3:0] mem_byte_enable,
	input logic [1:0] mem_byte_enable,
	input logic [31:0] cmem_address,	// cache_mem addr to read/write to
	//input logic prefetch_valid,
	//input logic [31:0] prefetch_address_in,
	//input logic [255:0] prefetch_data,
	
	output logic cmem_resp,
	output logic [31:0] cmem_rdata,		// read data FROM cache_mem to cpu
   	output logic pmem_read,				// cache trying to perform read phys_mem
   	output logic [31:0] pmem_address	// phys_mem addr to read/write to	
   	//output logic [31:0] hit_l1_count_out,
   	//output logic [31:0] miss_l1_count_out,
	//output logic [31:0] prefetch_address_out,
	//output logic update_prefetch_buffer
);

logic hit, hit_way_1, way_select;
logic cache_write, valid_bit_datain, valid_bit_dataout;
//logic [23:0] tag_array_dataout;
//logic pmem_addr_select;
logic lru_way;
//logic data_array_datain_sel;
logic unleash_cmem_rdata;
//logic unleash_prefetch_address;

I_cache_control control
(
	.*
);

I_cache_datapath datapath
(
	.*
);

endmodule : I_cache
