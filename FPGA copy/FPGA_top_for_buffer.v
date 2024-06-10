module FPGA_top #(
	parameter	RAM_WIDTH	= 32,
	parameter	RAM_PERFORMANCE = "LOW_LATENCY",
	parameter	INIT_FILE	= "test.txt",
	parameter	START_ADDR	= 32'h0,
	parameter	PC_START	= 32'h0,
	parameter	NUM_INST	= 32'd677,
	parameter	END_INST	= START_ADDR + (NUM_INST - 1) << 2
) (
	input			clk,
	input		 	rst,
	input			enb,
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
wire 	[511:0] read_data_MEM_L2_bram;
wire 	[511:0] read_data_MEM_L2_dram;
wire 	ready_MEM_L2_bram;
wire 	ready_MEM_L2_dram;

wire			ready_MEM_L2;
wire			read_L2_MEM;
wire			write_L2_MEM;
wire	[7:0]	index_L2_MEM;
wire	[17:0]	tag_L2_MEM;
wire	[17:0]	write_tag_L2_MEM;

reg		[31:0]	rw_address_n;
reg				read_C_L1I_n;
reg				read_C_L1D_n;

wire			read_L1_L2;
wire			write_L1_L2;
wire			L2_miss;
wire			L1I_miss;
wire			L1D_miss;

wire	[25:0]	init_address;
wire	[7:0]	dram_index;
wire	[17:0]	write_dram_tag;
wire			wire_dram;
wire	[511:0]	write_data_MEM;

wire			done;
wire	[7:0]	data_o;
wire	[7:0]	data_out;
wire 			clk_cpu;

wire			read_L2_MEM_w;

assign	test_led = data_out[1:0];

reg		read_request_reg;

always @(posedge clk) begin
	if(rst) begin
		read_request_reg	<= 32'b0;
	end
	else begin
		if(read_request_reg) begin
			read_request_reg	<= 1'b0;
		end
		else begin
			read_request_reg	<= read_C_L1I_n;
		end
	end
end

rvsteel_core #(
	.BOOT_ADDRESS			(	PC_START		)
) u_cpu (
  // Global signals

	.clock					(	clk_cpu			),
	.reset					(	rst				),
	.halt					(	~enb			),

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

assign read_C_L1I		= read_request & (rw_address_n <= END_INST);
assign read_C_L1D		= read_request & (rw_address_n > END_INST);
assign read_response	= ((rw_address_n <= END_INST) & ready_L1I_C) | 
						  ((rw_address_n > END_INST) & ready_L1D_C);

assign read_data		= rw_address_n <= END_INST ? read_data_L1I_C : (
						  rw_address_n > END_INST ? read_data_L1D_C : 32'b0);

assign write_data_C_L1	= write_strobe == 4'b0001 ? read_data_L1D_C & ~32'h000F | write_data :
						  (write_strobe == 4'b0010 ? read_data_L1D_C & ~32'h00F0 | write_data :
						  (write_strobe == 4'b0100 ? read_data_L1D_C & ~32'h0F00 | write_data :
						  (write_strobe == 4'b1000 ? read_data_L1D_C & ~32'hF000 | write_data :
						  (write_strobe == 4'b0011 ? read_data_L1D_C & ~32'h00FF | write_data :
						  (write_strobe == 4'b1100 ? read_data_L1D_C & ~32'hFF00 | write_data :
						  (write_strobe == 4'b1111 ? write_data : 32'b0
						  ))))));


always @(posedge clk_cpu) begin
	if (rst) begin
		rw_address_n	<= 32'b0;
		read_C_L1I_n	<= 1'b0;
		read_C_L1D_n	<= 1'b0;
	end
	else begin
		rw_address_n	<= rw_address;
		read_C_L1I_n	<= read_C_L1I;
		read_C_L1D_n	<= read_C_L1D;
	end
end
LED_module u_LED_module (
	.clk(clk_cpu),
	.rstn(~rst),
	.LED(LED),
	// .ready_L1I_C(ready_L1I_C),
	// .read_data_L1I_C(read_data_L1I_C),
	// .read_C_L1I(read_C_L1I)
	.ready_L1I_C(ready_MEM_L2_dram),
	.read_data_L1I_C(read_data_MEM_L2_bram),
	.read_C_L1I(read_L2_MEM)
);
top u_top (
	.clk				(	clk_cpu				),
	.nrst				(	~rst				),

	.address_L1I		(	rw_address_n		),
	.address_L1D		(	rw_address_n		),
	.flush_L1I			(	1'b0				),
	.flush_L1D			(	1'b0				),
	.read_C_L1I			(	read_C_L1I_n		),
	.read_C_L1D			(	read_C_L1D_n		),
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
	.RAM_DEPTH			(	32'd3000					),
	.INIT_FILE			(	"test.txt"					),
	.START_ADDR			(	START_ADDR					),
	.NUM_INST			(	NUM_INST					)
) u_inst_rom (
	.clk				(	clk_cpu						),
	.enb				(	enb							),
	.rstn				(	~rst						),
	.init_address		(	init_address				),
	.read_data_MEM_L2	(	read_data_MEM_L2_bram		),
	.ready_MEM_L2		(	ready_MEM_L2_bram			),
	.ready_MEM			(	ready_MEM_L2_dram			)
);

assign	write_dram_tag		= enb ? write_tag_L2_MEM		:	init_address[25-:18	];
assign	dram_index			= enb ? index_L2_MEM			:	init_address[0+:8	];
assign	write_data_MEM		= enb ? write_data_L2_MEM		:	read_data_MEM_L2_bram;
assign	write_dram			= enb ? write_L2_MEM & 	 ~ready_MEM_L2_dram		:	ready_MEM_L2_bram;
assign	read_data_MEM_L2	= enb ? read_data_MEM_L2_dram	:	512'h0;
assign	ready_MEM_L2 		= enb & ready_MEM_L2_dram;
assign	read_L2_MEM_w		= read_L2_MEM & ~ready_MEM_L2_dram;

mig_example_top u_mig_example_top(
	.CLK100MHZ(clk),
	.CPU_RESETN(~rst),
	.LED(),
	.read_L2_MEM(read_L2_MEM_w),
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


counter_2 u_counter(
     .clk(clk_cpu),
     .rstn(~rst),
     .read_C_L1I(read_C_L1I),
     .miss_L1I_C(L1I_miss_o),
     .read_C_L1D(read_C_L1D),
     .write_C_L1D(write_C_L1D),
     .miss_L1D_C(L1D_miss_o),
     .read_L1_L2(read_L1_L2),
     .write_L1_L2(write_L1_L2),
     .miss_L2_L1(L2_miss_o),
     .data_o(data_o),
     .wr_en(wr_en)
);

wire uart_ready;

data_separator u_data_separator(
	.clk			(	clk_cpu			),
	.rstn			(	~rst			),
	.data_i			(	data_o      	),
	.valid_pulse_i	(	wr_en		    ),
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