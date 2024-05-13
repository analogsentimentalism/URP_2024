module tb_FPGA_top ();

reg				clk_mem	;
reg				clk		;
reg				rst		;
reg				enb		;
wire			tx_data	;
wire	[3:0]	test_led;

FPGA_top u_FPGA_top (
	.clk		(	clk			),
	.clk_mem	(	clk_mem		),
	.rst		(	rst			),
	.enb		(	enb			),
	.tx_data	(	tx_data		),
	.test_led	(	test_led	)
);

initial begin
	forever	#1	clk_mem	<= ~clk_mem	;
	
end

initial begin
	forever	#8	clk	<= ~clk	;
end

initial begin
	clk	= 'b1	;
	clk_mem	= 'b1	;
	rst		= 'b0	;
	enb		= 'b0	;
	
#50;
	rst		= 'b1	;

#50;
	rst		= 'b0	;

#50;
	enb		= 'b1	;

#8000000;
	$finish();
end


endmodule