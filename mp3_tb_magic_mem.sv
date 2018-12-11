module mp3_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic mem_resp_i;
logic mem_resp_d;
logic mem_read_i;
logic mem_read_d;
logic mem_write_i;
logic mem_write_d;
logic [3:0] mem_byte_enable_i;
logic [3:0] mem_byte_enable_d;
logic [31:0] mem_address_i;
logic [31:0] mem_address_d;
logic [255:0] mem_rdata_i;
logic [255:0] mem_rdata_d;
logic [255:0] mem_wdata_i;
logic [255:0] mem_wdata_d;
logic [31:0] write_data;
logic [31:0] write_address;
logic write;
logic [31:0] registers [32];

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

assign registers = dut.cpu.Regfile.data;

always @(posedge clk)
begin
	if (mem_write_d & mem_resp_d) begin
		write_address = mem_address_d;
		write_data = mem_wdata_d;
		write = 1;
	end else begin
		write_address = 32'hx;
		write_data = 256'hx;
		write = 0;
	end

end

/*
cpu_datapath dut
(
    .clk,

	// i = instruction memory interactions
	// d = data memory interactions
    .mem_resp_i,
	.mem_resp_d,
	.mem_rdata_i,
    .mem_rdata_d,
	.mem_read_i,
    .mem_read_d,
	.mem_write_i,
    .mem_write_d,
    .mem_byte_enable_i,
	.mem_byte_enable_d,
	.mem_wdata_i,
    .mem_wdata_d,
	.mem_address_i,
	.mem_address_d
);
*/

cpu_cache_toplevel dut
(
	.clk,
	.pmem_resp_i(mem_resp_i),
	.pmem_resp_d(mem_resp_d),
	.pmem_rdata_i(mem_rdata_i),
	.pmem_rdata_d(mem_rdata_d),
	.pmem_read_i(mem_read_i),
	.pmem_read_d(mem_read_d),
	.pmem_write_i(mem_write_i),
	.pmem_write_d(mem_write_d),
	.pmem_address_i(mem_address_i),
	.pmem_address_d(mem_address_d),
	.pmem_wdata_i(mem_wdata_i),
	.pmem_wdata_d(mem_wdata_d)
);

magic_memory_dp memory //TODO: change ports to reflect dual port memory
(
    .clk(clk),
	
	//  a = instruction memory interactions
    .read_a(mem_read_i),
    .write_a(mem_write_i),
    .wmask_a(mem_byte_enable_i),
    .address_a(mem_address_i),
    .wdata_a(mem_wdata_i),
    .resp_a(mem_resp_i),
    .rdata_a(mem_rdata_i),

	// b = data memory interactions
	.read_b(mem_read_d),
	.write_b(mem_write_d),
	.wmask_b(mem_byte_enable_d),
	.address_b(mem_address_d),
	.wdata_b(mem_wdata_d),
	.resp_b(mem_resp_d),
	.rdata_b(mem_rdata_d)
);

endmodule : mp3_tb
