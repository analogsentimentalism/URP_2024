module L1_D_top(
    input clk,
    input nrst,
    input [19:0] tag,
    input [5:0] index,
    input [5:0] offset,
    input write_C_L1,read_C_L1, ready_L2_L1, read_C_L1
    input flush,
    input [31:0] write_data,
    input [511:0] read_data_L2_L1,

    output write_L1_L2,
    output read_L1_L2,
    output [31:0] read_data_L1_C,
    output stall
);


wire refill;
wire update;


L1_D_controller_new u_L1_D_controller_new(
    .clk(clk),
    .nrst(nrst),
    .tag(tag),
    .index(index),
    .read_C_L1(read_C_L1),
    .flush(flush),
    .ready_L2_L1(ready_L2_L1),
    .write_C_L1(write_C_L1),
    .stall(stall),
    .refill(refill),
    .update(update),
    .read_L1_L2(read_L1_L2),
    .write_L1_L2(write_L1_L2)
);


L1_D_data_array_new u_L1_D_data_array_new(
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