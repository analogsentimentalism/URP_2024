module CORE_L1_connect(
    input clk,
    input nrst,

    // CORE와 CORE_L1_connect 사이의 신호
    input [31:0] address,
    input read_C_L1,
    input stall_L1I, stall_L1D,
    input [31:0] read_data_L1D_C, read_data_L1I_C,

    output stall,
    output [31:0]read_data_L1_C,

    output [20:0] tag_C_L1,
    output [4:0] index_C_L1,
    output [5:0] offset,
    // L1I/ L1D로 분배
    output read_C_L1I, read_C_L1D,
);

    assign tag_C_L1 = address[31:11];
    assign index_C_L1 = address[10:6];
    assign offset = address[5:0];

    assign read_C_L1I = (address <= 32'h10000000) ? read_C_L1 : 1'b0;
    assign read_C_L1D = (address > 32'h10000000) ? read_C_L1 : 1'b0;
    assign stall = stall_L1I || stall_L1D;

    assign read_data_L1_C = (read_C_L1I) ? read_data_L1I_C :
                                (read_C_L1D) ? read_data_L1D_C : 32'h0;

endmodule
    