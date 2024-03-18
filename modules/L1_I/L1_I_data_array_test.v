
module L1_I_data_array (
    input clk,
    input nrst,
    input [5:0] index,
    input [5:0] offset,
    input [31:0] write_data,
    output [31:0] read_data_L1_C,
    input [511:0] read_data_L2_L1,
    input update, refill
);
reg [511:0] DATA_ARR [63:0];
reg [31:0] read_data_L1_C_reg;
assign read_data_L1_C = read_data_L1_C_reg;
genvar i;

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        read_data_L1_C_reg <= 32'h0;
    for(i=0 ; i<64 ; i = i+1) begin
    else if (index == i)
        read_data_L1_C_reg <= DATA_ARR[i][{offset[5:1],5'b00000}+:32];
    end
    else
        read_data_L1_C_reg <= read_data_L1_C_reg;
end
generate
    for (i=0; i<64; i= i+1) begin
        always@(posedge clk or negedge nrst)
        begin
            DATA_ARR[i] <= 512'h0;
        end
        else if ((reflill == 1'b1) && (index == i))
            DATA_ARR[i] <= read_data_L2_L1;
        end
        else
            DATA_ARR[i] <= DATA_ARR[i]
        end
    end
endgenerate 

endmodule   