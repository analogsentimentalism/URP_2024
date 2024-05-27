module L2_top #(
	parameter	TNUM	= 18,
	parameter	INUM	= 26 - TNUM,
	parameter	TNUM2	= 16,
	parameter	INUM2	= 26 - TNUM2,
	parameter	WAY		= 4,
	parameter	DEPTH	= 1 << (INUM + clogb2(WAY-1)),
	parameter	BIT_WIDTH_high	= 512,
	parameter	BIT_WIDTH_low	= 512
) (
    input clk,
    input nrst,
    input [TNUM-1:0] tag_L1_L2,
    input [INUM-1:0] index_L1_L2,
    input [BIT_WIDTH_high-1:0] write_data,
    input [BIT_WIDTH_high-1:0] read_data_MEM_L2,
    
    input read_L1_L2, flush,
    input ready_MEM_L2,
    input write_L1_L2,
    output ready_L2_L1,
    output read_L2_MEM, write_L2_MEM,
    output [INUM2-1:0] index_L2_MEM,
    output [TNUM2-1:0] tag_L2_MEM,
    output [TNUM2-1:0] write_tag_L2_MEM,
    
    output [BIT_WIDTH_low-1:0] read_data_L2_L1,
    output [BIT_WIDTH_low-1:0] write_data_L2_MEM,
    output L2_miss_o
);

wire refill;
wire update;
wire [clogb2(WAY-1)-1:0] way;

L2_controller #(
	.TNUM		(	TNUM	),
	.INUM		(	INUM	),
	.TNUM2		(	TNUM2	),
	.INUM2		(	INUM2	),
	.WAY		(	WAY		),
	.DEPTH		(	DEPTH	)
) u_L2_controller(
    .clk(clk),
    .nrst(nrst),
    .refill(refill),
    .tag_L1_L2(tag_L1_L2),
    .index_L1_L2(index_L1_L2),
    .write_tag_L2_MEM(write_tag_L2_MEM),
    .index_L2_MEM(index_L2_MEM),
    .read_L1_L2(read_L1_L2),
    .ready_L2_L1(ready_L2_L1),
    .update(update),
    .read_L2_MEM(read_L2_MEM),
    .write_L2_MEM(write_L2_MEM),
    .write_L1_L2(write_L1_L2),
    .tag_L2_MEM(tag_L2_MEM),
    .way(way),
	.flush(flush),
	.ready_MEM_L2(ready_MEM_L2),
    .L2_miss_o(L2_miss_o)
);

L2_bram #(
	.TNUM			(	TNUM			),
	.INUM			(	INUM			),
	.WAY			(	WAY				),
	.RAM_DEPTH		(	DEPTH			),
	.BIT_WIDTH_high	(	BIT_WIDTH_high	),
	.BIT_WIDTH_low	(	BIT_WIDTH_low	)
) u_L2_data_array(
    .clk(clk),
    .nrst(nrst),
    .index_L1_L2(index_L1_L2),
    .write_data_L1_L2(write_data),
    .read_data_L2_L1(read_data_L2_L1),
    .read_data_MEM_L2(read_data_MEM_L2),
    .update(update),
    .refill(refill),
    .write_data_L2_MEM(write_data_L2_MEM),
    .way(way)
);

function integer clogb2;
input integer depth;
	for (clogb2=0; depth>0; clogb2=clogb2+1)
	depth = depth >> 1;
endfunction

endmodule