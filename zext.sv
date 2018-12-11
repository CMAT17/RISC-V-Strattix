module zext #(parameter width = 32)
(
	input logic in,
	output logic [width-1:0] out
);

assign out = {{(width-1){1'b0}}, in};

endmodule : zext

module zext_32 #(parameter in_width = 16)
(
	input logic[in_width-1 :0] in,
	output logic[31:0] out
);

assign out = {{(32-in_width){1'b0}}, in};

endmodule : zext_32