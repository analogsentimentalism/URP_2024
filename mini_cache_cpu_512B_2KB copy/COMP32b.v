module COMP32b(    // unsigned
    output Less,
    input [31:0] A, B,
    input uMod      // 1:UnsignedMode, 0:SignedMode
);

wire [31:0] ubitCompare;     // unsigned
wire [31:0] sbitCompare;
wire uresult, sresult;
wire SignCompare;

assign uresult = |ubitCompare;
assign sbitCompare = {SignCompare, ubitCompare[30:0]};
assign sresult = |sbitCompare;

assign Less = ~(uMod ? uresult : sresult);

assign SignCompare = (A[31] == B[31]) ? 1'b0 : ((A[31]) ? 1'b0 : 1'b1);
assign ubitCompare[31] = (A[31] == B[31]) ? 1'b0 : ((A[31]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[30] = (A[30] == B[30]) ? 1'b0 : ((A[30]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[29] = (A[29] == B[29]) ? 1'b0 : ((A[29]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[28] = (A[28] == B[28]) ? 1'b0 : ((A[28]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[27] = (A[27] == B[27]) ? 1'b0 : ((A[27]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[26] = (A[26] == B[26]) ? 1'b0 : ((A[26]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[25] = (A[25] == B[25]) ? 1'b0 : ((A[25]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[24] = (A[24] == B[24]) ? 1'b0 : ((A[24]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[23] = (A[23] == B[23]) ? 1'b0 : ((A[23]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[22] = (A[22] == B[22]) ? 1'b0 : ((A[22]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[21] = (A[21] == B[21]) ? 1'b0 : ((A[21]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[20] = (A[20] == B[20]) ? 1'b0 : ((A[20]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[19] = (A[19] == B[19]) ? 1'b0 : ((A[19]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[18] = (A[18] == B[18]) ? 1'b0 : ((A[18]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[17] = (A[17] == B[17]) ? 1'b0 : ((A[17]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[16] = (A[16] == B[16]) ? 1'b0 : ((A[16]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[15] = (A[15] == B[15]) ? 1'b0 : ((A[15]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[14] = (A[14] == B[14]) ? 1'b0 : ((A[14]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[13] = (A[13] == B[13]) ? 1'b0 : ((A[13]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[12] = (A[12] == B[12]) ? 1'b0 : ((A[12]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[11] = (A[11] == B[11]) ? 1'b0 : ((A[11]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[10] = (A[10] == B[10]) ? 1'b0 : ((A[10]) ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[9]  = (A[9]  == B[9])  ? 1'b0 : ((A[9])  ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[8]  = (A[8]  == B[8])  ? 1'b0 : ((A[8])  ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[7]  = (A[7]  == B[7])  ? 1'b0 : ((A[7])  ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[6]  = (A[6]  == B[6])  ? 1'b0 : ((A[6])  ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[5]  = (A[5]  == B[5])  ? 1'b0 : ((A[5])  ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[4]  = (A[4]  == B[4])  ? 1'b0 : ((A[4])  ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[3]  = (A[3]  == B[3])  ? 1'b0 : ((A[3])  ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[2]  = (A[2]  == B[2])  ? 1'b0 : ((A[2])  ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[1]  = (A[1]  == B[1])  ? 1'b0 : ((A[1])  ? 1'b1 : 1'b0);      // Less=0, GE=1
assign ubitCompare[0]  = (A[0]  == B[0])  ? 1'b0 : ((A[0])  ? 1'b1 : 1'b0);      // Less=0, GE=1

endmodule
