

module L1_D_top #(
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
    input write_C_L1,
    input flush,
    output stall,
    input [BIT_WIDTH_high-1:0] write_data,
    output [BIT_WIDTH_high-1:0] read_data_L1_C,
    input [BIT_WIDTH_low-1:0] read_data_L2_L1,
    output [BIT_WIDTH_low-1:0] write_data_L1_L2,
    output write_L1_L2,
    output read_L1_L2,
    input ready_L2_L1,
    input read_C_L1,
    output [TNUM2-1:0] tag_L1_L2,
    output [TNUM2-1:0] write_tag_L1_L2,
    output [INUM2-1:0] index_L1_L2,
    output [INUM2-1:0] write_index_L1_L2,
    output L1D_miss_o
);

wire refill;
wire update;
wire [clogb2(WAY-1)-1:0]	way;

L1_D_controller #(
	.TNUM		(	TNUM	),
	.INUM		(	INUM	),
	.TNUM2		(	TNUM2	),
	.INUM2		(	INUM2	),
	.WAY		(	WAY		),
	.DEPTH		(	DEPTH	)
) u_L1_D_controller(
    .clk(clk),
    .nrst(nrst),
    .refill(refill),
    .tag_C_L1(tag_C_L1),
    .index_C_L1(index_C_L1),
    .write_tag_L1_L2(write_tag_L1_L2),
    .index_L1_L2(index_L1_L2),
    .write_index_L1_L2(write_index_L1_L2),
    .read_C_L1(read_C_L1),
    .ready_L2_L1(ready_L2_L1),
    .stall(stall),
    .update(update),
    .read_L1_L2(read_L1_L2),
    .write_L1_L2(write_L1_L2),
    .write_C_L1(write_C_L1),
    .tag_L1_L2(tag_L1_L2),
    .way(way),
	.flush(flush),
    .L1D_miss_o(L1D_miss_o)
);

L1_D_bram #(
	.TNUM			(	TNUM			),
	.INUM			(	INUM			),
	.WAY			(	WAY				),
	.RAM_DEPTH		(	DEPTH			),
	.BIT_WIDTH_high	(	BIT_WIDTH_high	),
	.BIT_WIDTH_low	(	BIT_WIDTH_low	)
) u_L1_D_data_array(
    .clk(clk),
    .nrst(nrst),
    .index_C_L1(index_C_L1),
    .write_data_C_L1(write_data),
    .offset(offset),
    .read_data_L1_C(read_data_L1_C),
    .read_data_L2_L1(read_data_L2_L1),
    .update(update),
    .refill(refill),
    .write_data_L1_L2(write_data_L1_L2),
    .way(way)
);

function integer clogb2;
input integer depth;
	for (clogb2=0; depth>0; clogb2=clogb2+1)
	depth = depth >> 1;
endfunction

endmodule
