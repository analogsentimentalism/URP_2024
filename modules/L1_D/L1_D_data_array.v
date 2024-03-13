module L1_D_data_array(clk, nrst, read_data, write_data, index, offset, update_L1, refill_L1, data_block_L2)

input [511:0] write_data;
input [5:0] index; 
input [5:0] offset;
input clk, nrst;
input update_L1, refill_L1;
input [127:0] data_block_L2;
output reg [511:0] read_data;
output reg stall_L1;

wire [63:0] L1_data [511:0];  // L1 cache (each row: 16word, 64 rows)

always @(posedge clk, posedge nrst) begin
    if(!nrst) begin
        for (int i=0; i<64; i=i+1) 
            for (int j=0; j<512; j=j+1)
                L1_data [i][j]<= 1'b0; //배열 안돼??
    end
    else 

end






