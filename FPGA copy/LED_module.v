module LED_module(
    input clk,
    input rstn,
    output reg [15:0] LED,
    input ready_L1I_C,
    input [31:0] read_data_L1I_C,
    input read_C_L1I
);

reg enable;

always @(posedge clk or negedge rstn)
begin
    if(~rstn)
        enable <= 1'b1;
    else if (ready_L1I_C & read_C_L1I)
        enable <= 1'b0;
    else    
        enable <= enable;
end
always @(posedge clk or negedge rstn)
begin
    if(~rstn)
        LED <= 16'h0;
    else if(ready_L1I_C & read_C_L1I & enable)
        LED <= read_data_L1I_C[15:0];
    else
        LED <= LED;
end
endmodule