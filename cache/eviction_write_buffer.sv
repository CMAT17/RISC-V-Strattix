module eviction_write_buffer
(
	input logic clk,
	input [31:0] l2pmem_address,
	input [255:0] l2pmem_wdata,
	input logic l2_read,
				l2_write,
				l2pmem_read,
				l2pmem_write,
	input logic pmem_resp,

	output logic blocking,
	output logic send_ewb_to_pmem,
	output [255:0] ewb_pmem_wdata,
	output [31:0] ewb_pmem_address

);


logic complete_eviction;
logic ewb_valid;

eviction_write_buffer_datapath evb_datapath
(
	.clk			  (clk),
	.write			  (!ewb_valid & l2pmem_write),
	.complete_eviction(complete_eviction),
	.wdata_in		  (l2pmem_wdata),
	.address_in		  (l2pmem_address),
	
	.wdata_out		  (ewb_pmem_wdata),
	.address_out	  (ewb_pmem_address),
	.valid_out		  (ewb_valid)
);

eviction_write_buffer_control evb_control
(
	.clk				   (clk),
	.pmem_resp			   (pmem_resp),
	.l2_read			   (l2_read),
	.l2_write			   (l2_write),
	.ewb_valid 			   (ewb_valid),
	.l2_address			   (l2pmem_address),
	.ewb_address		   (ewb_pmem_address),
	.l2pmem_read (l2pmem_read),
	.l2pmem_write (l2pmem_write),
	
	.blocking			   (blocking),
	.send_evicted_line_pmem(send_ewb_to_pmem),
	.complete_eviction	   (complete_eviction)
);

endmodule : eviction_write_buffer 
