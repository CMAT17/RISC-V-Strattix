import rv32i_types::*;

module control_reg
(
	input logic clk,
	input logic load,
    input logic flush,
	input rv32i_ctrl_word in,
	output rv32i_ctrl_word out
);
rv32i_ctrl_word data;

initial
begin
	data = 0; 
end

always_ff @(posedge clk or posedge flush)
begin
    if(flush)
        data <= 0;
	else if(load)
		data <= in;
	else /*DO NOTHING*/;
end

always_comb
begin
    out = data;
end

endmodule : control_reg// control_reg
