module top (
    input clk,
    input nrst,

    // CORE와 CORE_L1_connect 사이의 신호
    input [31:0] address,
    input flush,
    input read_C_L1,
    input write_C_L1,
    input [31:0] write_data,
    output stall,
    output [31:0]read_data_L1_C,

    
);