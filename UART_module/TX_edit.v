module uart_tx(
    input clk,
    input [7:0] din,                        // ASCII code로 입력: 그럼 din[4]==1, din[5]==1, din[6]==0, din[7]==0 고정?
    input start,                            // counter.v의 done과 연결
    output reg tx_data
    );
    //din이 들어오는 속도가 앞단의 tx_data가 모두 출력되는 속도보다 빠른 문제 해결 어떻게
    localparam IDLE = 0, START = 1, ST2 = 2, ST3 = 3, ST4 = 4, ST5 = 5, ST6 = 6, ST7 = 7, ST8 = 8, ST9 = 9, STOP = 10;
    
    reg [3:0] state;
    reg [31:0] clk_count;

    
    ///////////////state register///////////////

    always @(posedge clk) begin
        if(clk_count == 868) begin                   //100MHz를 115,200Hz에 맞추기
            clk_count <= 0;
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
        else clk_count <= clk_count +1;
    end



    //////////output logic///////////////

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