module riscV32I(
    output [31:0] WB_o,
    input  [31:0] inst_data, 
    input  [6:0]  inst_addr, 
    input  clk, clk_mem, rst, inst_wen, enb
);

reg [8:0] PC;

wire [1:0] stall;
wire [1:0] flush;

// for CORE
reg				read_C_L1I					;
reg				read_C_L1D					;

// for MEM
wire		[511:0]	read_data_MEM_L2			;
wire				ready_MEM_L2				;

wire			read_L2_MEM					;
wire			write_L2_MEM				;
wire	[7:0]	index_L2_MEM				;
wire	[17:0]	tag_L2_MEM					;
wire	[17:0]	write_tag_L2_MEM			;
wire	[511:0]	write_data_L2_MEM			;

wire [31:0] Imm, instruction, WB, DataA, DataB, WB_cut;
wire [31:0] DMEM, WB_Half, WB_Byte;
wire PCsel, RegWEn, BrUn, ASel, BSel, MemRW, BrEq, BrLT;
wire [1:0]  WBSel;
wire [2:0]  ImmSel, WordSizeSel;
wire [3:0]  ALUSel;

reg [8:0] PC_Next;
wire [8:0] PCp4 = PC + 7'd4;

wire [31:0] ALU_o, ALU_A, ALU_B;


assign ALU_A = ASel ? PC : DataA;
assign ALU_B = BSel ? Imm : DataB;

assign WB = (WBSel == 2'd2) ? PCp4 : ((WBSel == 2'd1) ? ALU_o : DMEM);
assign WB_Half = WordSizeSel[2] ? {16'b0, WB[15:0]} : {{16{WB[15]}}, WB[15:0]};
assign WB_Byte = WordSizeSel[2] ? {24'b0, WB[7:0]}  : {{24{WB[7]}},  WB[7:0]};
assign WB_cut = (WordSizeSel[1:0] == 2'b0) ? WB_Byte : ((WordSizeSel[1:0] == 2'b1) ? WB_Half : WB);

// inst_mem IMEM(.inst(instruction),
//     .inst_data(inst_data),
//     .PC(PC[8 -: 7]), .inst_addr(inst_addr),
//     .clk(clk), .rst(rst), .inst_wen(inst_wen)
// );

register_file REGFILE(
    .RD1(DataA), .RD2(DataB),   
    .RR1(instruction[19:15]), .RR2(instruction[24:20]), .WR(instruction[11:7]),
    .WD(WB_cut),         
    .RegWrite(RegWEn), .clk(clk), .rst(rst)
);

BranchComp BrCOMP(
    .BrEq(BrEq), .BrLT(BrLT),
    .RD1(DataA), .RD2(DataB), 
    .BrUn(BrUn)
);

ImmGen IMMGEN(
    .Imm(Imm),
    .inst_Imm(instruction[31:7]),
    .ImmSel(ImmSel)
);

// data_mem DATAMEM(
//     .ReadData(DMEM),
//     .ADDR(ALU_o), .WriteData(DataB),
//     .clk(clk), .rst(rst), .MemWrite(MemRW)
// );

top #() u_top (
	.clk				(	clk_mem				),
	.nrst				(	~rst				),

	.address_L1I		(	{23'b0, PC}			),
	.address_L1D		(	ALU_o				),
	.flush_L1I			(	flush[0]			),
	.flush_L1D			(	flush[1]			),
	.read_C_L1I			(	read_C_L1I			),
	.read_C_L1D			(	~MemRW & read_C_L1D	),
	.write_C_L1D		(	MemRW				),
	.write_data			(	DataB				),
	.read_data_L1I_C	(	instruction			),

	.stall_L1I			(	stall[0]			),
	.stall_L1D			(	stall[1]			),
	.read_data_L1D_C	(	DMEM				),

	.read_data_MEM_L2	(	read_data_MEM_L2	),
	.ready_MEM_L2		(	ready_MEM_L2		),

	.read_L2_MEM		(	read_L2_MEM			),
	.write_L2_MEM		(	write_L2_MEM		),
	.index_L2_MEM		(	index_L2_MEM		),
	.tag_L2_MEM			(	tag_L2_MEM			),
	.write_tag_L2_MEM	(	write_tag_L2_MEM	),
	.write_data_L2_MEM	(	write_data_L2_MEM	)
);

mem #() u_mem (
	.clk				(	clk_mem				),
	.rstn				(	~rst				),
	.read_L2_MEM		(	read_L2_MEM			),
	.write_L2_MEM		(	write_L2_MEM		),
	.ready_MEM_L2		(	ready_MEM_L2		),
	.read_data_MEM_L2	(	read_data_MEM_L2	),
	.index_L2_MEM		(	index_L2_MEM		),
	.tag_L2_MEM			(	tag_L2_MEM			),
	.read_C_L1			(	read_C_L1I			)
);


control CTRL(
    .PCsel(PCsel), .RegWEn(RegWEn), .BrUn(BrUn),
    .ImmSel(ImmSel), .WordSizeSel(WordSizeSel),
    .BSel(BSel), .ASel(ASel), .MemRW(MemRW), 
    .ALUSel(ALUSel),
    .WBSel(WBSel),
    .instruction(instruction), 
    .BrEq(BrEq), .BrLT(BrLT)
);

ALU ALU_riscV(
    .ALU_o(ALU_o),
    .A(ALU_A), .B(ALU_B), .ALUSel(ALUSel)
);

reg [1:0] stall_temp;

reg [1:0] flag_stall;
reg flag_clk;

always @ (posedge clk) begin
    if (rst) begin
        PC <= 9'b0;
		PC_Next <= 9'b0;
    end
    else if (enb) begin
        PC <= stall[0] ? PC : PC_Next;
		PC_Next <= PCsel ? ALU_o : PCp4;
    end
end

always @(PC or negedge stall[0] or rst or enb) begin
	if (rst) begin
		read_C_L1I	<= 'b0;
	end
	else if (enb) begin
		read_C_L1I	<= ~ ((stall[0] ^ flag_stall[0]) & ~stall[0]);
	end
end

always @(ALU_o or negedge stall[1] or rst or enb) begin
	if (rst) begin
		read_C_L1D	<= 'b0;
	end
	else if (enb) begin
		read_C_L1D	<= ~ ((stall[1] ^ flag_stall[1]) & ~stall[1]);
	end
end

always @(posedge clk_mem) begin
	flag_stall	<= stall;
end



endmodule