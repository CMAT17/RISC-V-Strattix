module prefetch_buffer
(
	input logic clk,
	input logic update,
	input [31:0] address_in,
	input [255:0] data_in,
	
	output [31:0] address_out,
	output [255:0] data_out,
	output logic valid_out
);


logic [31:0] address;
logic [255:0] data;
logic valid;

initial
begin
	address = 0;
	data = 0;
	valid = 0;
end

always_ff @(posedge clk)
begin
	if(update == 1)
	begin
		address <= address_in;
		data <= data_in;
		valid <= 1;
	end
end

assign address_out = address;
assign data_out = data;
assign valid_out = valid;

endmodule : prefetch_buffer
