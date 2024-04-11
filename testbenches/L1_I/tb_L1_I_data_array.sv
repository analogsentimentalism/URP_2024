`timescale 1ns/1ns

module tb_L1_l_data_array #(
	parameter	L1_CLK	= 1,			// L1의 클락
	parameter	L2_CLK	= 1,			// L2의 클락
	parameter	TOTAL	= 64,			// 전체 address 개수
	parameter	INIT	= 32,			// 처음 채울 개수
	parameter	TNUM	= 21,			// # Tag bits
	parameter	INUM	= 26 - TNUM,	// # Index bits
	parameter	L1CBUS	= 32, 
	parameter	L21BUS	= 512
) ();

reg						clk				;
reg						nrst			;

reg		[31:0]			address			;

reg						refill			;
reg						way				;

reg		[L21BUS - 1:0]	read_data_L2_L1	;
wire	[L1CBUS - 1:0]	read_data_L1_C	;
wire	[TNUM - 1:0]	tag_L1_L2		;

    //
    L1_I_data_array L1_I_data_array (
    .clk				(	clk						),
    .nrst				(	nrst					),
    .index_C_L1			(	address		[6+:INUM]	),
    .offset				(	address		[0+:6]		),
    .read_data_L2_L1	(	read_data_L2_L1			),
    .refill				(	refill					),
	.way				(	way						),
    .read_data_L1_C		(	read_data_L1_C			)
);

// Signals for Testbench
reg		[31:0]	address_array	[TOTAL-1:0]	;
reg		[31:0]	replace_array	[TOTAL-1:0]	;
reg		[511:0]	data_array		[TOTAL-1:0]	;
reg		[511:0]	rdata_array		[TOTAL-1:0]	;

integer			i, j						;
integer			aa, ra, d, r				;

integer			test_state					;

always begin
	#1 clk = ~clk;
end

    //initial value
// Init
initial begin: init
	clk			= '1	;
	nrst      	= '0	;
	refill		= '0	;
	way			= '0	;

	aa	= $fopen("../testbenches/etc/tb_L1_I_data_array_address_array.txt", "wb"	);
	ra	= $fopen("../testbenches/etc/tb_L1_I_data_array_replace_array.txt", "wb"	);
	d	= $fopen("../testbenches/etc/tb_L1_I_data_array_data_array.txt", "wb"		);
	r	= $fopen("../testbenches/etc/tb_L1_I_data_array_rdata_array.txt", "wb"		);

	@(posedge clk);	// 파일 오픈 적용이 잘 안될까봐

	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses
		address_array[i]	= $urandom & 32'hFFFF_F03C | {i[0+:INUM], 6'd0}	;
		$fwrite(aa, "%h\n", address_array[i])								;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses with same index
		replace_array[i]	= $urandom & 32'hFFFF_F03C | {address_array[i][6+:INUM], 6'd0}	;
		$fwriteh(ra, "%h\n",replace_array[i])												;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses
		data_array[i]	= $urandom			;
		$fwrite(d, "%h\n", data_array[i])	;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses with same index
		rdata_array[i]	= $urandom			;
		$fwriteh(r, "%h\n",rdata_array[i])	;
	end

	$fclose(aa)	;
	$fclose(ra)	;
	$fclose(d)	;
	$fclose(r)	;
end

initial begin: test

	// 0. Reset
	$display("%6d: Reset", $time)			;
	test_state	= 0							;

	nrst		= 1'b1						;
	repeat(5 * L1_CLK)	@(posedge	clk)	;
	nrst		= 1'b0						;

	repeat(5 * L1_CLK)	@(posedge	clk)	;
	nrst		= 1'b1						;

	// load data from L2
	// 1. L1 Miss, L2 Hit. way0
	$display("%6d: L1 Miss, L2 Hit. way0", $time)	;
	test_state	= 1									;

	refill	= '1									;

	for(i = 0; i<INIT; i = i + 1) begin
		address	= address_array[i]							;
		way		= '0										;
		
		repeat(2 * L1_CLK)	@(posedge	clk)				;
		repeat(2 * L2_CLK)  @(posedge   clk)				;
		read_data_L2_L1	= data_array[i]						;
		repeat(L1_CLK)		@(posedge	clk)				;
		$display("%6d: Data = %d", $time, read_data_L1_C)	;
	end

	// 2. L1 Miss, L2 Hit. way1
	$display("%6d: L1 Miss, L2 Hit. way1", $time)	;
	test_state	= 2									;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address	= address_array[i]							;
		way		= '1										;
		
		repeat(2 * L1_CLK)	@(posedge	clk)				;
		repeat(2 * L2_CLK)  @(posedge   clk)				;
		read_data_L2_L1	= data_array[i]						;
		repeat(L1_CLK)		@(posedge	clk)			;
		$display("%6d: Data = %d", $time, read_data_L1_C)	;
	end

	refill	= '0;

	// 3. L1 Hit, way0
	$display("%6d: L1 Hit. way0", $time)	;
	test_state	= 3							;

	for(i = 0; i<INIT; i = i + 1) begin
		address	= address_array[i]							;
		way		= '0										;
		
		repeat(2 * L1_CLK)  @(posedge   clk)				;
		$display("%6d: Data = %d", $time, read_data_L1_C)	;
	end

	// 4. L1 Hit, way1
	$display("%6d: L1 Hit. way1", $time)	;
	test_state	= 4							;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address	= address_array[i]							;
		way		= '1										;
		
		repeat(L1_CLK)		@(posedge	clk)				;
		$display("%6d: Data = %d", $time, read_data_L1_C)	;
	end

	// 5. L1 Miss, L2 Miss. way0
	$display("%6d: L1 Miss, L2 Miss. way0", $time)	;
	test_state	= 5									;

	refill	= '1									;

	for(i = 0; i<INIT; i = i + 1) begin
		address	= replace_array[i]							;
		way		= '0										;
		
		repeat(2 * L1_CLK)		@(posedge	clk)			;
		repeat(4 * L2_CLK + 8)  @(posedge   clk)			;
		read_data_L2_L1	= rdata_array[i]					;
		repeat(L1_CLK)		@(posedge	clk)				;
		$display("%6d: Data = %d", $time, read_data_L1_C)	;
	end

	// 6. L1 Miss, L2 Miss. way1
	$display("%6d: L1 Miss, L2 Miss. way1", $time)	;
	test_state	= 6									;

	for(i = 0; i<INIT; i = i + 1) begin
		address	= replace_array[i]							;
		way		= '1										;
		
		repeat(2 * L1_CLK)		@(posedge	clk)			;
		repeat(4 * L2_CLK + 8)  @(posedge   clk)			;
		read_data_L2_L1	= rdata_array[i]					;
		repeat(L1_CLK)		@(posedge	clk)				;
		$display("%6d: Data = %d", $time, read_data_L1_C)	;
	end

	$finish;
end

endmodule