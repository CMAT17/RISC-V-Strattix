import rv32i_types::*;

module D_cache_datapath
(
	input clk,
	input logic cache_write, dirty_bit_datain, valid_bit_datain,
	input logic [31:0] cmem_address,
	input logic [255:0] pmem_rdata,
	input logic cmem_resp,
	input logic pmem_addr_select,
	input logic way_select,
	input logic dirty_write_underway,
	input [31:0] cmem_wdata,
	input logic [1:0] mem_byte_enable,
	input logic unleash_pmem_wdata,
	input logic unleash_cmem_rdata,
	
	output logic dirty_bit_dataout, valid_bit_dataout,
	output logic hit, hit_way_1,
	//output logic [23:0] tag_array_dataout,
	output logic [31:0] cmem_rdata,
	output logic [255:0] pmem_wdata,
	output logic [31:0] pmem_address,
	output logic lru_way
);

logic cache_write_0, cache_write_1;
logic valid_bit_datain_0, valid_bit_datain_1;
logic dirty_bit_datain_0, dirty_bit_datain_1;

logic dirty_bit_dataout_0, dirty_bit_dataout_1;
logic valid_bit_dataout_0, valid_bit_dataout_1;
logic [255:0] data_array_dataout_0, data_array_dataout_1;
logic [23:0] tag_array_dataout_0, tag_array_dataout_1, tag_array_dataout;
logic [31:0] cmem_rdata_0, cmem_rdata_1;
logic [31:0] cmem_rdata_0_unleashed, cmem_rdata_1_unleashed;
logic tag_hit_0, tag_hit_1, lru_updated;

logic [31:0] word_to_insert_0, word_to_insert_1;
logic [31:0] word_to_insert_halfword_0, word_to_insert_halfword_1;
logic [31:0] word_to_insert_byte_0, word_to_insert_byte_1;

logic [255:0] cmem_wdata_inserted_0, cmem_wdata_inserted_1;
logic [255:0] data_array_datain_0, data_array_datain_1;

logic [255:0] pmem_wdata_held;

assign tag_hit_0 = (tag_array_dataout_0 == cmem_address[31:8]) && valid_bit_dataout_0;
assign tag_hit_1 = (tag_array_dataout_1 == cmem_address[31:8]) && valid_bit_dataout_1;
assign hit = tag_hit_0 || tag_hit_1;
assign hit_way_1 = tag_hit_1;

/* pseudo-LRU logic */
//logic lru_way;
//assign lru_updated = ~lru_way;


mux2 #(256) data_array_datain_mux_0
(
	.sel(dirty_write_underway),
	.a(pmem_rdata),
	.b(cmem_wdata_inserted_0),
	.f(data_array_datain_0)
);

mux2 #(256) data_array_datain_mux_1
(
	.sel(dirty_write_underway),
	.a(pmem_rdata),
	.b(cmem_wdata_inserted_1),
	.f(data_array_datain_1)
);

