module riscV32I #(
	parameter	RAM_WIDTH	= 32,
	parameter	RAM_DEPTH	= 32'h40_0000,
	parameter	RAM_PERFORMANCE = "LOW_LATENCY",
	parameter	INIT_FILE	= "test.txt",
	parameter	START_ADDR	= 32'h10094,
	parameter	PC_START	= 32'h100d8,

	parameter	TNUM	= 21,
	parameter	INUM	= 26 - TNUM,
	parameter	TNUM2	= 18,
	parameter	INUM2	= 26 - TNUM2,
	parameter	TNUM3	= 18,
	parameter	INUM3	= 26 - TNUM3,
	parameter	WAY		= 2,
	parameter	WAY2	= 4,
	parameter	DEPTH	= 1 << (INUM + clogb2(WAY-1)),
	parameter	DEPTH2	= 1 << (INUM2 + clogb2(WAY2-1)),
	parameter	BIT_WIDTH_high	= 32,
	parameter	BIT_WIDTH_low	= 512
) (
    input clk, clk_mem, rst, enb,
	// input [31:0]	PC_in,
	output L2_miss_o, L1I_miss_o, L1D_miss_o,
	output read_C_L1I_o, read_C_L1D_o, write_C_L1D_o,
	output read_L1_L2, write_L1_L2
	// output [31:0] PC
	// output reg [31:0] PC
);

reg [31:0] PC;

wire [1:0] stall;
reg [1:0] flush;

// for CORE
reg				read_C_L1I					;
reg				read_C_L1D					;
reg				write_C_L1D					;

assign	read_C_L1I_o = read_C_L1I;
assign	read_C_L1D_o = read_C_L1D;
assign	write_C_L1D_o = write_C_L1D;


// for MEM
wire		[BIT_WIDTH_low-1:0]	read_data_MEM_L2			;
wire				ready_MEM_L2				;

wire			read_L2_MEM					;
wire			write_L2_MEM				;
wire	[INUM3-1:0]	index_L2_MEM				;
wire	[TNUM3-1:0]	tag_L2_MEM					;
wire	[TNUM3-1:0]	write_tag_L2_MEM			;
wire	[BIT_WIDTH_low-1:0]	write_data_L2_MEM			;

wire [31:0] Imm, instruction, WB, DataA, DataB, WB_cut;
wire [31:0] DMEM, WB_Half, WB_Byte;
wire PCsel, RegWEn, BrUn, ASel, BSel, MemRW, BrEq, BrLT;
wire [1:0]  WBSel;
wire [2:0]  ImmSel, WordSizeSel;
wire [3:0]  ALUSel;


wire [31:0] ALU_o, ALU_A, ALU_B;

wire [31:0] PC_Next;
wire [31:0] PCp4 = PC + 'd4;
assign PC_Next = PCsel ? ALU_o : PCp4;

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

top #(
	.TNUM			(	TNUM			),
	.INUM			(	INUM			),
	.TNUM2			(	TNUM2			),
	.INUM2			(	INUM2			),
	.TNUM3			(	TNUM3			),
	.INUM3			(	INUM3			),
	.WAY			(	WAY				),
	.WAY2			(	WAY2			),
	.DEPTH			(	DEPTH			),
	.DEPTH2			(	DEPTH2			),
	.BIT_WIDTH_high	(	BIT_WIDTH_high	),
	.BIT_WIDTH_low	(	BIT_WIDTH_low	)
) u_top (
	.clk				(	clk_mem				),
	.nrst				(	~rst				),

	.address_L1I		(	PC					),
	.address_L1D		(	ALU_o				),
	.flush_L1I			(	flush[0]			),
	.flush_L1D			(	flush[1]			),
	.read_C_L1I			(	read_C_L1I			),
	.read_C_L1D			(	~MemRW & read_C_L1D	),
	.write_C_L1D		(	MemRW & write_C_L1D	),
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
	.write_data_L2_MEM	(	write_data_L2_MEM	),
	.L2_miss_o			(	L2_miss_o			),
	.L1I_miss_o			(	L1I_miss_o			),
	.L1D_miss_o			(	L1D_miss_o			),

	.read_L1_L2			(	read_L1_L2			),
	.write_L1_L2		(	write_L1_L2			)
);

