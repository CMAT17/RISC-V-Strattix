import rv32i_types::*;

module I_cache_datapath
(
	input clk,
	input logic cache_write, valid_bit_datain,
	input logic [31:0] cmem_address,
	input logic [255:0] pmem_rdata,
	input logic cmem_resp,
	//input logic pmem_addr_select,
	input logic way_select,
	//input logic data_array_datain_sel,
	input logic [1:0] mem_byte_enable,
	input logic unleash_cmem_rdata,
	//input logic unleash_prefetch_address,
	//input logic [255:0] prefetch_data,
	
	output logic valid_bit_dataout,
	output logic hit, hit_way_1,
	//output logic [23:0] tag_array_dataout,
	output logic [31:0] cmem_rdata,
	output logic [31:0] pmem_address,
	output logic lru_way
	//output logic [31:0] prefetch_address_out
);

logic cache_write_0, cache_write_1;
logic valid_bit_datain_0, valid_bit_datain_1;
logic valid_bit_dataout_0, valid_bit_dataout_1;

logic [255:0] data_array_dataout_0, data_array_dataout_1;
logic [23:0] tag_array_dataout_0, tag_array_dataout_1, tag_array_dataout;
logic [31:0] cmem_rdata_0, cmem_rdata_1;
logic [31:0] cmem_rdata_0_unleashed, cmem_rdata_1_unleashed;
logic tag_hit_0, tag_hit_1, lru_updated;

logic [255:0] data_array_datain;

logic [31:0] prefetch_address_unleashed;

assign tag_hit_0 = (tag_array_dataout_0 == cmem_address[31:8]) && valid_bit_dataout_0;
assign tag_hit_1 = (tag_array_dataout_1 == cmem_address[31:8]) && valid_bit_dataout_1;
assign hit = tag_hit_0 || tag_hit_1;
assign hit_way_1 = tag_hit_1;

//assign prefetch_address_out = cmem_address + 32'h20;
//assign prefetch_address_out = prefetch_address_unleashed;
assign pmem_address = {cmem_address[31:5], {5{1'b0}}};
assign data_array_datain = pmem_rdata;

/* pseudo-LRU logic */
//logic lru_way;
//assign lru_updated = ~lru_way;

/*
register #(32) prefetch_address_holding
(
	.clk (clk),
	.load(unleash_prefetch_address),
	.in	 (cmem_address + 32'h20),
	.out (prefetch_address_unleashed)
);

mux2 #(256) data_array_datain_mux
(
	.sel(data_array_datain_sel),
	.a(pmem_rdata),
	.b(prefetch_data),
	.f(data_array_datain)
);

mux2 pmem_addr_select_mux
(
	.sel(pmem_addr_select),
	.a({cmem_address[31:5], {5{1'b0}}}),
	//.b({tag_array_dataout, cmem_address[7:5], {5{1'b0}}}),
	//.b(prefetch_address_out),
	.b(prefetch_address_unleashed),
	.f(pmem_address)
);
*/

mux2 #(1) valid_bit_dataout_mux
(
	.sel(way_select),
	.a(valid_bit_dataout_0),
	.b(valid_bit_dataout_1),
	.f(valid_bit_dataout)
);

mux2 #(24) tag_array_dataout_mux
(
	.sel(way_select),
	.a(tag_array_dataout_0),
	.b(tag_array_dataout_1),
	.f(tag_array_dataout)
);

mux2 cmem_rdata_mux
(
	.sel(way_select),
	.a(cmem_rdata_0),
	.b(cmem_rdata_1),
	.f(cmem_rdata)
);

decoder2 #(1) cache_write_decoder
(
	.sel(way_select),
	.a(cache_write),
	.y(cache_write_0),
	.z(cache_write_1)
);

decoder2 #(1) valid_bit_datain_decoder
(
	.sel(way_select),
	.a(valid_bit_datain),
	.y(valid_bit_datain_0),
	.z(valid_bit_datain_1)
);

array #(1) lru_array
(
	.clk,
	.write(cmem_resp),
	.index(cmem_address[7:5]),
	.datain(tag_hit_0),
	.dataout(lru_way)
);

array data_array0
(
	.clk,
	.write(cache_write_0),
	.index(cmem_address[7:5]),
	.datain(data_array_datain),
	.dataout(data_array_dataout_0)
);

array data_array1
(
	.clk,
	.write(cache_write_1),
	.index(cmem_address[7:5]),
	.datain(data_array_datain),
	.dataout(data_array_dataout_1)
);

array #(24) tag_array0
(
	.clk,
	.write(cache_write_0),
	.index(cmem_address[7:5]),
	.datain(cmem_address[31:8]),
	.dataout(tag_array_dataout_0)
);

array #(24) tag_array1
(
	.clk,
	.write(cache_write_1),
	.index(cmem_address[7:5]),
	.datain(cmem_address[31:8]),
	.dataout(tag_array_dataout_1)
);

array #(1) valid_bit_array0
(
	.clk,
	.write(cache_write_0),
	.index(cmem_address[7:5]),
	.datain(valid_bit_datain_0),
	.dataout(valid_bit_dataout_0)
);

array #(1) valid_bit_array1
(
	.clk,
	.write(cache_write_1),
	.index(cmem_address[7:5]),
	.datain(valid_bit_datain_1),
	.dataout(valid_bit_dataout_1)
);

mux8 words_in_cache_line_mux_0
(
	.sel(cmem_address[4:2]),
	.a(data_array_dataout_0[31:0]),
	.b(data_array_dataout_0[63:32]),
	.c(data_array_dataout_0[95:64]),
	.d(data_array_dataout_0[127:96]),
	.e(data_array_dataout_0[159:128]),
	.f(data_array_dataout_0[191:160]),
	.g(data_array_dataout_0[223:192]),
	.h(data_array_dataout_0[255:224]),
	.res(cmem_rdata_0)
);

mux8 words_in_cache_line_mux_1
(
	.sel(cmem_address[4:2]),
	.a(data_array_dataout_1[31:0]),
	.b(data_array_dataout_1[63:32]),
	.c(data_array_dataout_1[95:64]),
	.d(data_array_dataout_1[127:96]),
	.e(data_array_dataout_1[159:128]),
	.f(data_array_dataout_1[191:160]),
	.g(data_array_dataout_1[223:192]),
	.h(data_array_dataout_1[255:224]),
	.res(cmem_rdata_1)
);

register #(32) cmem_rdata_0_holding
(
	.clk (clk),
	.load(unleash_cmem_rdata),
	.in	 (cmem_rdata_0),
	.out (cmem_rdata_0_unleashed)
);

register #(32) cmem_rdata_1_holding
(
	.clk (clk),
	.load(unleash_cmem_rdata),
	.in	 (cmem_rdata_1),
	.out (cmem_rdata_1_unleashed)
);


endmodule : I_cache_datapath
