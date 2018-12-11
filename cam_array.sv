
module cam_array #(parameter width = 32)
(
    input clk,
    input write,
    input [width-1:0] idx_addr,
    input [width-1:0] datain,
    output logic [width-1:0] dataout
);

logic [width-1:0] data [63:0] /* synthesis ramstyle = "logic" */;

/* Initialize array */
initial
begin
    for (int i = 0; i < $size(data); i++)
    begin
        data[i] = 1'b0;
    end
end

always_ff @(posedge clk)
begin
    if (write == 1)
    begin
        for (int i = 0; i < $size(data); i++)
        begin
            if(data[i][63:32] == idx_addr)
            begin
                
            end
        end
    end
end

assign dataout = data[index];

endmodule : cam_array

