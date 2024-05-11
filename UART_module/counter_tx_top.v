module counter_tx_top(
    input		clk,
	input		rstn,
	input		read_C_L1I,
	input		miss_L1I_C,
	input		read_C_L1D,
	input		write_C_L1D,
	input		miss_L1D_C,
	input		read_L1_L2,
	input		write_L1_L2,
	input		miss_L2_L1,

    output reg  tx_data
);


wire [7:0]      data_o;
wire            done;


counter u_counter(
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
    .data_o(data_o),
    .done(done)
);


uart_tx u_tx(
    .clk(clk),
    .din(data_o),
    .tx_start(done),
    .tx_data(tx_data)
);

endmodule
