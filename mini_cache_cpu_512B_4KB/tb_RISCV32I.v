`timescale 1ns/1ps

module tb_riscV();

reg clk, clk_mem, rst, enb;

reg	[31:0]	PC_in	;

wire L2_miss_o, L1I_miss_o, L1D_miss_o;
wire read_C_L1I_o, read_C_L1D_o, write_C_L1D_o;
wire read_L1_L2, write_L1_L2;

riscV32I TEST(
    .clk			(	clk				),
	.clk_mem		(	clk_mem			),
	.rst			(	rst				),
	.enb			(	enb				),
	.PC_in			(	PC_in			),
	.L2_miss_o		(	L2_miss_o		),
	.L1I_miss_o		(	L1I_miss_o		),
	.L1D_miss_o		(	L1D_miss_o		),
	.read_C_L1I_o	(	read_C_L1I_o	), 
	.read_C_L1D_o	(	read_C_L1D_o	),
	.write_C_L1D_o	(	write_C_L1D_o	),
	.read_L1_L2		(	read_L1_L2		),
	.write_L1_L2	(	write_L1_L2		)
);

initial begin
	forever #5 clk <= ~clk;
end

initial begin
	forever #1 clk_mem <= ~clk_mem;
end

initial begin
	PC_in = 'h000100d8;
    rst = 1;
    clk = 1;
	clk_mem = 1;
	enb = 0;
    #40;
    rst = 0;
    #20;
    enb = 1;
	#10000;
    // $display("%32h", TEST.DATAMEM.MEM_Data[88]);
    // $display("%32h", TEST.DATAMEM.MEM_Data[56]);
    // $display("%32h", TEST.DATAMEM.MEM_Data[57]);
end

endmodule