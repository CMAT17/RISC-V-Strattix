module mux16 #(parameter width = 32) 
(
	input logic [3:0] sel,
	input logic [width-1:0] entry0, entry1, entry2, entry3, 
							entry4, entry5, entry6, entry7, 
							entry8, entry9, entryA, entryB,
							entryC, entryD, entryE, entryF,
	output logic [width-1:0] res
);

always_comb
begin
	case(sel)
		0: res = entry0;
		1: res = entry1;
		2: res = entry2;
		3: res = entry3;
		4: res = entry4;
		5: res = entry5;
		6: res = entry6;
		7: res = entry7;
		8: res = entry8;
		9: res = entry9;
		10: res = entryA;
		11: res = entryB;
		12: res = entryC;
		13: res = entryD;
		14: res = entryE;
		15: res = entryF;
	endcase // sel
end

endmodule : mux16 // mux16