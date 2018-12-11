module mux32 #(parameter width = 32)
(
	input logic[4:0] sel,
	input logic[width-1:0] entry0, entry1, entry2, entry3,
						   entry4, entry5, entry6, entry7,
						   entry8, entry9, entry10, entry11,
						   entry12, entry13, entry14, entry15,
						   entry16, entry17, entry18, entry19,
						   entry20, entry21, entry22, entry23,
						   entry24, entry25, entry26, entry27,
						   entry28, entry29, entry30, entry31,
	output logic[width-1:0] result
);

always_comb
begin
	case(sel)
		0: result = entry0;
		1: result = entry1;
		2: result = entry2;
		3: result = entry3;

		4: result = entry4;
		5: result = entry5;
		6: result = entry6;
		7: result = entry7;
		
		8: result = entry8;
		9: result = entry9;
		10: result = entry10;
		11: result = entry11;
		
		12: result = entry12;
		13: result = entry13;
		14: result = entry14;
		15: result = entry15;
		
		16: result = entry16;
		17: result = entry17;
		18: result = entry18;
		19: result = entry19;
		
		20: result = entry20;
		21: result = entry21;
		22: result = entry22;
		23: result = entry23;
		
		24: result = entry24;
		25: result = entry25;
		26: result = entry26;
		27: result = entry27;
		
		28: result = entry28;
		29: result = entry29;
		30: result = entry30;
		31: result = entry31;
	endcase // sel
end


endmodule : mux32