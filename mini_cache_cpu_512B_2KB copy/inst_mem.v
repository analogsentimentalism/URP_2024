module inst_mem(
    output [31:0] inst,
    input  [31:0] inst_data,
    input  [6:0] PC, inst_addr,
    input  clk, rst, inst_wen
);

reg [31:0] inst_reg [0:127];

assign inst = inst_reg[PC];

always @ (posedge clk) begin
    if (rst) begin
        inst_reg[0]   <= 32'b0;
        inst_reg[1]   <= 32'b0;
        inst_reg[2]   <= 32'b0;
        inst_reg[3]   <= 32'b0;
        inst_reg[4]   <= 32'b0;
        inst_reg[5]   <= 32'b0;
        inst_reg[6]   <= 32'b0;
        inst_reg[7]   <= 32'b0;
        inst_reg[8]   <= 32'b0;
        inst_reg[9]   <= 32'b0;
        inst_reg[10]  <= 32'b0;
        inst_reg[11]  <= 32'b0;
        inst_reg[12]  <= 32'b0;
        inst_reg[13]  <= 32'b0;
        inst_reg[14]  <= 32'b0;
        inst_reg[15]  <= 32'b0;
        inst_reg[16]  <= 32'b0;
        inst_reg[17]  <= 32'b0;
        inst_reg[18]  <= 32'b0;
        inst_reg[19]  <= 32'b0;
        inst_reg[20]  <= 32'b0;
        inst_reg[21]  <= 32'b0;
        inst_reg[22]  <= 32'b0;
        inst_reg[23]  <= 32'b0;
        inst_reg[24]  <= 32'b0;
        inst_reg[25]  <= 32'b0;
        inst_reg[26]  <= 32'b0;
        inst_reg[27]  <= 32'b0;
        inst_reg[28]  <= 32'b0;
        inst_reg[29]  <= 32'b0;
        inst_reg[30]  <= 32'b0;
        inst_reg[31]  <= 32'b0;
        inst_reg[32]  <= 32'b0;
        inst_reg[33]  <= 32'b0;
        inst_reg[34]  <= 32'b0;
        inst_reg[35]  <= 32'b0;
        inst_reg[36]  <= 32'b0;
        inst_reg[37]  <= 32'b0;
        inst_reg[38]  <= 32'b0;
        inst_reg[39]  <= 32'b0;
        inst_reg[40]  <= 32'b0;
        inst_reg[41]  <= 32'b0;
        inst_reg[42]  <= 32'b0;
        inst_reg[43]  <= 32'b0;
        inst_reg[44]  <= 32'b0;
        inst_reg[45]  <= 32'b0;
        inst_reg[46]  <= 32'b0;
        inst_reg[47]  <= 32'b0;
        inst_reg[48]  <= 32'b0;
        inst_reg[49]  <= 32'b0;
        inst_reg[50]  <= 32'b0;
        inst_reg[51]  <= 32'b0;
        inst_reg[52]  <= 32'b0;
        inst_reg[53]  <= 32'b0;
        inst_reg[54]  <= 32'b0;
        inst_reg[55]  <= 32'b0;
        inst_reg[56]  <= 32'b0;
        inst_reg[57]  <= 32'b0;
        inst_reg[58]  <= 32'b0;
        inst_reg[59]  <= 32'b0;
        inst_reg[60]  <= 32'b0;
        inst_reg[61]  <= 32'b0;
        inst_reg[62]  <= 32'b0;
        inst_reg[63]  <= 32'b0;
        inst_reg[64]  <= 32'b0;
        inst_reg[65]  <= 32'b0;
        inst_reg[66]  <= 32'b0;
        inst_reg[67]  <= 32'b0;
        inst_reg[68]  <= 32'b0;
        inst_reg[69]  <= 32'b0;
        inst_reg[70]  <= 32'b0;
        inst_reg[71]  <= 32'b0;
        inst_reg[72]  <= 32'b0;
        inst_reg[73]  <= 32'b0;
        inst_reg[74]  <= 32'b0;
        inst_reg[75]  <= 32'b0;
        inst_reg[76]  <= 32'b0;
        inst_reg[77]  <= 32'b0;
        inst_reg[78]  <= 32'b0;
        inst_reg[79]  <= 32'b0;
        inst_reg[80]  <= 32'b0;
        inst_reg[81]  <= 32'b0;
        inst_reg[82]  <= 32'b0;
        inst_reg[83]  <= 32'b0;
        inst_reg[84]  <= 32'b0;
        inst_reg[85]  <= 32'b0;
        inst_reg[86]  <= 32'b0;
        inst_reg[87]  <= 32'b0;
        inst_reg[88]  <= 32'b0;
        inst_reg[89]  <= 32'b0;
        inst_reg[90]  <= 32'b0;
        inst_reg[91]  <= 32'b0;
        inst_reg[92]  <= 32'b0;
        inst_reg[93]  <= 32'b0;
        inst_reg[94]  <= 32'b0;
        inst_reg[95]  <= 32'b0;
        inst_reg[96]  <= 32'b0;
        inst_reg[97]  <= 32'b0;
        inst_reg[98]  <= 32'b0;
        inst_reg[99]  <= 32'b0;
        inst_reg[100] <= 32'b0;
        inst_reg[101] <= 32'b0;
        inst_reg[102] <= 32'b0;
        inst_reg[103] <= 32'b0;
        inst_reg[104] <= 32'b0;
        inst_reg[105] <= 32'b0;
        inst_reg[106] <= 32'b0;
        inst_reg[107] <= 32'b0;
        inst_reg[108] <= 32'b0;
        inst_reg[109] <= 32'b0;
        inst_reg[110] <= 32'b0;
        inst_reg[111] <= 32'b0;
        inst_reg[112] <= 32'b0;
        inst_reg[113] <= 32'b0;
        inst_reg[114] <= 32'b0;
        inst_reg[115] <= 32'b0;
        inst_reg[116] <= 32'b0;
        inst_reg[117] <= 32'b0;
        inst_reg[118] <= 32'b0;
        inst_reg[119] <= 32'b0;
        inst_reg[120] <= 32'b0;
        inst_reg[121] <= 32'b0;
        inst_reg[122] <= 32'b0;
        inst_reg[123] <= 32'b0;
        inst_reg[124] <= 32'b0;
        inst_reg[125] <= 32'b0;
        inst_reg[126] <= 32'b0;
        inst_reg[127] <= 32'b0;
    end
    else if (inst_wen) begin
        inst_reg[inst_addr] <= inst_data;
    end
end

endmodule

module dff_1b(
    output reg [31:0] Q, 
    input  [31:0] D, 
    input  clk, rst, wen, select
);

always @ (posedge clk) begin
    if (rst) begin
        Q <= 32'b0;
    end
    else if (select) begin
        if (wen) begin
            Q <= D;
        end
    end
end

endmodule