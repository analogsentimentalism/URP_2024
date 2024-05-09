

module L1_D_data_array (
    input clk,
    input nrst,
    input [1:0] index_C_L1,
    input [5:0] offset,
    input [31:0] write_data_C_L1,
    input [511:0] read_data_L2_L1,
    input update, refill, way,
    output [31:0] read_data_L1_C,
    output [511:0] write_data_L1_L2
);
reg [511:0] DATA_ARR [7:0];

assign read_data_L1_C = DATA_ARR[{index_C_L1,way}][{offset,3'b00} +: 32];
assign write_data_L1_L2 = DATA_ARR[{index_C_L1,way}];
genvar i;

generate
    for (i=0; i<8; i= i+1) begin
        always@(posedge clk or negedge nrst)
        begin
	if(!nrst)
            DATA_ARR[i] <= 512'h0;
        
        else if ((refill == 1'b1) && ({index_C_L1,way} == i))
            DATA_ARR[i] <= read_data_L2_L1;
        else if ((update == 1'b1 && ({index_C_L1,way} == i)))
            DATA_ARR[i][{offset,3'b000} +:32] <= write_data_C_L1; 
        else
            DATA_ARR[i] <= DATA_ARR[i];
        end
    end
endgenerate 

endmodule   