module tb_FPGA_top ();

reg		clk_mem			;
reg		rst				;
reg		enb				;
reg		start			;
wire	[7:0]	data_o	;

FPGA_top u_FPGA_top (
	.clk_mem(clk_mem),
	.start(start),
	.rst(rst),
	.enb(enb),
	.data_o(data_o)
);

initial begin
	forever #1 clk_mem <= ~clk_mem;
end

initial begin
	clk_mem = 'b1;
	rst = 'b1;
	enb = 'b0;
	start = 'b0;
#10;
	start = 'b1;
#200;
	rst = 'b0;
	enb = 'b1;
end

endmodule