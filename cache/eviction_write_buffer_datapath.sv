
module eviction_write_buffer_datapath 
(
    input clk,
    input write,
	input complete_eviction,

    //input [2:0] index,
    input [255:0] wdata_in,
	input [31:0] address_in,

    output [255:0] wdata_out,
	output [31:0] address_out,
	output logic valid_out
	//output logic blocking
);

//logic [288:0] data; // [wdata (256) | address (32) | valid (1)]
logic [255:0] data;
logic [31:0] address;
logic valid;

//assign blocking = (address_in == data[32:1]) && (data[0] == 1'b1);

/* Initialize array */
initial
begin
    //data = 0;
    data = 0;
	address = 0;
	valid = 0;
end

always_ff @(posedge clk)
begin
    if (write == 1 && valid == 1'b0)
    begin
		//if(!complete_eviction) blocking = ((address_in == data[32:1]) && (data[0] == 1'b1));
        //data <= {wdata_in, address_in, 1'b1};
        data = wdata_in;
		address = address_in;
		valid = 1'b1;
    end
	else if(complete_eviction)
	begin
		//data[0] <= 0;
		//blocking = 0;
		data = 0;
		address = 0;
		valid = 0;
	end
	//else if(!complete_eviction)
	//begin
	//	blocking = ((address_in == data[32:1]) && (data[0] == 1'b1));
	//end
	
end

assign wdata_out = data;
assign address_out = address;
assign valid_out = valid;

endmodule : eviction_write_buffer_datapath

