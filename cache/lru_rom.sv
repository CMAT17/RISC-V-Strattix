module lru_rom
(
	input logic[2:0] lru_curr,
	input logic[1:0] way_select,
	output logic[2:0] lru_new
);
always_comb
begin
	case(way_select)
		2'b00: 	begin
			 		lru_new = {2'b11, lru_curr[0]};
			   	end
		2'b01: 	begin
					lru_new = {2'b10, lru_curr[0]};
				end
		2'b10: 	begin
					lru_new = {1'b0, lru_curr[1], 1'b1};
				end
		2'b11: 	begin
					lru_new = {1'b0, lru_curr[1], 1'b0};
				end
		default:
				begin
					lru_new = 3'bx;
				end
	endcase
end

endmodule : lru_rom// lru_rom