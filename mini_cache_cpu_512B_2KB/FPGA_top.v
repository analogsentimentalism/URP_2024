module FPGA_top #(
	parameter	RAM_WIDTH	= 32,
	parameter	RAM_DEPTH	= 32'h200_0000,
	parameter	RAM_PERFORMANCE = "HIGH_PERFORMANCE",
	parameter	INIT_FILE	= "instructions.txt",
	parameter	START_ADDR	= 32'h10094,
	parameter	PC_START	= 32'h100d8
) (
	input 			clk_mem,
	input			clk,
	input			start,
	input		 	rst,
	input			enb,
<<<<<<< HEAD
	output reg 		tx_data,
	output	[3:0]	test_led
);

wire	L2_miss;
wire	L1I_miss;
wire	L1D_miss;
wire	read_C_L1I, read_C_L1D, write_C_L1D, read_L1_L2, write_L1_L2;
wire 	[7:0] data_o;
wire 	done;
<<<<<<< HEAD
wire	tx_data;
=======
reg		clk;
reg		[3:0] clk_cnt;

>>>>>>> 1139d8c31a76914098b53a571d9c4905e6b4350b

assign	test_led[0]	= done		;
assign	test_led[1]	= tx_data	;
assign	test_led[2]	= data_o[1]	;
assign	test_led[3]	= data_o[0]	;

riscV32I #(
	.RAM_WIDTH			(	RAM_WIDTH			),
	.RAM_DEPTH			(	RAM_DEPTH			),
	.RAM_PERFORMANCE 	(	RAM_PERFORMANCE		),
	.INIT_FILE			(	INIT_FILE			),
	.START_ADDR			(	START_ADDR			),
	.PC_START			(	PC_START			)
) u_cpu (
	.clk(clk),
	.clk_mem(clk_mem),
	.rst(rst),
	.enb(enb),
	.L2_miss_o(L2_miss),
	.L1I_miss_o(L1I_miss),
	.L1D_miss_o(L1D_miss),
	.read_C_L1I_o(read_C_L1I),
	.read_C_L1D_o(read_C_L1D),
	.write_C_L1D_o(write_C_L1D),
	.read_L1_L2(read_L1_L2),
	.write_L1_L2(write_L1_L2)
);

counter u_counter (
	.clk(clk_mem),
	.rstn(~rst),
	.read_C_L1I(read_C_L1I),
	.miss_L1I_C(L1I_miss),
	.read_C_L1D(read_C_L1D),
	.write_C_L1D(write_C_L1D),
	.miss_L1D_C(L1D_miss),
	.read_L1_L2(read_L1_L2),
	.write_L1_L2(write_L1_L2),
	.miss_L2_L1(L2_miss),
	.data_o(data_o),
	.done(done)
);

uart_tx u_tx (
	.clk(clk_mem),
	.din(data_o),
	.tx_start(done),
	.tx_data(tx_data)
);

endmodule