module control(
    output PCsel, RegWEn, BrUn,
    output [2:0] ImmSel, WordSizeSel,
    output BSel, ASel,  MemRW, 
    output [3:0] ALUSel,
    output [1:0] WBSel,
    input  [31:0] instruction, 
    input  BrEq, BrLT
);

// PCsel : +4=0, ALU=1
// ImmSel : I=0, B=1, U=2, J=3, S=4
// ASel : REG=0, PC=1
// BSel : Imm=1, REG=0
// ALUSel : SUB/SR=[3], OperationFunctionSelect=[2:0]
// MemRW : Read=0, Write(only at SW opcode)=1
// RegWEn : NotEnabled=0, Enabled=1
// WBSel : ALU=1, MEM=0, +4=2
// WordSizeSel : [7:5] at SaveLoad==1

wire [8:0] inst_opcode = {instruction[30], instruction[14:12], instruction[6:2]};
wire JAL, JALR;    // JAL, JALR
wire BrJal;     // Branch or Jump condition
wire BeQ, BnE;  // 1 if opcode is BEQ or BNE
wire BLT, BGE;  // 1 if opcode is BLT or BGE
wire I_cond, B_cond, U_cond, J_cond, S_cond;
wire AUIPC;
wire ALU_cond_I, ALU_cond_R;
wire RegNWRT;
wire WBMEM_cond, WBp4_cond; // MEM, +4 condition
wire SaveLoad;

// Branch and Jump mode == PCsel
assign BrJal = (inst_opcode[4:2] == 3'b110);
assign JAL = BrJal & (inst_opcode[1:0] == 2'b11);
assign JALR = BrJal & (inst_opcode[1:0] == 2'b01);
assign BeQ = (inst_opcode[7:5] == 3'b000) & BrJal & (inst_opcode[1:0] == 2'b00);
assign BnE = (inst_opcode[7:5] == 3'b001) & BrJal & (inst_opcode[1:0] == 2'b00);
assign BLT = ({inst_opcode[7], inst_opcode[5]} == 2'b10) & BrJal;
assign BGE = ({inst_opcode[7], inst_opcode[5]} == 2'b11) & BrJal;

assign PCsel = JAL | JALR | (BeQ & BrEq) | (BnE & (~BrEq)) | (BLT & BrLT) | (BGE & (~BrLT));

// ImmSel part
assign U_cond = {inst_opcode[4], inst_opcode[2:0]} == 4'b0101;
assign J_cond = JAL;
assign B_cond = inst_opcode[4:0] == 5'b11000;
assign S_cond = inst_opcode[4:0] == 5'b01000;
assign I_cond = ({inst_opcode[4:3], inst_opcode[1:0]} == 4'b0000) | JALR;

enc3b ENCODE1(ImmSel, {S_cond, J_cond, U_cond, B_cond, I_cond});

// BrUn part
assign BrUn = BrJal & inst_opcode[6];

// ASel part
assign AUIPC = (inst_opcode[4:0] == 5'b00101);
assign ASel = AUIPC | JAL | BeQ | BLT | BGE | BnE;

// BSel part
assign BSel = ~(inst_opcode[4:0] == 5'b01100);

// ALUSel part
assign ALU_cond_I = (inst_opcode[4:0] == 5'b00100);     // I type instruction
assign ALU_cond_R = (inst_opcode[4:0] == 5'b01100);     // R type instruction
assign ALUSel = ALU_cond_R ? inst_opcode[8 -: 4] : ((ALU_cond_I) ? {1'b0, inst_opcode[7:5]} : 4'b0);

// MemRw part
assign MemRW = (inst_opcode[4:0] == 5'b01000);

// RegWEn part
assign RegNWRT = (inst_opcode[3:0] == 4'b1000);
assign RegWEn = RegNWRT ? 1'b0 : 1'b1;

// WBSel part
assign WBMEM_cond = (inst_opcode[4:0] == 5'b00000);
assign WBp4_cond  = JAL | JALR;
assign WBSel = WBp4_cond ? 2'b10 : ((WBMEM_cond) ? 2'b00: 2'b01);

// WordSizeSel part
assign SaveLoad = {inst_opcode[4], inst_opcode[2:0]} == 4'b0000;
assign WordSizeSel = (SaveLoad) ? inst_opcode[7:5] : 3'b010;

endmodule

module enc3b(
    output [2:0] enc_o,
    input  [4:0] enc_i // {S, J, U, B, I} order
);

assign enc_o[0] = enc_i[3] | enc_i[1] | enc_i[0];
assign enc_o[1] = enc_i[3] | enc_i[2] | enc_i[0];
assign enc_o[2] = enc_i[4] | enc_i[0];

endmodule