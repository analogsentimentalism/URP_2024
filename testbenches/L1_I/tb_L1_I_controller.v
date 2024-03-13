`timescale 1ns/1ps

module tb_L1_l_controller;

    // clock
    reg clk;
    
    //input
    reg [53:0] tag;
    reg [5:0] index;
    reg read_C_l1;
    reg write_C_l1;
    reg ready_l2_l1;
    reg flush;
    //output
    wire refill;
    wire update;
    wire stall;
    wire read_l1_l2;
    wire read_l1_l2;


    //
    L1_l_controller_module L1_l_controller(.tag());

    initial
    begin
        clk = 1'b0;
        read_C_l1 = 1'b0;
        write_C_l1 = 1'b0;
        ready_l2_l1 = 1'b0;
    end