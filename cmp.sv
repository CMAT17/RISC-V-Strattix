module cmp
(
	input logic[2:0] cmpop,
	input logic[31:0] a, b,
	output logic cmp_out
);

logic eq_bit, lt_bit, ltu_bit, cmpinternalmux_out;

always_comb
begin
	eq_bit = (a==b);
	lt_bit = ($signed(a)<$signed(b));
	ltu_bit = (a<b);
end

mux4 #(.width(1)) cmpinternalmux
(
	.sel(cmpop[2:1]),
	.a  (eq_bit),
	.b  (), //leave empty (01 is invalid for two MSB in branch_funct3_t)
	.c  (lt_bit),
	.d  (ltu_bit),
	.f  (cmpinternalmux_out)
);

assign cmp_out = cmpinternalmux_out ^ cmpop[0];

endmodule : cmp