L2_bram_connect #(
	.RAM_WIDTH			(	RAM_WIDTH			),
	.RAM_DEPTH			(	RAM_DEPTH			),
	.RAM_PERFORMANCE 	(	RAM_PERFORMANCE		),
	.INIT_FILE			(	INIT_FILE			),
	.START_ADDR			(	START_ADDR			),
	.TNUM				(	TNUM2				)
)
u_bram (
	.clk				(	clk_mem				),
	.rstn				(	~rst				),
	.read_L2_MEM		(	read_L2_MEM			),
	.write_L2_MEM		(	write_L2_MEM		),
	.ready_MEM_L2		(	ready_MEM_L2		),
	.read_data_MEM_L2	(	read_data_MEM_L2	),
	.tag_L2_MEM			(	tag_L2_MEM			),
	.index_L2_MEM		(	index_L2_MEM		),
	.write_tag_L2_MEM	(	write_tag_L2_MEM	),
	.write_data_L2_MEM	(	write_data_L2_MEM	)
);

// mem u_mem (
// 	.clk				(	clk_mem				),
// 	.rstn				(	~rst				),
// 	.read_L2_MEM		(	read_L2_MEM			),
// 	.write_L2_MEM		(	write_L2_MEM		),
// 	.ready_MEM_L2		(	ready_MEM_L2		),
// 	.read_data_MEM_L2	(	read_data_MEM_L2	),
// 	.index_L2_MEM		(	index_L2_MEM		),
// 	.tag_L2_MEM			(	tag_L2_MEM			),
// 	.opcode				(	instruction[6:2]	),
// 	.read_C_L1I			(	read_C_L1I			),
// 	.read_C_L1D			(	read_C_L1D			),
// 	.write_C_L1D		(	write_C_L1D			)
// );


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
reg enb_reg;

reg	[31:0] PC_Prev;
reg	[31:0] inst_Prev;

always @ (posedge clk) begin
    if (rst) begin
		flush <= 'b0;
        // PC <= 'b0;
        PC <= PC_START;
		enb_reg <= 'b0;
    end
	// else if (~enb) begin
	// 	PC	<= PC_in	;
	// end
	else if (~enb_reg & enb) begin
		enb_reg <= 'b1;
	end
    else if (enb) begin
        PC <= (stall) ? PC : PC_Next;
    end
end

always @(posedge clk_mem) begin
	if (rst) begin
		inst_Prev <= 'b0;
	end
	else begin
		inst_Prev <= instruction;
	end
end

always @(*) begin
	if (rst) begin
		read_C_L1I	<= 'b0;
	end
	else if ((enb_reg ^ enb) & enb) begin
		read_C_L1I	<= 'b1;
	end
	else if (enb & (PC_Prev != PC)) begin
		read_C_L1I	<= 'b1;
	end
	else if (enb & (stall[0] ^ flag_stall[0]) & ~stall[0]) begin
		read_C_L1I	<= 'b0;
	end
	else begin
		read_C_L1I	<= read_C_L1I;
	end
end

always @(*) begin
	if (rst) begin
		read_C_L1D	<= 'b0;
		write_C_L1D	<= 'b0;
	end
	else if (enb & (inst_Prev != instruction) & (instruction[6:2] == 5'b00000) & (instruction != 'b0)) begin
		read_C_L1D	<= 'b1;
	end
	else if (enb & (inst_Prev != instruction) & (instruction[6:2] == 5'b01000) & (instruction != 'b0)) begin
		write_C_L1D	<= 'b1;
	end
	else if (enb & (stall[1] ^ flag_stall[1]) & ~stall[1]) begin
		read_C_L1D	<= 'b0;
		write_C_L1D	<= 'b0;
	end
	else begin
		read_C_L1D	<= read_C_L1D;
		write_C_L1D	<= write_C_L1D;
	end
end

always @(posedge clk_mem) begin
	if (rst) begin
		flag_stall	<= 'b0;
		PC_Prev	<= 'b0;
	end
	else begin
		flag_stall	<= stall;
		PC_Prev	<= PC;
	end
end

function integer clogb2;
input integer depth;
	for (clogb2=0; depth>0; clogb2=clogb2+1)
	depth = depth >> 1;
endfunction

endmodule