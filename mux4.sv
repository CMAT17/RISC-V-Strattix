module mux4 #(parameter width = 32)
(
	input logic[1:0] sel,
	input logic[width-1:0] a,b,c,d,
	output logic[width-1:0] f
);

always_comb
begin
	case(sel)
		0 : f = a;
		1 : f = b;
		2 : f = c;
		3 : f = d;
	endcase // sel
end

endmodule : mux4
