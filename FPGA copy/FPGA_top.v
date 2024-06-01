module FPGA_top #(
	parameter	RAM_WIDTH	= 32,
	parameter	RAM_DEPTH	= 32'h40_0000,
	parameter	RAM_PERFORMANCE = "LOW_LATENCY",
	parameter	INIT_FILE	= "test.txt",
	parameter	START_ADDR	= 32'h10094,
	parameter	PC_START	= 32'h100d8,
	parameter	END_INST	= 32'h11fd8
) (
	input 			clk_mem,
	input			clk,
	input		 	rst,
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

wire			read_C_L1I;
wire			read_C_L1D;
wire	[31:0]	read_data_L1I_C;
wire	[31:0]	read_data_L1D_C;
wire	[31:0]	write_data_C_L1;

wire			ready_L1I_C;
wire			ready_L1D_C;

wire	[511:0]	read_data_MEM_L2;
wire	[511:0]	write_data_L2_MEM;
wire			ready_MEM_L2;
wire			read_MEM_L2;
wire			write_L2_MEM;
wire	[7:0]	index_L2_MEM;
wire	[17:0]	tag_L2_MEM;
wire	[17:0]	write_tag_L2_MEM;

wire			read_L1_L2;
wire			write_L1_L2;
wire			L2_miss;
wire			L1I_miss;
wire			L1D_miss;

wire			done;
wire	[7:0]	data_o;

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

assign read_C_L1I		= read_request & (rw_address <= END_INST);
assign read_C_L1D		= read_request & (rw_address > END_INST);
assign read_response	= ((rw_address <= END_INST) & ready_L1I_C) | 
						  ((rw_address > END_INST) & ready_L1D_C);

assign read_data		= ((rw_address <= END_INST) & read_data_L1I_C) | 
						  ((rw_address > END_INST) & read_data_L1D_C);

assign write_data_C_L1	= write_strobe == 4'b0001 ? read_data_L1D_C & ~32'h000F | write_data :
						  (write_strobe == 4'b0010 ? read_data_L1D_C & ~32'h00F0 | write_data :
						  (write_strobe == 4'b0100 ? read_data_L1D_C & ~32'h0F00 | write_data :
						  (write_strobe == 4'b1000 ? read_data_L1D_C & ~32'hF000 | write_data :
						  (write_strobe == 4'b0011 ? read_data_L1D_C & ~32'h00FF | write_data :
						  (write_strobe == 4'b1100 ? read_data_L1D_C & ~32'hFF00 | write_data :
						  (write_strobe == 4'b1111 ? write_data : 32'b0
						  ))))));

top u_top (
	.clk				(	clk_mem				),
	.nrst				(	~rst				),

	.address_L1I		(	rw_address			),
	.address_L1D		(	rw_address			),
	.flush_L1I			(	1'b0				),
	.flush_L1D			(	1'b0				),
	.read_C_L1I			(	read_C_L1I			),
	.read_C_L1D			(	read_C_L1D			),
	.write_C_L1D		(	write_request		),
	.write_data			(	write_data_C_L1		),
	.read_data_L1I_C	(	read_data_L1I_C		),
	.read_data_L1D_C	(	read_data_L1D_C		),

	.write_response		(	write_response		),
	.ready_L1D_C		(	ready_L1D_C			),
	.ready_L1I_C		(	ready_L1I_C			),

	.stall_L1I			(),
	.stall_L1D			(),

	.read_data_MEM_L2	(	read_data_MEM_L2	),
	.ready_MEM_L2		(	ready_MEM_L2		),

	.read_L2_MEM		(	read_L2_MEM			),
	.write_L2_MEM		(	write_L2_MEM		),
	.index_L2_MEM		(	index_L2_MEM		),
	.tag_L2_MEM			(	tag_L2_MEM			),
	.write_tag_L2_MEM	(	write_tag_L2_MEM	),
	.write_data_L2_MEM	(	write_data_L2_MEM	),
	.read_L1_L2			(	read_L1_L2			),
	.write_L1_L2		(	write_L1_L2			),

	.L2_miss_o			(	L2_miss				),
	.L1I_miss_o			(	L1I_miss			),
	.L1D_miss_o			(	L1D_miss			)
);

instruction_rom #(
	.RAM_WIDTH			(	32							),
	.RAM_DEPTH			(	(END_INST-START_ADDR)/4+1	),
	.INIT_FILE			(	"test.txt"					),
	.START_ADDR			(	START_ADDR					),
	.TNUM				(	18							),
	.INUM				(	26 - 18						)
) u_inst_rom (
	.read_L2_MEM		(	read_L2_MEM					),
	.clk				(	clk_mem						),
	.rstn				(	~rst						),
	.tag_L2_MEM			(	tag_L2_MEM					),
	.index_L2_MEM		(	index_L2_MEM				),
	.ready_MEM_L2		(	ready_MEM_L2				),
	.read_data_MEM_L2	(	read_data_MEM_L2			)
);

counter u_counter (
	.clk(clk_mem),
	.rstn(~rst),
	.read_C_L1I(read_C_L1I),
	.miss_L1I_C(L1I_miss),
	.read_C_L1D(read_C_L1D),
	.write_C_L1D(write_request),
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