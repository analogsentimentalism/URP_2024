

module L1_I_data_array (
    input clk,
    input nrst,
    input [1:0] index_C_L1,
    input [5:0] offset,
    input [511:0] read_data_L2_L1,
    input refill, way,
    output [31:0] read_data_L1_C
);
reg [511:0] DATA_ARR [7:0];

assign read_data_L1_C = DATA_ARR[{index_C_L1,way}][{offset[5:2],5'b00000} +: 32];
genvar i;

generate
    for (i=0; i<8; i= i+1) begin
        always@(posedge clk or negedge nrst)
        begin
	    if(!nrst)
            DATA_ARR[i] <= 512'h0;
        
        else if ((refill == 1'b1) && ({index_C_L1,way} == i))
            DATA_ARR[i] <= read_data_L2_L1;
        else
            DATA_ARR[i] <= DATA_ARR[i];
        end
    end
endgenerate 

endmodule   