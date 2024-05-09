module L2_data_array (
    input clk,
    input nrst,
    input [7:0] index_L1_L2,
    input [511:0] write_data_L1_L2,
    input [511:0] read_data_MEM_L2,
    input update, refill,
    input [1:0] way,
    //input [511:0] write_line_L2_L1,
    output [511:0] read_data_L2_L1,
    output [511:0] write_data_L2_MEM
);

parameter cache_line_num = 11'd1024;


(* ram_style = "block" *) reg [511:0] DATA_ARR [cache_line_num-1:0];
assign write_data_L2_MEM = DATA_ARR[{index_L1_L2,way}];     //?ˆ˜? •
assign read_data_L2_L1 = DATA_ARR[{index_L1_L2,way}];
genvar i;

generate
    for (i=0; i<cache_line_num; i= i+1) begin
        always@(posedge clk or negedge nrst)
        begin
	if(!nrst)
            DATA_ARR[i] <= 512'h0;

        else if ((refill == 1'b1) && ({index_L1_L2,way} == i))
            DATA_ARR[i] <= read_data_MEM_L2;
        else if ((update == 1'b1 && ({index_L1_L2,way} == i)))     //write hit
            DATA_ARR[i] <= write_data_L1_L2; 
        else
            DATA_ARR[i] <= DATA_ARR[i];
        end
    end
endgenerate

endmodule