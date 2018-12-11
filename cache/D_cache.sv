import rv32i_types::*;

module D_cache
(
	input clk,
	input logic pmem_resp,					// phys_mem finished requested operation
   input logic [255:0] pmem_rdata,		// read data FROM phys_mem
	input logic cmem_read,					// cpu trying to perform read cache_mem
	input logic cmem_write,					// cpu trying to perform write cache_mem
	//input logic flush_hit,
	//input logic flush_miss,
	//input [3:0] mem_byte_enable,
	input logic [1:0] mem_byte_enable,
	input logic [31:0] cmem_address,		// cache_mem addr to read/write to
	input logic [31:0] cmem_wdata,		// write data TO cache_mem from cpu
	
	output logic cmem_resp,
	output logic [31:0] cmem_rdata,		// read data FROM cache_mem to cpu
   output logic pmem_read,					// cache trying to perform read phys_mem
   output logic pmem_write,				// cache trying to perform write phys_mem
   output logic [31:0] pmem_address,	// phys_mem addr to read/write to	
   output logic [255:0] pmem_wdata		// write data TO phys_mem
   //output logic [31:0] hit_l1_count_out,
   //output logic [31:0] miss_l1_count_out
);

logic hit, hit_way_1, way_select;
logic cache_write, dirty_bit_datain, valid_bit_datain;
logic dirty_bit_dataout, valid_bit_dataout;
//logic [23:0] tag_array_dataout;
logic pmem_addr_select;
logic lru_way;
logic dirty_write_underway;
logic unleash_pmem_wdata;
logic unleash_cmem_rdata;

D_cache_control control
(
	.*
);

D_cache_datapath datapath
(
	.*
);

endmodule : D_cache
