module dram_please_top(
    input clk,
    input rst,
    input read,
    input write,
    output tx_data,
    output [3:0] LED,

    inout[15:0] ddr2_dq,
    inout[1:0] ddr2_dqs_n,
    inout[1:0] ddr2_dqs_p,
    output[12:0] ddr2_addr,
    output[2:0] ddr2_ba,
    output ddr2_ras_n,
    output ddr2_cas_n,
    output ddr2_we_n,
    output ddr2_ck_p,
    output ddr2_ck_n,
    output ddr2_cke,
    output ddr2_cs_n,
    output[1:0] ddr2_dm,
    output ddr2_odt,
);
wire raedy_MEM_L2_dram;
wire [511:0] read_data_MEM_L2_dram;
wire clk_cpu;
wire uart_ready;
wire [7:0]data_out;
wire rd_en;

mig_example_top u_mig_example_top(
	.CLK100MHZ(clk),
	.CPU_RESETN(~rst),
	.LED(),
	.read_L2_MEM(read),
	.write_L2_MEM(write),
	.tag_L2_MEM('h0),
	.index_L2_MEM('h0),
	.write_tag_L2_MEM('h0),
	.write_data_L2_MEM(512'h0123_4567_89AB_CDEF_4567_89AB_CDEF_0123_1357_2468_1357_2468_3579_468A_2345_5632_0123_4567_89AB_CDEF_4567_89AB_CDEF_0123_1357_2468_1357_2468_3579_468A_2345_5632),
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
data_separator u_data_separator(
	.clk			(	clk_cpu			),
	.rstn			(	~rst			),
	.data_i			(	read_data_MEM_L2_dram	),
	.valid_pulse_i	(	ready_MEM_L2_dram	),

	.ready			(	uart_ready		),
	.data_o			(	data_out		),
	.valid_o		(	rd_en			)
);

TX_2 u_tx(
    .clk(clk_cpu),
    .rstn(~rst),
    .din(data_out),
    .tx_start(rd_en),
    .tx_data(tx_data),
	.ready(uart_ready)
);



endmodule