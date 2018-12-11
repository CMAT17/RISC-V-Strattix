module l2_cache_datapath_revamped
(
	input logic clk,
	input logic cache_write,

	input logic l2cmem_resp,		// going to L1, but used to update LRU
	input logic[255:0] pmem_rdata,
					   l2cmem_wdata,
	input logic[31:0] l2cmem_address,

	input logic valid_bit_in,
				dirty_bit_in,

	input logic [1:0] way_select,

	input logic pmem_address_sel,
	input logic dirty_write_sel,

	input logic unleash_l2cmem_rdata,
				unleash_l2cmem_wdata,
				unleash_pmem_rdata,
                unleash_l2cmem_address,
                unleash_pmem_address,

	input logic pmem_resp,

	output logic dirty_bit_out,

	output logic[255:0] l2cmem_rdata,	// moving data from L2 line to L1
	output logic[255:0] pmem_wdata,
	output logic[31:0] pmem_address,

	output logic [3:0] which_way_hit,
	output logic hit,
	output logic [2:0] lru_way

);

logic[255:0] data_arr0_out,
			 data_arr1_out,
			 data_arr2_out,
			 data_arr3_out,
			 data_arr_in_mux_out;
logic[31:0] l2cmem_address_unleashed,pmem_address_in;

logic[2:0] lru_out, lru_data_in;
logic[3:0] index;
logic[22:0] tag, 
			tag_arr0_out,
			tag_arr1_out,
			tag_arr2_out,
			tag_arr3_out,
			tag_arr_out_mux_out;


logic valid_arr0_out,
	  valid_arr1_out,
	  valid_arr2_out,
	  valid_arr3_out;

logic dirty_arr0_out,
	  dirty_arr1_out,
	  dirty_arr2_out,
	  dirty_arr3_out;	 

logic valid_arr0_in,
	  valid_arr1_in,
	  valid_arr2_in,
	  valid_arr3_in;

logic dirty_arr0_in,
	  dirty_arr1_in,
      dirty_arr2_in,
	  dirty_arr3_in; 

logic l2cmem_arr0_write_data,
	  l2cmem_arr1_write_data,
	  l2cmem_arr2_write_data,
	  l2cmem_arr3_write_data;

logic tag_arr0_hit,
	  tag_arr1_hit,
	  tag_arr2_hit,
	  tag_arr3_hit;

logic [255:0] l2cmem_rdata_unleashed, 
			  l2cmem_wdata_unleashed,
			  pmem_rdata_unleashed,
			  data_arr_out;

logic [24:0] info_arr0_out, 
			 info_arr1_out,
			 info_arr2_out,
			 info_arr3_out,
			 info_arr_out,
			 new_info;

assign index = l2cmem_address_unleashed[8:5];
assign tag = l2cmem_address_unleashed[31:9];
assign lru_way = lru_out;
lru_rom lru_ctrl
(
	.lru_curr  (lru_out),
	.way_select(way_select), //figure it out
	.lru_new   (lru_data_in)
);


/******** HIT LOGIC ********/
//assign tag_arr0_hit = (tag_arr0_out == l2cmem_address_unleashed[31:9]) && valid_arr0_out;
//assign tag_arr1_hit = (tag_arr1_out == l2cmem_address_unleashed[31:9]) && valid_arr1_out;
//assign tag_arr2_hit = (tag_arr2_out == l2cmem_address_unleashed[31:9]) && valid_arr2_out;
//assign tag_arr3_hit = (tag_arr3_out == l2cmem_address_unleashed[31:9]) && valid_arr3_out;

//assign hit = tag_arr0_hit | tag_arr1_hit | tag_arr2_hit | tag_arr3_hit;
//assign hit = {tag_arr0_hit,tag_arr1_hit,tag_arr2_hit,tag_arr3_hit;

//assign which_way_hit = {tag_arr0_hit,tag_arr1_hit,tag_arr2_hit,tag_arr3_hit};

assign tag_arr0_hit = (info_arr0_out[24:2] == l2cmem_address_unleashed[31:9]) 
					  && info_arr0_out[0];

assign tag_arr1_hit = (info_arr1_out[24:2] == l2cmem_address_unleashed[31:9]) 
					  && info_arr1_out[0];

assign tag_arr2_hit = (info_arr2_out[24:2] == l2cmem_address_unleashed[31:9]) 
					  && info_arr2_out[0];

assign tag_arr3_hit = (info_arr3_out[24:2] == l2cmem_address_unleashed[31:9]) 
					  && info_arr3_out[0];

assign hit = tag_arr0_hit | tag_arr1_hit | tag_arr2_hit | tag_arr3_hit;

assign which_way_hit = {tag_arr0_hit,tag_arr1_hit,tag_arr2_hit,tag_arr3_hit};

assign dirty_bit_out = info_arr_out[1];

