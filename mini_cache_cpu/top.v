// 앞에가 자기
module top (
    input clk,
    input nrst,

    // CORE와 L1I 사이의 신호
    input [31:0] address_L1I,
    input flush_L1I,
    input read_C_L1I,
    output stall_L1I,
    output [31:0]read_data_L1I_C,
    // CORE와 L1D top 사이의 신호
    input [31:0] address_L1D,
    input flush_L1D, 
    input read_C_L1D,
    input write_C_L1D,
    input [31:0] write_data,
    output stall_L1D,
    output [31:0]read_data_L1D_C,
    // L2와 MEM 사이의 신호
    input [511:0] read_data_MEM_L2,
    input ready_MEM_L2,
    output read_L2_MEM,
    output write_L2_MEM,
    output [7:0] index_L2_MEM,
    output [17:0] tag_L2_MEM,
    output [17:0] write_tag_L2_MEM,
    output [511:0] write_data_L2_MEM,
    output L2_miss_o, L1I_miss_o, L1D_miss_o
);

wire [23:0] tag_C_L1;
wire [1:0] index_C_L1;
wire [5:0] offset;

wire [511:0] read_data_L2_L1;
wire [511:0] write_data_L1_L2;
wire write_L1_L2;
wire read_L1D_L2, read_L1I_L2;
wire read_L1_L2;
wire ready_L2_L1I, ready_L2_L1D;
wire ready_L2_L1;
wire [20:0] tag_L1D_L2, write_tag_L1D_L2, tag_L1I_L2;
wire [20:0] tag_L1_L2;
wire [4:0] index_L1D_L2, index_L1I_L2, write_index_L1D_L2;
wire [4:0] index_L1_L2;



L1_D_top u_L1_D_top (
    .clk(clk),
    .nrst(nrst),
    .tag_C_L1(address_L1D[31:8]),
    .index_C_L1(address_L1D[7:6]),
    .offset(address_L1D[5:0]),
    .write_C_L1(write_C_L1D),
    .flush(flush_L1D),
    .stall(stall_L1D),
    .write_data(write_data),
    .read_data_L1_C(read_data_L1D_C),
    .read_data_L2_L1(read_data_L2_L1),
    .write_data_L1_L2(write_data_L1_L2),
    .write_L1_L2(write_L1D_L2),
    .read_L1_L2(read_L1D_L2),
    .ready_L2_L1(ready_L2_L1D),
    .read_C_L1(read_C_L1D),
    .tag_L1_L2(tag_L1D_L2),
    .write_tag_L1_L2(write_tag_L1D_L2),
    .index_L1_L2(index_L1D_L2),
    .write_index_L1_L2(write_index_L1D_L2),
    .L1D_miss_o(L1D_miss_o)
);

L1_I_top u_L1_I_top(
    .clk(clk),
    .nrst(nrst),
    .tag_C_L1(address_L1I[31:8]),
    .index_C_L1(address_L1I[7:6]),
    .offset(address_L1I[5:0]),
    .flush(flush_L1I),
    .stall(stall_L1I),
    .read_data_L1_C(read_data_L1I_C),
    .read_data_L2_L1(read_data_L2_L1),
    .read_L1_L2(read_L1I_L2),
    .ready_L2_L1(ready_L2_L1I),
    .read_C_L1(read_C_L1I),
    .tag_L1_L2(tag_L1I_L2),
    .index_L1_L2(index_L1I_L2),
    .L1I_miss_o(L1I_miss_o)
);

L1_L2_connect u_L1_L2_connect(
    .write_index_L1D_L2(write_index_L1D_L2),
    .index_L1D_L2(index_L1D_L2),
    .index_L1I_L2(index_L1I_L2),
    .tag_L1D_L2(tag_L1D_L2),
    .write_tag_L1D_L2(write_tag_L1D_L2),
    .tag_L1I_L2(tag_L1I_L2),
    .read_L1I_L2(read_L1I_L2),
    .read_L1D_L2(read_L1D_L2),
    .read_L1_L2(read_L1_L2),
    .write_L1D_L2(write_L1D_L2),
    .ready_L2_L1(ready_L2_L1),
    .ready_L2_L1I(ready_L2_L1I),
    .ready_L2_L1D(ready_L2_L1D),
    .index_L1_L2(index_L1_L2),
    .tag_L1_L2(tag_L1_L2)
);

L2_top u_L2_top(
    .clk(clk),
    .nrst(nrst),
    .tag_L1_L2(tag_L1_L2),
    .index_L1_L2(index_L1_L2),
    .write_data(write_data_L1_L2),
    .read_data_MEM_L2(read_data_MEM_L2),
    .read_L1_L2(read_L1_L2),
    .flush(flush_L1I),
    .ready_MEM_L2(ready_MEM_L2),
    .write_L1_L2(write_L1D_L2),
    .ready_L2_L1(ready_L2_L1),
    .read_L2_MEM(read_L2_MEM),
    .write_L2_MEM(write_L2_MEM),
    .index_L2_MEM(index_L2_MEM),
    .tag_L2_MEM(tag_L2_MEM),
    .write_tag_L2_MEM(write_tag_L2_MEM),
    .read_data_L2_L1(read_data_L2_L1),
    .write_data_L2_MEM(write_data_L2_MEM),
    .L2_miss_o(L2_miss_o)
);



endmodule