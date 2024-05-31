module FPGA_top #(
	parameter	RAM_WIDTH	= 32,
	parameter	RAM_DEPTH	= 32'h40_0000,
	parameter	RAM_PERFORMANCE = "LOW_LATENCY",
	parameter	INIT_FILE	= "test.txt",
	parameter	START_ADDR	= 32'h10094,
	parameter	PC_START	= 32'h100d8
) (
	input 			clk_mem,
	input			clk,
	input		 	rst,
	input			enb,
	output	 		tx_data,
	output	[3:0]	test_led
);

wire	[31:0]	rw_address;
wire	[31:0]	read_data;
wire			read_request;
wire			read_response;
wire	[31:0]	write_data;
wire	[3:0]	write_strobe;
wire			write_request;
wire			write_response;

rvsteel_core #(
  .BOOT_ADDRESS	(	PC_START	)
  ) (

  // Global signals

	.clock	(	clk		),
	.reset	(	rst		),
	.halt	(	1'b0	),

	// IO interface

	.rw_address		(	rw_address		),
	.read_data		(	read_data		),
	.read_request	(	read_request	),
	.read_response	(	read_response	),
	.write_data		(	write_data		),
	.write_strobe	(	wite_strobe		),
	.write_request	(	write_request	),
	.write_response	(	write_response	),

	// Interrupt signals (hardwire inputs to zero if unused)

	.irq_external			(	1'b0	),
	.irq_external_response	(			),
	.irq_timer				(	1'b0	),
	.irq_timer_response		(			),
	.irq_software			(	1'b0	),
	.irq_software_response	(			),
	.irq_fast				(	1'b0	),
	.irq_fast_response		(			),

	// Real Time Clock (hardwire to zero if unused)

	.real_time_clock	(	64'b0	)

  );

top	u_top (

);



// riscV32I #(
// 	.RAM_WIDTH			(	RAM_WIDTH			),
// 	.RAM_DEPTH			(	RAM_DEPTH			),
// 	.RAM_PERFORMANCE 	(	RAM_PERFORMANCE		),
// 	.INIT_FILE			(	INIT_FILE			),
// 	.START_ADDR			(	START_ADDR			),
// 	.PC_START			(	PC_START			)
// ) u_cpu (
// 	.clk(clk),
// 	.clk_mem(clk_mem),
// 	.rst(rst),
// 	.enb(enb),
// 	.L2_miss_o(L2_miss),
// 	.L1I_miss_o(L1I_miss),
// 	.L1D_miss_o(L1D_miss),
// 	.read_C_L1I_o(read_C_L1I),
// 	.read_C_L1D_o(read_C_L1D),
// 	.write_C_L1D_o(write_C_L1D),
// 	.read_L1_L2(read_L1_L2),
// 	.write_L1_L2(write_L1_L2)
// );

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
	.rstn(~rst),
	.clk(clk_mem),
	.din(data_o),
	.tx_start(done),
	.tx_data(tx_data_wire)
);

endmodule