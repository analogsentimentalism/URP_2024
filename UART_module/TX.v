module uart_tx(
    input clk,
    input [7:0] din,                        // ASCI code로 입력
    input start,
    output reg tx_data
    );
    
    localparam IDLE = 0, START = 1, ST2 = 2, ST3 = 3, ST4 = 4, ST5 = 5, ST6 = 6, ST7 = 7, ST8 = 8, ST9 = 9, STOP = 10;
    
    (*keep="true"*) reg [3:0] state;

    ///////////////state transition///////////////
    always @(posedge clk) begin
        case (state)
            IDLE : if(start==1) state <= START;
                   else state <= IDLE;
            START  : state <= ST2;
            ST2  : state <= ST3;
            ST3  : state <= ST4;
            ST4  : state <= ST5;
            ST5  : state <= ST6;
            ST6  : state <= ST7;
            ST7  : state <= ST8;
            ST8  : state <= ST9;
            ST9  : state <= STOP;
            STOP : state <= IDLE;
            default : state <= IDLE;
        endcase
    end

    always @(posedge clk) begin
        case (state)
            IDLE  : tx_data <= 1; 
            START : tx_data <= 0;       // start bit(1'b0)
            ST2   : tx_data <= din[0];
            ST3   : tx_data <= din[1];
            ST4   : tx_data <= din[2];
            ST5   : tx_data <= din[3];
            ST6   : tx_data <= din[4];
            ST7   : tx_data <= din[5];
            ST8   : tx_data <= din[6];
            ST9   : tx_data <= din[7];
            STOP  : tx_data <= 1;      // stop bit(1'b1)
            default: tx_data <= 1; 
        endcase
    end

endmodule