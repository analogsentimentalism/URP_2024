`timescale 1ns / 10ps

module clock_module(
    input wire clk_in,
    output wire clk_out
    );
    
    wire locked;
    wire clk_100mhz;
   
    clk_wiz_0 u0(.clk_out1(clk_100mhz), .locked(locked), .clk_in1(clk_in));     // clock wizard instance
    baudrate_gen u1(.clk(clk_100mhz), .clk1(clk_out));                          // baud rate generator instance
    
endmodule

module baudrate_gen(
    input wire clk,                                                             // 100mhz(10ns) input clock 
    output reg clk1                                                             // 115200mhz(8680ns) output clock
);
    reg [27:0] counter = 28'b0;
    
    always @(posedge clk)begin
        if(counter == 867)   
            counter <= 28'b0;
        else 
            counter <= counter + 1'b1;
    end

    always @(posedge clk) begin
        if(counter == 0)
            clk1 <= 1'b0;
        else if(counter == 434)
            clk1 <= ~clk1;
        else if (counter == 867)
            clk1 <= ~clk1;
        else   
            clk1 <= clk1;
    end

endmodule