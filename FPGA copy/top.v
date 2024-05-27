// 앞에가 자기
module top #(
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
    input clk,
    input nrst,

    // CORE와 L1I 사이의 신호
    input [31:0] address_L1I,
    input flush_L1I,
    input read_C_L1I,
    output stall_L1I,
    output [BIT_WIDTH_high-1:0]read_data_L1I_C,
    // CORE와 L1D top 사이의 신호
    input [31:0] address_L1D,
    input flush_L1D, 
    input read_C_L1D,
    input write_C_L1D,
    input [BIT_WIDTH_high-1:0] write_data,
    output stall_L1D,
    output [BIT_WIDTH_high-1:0]read_data_L1D_C,
    // L2와 MEM 사이의 신호
    input [BIT_WIDTH_low-1:0] read_data_MEM_L2,
    input ready_MEM_L2,
    output read_L2_MEM,
    output write_L2_MEM,
    output [INUM3-1:0] index_L2_MEM,
    output [TNUM3-1:0] tag_L2_MEM,
    output [TNUM3-1:0] write_tag_L2_MEM,
    output [BIT_WIDTH_low-1:0] write_data_L2_MEM,
    output L2_miss_o, L1I_miss_o, L1D_miss_o,
	output read_L1_L2,
	output write_L1_L2
);

wire [BIT_WIDTH_low-1:0] read_data_L2_L1;
wire [BIT_WIDTH_low-1:0] write_data_L1_L2;
wire read_L1D_L2, read_L1I_L2;
wire ready_L2_L1I, ready_L2_L1D;
wire ready_L2_L1;
wire [TNUM2-1:0] tag_L1D_L2, write_tag_L1D_L2, tag_L1I_L2;
wire [TNUM2-1:0] tag_L1_L2;
wire [INUM2-1:0] index_L1D_L2, index_L1I_L2, write_index_L1D_L2;
wire [INUM2-1:0] index_L1_L2;

wire [TNUM-1:0] tag_C_L1D;
wire [INUM-1:0] index_C_L1D;
wire [5:0] offset_C_L1D;
wire [TNUM-1:0] tag_C_L1I;
wire [INUM-1:0] index_C_L1I;
wire [5:0] offset_C_L1I;

assign tag_C_L1D = address_L1D[31-:TNUM];
assign index_C_L1D = address_L1D[6+:INUM];
assign offset_C_L1D = address_L1D[5:0];
assign tag_C_L1I = address_L1I[31-:TNUM];
assign index_C_L1I = address_L1I[6+:INUM];
assign offset_C_L1I = address_L1I[5:0];

L1_D_top #(
	.TNUM			(	TNUM			),
	.INUM			(	INUM			),
	.TNUM2			(	TNUM2			),
	.INUM2			(	INUM2			),
	.WAY			(	WAY				),	
	.DEPTH			(	DEPTH			),
	.BIT_WIDTH_high	(	BIT_WIDTH_high	),
	.BIT_WIDTH_low	(	BIT_WIDTH_low	)
) u_L1_D_top (
    .clk(clk),
    .nrst(nrst),
    .tag_C_L1(tag_C_L1D),
    .index_C_L1(index_C_L1D),
    .offset(offset_C_L1D),
    .write_C_L1(write_C_L1D),
    .flush(flush_L1D),
    .stall(stall_L1D),
    .write_data(write_data),
    .read_data_L1_C(read_data_L1D_C),
    .read_data_L2_L1(read_data_L2_L1),
    .write_data_L1_L2(write_data_L1_L2),
    .write_L1_L2(write_L1_L2),
    .read_L1_L2(read_L1D_L2),
    .ready_L2_L1(ready_L2_L1D),
    .read_C_L1(read_C_L1D),
    .tag_L1_L2(tag_L1D_L2),
    .write_tag_L1_L2(write_tag_L1D_L2),
    .index_L1_L2(index_L1D_L2),
    .write_index_L1_L2(write_index_L1D_L2),
    .L1D_miss_o(L1D_miss_o)
);

L1_I_top #(
	.TNUM			(	TNUM			),
	.INUM			(	INUM			),
	.TNUM2			(	TNUM2			),
	.INUM2			(	INUM2			),
	.WAY			(	WAY				),	
	.DEPTH			(	DEPTH			),
	.BIT_WIDTH_high	(	BIT_WIDTH_high	),
	.BIT_WIDTH_low	(	BIT_WIDTH_low	)
) u_L1_I_top(
    .clk(clk),
    .nrst(nrst),
    .tag_C_L1(tag_C_L1I),
    .index_C_L1(index_C_L1I),
    .offset(offset_C_L1I),
    .flush(flush_L1I),
    .stall(stall_L1I),
    .read_data_L1_C(read_data_L1I_C),
    .read_data_L2_L1(read_data_L2_L1),
    .read_L1_L2(read_L1I_L2),
    .ready_L2_L1(ready_L2_L1I),
    .read_C_L1(read_C_L1I),
    .tag_L1_L2(tag_L1I_L2),
    .index_L1_L2(index_L1I_L2),
    .L1I_miss_o(L1I_miss_o)
);

L1_L2_connect #(
	.TNUM2	(	TNUM2	),
	.INUM2	(	INUM2	)
) u_L1_L2_connect(
    .write_index_L1D_L2(write_index_L1D_L2),
    .index_L1D_L2(index_L1D_L2),
    .index_L1I_L2(index_L1I_L2),
    .tag_L1D_L2(tag_L1D_L2),
    .write_tag_L1D_L2(write_tag_L1D_L2),
    .tag_L1I_L2(tag_L1I_L2),
    .read_L1I_L2(read_L1I_L2),
    .read_L1D_L2(read_L1D_L2),
    .read_L1_L2(read_L1_L2),
    .write_L1D_L2(write_L1_L2),
    .ready_L2_L1(ready_L2_L1),
    .ready_L2_L1I(ready_L2_L1I),
    .ready_L2_L1D(ready_L2_L1D),
    .index_L1_L2(index_L1_L2),
    .tag_L1_L2(tag_L1_L2)
);

L2_top #(
	.TNUM			(	TNUM2			),
	.INUM			(	INUM2			),
	.TNUM2			(	TNUM3			),
	.INUM2			(	INUM3			),
	.WAY			(	WAY2			),	
	.DEPTH			(	DEPTH2			),
	.BIT_WIDTH_high	(	BIT_WIDTH_low	),
	.BIT_WIDTH_low	(	BIT_WIDTH_low	)
) u_L2_top(
    .clk(clk),
    .nrst(nrst),
    .tag_L1_L2(tag_L1_L2),
    .index_L1_L2(index_L1_L2),
    .write_data(write_data_L1_L2),
    .read_data_MEM_L2(read_data_MEM_L2),
    .read_L1_L2(read_L1_L2),
    .flush(flush_L1I),
    .ready_MEM_L2(ready_MEM_L2),
    .write_L1_L2(write_L1_L2),
    .ready_L2_L1(ready_L2_L1),
    .read_L2_MEM(read_L2_MEM),
    .write_L2_MEM(write_L2_MEM),
    .index_L2_MEM(index_L2_MEM),
    .tag_L2_MEM(tag_L2_MEM),
    .write_tag_L2_MEM(write_tag_L2_MEM),
    .read_data_L2_L1(read_data_L2_L1),
    .write_data_L2_MEM(write_data_L2_MEM),
    .L2_miss_o(L2_miss_o)
);

function integer clogb2;
input integer depth;
	for (clogb2=0; depth>0; clogb2=clogb2+1)
	depth = depth >> 1;
endfunction

endmodule