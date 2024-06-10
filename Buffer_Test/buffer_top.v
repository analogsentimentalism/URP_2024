`timescale 1ns/1ns
module top_dsnfifo (

    input		clk,
	input		rstn,
	input		read_C_L1I,//
	input		miss_L1I_C,
	input		read_C_L1D,//
	input		write_C_L1D,
	input		miss_L1D_C,
	input		read_L1_L2,//
	input		write_L1_L2,//
	input		miss_L2_L1,

    output reg  tx_data
);


wire	[31:0	]	data_out1;
wire                wr_en;
wire    [7:0]         data_out2;
wire				valid_o;
wire				tx_data;
wire				ready;




reg					led_tx_data_reg;



counter_2 u_counter(
     .clk(clk),
     .rstn(rstn),
     .read_C_L1I(read_C_L1I),
     .miss_L1I_C(miss_L1I_C),
     .read_C_L1D(read_C_L1D),
     .write_C_L1D(write_C_L1D),
     .miss_L1D_C(miss_L1D_C),
     .read_L1_L2(read_L1_L2),
     .write_L1_L2(write_L1_L2),
     .miss_L2_L1(miss_L2_L1),
     .data_out1(data_out1),
     .wr_en(wr_en)
);


data_separator u_data_separator(
	.clk			(	clk			),
	.rstn			(	rstn			),
	.data_i			(	data_out1      	),
	.valid_pulse_i	(	wr_en		    ),
    .ready			(	uart_ready		),

	.data_out2			(	data_out2		),
	.valid_o		(	rd_en			)
);

TX_2 u_tx(
    .clk(clk),
    .rstn(rstn),
    .din(data_out2),
    .tx_start(rd_en),

    .tx_data(tx_data),
	.ready(uart_ready)
);



endmodule