module L1_I_top(
    input clk,
    input nrst,
    input [51:0] tag,
    input [5:0] index,
    input [5:0] offset,
    input write_C_L1,
    input flush,
    output stall,
    input [31:0] write_data,
    output [31:0] read_data_L1_C,
    input [511:0] read_data_L2_L1,
    output write_L1_L2,
    output read_L1_L2,
    input ready_L2_L1,
    input read_C_L1
);

wire refill;
wire update;

L1_I_controller u_L1_I_controller(
    .clk(clk),
    .nrst(nrst),
    .refill(refill),
    .tag(tag),
    .index(index),
    .read_C_L1(read_C_L1),
    .ready_L2_L1(ready_L2_L1),
    .stall(stall),
    .update(update),
    .read_L1_L2(read_L1_L2),
    .write_L1_L2(write_L1_L2)
);

L1_I_data_array u_L1_I_data_array(
    .clk(clk),
    .nrst(nrst),
    .index(index),
    .write_data(write_data),
    .offset(offset),
    .read_data_L1_C(read_data_L1_C),
    .read_data_L2_L1(read_data_L2_L1),
    .update(update),
    .refill(refill)
);

endmodule