

module L1_D_top(
    input clk,
    input nrst,
    input [20:0] tag_C_L1,
    input [4:0] index_C_L1,
    input [5:0] offset,
    input write_C_L1,
    input flush,
    output stall,
    input [31:0] write_data,
    output [31:0] read_data_L1_C,
    input [511:0] read_data_L2_L1,
    output [511:0] write_data_L1_L2,
    output write_L1_L2,
    output read_L1_L2,
    input ready_L2_L1,
    input read_C_L1,
    output [20:0] tag_L1_L2,
    output [20:0] write_tag_L1_L2,
    output [4:0] index_L1_L2
);

wire refill;
wire update;
wire way;

L1_D_controller u_L1_D_controller(
    .clk(clk),
    .nrst(nrst),
    .refill(refill),
    .tag_C_L1(tag_C_L1),
    .index_C_L1(index_C_L1),
    .write_tag_L1_L2(write_tag_L1_L2),
    .index_L1_L2(index_L1_L2),
    .read_C_L1(read_C_L1),
    .ready_L2_L1(ready_L2_L1),
    .stall(stall),
    .update(update),
    .read_L1_L2(read_L1_L2),
    .write_L1_L2(write_L1_L2),
    .write_C_L1(write_C_L1),
    .tag_L1_L2(tag_L1_L2),
    .way(way)
);

L1_D_data_array u_L1_D_data_array(
    .clk(clk),
    .nrst(nrst),
    .index_C_L1(index),
    .write_data_C_L1(write_data),
    .offset(offset),
    .read_data_L1_C(read_data_L1_C),
    .read_data_L2_L1(read_data_L2_L1),
    .update(update),
    .refill(refill),
    .write_data_L1_L2(write_data_L1_L2),
    .way(way)
);

endmodule
