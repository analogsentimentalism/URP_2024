`timescale 1ns/1ns
module tb_uart_tx();

reg         clk;
reg [7:0]   din;                      
reg         tx_start;                         
wire        tx_data;



uart_tx u_tx(
    .clk(clk),
    .din(din),
    .tx_start(tx_start),
    .tx_data(tx_data)
);


initial clk=1;
always #5 clk = ~clk;


initial begin
    tx_start =0;
    din =0;
    u_tx.clk_count =0;
    u_tx.state = 0;
    
    #100 
    tx_start =1;
    din = 'b01101110;
    #8680 tx_start =0;

    #100000
    tx_start =1;
    din = 'b00000110;
    #8680 tx_start =0;

    #100000
    tx_start =1;
    din = 'b11000011;
    #8680 tx_start =0;

    #100000 
    tx_start =1;
    din = 'b11110000;
    #8680 tx_start =0;

    #20000 $stop;
end
endmodule