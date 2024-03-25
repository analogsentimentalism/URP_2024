`timescale 1ns/1ns

module tb_L1_l_data_array;

    // clock
    reg clk;
    reg nrst;
    //input
    reg [63:0] address;
    reg refill;
    reg update;
    reg [31:0]write_data;
    reg [511:0] read_data_L2_L1;
    //output
    wire [31:0] read_data_L1_C;

    //
    L1_l_data_array L1_I_data_array (
    .clk(clk),
    .nrst(nrst),
    .index(address[11:6]),
    .offset(address[5:0]),
    .write_data(write_data),
    .read_data_L2_L1(read_data_L2_L1),
    .update(update),
    .refill(refill),
    .read_data_L1_C(read_data_L1_C)
);

    always@
    begin
        #1 clk = ~clk;
    end

    //initial value
    initial
    begin
        clk = 1'b0;
        nrst = 1'b1;
        address = 64'b0;
        refill = 1'b0;
        update = 1'b0;
        write_data = 32'b0;
        read_data_L2_L1 = 512'h0;
    end

    initial
    begin

    end
endmodule