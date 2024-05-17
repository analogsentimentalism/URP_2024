`timescale 1ns/1ns

module L1_I_top #(
	parameter	TNUM	= 21,
	parameter	INUM	= 26 - TNUM,
	parameter	TNUM2	= 18,
	parameter	INUM2	= 26 - TNUM2,
	parameter	WAY		= 2,
	parameter	DEPTH	= 1 << (INUM + clogb2(WAY-1)),
	parameter	BIT_WIDTH_high	= 32,
	parameter	BIT_WIDTH_low	= 512
) (
    input clk,
    input nrst,
    input [TNUM-1:0] tag_C_L1,
    input [INUM-1:0] index_C_L1,
    input [5:0] offset,
    input flush,
    output stall,
    output [BIT_WIDTH_high-1:0] read_data_L1_C,
    input [BIT_WIDTH_low-1:0] read_data_L2_L1,
    output read_L1_L2,
    input ready_L2_L1,
    input read_C_L1,
    output [TNUM2-1:0] tag_L1_L2,
    output [INUM2-1:0] index_L1_L2,
    output L1I_miss_o
);

wire refill;
wire [clogb2(WAY-1)-1:0]	way;

L1_I_controller #(
	.TNUM		(	TNUM	),
	.INUM		(	INUM	),
	.TNUM2		(	TNUM2	),
	.INUM2		(	INUM2	),
	.WAY		(	WAY		),
	.DEPTH		(	DEPTH	)
) u_L1_I_controller  (
    .clk(clk),
    .nrst(nrst),
    .refill(refill),
    .tag_C_L1(tag_C_L1),
    .index_C_L1(index_C_L1),
    .index_L1_L2(index_L1_L2),
    .read_C_L1(read_C_L1),
    .ready_L2_L1(ready_L2_L1),
    .stall(stall),
    .read_L1_L2(read_L1_L2),
    .tag_L1_L2(tag_L1_L2),
    .way(way),
	.flush(flush),
    .L1I_miss_o(L1I_miss_o)
);

L1_I_bram #(
	.TNUM			(	TNUM			),
	.INUM			(	INUM			),
	.WAY			(	WAY				),
	.RAM_DEPTH		(	DEPTH			),
	.BIT_WIDTH_high	(	BIT_WIDTH_high	),
	.BIT_WIDTH_low	(	BIT_WIDTH_low	)
) u_L1_I_data_array(
    .clk(clk),
    .nrst(nrst),
    .index_C_L1(index_C_L1),
    .offset(offset),
    .read_data_L1_C(read_data_L1_C),
    .read_data_L2_L1(read_data_L2_L1),
    .refill(refill),
    .way(way)
);

function integer clogb2;
input integer depth;
	for (clogb2=0; depth>0; clogb2=clogb2+1)
	depth = depth >> 1;
endfunction

endmodule
