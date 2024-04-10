module L2_top(
    input clk,
    input nrst,
    input [17:0] tag_L1_L2,
    input [7:0] index_L1_L2,
    input [5:0] offset,
    input [511:0] write_data,
    input [511:0] read_data_MEM_L2,
    
    input read_L1_L2, flush,
    input ready_MEM_L2,
    input write_L1_L2,
    output ready_L2_L1,
    output read_L2_MEM, write_L2_MEM,
    output [7:0] index_L2_MEM,
    output [17:0] tag_L2_MEM,
    output [17:0] write_tag_L2_MEM,
    
    output [511:0] read_data_L2_L1,
    output [511:0] write_data_L2_MEM
);

wire refill;
wire update;
wire [1:0] way;

L2_controller u_L2_controller(
    .clk(clk),
    .nrst(nrst),
    .refill(refill),
    .tag_L1_L2(tag_L1_L2),
    .index_L1_L2(index_L1_L2),
    .write_tag_L2_MEM(write_tag_L2_MEM),
    .index_L2_MEM(index_L2_MEM),
    .read_L1_L2(read_L1_L2),
    .ready_L2_L1(ready_L2_L1),
    .update(update),
    .read_L2_MEM(read_L2_MEM),
    .write_L2_MEM(write_L2_MEM),
    .write_L1_L2(write_L1_L2),
    .tag_L2_MEM(tag_L2_MEM),
    .way(way)
);

L2_data_array u_L2_data_array(
    .clk(clk),
    .nrst(nrst),
    .index_L1_L2(index_L1_L2),
    .write_data_L1_L2(write_data),
    .offset(offset),
    .read_data_L2_L1(read_data_L2_L1),
    .read_data_MEM_L2(read_data_MEM_L2),
    .update(update),
    .refill(refill),
    .write_data_L2_MEM(write_data_L2_MEM),
    .way(way)
);

endmodule