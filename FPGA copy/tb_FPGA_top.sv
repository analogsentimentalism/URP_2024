`timescale	1ns/1ns
module tb_FPGA_top ();

reg		clk_mem			;
reg		clk				;
reg		rst				;
wire	data_o			;
wire	[3:0]	test_led;

FPGA_top u_FPGA_top (
	.clk(clk),
	.clk_mem(clk_mem),
	.rst(rst),
	.tx_data(data_o),
	.test_led(test_led)
);

initial begin
	forever #1 clk_mem <= ~clk_mem;
end

initial begin
	forever #5 clk <= ~clk;
end

initial begin
	$display("START!!!!");
	clk	= 'b1;
	clk_mem = 'b1;
	rst = 'b1;
#200;
	rst = 'b0;
end

endmodule