`timescale 1ns/1ns
module tb_top ();

reg				clk;
reg				rst;
wire	[31:0]	rw_address;

top u_top (
	.clk			(	clk			),
	.rst			(	rst			),
	.rw_address_o	(	rw_address	)
);

initial begin
	forever #5 clk	= ~clk;
end

initial begin
	rst	= 1'b1;
	clk	= 1'b1;
	repeat(10) @(posedge clk);
	rst	= 1'b0;
end

endmodule