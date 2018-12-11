module arbiter
(	
	// L1 caches -> arbiter
	input logic l1_read_i,
				l1_write_d,
				l1_read_d,
	input logic [31:0] l1_address_i,
					   l1_address_d,
	input logic [255:0] l1_wdata_d,

	// L2 cache -> arbiter
	input logic l2_resp,

	//arbiter -> L1 caches
	output logic 			l2_resp_i,
				 			l2_resp_d,

	// arbiter -> L2 cache
	output logic 			l2_read,
				 			l2_write,
	output logic [31:0] 	l2_address,
	output logic [255:0] 	l2_wdata
);
/*
logic prefetch;
logic [31:0] prefetch_addr;

initial 
begin
	prefetch = 0;
	prefetch_addr = 0;
end
*/

assign l2_write = l1_write_d;
always_comb
begin
	l2_resp_i = 1'b0;
	l2_resp_d = 1'b0;
	l2_read = 1'b0;
	l2_address = 32'bx;
	l2_wdata = 256'bx;
	/*if(prefetch == 1'b1)
	begin
		prefetch == 1'b0;
		l2_read = 1'b1;
		l2_resp_prefetch = l2_resp;
		l2_address = prefetch_address;
	end

	else */
	if (l1_read_d || l1_write_d)
	begin : data_cache_op
		l2_read = l1_read_d;
		l2_resp_d = l2_resp;
		l2_address = l1_address_d;
		l2_wdata = l1_wdata_d;
	end

	else if(l1_read_i) 
	begin : instr_cache_op
		//prefetch = 1'b1;
		//prefetch_addr = {l1_address_i[31:5] + 1'b1, 5'h0};
		l2_read = l1_read_i;
		l2_resp_i = l2_resp;
		l2_address = l1_address_i;
	end
	else
	begin
		/*DO NOTHING*/;
	end
	
end


endmodule : arbiter // arbiter
