module FPGA_top (
	input 			clk_mem,
	input			start,
	input		 	rst,
	input			enb,
	output reg 		tx_data
);

wire	L2_miss;
wire	L1I_miss;
wire	L1D_miss;
wire 	[7:0] data_o;
wire 	done;
reg		clk;
reg		[3:0] clk_cnt;

riscV32I u_cpu (
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
	.rstn(~rst),
	.din(data_o),
	.tx_start(done),
	.tx_data(tx_data)
);

// clock gen
always @(posedge clk_mem) begin
	if (~start) begin
		clk_cnt	<= 'b0;
		clk	<= 'b0;
	end
	else begin
		clk_cnt	<= clk_cnt + 1;
		if(clk_cnt == 'b1111) begin
			clk	<= ~clk;
		end
	end
end


endmodule