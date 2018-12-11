module counter_reg #(parameter width = 32)
(
    input clk,
    input inc,
	input flush,

    output logic [width-1:0] out
);

logic [width-1:0] data;

/* Altera device registers are 0 at power on. Specify this
 * so that Modelsim works as expected.
 */
initial
begin
    data = 32'b0;
end

always_ff @(posedge clk or posedge flush)
begin
	if (flush)
	begin
		data <= 0;
	end
    else if (inc)
    begin
        data <= data + 1;
    end
end

always_comb
begin
    out = data;
end

endmodule : counter_reg
