module decoder4 #(parameter width = 32)
(
	input [1:0] sel,
	input [width-1:0] a,
	output logic [width-1:0] w,x,y, z
);

always_comb
begin
	/* default = DON'T CARE */
	w = 0;
	x = 0;
	y = 0;
	z = 0;

	if(sel == 2'b00) w = a;
	else if(sel == 2'b01) x = a;
	else if(sel == 2'b10) y = a;
	else if(sel == 2'b11) z = a;
end

endmodule : decoder4