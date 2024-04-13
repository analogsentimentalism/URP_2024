`timescale 1ns/1ns
module tb_L2_controller #(
	parameter	L2_CLK	= 1,			// L1의 클락
	parameter	MEM_CLK	= 1,			// L2의 클락
	parameter	TOTAL	= 1024,			// 전체 address 개수
	parameter	INIT	= 256,			// 처음 채울 개수
	parameter	TNUM	= 18,			// # Tag bits
	parameter	INUM	= 26 - TNUM,	// # Index bits
	parameter	TNUM_2	= 18,			// # Tag bits for L2
	parameter	INUM_2	= 26 - TNUM_2	// # Index bits for L2
) ();

reg						clk					;
reg						nrst				;

reg		[31:0]			address				; 
reg						read_L1_L2			;
reg						flush				;
reg						ready_MEM_L2		;

reg						write_L1_L2			;

reg						ready_L2_L1			;

wire					refill				;
wire					update				;
wire					read_L2_MEM			;
wire					write_L2_MEM		;
wire	[1:0]			way					;
wire	[INUM_2 - 1:0]	index_L2_MEM		;
wire	[TNUM_2 - 1:0]	tag_L2_MEM			;
wire	[INUM_2 - 1:0]	write_index_L2_MEM	;
wire	[TNUM_2 - 1:0]	write_tag_L2_MEM	;

L2_controller u_L2_controller (

	.clk				(	clk					),
    .nrst				(	nrst				),

    .tag_L1_L2			(	address[31-:TNUM]	),
    .index_L1_L2		(	address[6+:INUM]	),
    .read_L1_L2			(	read_L1_L2			),
    .flush				(	flush				),
    .ready_MEM_L2		(	ready_MEM_L2		),

	.write_L1_L2		(	write_L1_L2			),
	.ready_L2_L1		(	ready_L2_L1			),

	.refill				(	refill				),
	.update				(	update				),
    .read_L2_MEM		(	read_L2_MEM			),
	.write_L2_MEM		(	write_L2_MEM		),

	.index_L2_MEM		(	index_L2_MEM		),
	.tag_L2_MEM			(	tag_L2_MEM			),
	.write_tag_L2_MEM	(	tag_L2_MEM			),
	
	.way				(	way					)
);

// Signals for Testbench
reg		[31:0]	address_array	[TOTAL-1:0]	;
reg		[31:0]	replace_array	[TOTAL-1:0]	;
integer			i, j						;
integer			aa, ra						;

integer			test_state					;

always begin
#1   clk		= ~clk						;
end

// Init
initial begin: init
	clk			= '1	;
	nrst      	= '0	;
	address     = '0	;
	read_L1_L2	= '0	;
	flush		= '0	;
	ready_MEM_L2	= '0	;
	write_L1_L2	= '0	;

	aa	= $fopen("../testbenches/etc/tb_L2_controller_address_array.txt", "wb");
	ra	= $fopen("../testbenches/etc/tb_L2_controller_replace_array.txt", "wb");

	@(posedge clk);	// 파일 오픈 적용이 잘 안될까봐

	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses
		address_array[i]	= $urandom & 32'hFFFF_C03F | {i[0+:INUM], 6'd0}	;
		$fwrite(aa, "%h\n", address_array[i])								;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses with same index
		replace_array[i]	= $urandom & 32'hFFFF_C03F | {address_array[i][6+:INUM], 6'd0}	;
		$fwriteh(ra, "%h\n",replace_array[i])												;
	end

	$fclose(aa);
	$fclose(ra);
end

initial begin: test

	// 1. Read: L2 Miss - Mem Hit way0.
	$display("%6d: Cache Init start - way0", $time)		;
	test_state	= 1							;

	nrst		= 1'b1						;
	repeat(5 * L2_CLK)	@(posedge	clk)	;
	nrst		= 1'b0						;

	repeat(5 * L2_CLK)	@(posedge	clk)	;
	nrst		= 1'b1						;
	read_L1_L2	= 1'b1						;   // Initial reset

	for(i = 0; i<INIT; i = i + 1) begin	// fill way0.
		address		= address_array[i]				;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)  @(posedge   clk)			;
		ready_MEM_L2	= 1'b1								;
		repeat(MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2	= 1'b0								;
	end

	repeat(50)	@(posedge   clk)		;	// test_state 바뀔 때 구분.
											// Cache clock과 관련 X

	// 2. Read: L2 Miss - Mem Hit way1.
	$display("Cache Init start - way1")	;
	test_state	= 2	;

	for(i = INIT; i<INIT*2; i = i + 1) begin	// fill way1.
		address		= address_array[i]					;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)   @(posedge   clk)			;
		ready_MEM_L2	= 1'b1								;
		repeat(MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2	= 1'b0								;
	end

	// 3. Read: L3 Miss - Mem Hit way2.
	$display("Cache Init start - way2")	;
	test_state	= 3	;

	for(i = INIT*2; i<INIT*3; i = i + 1) begin	// fill way1.
		address		= address_array[i]					;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)   @(posedge   clk)			;
		ready_MEM_L2	= 1'b1							;
		repeat(MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2	= 1'b0							;
	end

	// 3. Read: L3 Miss - Mem Hit way3.
	$display("Cache Init start - way3")	;
	test_state	= 4	;

	for(i = INIT*3; i<TOTAL; i = i + 1) begin	// fill way1.
		address		= address_array[i]					;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)   @(posedge   clk)			;
		ready_MEM_L2	= 1'b1								;
		repeat(MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2	= 1'b0								;
	end

	read_L1_L2   = 1'b0				;
	repeat(50)   @(posedge   clk)	;

/*

	// 3. Read: L1 Hit way0.
	$display("%6d: Read-Hit-way0", $time);
	test_state	= 3					;

	read_L1_L2	= 1'b1				;

	for(i = 0; i<INIT; i = i + 1) begin	// read hit way 0
		address	= address_array[i]						;

		$display("%6d: Read Address %h", $time, address);
		repeat(L2_CLK)	@(posedge   clk)				;
	end

	repeat(50)	@(posedge   clk)	;

	// 4. Read: L1 Hit way1.
	$display("%6d: Read-Hit-way1", $time);
	test_state	= 4	;

	for(i = INIT; i<TOTAL; i = i + 1) begin	// read hit way 1
		address	= address_array[i]						;

		$display("%6d: Read Address %h", $time, address);
		repeat(L2_CLK)	@(posedge   clk)				;
	end

	read_L1_L2	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 5. Read: L1 Miss - L2 Hit (Replace way0)
	$display("%6d: Read-Miss-Hit (Replace way0)", $time);
	test_state	= 5							;

	read_L1_L2	= 1'b1						;

	for(i = 0; i<INIT; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)   @(posedge   clk)			;
		ready_MEM_L2	= 1'b1								;
		repeat(MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2	= 1'b0								;
		repeat(L2_CLK)	@(posedge   clk)				;
	end

	// 6. Read: L1 Miss - L2 Hit (Replace way1)
	$display("%6d: Read-Miss-Hit (Replace way1)", $time);
	test_state	= 6										;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)   @(posedge   clk)			;		
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;
		repeat(L2_CLK)	@(posedge   clk)				;
	end

	read_L1_L2	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 7. Flush
	$display("%6d: FLUSH", $time)	;
	test_state	= 7					;

	flush		= 1'b1				;
	repeat(L2_CLK)	@(posedge	clk);
	flush		= 1'b0				;

	repeat(50)	@(posedge   clk)	;

	$display("For L2 Miss")			;

	// 8. Read: L1 Miss - L2 Miss way0.
	$display("%6d: Cache Init start - way0", $time)	;
	test_state	= 8									;

	read_L1_L2	= 1'b1								;

	for(i = 0; i<INIT; i = i + 1) begin	// fill way0.
		address		= address_array[i]					;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(4 * MEM_CLK + 8)  @(posedge   clk)		;
		ready_MEM_L2	= 1'b1								;
		repeat(MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2	= 1'b0								;
      
	end

	repeat(50)	@(posedge   clk)		;

	// 9. Read: L1 Miss - L2 Hit way1.
	$display("Cache Init start - way1")	;
	test_state	= 9	;

	for(i = INIT; i<TOTAL; i = i + 1) begin	// fill way1.
		address		= address_array[i]					;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(4 * MEM_CLK + 8)  @(posedge   clk)		;
		ready_MEM_L2	= 1'b1								;
		repeat(MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2	= 1'b0								;
      
	end

	read_L1_L2   = 1'b0				;
	repeat(50)   @(posedge   clk)	;

	// 10. Read: L1 Miss - L2 Miss (Replace way0)
	$display("%6d: Read-Miss-Miss (Replace way0)", $time)	;
	test_state	= 10										;
	read_L1_L2	= 1'b1										;

	for(i = 0; i<INIT; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(4 * MEM_CLK + 8)  @(posedge   clk)		;
		ready_MEM_L2	= 1'b1								;
		repeat(MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2	= 1'b0								;
		repeat(L2_CLK)	@(posedge   clk)				;
	end

	repeat(50)   @(posedge   clk)	;

	// 11. Read: L1 Miss - L2 Miss (Replace way1)
	$display("%6d: Read-Miss-Miss (Replace way1)", $time)	;
	test_state	= 11										;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(4 * MEM_CLK + 8)  @(posedge   clk)		;		
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;
		repeat(L2_CLK)	@(posedge   clk)				;
	end

	read_L1_L2	= 1'b0				;	
	repeat(50)   @(posedge   clk)	;

	// init for write
	$display("%6d: FLUSH", $time)	;

	flush		= 1'b1				;
	repeat(L2_CLK)	@(posedge	clk);
	flush		= 1'b0				;

	repeat(50)   @(posedge   clk)	;

	// 12. Write: L1 Miss - L2 Hit. Way0
	$display("%6d: Write-Miss-Hit. Way0", $time)	;
	test_state	= 12								;

	write_L1_L2	= 1'b1								;

	for(i = 0; i<INIT; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)	@(posedge   clk)			;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;
	end

	// 13. Write: L1 Miss - L2 Hit. Way1
	$display("%6d: Write-Miss-Hit. Way1", $time)	;
	test_state	= 13								;

	for(i = INIT; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)	@(posedge   clk)			;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;
	end

	write_L1_L2	= 1'b0				;
	repeat(50)   @(posedge   clk)	;

   // 14. Read: L1 Hit way0.
	$display("%6d: Read-Hit-way0", $time)	;
	test_state	= 14						;

	read_L1_L2	= 1'b1						;

	for(i = 0; i<INIT; i = i + 1) begin	// read hit way 0
		address	= address_array[i]						;

		$display("%6d: Read Address %h", $time, address);
		repeat(L2_CLK)	@(posedge   clk)				;
	end

	repeat(50)	@(posedge   clk)	;

	// 15. Read: L1 Hit way1.
	$display("%6d: Read-Hit-way1", $time);
	test_state	= 15					;

	for(i = INIT; i<TOTAL; i = i + 1) begin	// read hit way 1
		address	= address_array[i]						;

		$display("%6d: Read Address %h", $time, address);
		repeat(L2_CLK)	@(posedge   clk)				;
	end

	read_L1_L2	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 16. Write: L1 Hit. Way0
	$display("%6d: Write L1 Hit. Way0", $time)	;
	test_state	= 16								;

	write_L1_L2	= 1'b1								;

	for(i = 0; i<INIT; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L2_CLK)	@(posedge   clk)			;
	end

	// 17. Write: L1 Hit. Way1
	$display("%6d: Write L1 Hit. Way1", $time)	;
	test_state	= 17										;

	for(i = INIT; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L2_CLK)	@(posedge   clk)			;
	end

	write_L1_L2	= 1'b0				;
	repeat(50)   @(posedge   clk)	;

	// 18. Read: L1 Miss - L2 Hit (Write back) way0
	$display("%6d: Read-Miss-Hit (Write back) way0", $time)	;
	test_state	= 18									;

	read_L1_L2	= 1'b1									;

	for(i = 0; i<INIT; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)  @(posedge   clk)			;
		repeat(2 * MEM_CLK)  @(posedge   clk)			;
		ready_MEM_L2	= 1'b1								;
		repeat(MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2	= 1'b0								;
		repeat(L2_CLK)	@(posedge   clk)				;
	end

	// 19. Read: L1 Miss - L2 Hit (Write back) way1
	$display("%6d: Read-Miss-Hit (Write back) way1", $time)	;
	test_state	= 19										;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)  @(posedge   clk)			;		
		repeat(2 * MEM_CLK)  @(posedge   clk)			;		
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;
		repeat(L2_CLK)	@(posedge   clk)				;
	end

	read_L1_L2	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 20. Write: L1 Miss - L2 Miss. Way0
	$display("%6d: Write-Miss-Miss. Way0", $time)	;
	test_state	= 20								;

	write_L1_L2	= 1'b1								;

	for(i = 0; i<INIT; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address)	;
		repeat(2 * L2_CLK)	@(posedge   clk)				;
		repeat(4 * MEM_CLK + 8)	@(posedge   clk)			;
		ready_MEM_L2		= 1'b1								;
		repeat(MEM_CLK)   @(posedge   clk)					;
		ready_MEM_L2		= 1'b0								;
	end

	// 21. Write: L1 Miss - L2 Miss. Way1
	$display("%6d: Write-Miss-Miss. Way1", $time)	;
	test_state	= 21								;

	for(i = INIT; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address)	;
		repeat(2 * L2_CLK)	@(posedge   clk)				;
		repeat(4 * MEM_CLK + 8)	@(posedge   clk)			;
		ready_MEM_L2		= 1'b1								;
		repeat(MEM_CLK)   @(posedge   clk)					;
		ready_MEM_L2		= 1'b0								;
	end

	write_L1_L2	= 1'b0				;
	repeat(50)   @(posedge   clk)	;

	// 22. Read: L1 Miss - L2 Miss (Write back) way0
	$display("%6d: Read-Miss-Miss (Write back) way0", $time)	;
	test_state	= 22									;

	read_L1_L2	= 1'b1									;

	for(i = 0; i<INIT; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L2_CLK)		@(posedge   clk)			;
		repeat(4 * MEM_CLK + 8)  @(posedge   clk)			;
		repeat(2 * MEM_CLK)  	@(posedge   clk)			;
		ready_MEM_L2	= 1'b1									;
		repeat(MEM_CLK)	@(posedge   clk)					;
		ready_MEM_L2	= 1'b0									;
		repeat(L2_CLK)	@(posedge   clk)					;
	end

	// 23. Read: L1 Miss - L2 Miss (Write back) way1
	$display("%6d: Read-Miss-Hit (Write back) way1", $time)	;
	test_state	= 23										;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address			= replace_array[i]					;

		$display("%6d: Read Address %h", $time, address)	;

		repeat(2 * L2_CLK)		@(posedge   clk)			;
		repeat(4 * MEM_CLK + 8)  @(posedge   clk)			;
		repeat(2 * MEM_CLK)  	@(posedge   clk)			;
		ready_MEM_L2	= 1'b1									;
		repeat(MEM_CLK)	@(posedge   clk)					;
		ready_MEM_L2	= 1'b0									;
		repeat(L2_CLK)	@(posedge   clk)					;
	end

	read_L1_L2	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 24. Write Init
	$display("%6d: (Write Init)", $time)	;
	test_state	= 24								;

	write_L1_L2	= 1'b1								;

	for(i = 0; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address)	;

		repeat(2 * L2_CLK)	@(posedge   clk)				;
		repeat(2 * MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2		= 1'b1								;
		repeat(MEM_CLK)   @(posedge   clk)					;
		ready_MEM_L2		= 1'b0								;
	end

	repeat(50)	@(posedge   clk)	;

	// 25. Write: L1 Miss - L2 Hit. (Write back) Way0
	$display("%6d: Write-Miss-Hit. (Write back) Way0", $time)	;
	test_state	= 25								;

	write_L1_L2	= 1'b1								;

	for(i = 0; i<INIT; i = i  + 1) begin
		address		= replace_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)	@(posedge   clk)			;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;

		repeat(2 * MEM_CLK)	@(posedge   clk)			;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;

	end

	repeat(50)	@(posedge   clk)	;

	// 26. Write: L1 Miss - L2 Hit. (Write back) Way1
	$display("%6d: Write-Miss-Hit.(Write back) Way1", $time)	;
	test_state	= 26								;

	for(i = INIT; i<TOTAL; i = i  + 1) begin
		address		= replace_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		repeat(2 * MEM_CLK)	@(posedge   clk)			;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;

		repeat(2 * MEM_CLK)	@(posedge   clk)			;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;

	end

	repeat(50)	@(posedge   clk)	;

	// 27. Write: L1 Miss - L2 Miss. (Write back) Way0
	$display("%6d: Write-Miss-Hit. (Write back) Way0", $time)	;
	test_state	= 27								;

	for(i = 0; i<INIT; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L2_CLK)		@(posedge   clk)		;
		repeat(2 * MEM_CLK)		@(posedge   clk)		;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;

		repeat(4 * MEM_CLK + 8)	@(posedge   clk)			;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;

	end

	repeat(50)	@(posedge   clk)	;

	// 28. Write: L1 Miss - L2 Miss. (Write back) Way1
	$display("%6d: Write-Miss-Hit.(Write back) Way1", $time)	;
	test_state	= 28								;

	for(i = INIT; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L2_CLK)		@(posedge   clk)		;
		repeat(2 * MEM_CLK)	@(posedge   clk)		;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;

		repeat(4 * MEM_CLK + 8)	@(posedge   clk)			;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)				;
		ready_MEM_L2		= 1'b0							;

	end

	$finish	;

*/
end

initial begin
	$dumpfile("tb_L2_controller.vcd")	;
	$dumpvars(u_L2_controller)		;
end

endmodule