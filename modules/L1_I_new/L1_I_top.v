

module L1_I_top(
    input clk,
    input nrst,
    input [20:0] tag_C_L1,
    input [4:0] index_C_L1,
    input [5:0] offset,
    input flush,
    output stall,
    output [31:0] read_data_L1_C,
    input [511:0] read_data_L2_L1,
    output read_L1_L2,
    input ready_L2_L1,
    input read_C_L1,
    output [17:0] tag_L1_L2,
    output [7:0] index_L1_L2,
    output L1I_miss_o
);

wire refill;
wire way;

L1_I_controller u_L1_I_controller(
    .clk(clk),
    .nrst(nrst),
    .refill(refill),
    .tag_C_L1(tag_C_L1),
    .index_C_L1(index_C_L1),
    .index_L1_L2(index_L1_L2),
    .read_C_L1(read_C_L1),
    .ready_L2_L1(ready_L2_L1),
    .stall(stall),
    .read_L1_L2(read_L1_L2),
    .tag_L1_L2(tag_L1_L2),
    .way(way),
	.flush(flush),
    .L1I_miss_o(L1I_miss_o)
);

L1_I_data_array u_L1_I_data_array(
    .clk(clk),
    .nrst(nrst),
    .index_C_L1(index_C_L1),
    .offset(offset),
    .read_data_L1_C(read_data_L1_C),
    .read_data_L2_L1(read_data_L2_L1),
    .refill(refill),
    .way(way)
);

endmodule