mux2 pmem_addr_select_mux
(
	.sel(pmem_addr_select),
	.a({cmem_address[31:5], {5{1'b0}}}),
	.b({tag_array_dataout, cmem_address[7:5], {5{1'b0}}}),
	.f(pmem_address)
);


mux2 #(1) dirty_bit_dataout_mux
(
	.sel(way_select),
	.a(dirty_bit_dataout_0),
	.b(dirty_bit_dataout_1),
	.f(dirty_bit_dataout)
);

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

register #(256) pmem_wdata_holding
(
	.clk (clk),
	.load(unleash_pmem_wdata),
	.in	 (pmem_wdata_held),
	.out (pmem_wdata)
);

mux2 #(256) pmem_wdata_mux
(
	.sel(way_select),
	.a(data_array_dataout_0),
	.b(data_array_dataout_1),
	.f(pmem_wdata_held)
);

decoder2 #(1) cache_write_decoder
(
	.sel(way_select),
	.a(cache_write),
	.y(cache_write_0),
	.z(cache_write_1)
);

decoder2 #(1) dirty_bit_datain_decoder
(
	.sel(way_select),
	.a(dirty_bit_datain),
	.y(dirty_bit_datain_0),
	.z(dirty_bit_datain_1)
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
	.datain(data_array_datain_0),
	.dataout(data_array_dataout_0)
);

array data_array1
(
	.clk,
	.write(cache_write_1),
	.index(cmem_address[7:5]),
	.datain(data_array_datain_1),
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

array #(1) dirty_bit_array0
(
	.clk,
	.write(cache_write_0),
	.index(cmem_address[7:5]),
	.datain(dirty_bit_datain_0),
	.dataout(dirty_bit_dataout_0)
);

array #(1) dirty_bit_array1
(
	.clk,
	.write(cache_write_1),
	.index(cmem_address[7:5]),
	.datain(dirty_bit_datain_1),
	.dataout(dirty_bit_dataout_1)
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

mux4 choose_word_to_insert_mux_0
(
	.sel(mem_byte_enable),
	.a(cmem_wdata),
	.b(word_to_insert_halfword_0),
	.c(word_to_insert_byte_0),
	.f(word_to_insert_0)
);

mux4 choose_word_to_insert_mux_1
(
	.sel(mem_byte_enable),
	.a(cmem_wdata),
	.b(word_to_insert_halfword_1),
	.c(word_to_insert_byte_1),
	.f(word_to_insert_1)
);

mux4 store_byte_into_word_in_cache_line_mux_0
(
	.sel(cmem_address[1:0]),
	.a({cmem_rdata_0_unleashed[31:8], cmem_wdata[7:0]}),
	.b({cmem_rdata_0_unleashed[31:16], cmem_wdata[7:0], cmem_rdata_0_unleashed[7:0]}),
	.c({cmem_rdata_0_unleashed[31:24], cmem_wdata[7:0], cmem_rdata_0_unleashed[15:0]}),
	.d({cmem_wdata[7:0], cmem_rdata_0_unleashed[23:0]}),
	.f(word_to_insert_byte_0)
);

mux4 store_byte_into_word_in_cache_line_mux_1
(
	.sel(cmem_address[1:0]),
	.a({cmem_rdata_1_unleashed[31:8], cmem_wdata[7:0]}),
	.b({cmem_rdata_1_unleashed[31:16], cmem_wdata[7:0], cmem_rdata_1_unleashed[7:0]}),
	.c({cmem_rdata_1_unleashed[31:24], cmem_wdata[7:0], cmem_rdata_1_unleashed[15:0]}),
	.d({cmem_wdata[7:0], cmem_rdata_1_unleashed[23:0]}),
	.f(word_to_insert_byte_1)
);

mux2 store_halfword_into_word_in_cache_line_mux_0
(
	.sel(cmem_address[1]),
	.a({cmem_rdata_0_unleashed[31:16], cmem_wdata[15:0]}),
	.b({cmem_wdata[15:0], cmem_rdata_0_unleashed[15:0]}),
	.f(word_to_insert_halfword_0)
);

mux2 store_halfword_into_word_in_cache_line_mux_1
(
	.sel(cmem_address[1]),
	.a({cmem_rdata_1_unleashed[31:16], cmem_wdata[15:0]}),
	.b({cmem_wdata[15:0], cmem_rdata_1_unleashed[15:0]}),
	.f(word_to_insert_halfword_1)
);

/*
mux4 store_halfword_into_word_in_cache_line_mux_0
(
	.sel(cmem_address[1:0]),
	.a({cmem_rdata_0_unleashed[31:16], cmem_wdata[15:0]}),
	.c({cmem_wdata[15:0], cmem_rdata_0_unleashed[15:0]}),
	.f(word_to_insert_halfword_0)
);

mux4 store_halfword_into_word_in_cache_line_mux_1
(
	.sel(cmem_address[1:0]),
	.a({cmem_rdata_1_unleashed[31:16], cmem_wdata[15:0]}),
	.c({cmem_wdata[15:0], cmem_rdata_1_unleashed[15:0]}),
	.f(word_to_insert_halfword_1)
);
*/

mux8 #(256) insert_word_into_cache_line_0
(
	.sel(cmem_address[4:2]),
	.a({data_array_dataout_0[255:32], word_to_insert_0}),
	.b({data_array_dataout_0[255:64], word_to_insert_0, data_array_dataout_0[31:0]}),
	.c({data_array_dataout_0[255:96], word_to_insert_0, data_array_dataout_0[63:0]}),
	.d({data_array_dataout_0[255:128], word_to_insert_0, data_array_dataout_0[95:0]}),
	.e({data_array_dataout_0[255:160], word_to_insert_0, data_array_dataout_0[127:0]}),
	.f({data_array_dataout_0[255:192], word_to_insert_0, data_array_dataout_0[159:0]}),
	.g({data_array_dataout_0[255:224], word_to_insert_0, data_array_dataout_0[191:0]}),
	.h({word_to_insert_0, data_array_dataout_0[223:0]}),
	.res(cmem_wdata_inserted_0)
);

mux8 #(256) insert_word_into_cache_line_1
(
	.sel(cmem_address[4:2]),
	.a({data_array_dataout_1[255:32], word_to_insert_1}),
	.b({data_array_dataout_1[255:64], word_to_insert_1, data_array_dataout_1[31:0]}),
	.c({data_array_dataout_1[255:96], word_to_insert_1, data_array_dataout_1[63:0]}),
	.d({data_array_dataout_1[255:128], word_to_insert_1, data_array_dataout_1[95:0]}),
	.e({data_array_dataout_1[255:160], word_to_insert_1, data_array_dataout_1[127:0]}),
	.f({data_array_dataout_1[255:192], word_to_insert_1, data_array_dataout_1[159:0]}),
	.g({data_array_dataout_1[255:224], word_to_insert_1, data_array_dataout_1[191:0]}),
	.h({word_to_insert_1, data_array_dataout_1[223:0]}),
	.res(cmem_wdata_inserted_1)
);


endmodule : D_cache_datapath
