module pc_adder #(parameter width = 32)
(
	input logic[width-1:0] in,
	output logic[width-1:0] out
);

assign out = in + 32'd4;

endmodule : pc_adder