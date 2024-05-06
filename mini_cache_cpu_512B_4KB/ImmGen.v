module ImmGen(
    output [31:0] Imm,
    input  [24:0] inst_Imm,
    input  [2:0]  ImmSel
);

wire [31:0] I, B, U, J, S;  // type of Immediate 0~4
// 000, 001, 010, 011, 100
wire [31:0] IB, JU, IS, IBJU;

assign I = {{20{inst_Imm[24]}}, inst_Imm[24 -: 12]};
assign U = {inst_Imm[24 -: 20], 12'b0};
assign B = {{19{inst_Imm[24]}}, inst_Imm[24], inst_Imm[0], inst_Imm[23 -: 6], inst_Imm[1 +: 4], 1'b0};
assign J = {{12{inst_Imm[24]}}, inst_Imm[24], inst_Imm[12:5], inst_Imm[13], inst_Imm[23:14], 1'b0};
assign S = {{20{inst_Imm[24]}}, inst_Imm[24:18], inst_Imm[4:0]};

assign IB = ImmSel[0] ? B : I;
assign JU = ImmSel[0] ? J : U;
assign IS = (|ImmSel[1:0]) ? I : S;
assign IBJU = ImmSel[1] ? JU : IB;
assign Imm = ImmSel[2] ? IS : IBJU;

endmodule