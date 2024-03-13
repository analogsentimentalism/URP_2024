`timescale 1ns/1ps

module tb_L1_l_data_array;

    // clock
    reg clk;
    reg nrst;
    //input
    reg [63:0] address;
    reg refill;
    reg update;
    reg [] data_block;
    //output
    wire [127:0] read_data;

    //
    L1_l_data_array L1_l_data_array_module(
        .clk        (clk),
        .nrst       (nrst),

        .index      (address[11:6]),
        .offset     (address[5:0]),
        .refill     (refill),
        .update     (update),

        .read_data  (read_data[127:0]);
    );

    always
    begin
        #5 clk = ~clk;
    end

    //initial value
    initial
    begin
        clk = 1'b0;
        address = 64'b0;
        refill = 1'b0;
        update = 1'b0;
    end

    initial
    begin

    end
endmodule