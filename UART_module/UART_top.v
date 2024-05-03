module uart_top(
    input wire rxd,
    input wire clk,
    output wire txd
    );
    
    wire clk_wire;
    wire [7:0] data_wire;
    wire done;
    
    clock_module clock(.clk_in(clk), .clk_out(clk_wire));
    uart_rx rx(.clk(clk_wire), .rx_data(rxd), .dout(data_wire),.done(done));
    uart_tx tx(.clk(clk_wire), .din(data_wire),.start(done),.tx_data(txd));
    
endmodule