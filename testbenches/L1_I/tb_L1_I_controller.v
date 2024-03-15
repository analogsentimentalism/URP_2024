`timescale 1ns/1ps

module tb_L1_I_controller;

    // clock
    reg clk;
    reg nrst;
    //input
    reg [51:0] tag;
    reg [5:0] index;
    reg read_C_L1;
    reg write_C_L1;
    reg ready_L2_L1;
    reg flush;
    //output
    wire stall;
    wire refill;
    wire update;
    wire read_L1_L2;
    wire write_L1_L2;


    //module
    L1_I_controller L1_I_controller(
        .clk(clk),
        .nrst(nrst),
        .tag(tag),
        .index(index),
        .read_C_L1(read_C_L1),
        //.write_C_L1(write_C_L1),
        .ready_L2_L1(ready_L2_L1),
        .flush(flush),
        .stall(stall),
        .refill(refill),
        .update(update),
        .read_L1_L2(read_L1_L2),
        .write_L1_L2(write_L1_L2)
    );

    //clock    
    always
    begin
        #5 clk = ~clk;
    end

    //initial value
    initial
    begin
        clk = 1'b0;
        nrst = 1'b1;
        read_C_L1 = 1'b0;
        //write_C_L1 = 1'b0;
        ready_L2_L1 = 1'b0;
        flush = 1'b0;
        tag = 52'h0;
        index = 5'b0;
    end

    initial
    begin
        #10
        read_C_L1 = 1'b1;
        tag = 52'hFF00FF00FFFFF;
        index = 5'b01101;

        #10
        read_C_L1 = 1'b0;
        ready_L2_L1 = 1'b1;

        #10
        read_C_L1 = 1'b1;
        tag = 52'h0000FF00000FF;
        index = 5'b00000;

        #10
        ready_L2_L1 = 1'b0;

        #10
        read_C_L1 = 1'b0;

        #10
        ready_L2_L1 = 1'b1;

        #10
        ready_L2_L1 = 1'b0;
        read_C_L1 = 1'b1;
        tag = 52'hFF00FF00FFFFF;
        index = 5'b01101;

        #10
        read_C_L1 = 1'b0;
        ready_L2_L1 = 1'b1;

        #10
        ready_L2_L1 = 1'b0;
        read_C_L1 = 1'b1;
        tag = 52'h0000FF00FFFFF;
        index = 5'b01101;

        #10
        read_C_L1 = 1'b0;
        ready_L2_L1 = 1'b1;

        #10
        read_C_L1 = 1'b1;
        tag = 52'h0000FF00000FF;
        index = 5'b00000;

        #10
        ready_L2_L1 = 1'b0;

        #10
        read_C_L1 = 1'b0;
        flush = 1'b1;

        #10
        flush = 1'b0;

        #10
        read_C_L1 = 1'b1;
        tag = 52'h0000FF00000FF;
        index = 5'b00000;

        #10
        tag = 52'h0000FF00FFFFF;
        index = 5'b01101;

        #10
        read_C_L1 = 1'b0;
        nrst = 1'b0;

        #10
        nrst = 1'b1;
        read_C_L1 = 1'b1;
        tag = 52'h0000FF00FFFFF;
        index = 5'b01101;

    end
endmodule