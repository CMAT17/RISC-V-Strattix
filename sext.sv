module sext_32 #(parameter in_width = 16)
(
	input logic[in_width-1 :0] in,
	output logic[31:0] out
);

assign out = {{(32-in_width){in[in_width-1]}},in};

endmodule : sext_32