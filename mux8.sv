module mux8 #(parameter width = 32)
(
	input logic[2:0] sel,
	input logic[width-1:0] a,b,c,d,e,f,g,h,
	output logic[width-1:0] res
);
always_comb
begin
	case(sel)
		0: res = a;
		1: res = b;
		2: res = c;
		3: res = d;
		4: res = e;
		5: res = f;
		6: res = g;
		7: res = h;
	endcase
end
endmodule : mux8
