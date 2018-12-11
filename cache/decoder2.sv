module decoder2 #(parameter width = 32)
(
	input sel,
	input [width-1:0] a,
	output logic [width-1:0] y, z
);

always_comb
begin
	if(sel == 0) begin
		y = a;
		z = 1'b0;
	end
	else begin
		z = a;
		y = 1'b0;
	end
end

endmodule : decoder2