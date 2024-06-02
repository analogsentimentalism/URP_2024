module top #(
	parameter	PC_START	= 32'h100d8
) (
	input			clk,
	input			rst,
	output	[31:0]	rw_address_o
);

wire	[31:0	]	rw_address;
wire	[31:0	]	read_data;
wire				read_request;
wire				read_response;
wire	[31:0	]	write_data;
wire	[3:0	]	write_strobe;
wire				write_request;
wire				write_response;

rvsteel_core #(
	.BOOT_ADDRESS			(	PC_START		)
) u_cpu (
  // Global signals

	.clock					(	clk				),
	.reset					(	rst				),
	.halt					(	1'b0			),

	// IO interface

	.rw_address				(	rw_address		),
	.read_data				(	read_data		),
	.read_request			(	read_request	),
	.read_response			(	read_response	),
	.write_data				(	write_data		),
	.write_strobe			(	write_strobe	),
	.write_request			(	write_request	),
	.write_response			(	write_response	),

	// Interrupt signals (hardwire inputs to zero if unused)

	.irq_external			(	1'b0			),
	.irq_external_response	(),
	.irq_timer				(	1'b0			),
	.irq_timer_response		(),
	.irq_software			(	1'b0			),
	.irq_software_response	(),
	.irq_fast				(	16'b0			),
	.irq_fast_response		(),

	// Real Time Clock (hardwire to zero if unused)

	.real_time_clock		(	64'b0			)
);

rvsteel_ram #(
	// Memory size in bytes
	.MEMORY_SIZE      (	8192			),
	// File with program and data
	.MEMORY_INIT_FILE (	"test.txt"		)
) u_ram (

  // Global signals

  	.clock			(	clk				),
  	.reset			(	rst				),

  // IO interface

  	.rw_address		(	rw_address-32'h10094	),
  	.read_data		(	read_data				),
  	.read_request	(	read_request			),
  	.read_response	(	read_response			),
  	.write_data		(	write_data				),
  	.write_strobe	(	write_strobe			),
  	.write_request	(	write_request			),
  	.write_response	(	write_response			)
);

assign	rw_address_o	= rw_address;

endmodule