/******** DATA MOVING OUT OF L2 ********/

assign pmem_wdata = l2cmem_rdata_unleashed;
//assign l2cmem_rdata = data_arr_out;
assign l2cmem_rdata = l2cmem_rdata_unleashed;

register #(256) l2cmem_rdata_holding
(
	.clk (clk),
	.load(unleash_l2cmem_rdata),
	.in  (data_arr_out),
	.out (l2cmem_rdata_unleashed)
);

register #(256) pmem_rdata_holding
(
	.clk (clk),
	.load(pmem_resp),
	.in  (pmem_rdata),
	.out (pmem_rdata_unleashed)
);

register #(256) l2cmem_wdata_holding
(
	.clk (clk),
	.load(unleash_l2cmem_wdata),
	.in  (l2cmem_wdata),
	.out (l2cmem_wdata_unleashed)
);
register #(32) l2cmem_address_holding
(
    .clk(clk),
    .load(unleash_l2cmem_address),
    .in(l2cmem_address),
    .out(l2cmem_address_unleashed)
);

register #(32) pmem_address_holding
(
    .clk(clk),
    .load(unleash_pmem_address),
    .in(pmem_address_in),
    .out(pmem_address)
);

mux2 pmem_address_select_mux
(
	.sel(pmem_address_sel), //TODO: put something in -> pmem_addr_select from control
	.a	({l2cmem_address_unleashed[31:5], 5'h0}),
	//.b	({tag_arr_out_mux_out, index, 5'h0}),
	.b	({info_arr_out[24:2], index, 5'h0}),
	.f	(pmem_address_in)
);

/*
mux4 #(1) dirty_bit_out_mux
(
	.sel(way_select), //TODO: put something in -> way_select
	.a	(dirty_arr0_out),
	.b	(dirty_arr1_out),
	.c	(dirty_arr2_out),
	.d	(dirty_arr3_out),
	.f	(dirty_bit_out)
);
*/
//Here lies valid_bit_out. Kind of useless
/*
mux4 valid_bit_out_mux
(
	.sel(way_select), //TODO: put something in -> way_select
	.a	(valid_arr0_out),
	.b	(valid_arr1_out),
	.c	(valid_arr2_out),
	.d	(valid_arr3_out),
	.f	(valid_bit_out)
);
*/


mux4 #(.width(25)) info_arr_out_mux
(
	.sel(way_select), //TODO: put something in -> way_select
	.a	(info_arr0_out),
	.b	(info_arr1_out),
	.c	(info_arr2_out),
	.d	(info_arr3_out),
	.f	(info_arr_out)
);

/*
mux4 #(.width(23)) tag_arr_out_mux
(
	.sel(way_select), //TODO: put something in -> way_select
	.a	(tag_arr0_out),
	.b	(tag_arr1_out),
	.c	(tag_arr2_out),
	.d	(tag_arr3_out),
	.f	(tag_arr_out_mux_out)
);
*/

mux2 #(.width(256)) data_arr_in_mux
(
	.sel(dirty_write_sel), // TODO: figure out somehow -> dirty_write_underway
	.a  (pmem_rdata_unleashed),
	.b  (l2cmem_wdata_unleashed),
	.f  (data_arr_in_mux_out)
);

decoder4 #(1) data_arr_write_decoder
(
	.sel(way_select), //TODO: put something in -> way_select
	.a	(cache_write),
	.w	(l2cmem_arr0_write_data),
	.x	(l2cmem_arr1_write_data),
	.y	(l2cmem_arr2_write_data),
	.z	(l2cmem_arr3_write_data)
);


array2 #(.width(256)) data_array0
(
	.clk    (clk),
	.write  (l2cmem_arr0_write_data),
	.index  (index),
	.datain (data_arr_in_mux_out),
	.dataout(data_arr0_out)
);

array2 #(.width(256)) data_array1
(
	.clk    (clk),
	.write  (l2cmem_arr1_write_data),
	.index  (index),
	.datain (data_arr_in_mux_out),
	.dataout(data_arr1_out)
);

array2 #(.width(256)) data_array2
(
	.clk    (clk),
	.write  (l2cmem_arr2_write_data),
	.index  (index),
	.datain (data_arr_in_mux_out),
	.dataout(data_arr2_out)
);

array2 #(.width(256)) data_array3
(
	.clk    (clk),
	.write  (l2cmem_arr3_write_data),
	.index  (index),
	.datain (data_arr_in_mux_out),
	.dataout(data_arr3_out)
);

mux4 #(.width(256)) data_arr_out_to_L1_mux
(
	.sel(way_select), //TODO: put something in -> way_select
	.a  (data_arr0_out),
	.b  (data_arr1_out),
	.c  (data_arr2_out),
	.d  (data_arr3_out),
	.f  (data_arr_out)
);

/*
mux4 #(.width(256)) data_arr_out_to_pmem_mux
(
	.sel(way_select), //TODO: put something in -> way_select
	.a  (data_arr0_out),
	.b  (data_arr1_out),
	.c  (data_arr2_out),
	.d  (data_arr3_out),
	.f  (pmem_wdata_held)
);
*/

array2 #(.width(3)) lru_array
(
	.clk    (clk),
	.write  (l2cmem_resp),
	.index  (index),
	.datain (lru_data_in),
	.dataout(lru_out)
);


/* info array contains tag, dirty, and valid bits */
assign new_info = {tag, dirty_bit_in, valid_bit_in};

array2 #(25) info_array_0
(
	.clk	(clk),
	.write	(l2cmem_arr0_write_data),
	.index	(index),
	.datain	(new_info),
	.dataout(info_arr0_out)
);

array2 #(25) info_array_1
(
	.clk	(clk),
	.write	(l2cmem_arr1_write_data),
	.index	(index),
	.datain	(new_info),
	.dataout(info_arr1_out)
);
array2 #(25) info_array_2
(
	.clk	(clk),
	.write	(l2cmem_arr2_write_data),
	.index	(index),
	.datain	(new_info),
	.dataout(info_arr2_out)
);
array2 #(25) info_array_3
(
	.clk	(clk),
	.write	(l2cmem_arr3_write_data),
	.index	(index),
	.datain	(new_info),
	.dataout(info_arr3_out)
);


/********* VALID ARRAY SECTION *********/
/*
decoder4 #(1) valid_arr_in_decoder
(
	.sel(way_select), //TODO: put something in -> way_select
	.a	(valid_bit_in),
	.w	(valid_arr0_in),
	.x	(valid_arr1_in),
	.y	(valid_arr2_in),
	.z	(valid_arr3_in)
);

array2 #(.width(1)) valid_array0
(
	.clk    (clk),
	.write  (l2cmem_arr0_write_data),
	.index  (index),
	.datain (valid_arr0_in),
	.dataout(valid_arr0_out)
);

array2 #(.width(1)) valid_array1
(
	.clk    (clk),
	.write  (l2cmem_arr1_write_data),
	.index  (index),
	.datain (valid_arr1_in),
	.dataout(valid_arr1_out)
);

array2 #(.width(1)) valid_array2
(
	.clk    (clk),
	.write  (l2cmem_arr2_write_data),
	.index  (index),
	.datain (valid_arr2_in),
	.dataout(valid_arr2_out)
);

array2 #(.width(1)) valid_array3
(
	.clk    (clk),
	.write  (l2cmem_arr3_write_data),
	.index  (index),
	.datain (valid_arr3_in),
	.dataout(valid_arr3_out)
);

decoder4 #(1) dirty_arr_in_decoder
(
	.sel(way_select), //TODO: put something in -> way_select
	.a	(dirty_bit_in),
	.w	(dirty_arr0_in),
	.x	(dirty_arr1_in),
	.y	(dirty_arr2_in),
	.z	(dirty_arr3_in)
);

array2 #(.width(1)) dirty_array0
(
	.clk    (clk),
	.write  (l2cmem_arr0_write_data),
	.index  (index),
	.datain (dirty_arr0_in),
	.dataout(dirty_arr0_out)
);

array2 #(.width(1)) dirty_array1
(
	.clk    (clk),
	.write  (l2cmem_arr1_write_data),
	.index  (index),
	.datain (dirty_arr1_in),
	.dataout(dirty_arr1_out)
);

array2 #(.width(1)) dirty_array2
(
	.clk    (clk),
	.write  (l2cmem_arr2_write_data),
	.index  (index),
	.datain (dirty_arr2_in),
	.dataout(dirty_arr2_out)
);

array2 #(.width(1)) dirty_array3
(
	.clk    (clk),
	.write  (l2cmem_arr3_write_data),
	.index  (index),
	.datain (dirty_arr3_in),
	.dataout(dirty_arr3_out)
);

array2 #(.width(23)) tag_array0
(
	.clk    (clk),
	.write  (l2cmem_arr0_write_data),
	.index  (index),
	.datain (tag),
	.dataout(tag_arr0_out)
);


array2 #(.width(23)) tag_array1
(
	.clk    (clk),
	.write  (l2cmem_arr1_write_data),
	.index  (index),
	.datain (tag),
	.dataout(tag_arr1_out)
);


array2 #(.width(23)) tag_array2
(
	.clk    (clk),
	.write  (l2cmem_arr2_write_data),
	.index  (index),
	.datain (tag),
	.dataout(tag_arr2_out)
);


array2 #(.width(23)) tag_array3
(
	.clk    (clk),
	.write  (l2cmem_arr3_write_data),
	.index  (index),
	.datain (tag),
	.dataout(tag_arr3_out)
);
*/


endmodule : l2_cache_datapath_revamped // l2_cache_datapath_revamped
