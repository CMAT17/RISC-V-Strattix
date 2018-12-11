module register #(parameter width = 32)
(
    input clk,
    input load,
	input flush,
    input [width-1:0] in,

    output logic [width-1:0] out
);

logic [width-1:0] data;

/* Altera device registers are 0 at power on. Specify this
 * so that Modelsim works as expected.
 */
initial
begin
    data = 1'b0;
end

/*
always_ff @ (posedge flush)
begin
	if(flush)
	begin
		data = 0;
	end
end
*/

always_ff @(posedge clk or posedge flush)
begin
	if (flush)
	begin
		data <= 0;
	end
    else if (load)
    begin
        data <= in;
    end
	else 
	begin
		/*DO NOTHING*/;
	end
end

always_comb
begin
    out = data;
end

endmodule : register
