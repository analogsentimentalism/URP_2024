module test_top (
	input			clk,
	input		 	rst,
	input			write,
	input			read,
	input	[3:0]	sw,
	output	 		tx_data,
	inout	[15:0]	ddr2_dq,
	inout 	[1:0]	ddr2_dqs_n,
	inout	[1:0]ddr2_dqs_p,
	output	[12:0]ddr2_addr,
	output	[2:0]ddr2_ba,
	output	ddr2_ras_n,
	output	ddr2_cas_n,
	output	ddr2_we_n,
	output	ddr2_ck_p,
	output	ddr2_ck_n,
	output	ddr2_cke,
	output	ddr2_cs_n,
	output	[1:0]ddr2_dm,
	output	ddr2_odt,
	output [15:0] LED,
	output	[1:0] test_led
);



mig_example_top u_mig_example_top(
	.CLK100MHZ(clk),
	.CPU_RESETN(~rst),
	.LED(),
	.read_L2_MEM(read_L2_MEM),
	.write_L2_MEM(write_dram),
	.tag_L2_MEM(tag_L2_MEM),
	.index_L2_MEM(dram_index),
	.write_tag_L2_MEM(write_dram_tag),
	.write_data_L2_MEM(write_data_MEM),
	.read_data_MEM_L2(read_data_MEM_L2_dram),
	.ready_MEM_L2(ready_MEM_L2_dram),
	.ddr2_dq(ddr2_dq),
	.ddr2_dqs_n(ddr2_dqs_n),
	.ddr2_dqs_p(ddr2_dqs_p),
	.ddr2_addr(ddr2_addr),
	.ddr2_ba(ddr2_ba),
	.ddr2_ras_n(ddr2_ras_n),
	.ddr2_cas_n(ddr2_cas_n),
	.ddr2_we_n(ddr2_we_n),
	.ddr2_ck_p(ddr2_ck_p),
	.ddr2_ck_n(ddr2_ck_n),
	.ddr2_cke(ddr2_cke),
	.ddr2_cs_n(ddr2_cs_n),
	.ddr2_dm(ddr2_dm),
	.ddr2_odt(ddr2_odt),
	.clk_cpu(clk_cpu)
);


endmodule