
module L1_I_controller (
    input clk,
    input nrst,
    input [51:0] tag, 
    input [5:0] index, 
    input read_C_L1, flush,
    input ready_L2_L1,
    input write_C_L1,
    output stall, refill, update, read_L1_L2, write_L1_L2
);

// define TAG_ARR
reg [53:0] TAG_ARR [63:0];
reg miss;
reg hit;
reg read_C_L1_reg;
reg stall_reg;
reg refill_reg;
reg read_L1_L2_reg;

assign stall = stall_reg;
assign refill = refill_reg;
assign read_L1_L2 = read_L1_L2_reg;

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        read_C_L1_reg <= 1'b0;
    else   
        read_C_L1_reg <= read_C_L1;
end
// stall
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        stall_reg <= 1'b0;
    else if(miss == 1'b1)
        stall_reg <= 1'b1;
    else if(stall_reg == 1'b1)
        stall_reg <= 1'b0;
    else if(read_C_L1 == 1'b1)
        stall_reg <= 1'b1;
    else stall_reg <= stall_reg;
end
// miss
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        miss <= 1'b0;
    else if(ready_L2_L1 == 1'b1)
        miss <= 1'b0;
    else if (read_C_L1 == 1'b1)
    begin
        miss <= ((TAG_ARR[index][53] == 1'b1) && (tag == TAG_ARR[index][51:0])) ? 1'b0 : 1'b1; 
    end  
    else
        miss <= miss;          
end
always@(posedge clk or negedge nrst)    //tag
begin
    if (!nrst)
    begin           // reset
        TAG_ARR[0]   <= 54'h0;
        TAG_ARR[1]   <= 54'h0;
        TAG_ARR[2]  <= 54'h0;
        TAG_ARR[3]  <= 54'h0;
        TAG_ARR[4]  <= 54'h0;
        TAG_ARR[5]  <= 54'h0;
        TAG_ARR[6]  <= 54'h0;
        TAG_ARR[7]  <= 54'h0;
        TAG_ARR[8]  <= 54'h0;
        TAG_ARR[9]  <= 54'h0;
        TAG_ARR[10]  <= 54'h0;
        TAG_ARR[11]  <= 54'h0;
        TAG_ARR[12]  <= 54'h0;
        TAG_ARR[13]  <= 54'h0;
        TAG_ARR[14]  <= 54'h0;
        TAG_ARR[15]  <= 54'h0;
        TAG_ARR[16]  <= 54'h0;
        TAG_ARR[17]  <= 54'h0;
        TAG_ARR[18]  <= 54'h0;
        TAG_ARR[19]  <= 54'h0;
        TAG_ARR[20]  <= 54'h0;
        TAG_ARR[21]  <= 54'h0;
        TAG_ARR[22]  <= 54'h0;
        TAG_ARR[23]  <= 54'h0;
        TAG_ARR[24]  <= 54'h0;
        TAG_ARR[25]  <= 54'h0;
        TAG_ARR[26]  <= 54'h0;
        TAG_ARR[27]  <= 54'h0;
        TAG_ARR[28]  <= 54'h0;
        TAG_ARR[29]  <= 54'h0;
        TAG_ARR[30]  <= 54'h0;
        TAG_ARR[31]  <= 54'h0;
        TAG_ARR[32]  <= 54'h0;
        TAG_ARR[33]  <= 54'h0;
        TAG_ARR[34]  <= 54'h0;
        TAG_ARR[35]  <= 54'h0;
        TAG_ARR[36]  <= 54'h0;
        TAG_ARR[37]  <= 54'h0;
        TAG_ARR[38]  <= 54'h0;
        TAG_ARR[39]  <= 54'h0;
        TAG_ARR[40]  <= 54'h0;
        TAG_ARR[41]  <= 54'h0;
        TAG_ARR[42]  <= 54'h0;
        TAG_ARR[43]  <= 54'h0;
        TAG_ARR[44]  <= 54'h0;
        TAG_ARR[45]  <= 54'h0;
        TAG_ARR[46]  <= 54'h0;
        TAG_ARR[47]  <= 54'h0;
        TAG_ARR[48]  <= 54'h0;
        TAG_ARR[49]  <= 54'h0;
        TAG_ARR[50]  <= 54'h0;
        TAG_ARR[51]  <= 54'h0;
        TAG_ARR[52]  <= 54'h0;
        TAG_ARR[53]  <= 54'h0;
        TAG_ARR[54]  <= 54'h0;
        TAG_ARR[55]  <= 54'h0;
        TAG_ARR[56]  <= 54'h0;
        TAG_ARR[57]  <= 54'h0;
        TAG_ARR[58]  <= 54'h0;
        TAG_ARR[59]  <= 54'h0;
        TAG_ARR[60]  <= 54'h0;
        TAG_ARR[61]  <= 54'h0;
        TAG_ARR[62]  <= 54'h0;
        TAG_ARR[63]  <= 54'h0;
    end
    else if (flush == 1'b1)
    begin           // flush
        TAG_ARR[0][53]    <=   1'b0; 
        TAG_ARR[1][53]    <=   1'b0; 
        TAG_ARR[2][53]    <=   1'b0; 
        TAG_ARR[3][53]    <=   1'b0; 
        TAG_ARR[4][53]    <=   1'b0; 
        TAG_ARR[5][53]    <=   1'b0; 
        TAG_ARR[6][53]    <=   1'b0; 
        TAG_ARR[7][53]    <=   1'b0; 
        TAG_ARR[8][53]    <=   1'b0; 
        TAG_ARR[9][53]     <=   1'b0; 
        TAG_ARR[10][53]    <=   1'b0; 
        TAG_ARR[11][53]    <=   1'b0; 
        TAG_ARR[12][53]    <=   1'b0; 
        TAG_ARR[13][53]    <=   1'b0; 
        TAG_ARR[14][53]    <=   1'b0; 
        TAG_ARR[15][53]    <=   1'b0; 
        TAG_ARR[16][53]    <=   1'b0; 
        TAG_ARR[17][53]    <=   1'b0; 
        TAG_ARR[18][53]    <=   1'b0; 
        TAG_ARR[19][53]    <=   1'b0;
        TAG_ARR[20][53]    <=   1'b0;        
        TAG_ARR[21][53]    <=   1'b0;
        TAG_ARR[22][53]    <=   1'b0;
        TAG_ARR[23][53]    <=   1'b0;
        TAG_ARR[24][53]    <=   1'b0;
        TAG_ARR[25][53]    <=   1'b0;
        TAG_ARR[26][53]    <=   1'b0;
        TAG_ARR[27][53]    <=   1'b0;
        TAG_ARR[28][53]    <=   1'b0;
        TAG_ARR[29][53]    <=   1'b0;
        TAG_ARR[30][53]    <=   1'b0;
        TAG_ARR[31][53]    <=   1'b0;
        TAG_ARR[32][53]    <=   1'b0;
        TAG_ARR[33][53]    <=   1'b0;
        TAG_ARR[34][53]    <=   1'b0;
        TAG_ARR[35][53]    <=   1'b0;
        TAG_ARR[36][53]    <=   1'b0;
        TAG_ARR[37][53]    <=   1'b0;
        TAG_ARR[38][53]    <=   1'b0;
        TAG_ARR[39][53]    <=   1'b0;
        TAG_ARR[40][53]    <=   1'b0;
        TAG_ARR[41][53]    <=   1'b0;
        TAG_ARR[42][53]    <=   1'b0;
        TAG_ARR[43][53]    <=   1'b0;
        TAG_ARR[44][53]    <=   1'b0;
        TAG_ARR[45][53]    <=   1'b0;
        TAG_ARR[46][53]    <=   1'b0;
        TAG_ARR[47][53]    <=   1'b0;
        TAG_ARR[48][53]    <=   1'b0;
        TAG_ARR[49][53]    <=   1'b0;
        TAG_ARR[50][53]    <=   1'b0;
        TAG_ARR[51][53]    <=   1'b0;
        TAG_ARR[52][53]    <=   1'b0;
        TAG_ARR[53][53]    <=   1'b0;
        TAG_ARR[54][53]    <=   1'b0;
        TAG_ARR[55][53]    <=   1'b0;
        TAG_ARR[56][53]    <=   1'b0;
        TAG_ARR[57][53]    <=   1'b0;
        TAG_ARR[58][53]    <=   1'b0;
        TAG_ARR[59][53]    <=   1'b0;
        TAG_ARR[60][53]    <=   1'b0;
        TAG_ARR[61][53]    <=   1'b0;
        TAG_ARR[62][53]    <=   1'b0;
        TAG_ARR[63][53]    <=   1'b0;

    end
    else if(read_C_L1_reg == 1'b1)
    begin
        TAG_ARR[index][51:0] <= (miss == 1'b1) ? TAG_ARR[index][51:0] : tag;
        TAG_ARR[index][53] <= (ready_L2_L1 == 1'b0) ? TAG_ARR[index][53] : 1'b1;       
    end
    else
    begin
        TAG_ARR[0] <= TAG_ARR[0];   
        TAG_ARR[1] <= TAG_ARR[1];   
        TAG_ARR[2] <= TAG_ARR[2];   
        TAG_ARR[3] <= TAG_ARR[3];   
        TAG_ARR[4] <= TAG_ARR[4];   
        TAG_ARR[5] <= TAG_ARR[5];   
        TAG_ARR[6] <= TAG_ARR[6];   
        TAG_ARR[7] <= TAG_ARR[7];   
        TAG_ARR[8] <= TAG_ARR[8];   
        TAG_ARR[9] <= TAG_ARR[9];   
        TAG_ARR[10] <= TAG_ARR[10];   
        TAG_ARR[11] <= TAG_ARR[11];   
        TAG_ARR[12] <= TAG_ARR[12];   
        TAG_ARR[13] <= TAG_ARR[13];   
        TAG_ARR[14] <= TAG_ARR[14];   
        TAG_ARR[15] <= TAG_ARR[15];   
        TAG_ARR[16] <= TAG_ARR[16];   
        TAG_ARR[17] <= TAG_ARR[17];   
        TAG_ARR[18] <= TAG_ARR[18];   
        TAG_ARR[19] <= TAG_ARR[19];   
        TAG_ARR[20] <= TAG_ARR[20];   
        TAG_ARR[21] <= TAG_ARR[21];   
        TAG_ARR[22] <= TAG_ARR[22];   
        TAG_ARR[23] <= TAG_ARR[23];   
        TAG_ARR[24] <= TAG_ARR[24];   
        TAG_ARR[25] <= TAG_ARR[25];   
        TAG_ARR[26] <= TAG_ARR[26];   
        TAG_ARR[27] <= TAG_ARR[27];   
        TAG_ARR[28] <= TAG_ARR[28];   
        TAG_ARR[29] <= TAG_ARR[29];   
        TAG_ARR[30] <= TAG_ARR[30];   
        TAG_ARR[31] <= TAG_ARR[31];   
        TAG_ARR[32] <= TAG_ARR[32];   
        TAG_ARR[33] <= TAG_ARR[33];   
        TAG_ARR[34] <= TAG_ARR[34];   
        TAG_ARR[35] <= TAG_ARR[35];   
        TAG_ARR[36] <= TAG_ARR[36];   
        TAG_ARR[37] <= TAG_ARR[37];   
        TAG_ARR[38] <= TAG_ARR[38];   
        TAG_ARR[39] <= TAG_ARR[39];   
        TAG_ARR[40] <= TAG_ARR[40];   
        TAG_ARR[41] <= TAG_ARR[41];   
        TAG_ARR[42] <= TAG_ARR[42];   
        TAG_ARR[43] <= TAG_ARR[43];   
        TAG_ARR[44] <= TAG_ARR[44];   
        TAG_ARR[45] <= TAG_ARR[45];   
        TAG_ARR[46] <= TAG_ARR[46];   
        TAG_ARR[47] <= TAG_ARR[47];   
        TAG_ARR[48] <= TAG_ARR[48];   
        TAG_ARR[49] <= TAG_ARR[49];   
        TAG_ARR[50] <= TAG_ARR[50];   
        TAG_ARR[51] <= TAG_ARR[51];   
        TAG_ARR[52] <= TAG_ARR[52];   
        TAG_ARR[53] <= TAG_ARR[53];   
        TAG_ARR[54] <= TAG_ARR[54];   
        TAG_ARR[55] <= TAG_ARR[55];   
        TAG_ARR[56] <= TAG_ARR[56];   
        TAG_ARR[57] <= TAG_ARR[57];   
        TAG_ARR[58] <= TAG_ARR[58];   
        TAG_ARR[59] <= TAG_ARR[59];   
        TAG_ARR[60] <= TAG_ARR[60];   
        TAG_ARR[61] <= TAG_ARR[61];   
        TAG_ARR[62] <= TAG_ARR[62];   
        TAG_ARR[63] <= TAG_ARR[63];   
           
    end
end  

always@(posedge clk or negedge nrst)
begin
    if (!nrst)
        refill_reg <= 1'b0;
    else if(ready_L2_L1)
        refill_reg <= 1'b1;
    else if(refill_reg == 1'b1)
        refill_reg <= 1'b0;
    else
        refill_reg <= refill_reg;
end

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        read_L1_L2_reg <= 1'b0;
    else if (miss == 1)
        read_L1_L2_reg <= 1'b1;
    else if (ready_L2_L1 == 1'b1)
        read_L1_L2_reg <= 1'b0; 
    else
        read_L1_L2_reg <= read_L1_L2_reg;
end

endmodule