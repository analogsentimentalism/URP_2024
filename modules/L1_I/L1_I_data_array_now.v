


module L1_I_data_array (
    input clk,
    input nrst,
    input [5:0] index,
    input [5:0] offset,
    input [31:0] write_data,
    input [511:0] read_data_L2_L1,
    input update, refill,
    output [31:0] read_data_L1_C
);
reg [511:0] DATA_ARR [63:0];

assign read_data_L1_C = DATA_ARR[index][{offset,3'b00} +: 32];
genvar i;

generate
    for (i=0; i<64; i= i+1) begin
        always@(posedge clk or negedge nrst)
        begin
	if(!nrst)
            DATA_ARR[i] <= 512'h0;
        
        else if ((refill == 1'b1) && (index == i))
            DATA_ARR[i] <= read_data_L2_L1;
        else if ((update == 1'b1 && (index == i)))
            DATA_ARR[i] <= write_data; 
        else
            DATA_ARR[i] <= DATA_ARR[i];
        end
    end
endgenerate 

endmodule   