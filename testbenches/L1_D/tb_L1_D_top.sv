`timescale 1ns/1ns
module tb_L1_D_top #(
	parameter	L1_CLK	= 1,			// L1의 클락
	parameter	L2_CLK	= 1,			// L2의 클락
	parameter	TOTAL	= 64,			// 전체 address 개수
	parameter	INIT	= 32,			// 처음 채울 개수
	parameter	TNUM	= 21,			// # Tag bits
	parameter	INUM	= 26 - TNUM,	// # Index bits
	parameter	TNUM_2	= 18,			// # Tag bits for L2
	parameter	INUM_2	= 26 - TNUM_2	// # Index bits for L2
) ();

reg						clk					;
reg						nrst				;

reg		[31:0]			address				; 
reg						write_C_L1			;
reg						flush				;
reg						ready_L2_L1			;
reg						read_C_L1			;

reg		[31:0]			write_data			;
reg		[511:0]			read_data_L2_L1		;
wire	[31:0]			read_data_L1_C		;
wire	[511:0]			write_data_L1_L2	;

wire					write_L1_L2			;
wire					stall				;
wire					read_L1_L2			;
wire	[INUM_2 - 1:0]	index_L1_L2			;
wire	[TNUM_2 - 1:0]	tag_L1_L2			;
wire	[INUM_2 - 1:0]	write_index_L1_L2	;
wire	[TNUM_2 - 1:0]	write_tag_L1_L2		;

L1_D_top u_L1_D_top (
	.clk				(	clk					),
    .nrst				(	nrst				),

    .tag_C_L1			(	address[31-:TNUM]	),
    .index_C_L1			(	address[6+:INUM]	),
	.offset				(	address[5:0]		),
	.write_C_L1			(	write_C_L1			),
    .flush				(	flush				),
    .stall				(	stall				),

	.write_data			(	write_data			),
	.read_data_L1_C		(	read_data_L1_C		),
	.read_data_L2_L1	(	read_data_L2_L1		),

	.write_data_L1_L2	(	write_data_L1_L2	),
	.write_L1_L2		(	write_L1_L2			),
    .read_L1_L2			(	read_L1_L2			),
    .ready_L2_L1		(	ready_L2_L1			),
    .read_C_L1			(	read_C_L1			),
   
	.index_L1_L2		(	index_L1_L2			),
	.tag_L1_L2			(	tag_L1_L2			),
	.write_index_L1_L2	(	write_index_L1_L2	),
	.write_tag_L1_L2	(	write_tag_L1_L2		)
);


// Signals for Testbench
reg		[31:0]	address_array	[TOTAL-1:0]	;
reg		[31:0]	replace_array	[TOTAL-1:0]	;
reg		[511:0]	data_array		[TOTAL-1:0]	;
reg		[511:0]	rdata_array		[TOTAL-1:0]	;
reg		[31:0]	wdata_array		[TOTAL-1:0]	;
reg		[31:0]	wdata_array_2	[TOTAL-1:0]	;

integer			i, j						;
integer			aa, ra, d, r, w, w_2		;

integer			test_state					;

always begin
#1   clk		= ~clk						;
end

// Init
initial begin: init
	clk			= '1	;
	nrst      	= '0	;
	address     = '0	;
	read_C_L1	= '0	;
	flush		= '0	;
	ready_L2_L1	= '0	;
	write_C_L1	= '0	;

	aa	= $fopen("../testbenches/etc/tb_L1_I_top_address_array.txt", "wb")	;
	ra	= $fopen("../testbenches/etc/tb_L1_I_top_replace_array.txt", "wb")	;
	d	= $fopen("../testbenches/etc/tb_L1_I_top_data_array.txt", "wb")		;
	r	= $fopen("../testbenches/etc/tb_L1_I_top_rdata_array.txt", "wb")	;
	w	= $fopen("../testbenches/etc/tb_L1_I_top_wdata_array.txt", "wb")	;
	w_2	= $fopen("../testbenches/etc/tb_L1_I_top_wdata_array_2.txt", "wb")	;

	@(posedge clk);	// 파일 오픈 적용이 잘 안될까봐

	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses
		address_array[i]	= $urandom & 32'hFFFF_F03C | {i[0+:INUM], 6'd0}	;
		$fwrite(aa, "0x%h\n", address_array[i])								;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses with same index
		replace_array[i]	= $urandom & 32'hFFFF_F03C | {address_array[i][6+:INUM], 6'd0}	;
		$fwriteh(ra, "0x%h\n",replace_array[i])												;
	end
	std::randomize(data_array);
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses
		$fwrite(d, "%d\n", data_array[i])	;
	end
	std::randomize(rdata_array);
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses with same index
		$fwriteh(r, "%d\n",rdata_array[i])	;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses with same index
		wdata_array[i]	= $urandom				;
		$fwriteh(ra, "0x%h\n",wdata_array[i])	;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses with same index
		wdata_array_2[i]	= $urandom			;
		$fwriteh(ra, "0x%h\n",wdata_array_2[i])	;
	end
	$fclose(aa)	;
	$fclose(ra)	;
	$fclose(d)	;
	$fclose(r)	;
	$fclose(w)	;
	$fclose(w_2);
end

initial begin: test

	// 1. Read: L1 Miss - L2 Hit way0.
	$display("%6d: Cache Init start - way0", $time)	;
	test_state	= 1									;

	nrst		= 1'b1								;
	repeat(5 * L1_CLK)	@(posedge	clk)			;
	nrst		= 1'b0								;

	repeat(5 * L1_CLK)	@(posedge	clk)			;
	nrst		= 1'b1								;
	read_C_L1	= 1'b1								;   // Initial reset

	for(i = 0; i<INIT; i = i + 1) begin	// fill way0.
		address		= address_array[i]					;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)  @(posedge   clk)			;
		ready_L2_L1		= 1'b1							;
		read_data_L2_L1	= data_array[i]					;
		repeat(L2_CLK)	@(posedge   clk)				;
		ready_L2_L1	= 1'b0								;
      
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	repeat(50)	@(posedge   clk)		;	// test_state 바뀔 때 구분.
											// Cache clock과 관련 X

	// 2. Read: L1 Miss - L2 Hit way1.
	$display("Cache Init start - way1")	;
	test_state	= 2	;

	for(i = INIT; i<TOTAL; i = i + 1) begin	// fill way1.
		address		= address_array[i]					;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)   @(posedge   clk)			;
		ready_L2_L1	= 1'b1								;
		read_data_L2_L1	= data_array[i]					;
		repeat(L2_CLK)	@(posedge   clk)				;
		ready_L2_L1	= 1'b0								;
      
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	read_C_L1   = 1'b0				;
	repeat(50)   @(posedge   clk)	;

	// 3. Read: L1 Hit way0.
	$display("%6d: Read-Hit-way0", $time);
	test_state	= 3					;

	read_C_L1	= 1'b1				;

	for(i = 0; i<INIT; i = i + 1) begin	// read hit way 0
		address	= address_array[i]						;

		$display("%6d: Read Address %h", $time, address);
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	repeat(50)	@(posedge   clk)	;

	// 4. Read: L1 Hit way1.
	$display("%6d: Read-Hit-way1", $time);
	test_state	= 4	;

	for(i = INIT; i<TOTAL; i = i + 1) begin	// read hit way 1
		address	= address_array[i]						;

		$display("%6d: Read Address %h", $time, address);
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	read_C_L1	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 5. Read: L1 Miss - L2 Hit (Replace way0)
	$display("%6d: Read-Miss-Hit (Replace way0)", $time);
	test_state	= 5							;

	read_C_L1	= 1'b1						;

	for(i = 0; i<INIT; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)   @(posedge   clk)			;
		ready_L2_L1	= 1'b1								;
		read_data_L2_L1	= rdata_array[i]				;
		repeat(L2_CLK)	@(posedge   clk)				;
		ready_L2_L1	= 1'b0								;
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	// 6. Read: L1 Miss - L2 Hit (Replace way1)
	$display("%6d: Read-Miss-Hit (Replace way1)", $time);
	test_state	= 6										;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)   @(posedge   clk)			;		
		ready_L2_L1		= 1'b1							;
		read_data_L2_L1	= rdata_array[i]				;
		repeat(L2_CLK)   @(posedge   clk)				;
		ready_L2_L1		= 1'b0							;
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	read_C_L1	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 7. Flush
	$display("%6d: FLUSH", $time)	;
	test_state	= 7					;

	flush		= 1'b1				;
	repeat(L1_CLK)	@(posedge	clk);
	flush		= 1'b0				;

	repeat(50)	@(posedge   clk)	;

	$display("For L2 Miss")			;

	// 8. Read: L1 Miss - L2 Miss way0.
	$display("%6d: Cache Init start - way0", $time)	;
	test_state	= 8									;

	read_C_L1	= 1'b1								;

	for(i = 0; i<INIT; i = i + 1) begin	// fill way0.
		address		= address_array[i]					;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(4 * L2_CLK + 8)  @(posedge   clk)		;
		ready_L2_L1	= 1'b1								;
		read_data_L2_L1	= data_array[i]					;
		repeat(L2_CLK)	@(posedge   clk)				;
		ready_L2_L1	= 1'b0								;
      
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	repeat(50)	@(posedge   clk)		;

	// 9. Read: L1 Miss - L2 Hit way1.
	$display("Cache Init start - way1")	;
	test_state	= 9	;

	for(i = INIT; i<TOTAL; i = i + 1) begin	// fill way1.
		address		= address_array[i]					;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(4 * L2_CLK + 8)  @(posedge   clk)		;
		ready_L2_L1	= 1'b1								;
		read_data_L2_L1	= data_array[i]					;
		repeat(L2_CLK)	@(posedge   clk)				;
		ready_L2_L1	= 1'b0								;
      
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	read_C_L1   = 1'b0				;
	repeat(50)   @(posedge   clk)	;

	// 10. Read: L1 Miss - L2 Miss (Replace way0)
	$display("%6d: Read-Miss-Miss (Replace way0)", $time)	;
	test_state	= 10										;
	read_C_L1	= 1'b1										;

	for(i = 0; i<INIT; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(4 * L2_CLK + 8)  @(posedge   clk)		;
		ready_L2_L1	= 1'b1								;
		read_data_L2_L1	= rdata_array[i]				;
		repeat(L2_CLK)	@(posedge   clk)				;
		ready_L2_L1	= 1'b0								;
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	repeat(50)   @(posedge   clk)	;

	// 11. Read: L1 Miss - L2 Miss (Replace way1)
	$display("%6d: Read-Miss-Miss (Replace way1)", $time)	;
	test_state	= 11										;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(4 * L2_CLK + 8)  @(posedge   clk)		;		
		ready_L2_L1		= 1'b1							;
		read_data_L2_L1	= rdata_array[i]				;
		repeat(L2_CLK)   @(posedge   clk)				;
		ready_L2_L1		= 1'b0							;
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	read_C_L1	= 1'b0				;	
	repeat(50)   @(posedge   clk)	;

	// init for write
	$display("%6d: FLUSH", $time)	;

	flush		= 1'b1				;
	repeat(L1_CLK)	@(posedge	clk);
	flush		= 1'b0				;

	repeat(50)   @(posedge   clk)	;

	// 12. Write: L1 Miss - L2 Hit. Way0
	$display("%6d: Write-Miss-Hit. Way0", $time)	;
	test_state	= 12								;

	write_C_L1	= 1'b1								;

	for(i = 0; i<INIT; i = i  + 1) begin
		address		= address_array[i]	;
		write_data	= wdata_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		ready_L2_L1		= 1'b1							;
		read_data_L2_L1	= data_array[i]					;
		repeat(L2_CLK)   @(posedge   clk)				;
		ready_L2_L1		= 1'b0							;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	// 13. Write: L1 Miss - L2 Hit. Way1
	$display("%6d: Write-Miss-Hit. Way1", $time)	;
	test_state	= 13								;

	for(i = INIT; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;
		write_data	= wdata_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		ready_L2_L1		= 1'b1							;
		read_data_L2_L1	= data_array[i]					;
		repeat(L2_CLK)   @(posedge   clk)				;
		ready_L2_L1		= 1'b0							;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	write_C_L1	= 1'b0				;
	repeat(50)   @(posedge   clk)	;

   // 14. Read: L1 Hit way0.
	$display("%6d: Read-Hit-way0", $time)	;
	test_state	= 14						;

	read_C_L1	= 1'b1						;

	for(i = 0; i<INIT; i = i + 1) begin	// read hit way 0
		address	= address_array[i]						;

		$display("%6d: Read Address %h", $time, address);
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	repeat(50)	@(posedge   clk)	;

	// 15. Read: L1 Hit way1.
	$display("%6d: Read-Hit-way1", $time);
	test_state	= 15					;

	for(i = INIT; i<TOTAL; i = i + 1) begin	// read hit way 1
		address	= address_array[i]						;

		$display("%6d: Read Address %h", $time, address);
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	read_C_L1	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 16. Write: L1 Hit. Way0
	$display("%6d: Write L1 Hit. Way0", $time)	;
	test_state	= 16								;

	write_C_L1	= 1'b1								;

	for(i = 0; i<INIT; i = i  + 1) begin
		address		= address_array[i]	;
		write_data	= wdata_array_2[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L1_CLK)	@(posedge   clk)			;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	// 17. Write: L1 Hit. Way1
	$display("%6d: Write L1 Hit. Way1", $time)	;
	test_state	= 17										;

	for(i = INIT; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;
		write_data	= wdata_array_2[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L1_CLK)	@(posedge   clk)			;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	write_C_L1	= 1'b0				;
	repeat(50)   @(posedge   clk)	;

	// 18. Read: L1 Miss - L2 Hit (Write back) way0
	$display("%6d: Read-Miss-Hit (Write back) way0", $time)	;
	test_state	= 18									;

	read_C_L1	= 1'b1									;

	for(i = 0; i<INIT; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)  @(posedge   clk)			;
		repeat(2 * L2_CLK)  @(posedge   clk)			;
		ready_L2_L1	= 1'b1								;
		read_data_L2_L1	= rdata_array[i]				;
		repeat(L2_CLK)	@(posedge   clk)				;
		ready_L2_L1	= 1'b0								;
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	// 19. Read: L1 Miss - L2 Hit (Write back) way1
	$display("%6d: Read-Miss-Hit (Write back) way1", $time)	;
	test_state	= 19										;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)  @(posedge   clk)			;		
		repeat(2 * L2_CLK)  @(posedge   clk)			;		
		ready_L2_L1		= 1'b1							;
		read_data_L2_L1	= rdata_array[i]				;
		repeat(L2_CLK)   @(posedge   clk)				;
		ready_L2_L1		= 1'b0							;
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	read_C_L1	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 20. Write: L1 Miss - L2 Miss. Way0
	$display("%6d: Write-Miss-Miss. Way0", $time)	;
	test_state	= 20								;

	write_C_L1	= 1'b1								;
	write_data	= wdata_array[i]					;

	for(i = 0; i<INIT; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address)	;
		repeat(2 * L1_CLK)	@(posedge   clk)				;
		repeat(4 * L2_CLK + 8)	@(posedge   clk)			;
		ready_L2_L1		= 1'b1								;
		read_data_L2_L1	= data_array[i]						;
		repeat(L2_CLK)   @(posedge   clk)					;
		ready_L2_L1		= 1'b0								;
		while(stall)	repeat(L1_CLK)	@(posedge   clk)	;
	end

	// 21. Write: L1 Miss - L2 Miss. Way1
	$display("%6d: Write-Miss-Miss. Way1", $time)	;
	test_state	= 21								;

	for(i = INIT; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;
		write_data	= wdata_array[i]	;

		$display("%6d: Write Address %h", $time, address)	;
		repeat(2 * L1_CLK)	@(posedge   clk)				;
		repeat(4 * L2_CLK + 8)	@(posedge   clk)			;
		ready_L2_L1		= 1'b1								;
		read_data_L2_L1	= data_array[i]						;
		repeat(L2_CLK)   @(posedge   clk)					;
		ready_L2_L1		= 1'b0								;
		while(stall)	repeat(L1_CLK)	@(posedge   clk)	;
	end

	write_C_L1	= 1'b0				;
	repeat(50)   @(posedge   clk)	;

	// 22. Read: L1 Miss - L2 Miss (Write back) way0
	$display("%6d: Read-Miss-Miss (Write back) way0", $time)	;
	test_state	= 22									;

	read_C_L1	= 1'b1									;

	for(i = 0; i<INIT; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L1_CLK)		@(posedge   clk)			;
		repeat(4 * L2_CLK + 8)  @(posedge   clk)			;
		repeat(2 * L2_CLK)  	@(posedge   clk)			;
		ready_L2_L1	= 1'b1									;
		read_data_L2_L1	= rdata_array[i]					;
		repeat(L2_CLK)	@(posedge   clk)					;
		ready_L2_L1	= 1'b0									;
		repeat(L1_CLK)	@(posedge   clk)					;
		while(stall)	repeat(L1_CLK)	@(posedge   clk)	;
	end

	// 23. Read: L1 Miss - L2 Miss (Write back) way1
	$display("%6d: Read-Miss-Hit (Write back) way1", $time)	;
	test_state	= 23										;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address			= replace_array[i]					;

		$display("%6d: Read Address %h", $time, address)	;

		repeat(2 * L1_CLK)		@(posedge   clk)			;
		repeat(4 * L2_CLK + 8)  @(posedge   clk)			;
		repeat(2 * L2_CLK)  	@(posedge   clk)			;
		ready_L2_L1	= 1'b1									;
		read_data_L2_L1	= rdata_array[i]					;
		repeat(L2_CLK)	@(posedge   clk)					;
		ready_L2_L1	= 1'b0									;
		repeat(L1_CLK)	@(posedge   clk)					;
		while(stall)	repeat(L1_CLK)	@(posedge   clk)	;
	end

	read_C_L1	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 24. Write Init
	$display("%6d: (Write Init)", $time)	;
	test_state	= 24								;

	write_C_L1	= 1'b1								;

	for(i = 0; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;
		write_data	= wdata_array[i]	;

		$display("%6d: Write Address %h", $time, address)	;

		repeat(2 * L1_CLK)	@(posedge   clk)				;
		repeat(2 * L2_CLK)	@(posedge   clk)				;
		ready_L2_L1		= 1'b1								;
		read_data_L2_L1	= data_array[i]						;
		repeat(L2_CLK)   @(posedge   clk)					;
		ready_L2_L1		= 1'b0								;
		while(stall)	repeat(L1_CLK)	@(posedge   clk)	;
	end

	repeat(50)	@(posedge   clk)	;

	// 25. Write: L1 Miss - L2 Hit. (Write back) Way0
	$display("%6d: Write-Miss-Hit. (Write back) Way0", $time)	;
	test_state	= 25								;

	write_C_L1	= 1'b1								;

	for(i = 0; i<INIT; i = i  + 1) begin
		address		= address_array[i]	;
		write_data	= wdata_array[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		ready_L2_L1		= 1'b1							;
		repeat(L2_CLK)   @(posedge   clk)				;
		ready_L2_L1		= 1'b0							;

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		ready_L2_L1		= 1'b1							;
		read_data_L2_L1	= data_array[i]					;		
		repeat(L2_CLK)   @(posedge   clk)				;
		ready_L2_L1		= 1'b0							;

		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	repeat(50)	@(posedge   clk)	;

	// 26. Write: L1 Miss - L2 Hit. (Write back) Way1
	$display("%6d: Write-Miss-Hit.(Write back) Way1", $time)	;
	test_state	= 26								;

	for(i = INIT; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;
		write_data	= wdata_array_2[i]	;

		$display("%6d: Write Address %h", $time, address);
		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)	@(posedge   clk)			;
		ready_L2_L1		= 1'b1							;
		repeat(L2_CLK)   @(posedge   clk)				;
		ready_L2_L1		= 1'b0							;

		repeat(2 * L2_CLK)	@(posedge   clk)			;
		ready_L2_L1		= 1'b1							;
		read_data_L2_L1	= data_array[i]					;		
		repeat(L2_CLK)   @(posedge   clk)				;
		ready_L2_L1		= 1'b0							;

		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	repeat(50)	@(posedge   clk)	;

	// 27. Write: L1 Miss - L2 Miss. (Write back) Way0
	$display("%6d: Write-Miss-Miss. (Write back) Way0", $time)	;
	test_state	= 27											;

	for(i = 0; i<INIT; i = i  + 1) begin
		address		= replace_array[i]						;
		write_data	= wdata_array[i]						;

		$display("%6d: Write Address %h", $time, address)	;
		repeat(2 * L1_CLK)	@(posedge   clk)				;
		repeat(2 * L2_CLK)	@(posedge   clk)				;
		ready_L2_L1		= 1'b1								;
		repeat(L2_CLK)   @(posedge   clk)					;
		ready_L2_L1		= 1'b0								;

		repeat(4 * L2_CLK + 8)	@(posedge   clk)			;
		ready_L2_L1		= 1'b1								;
		read_data_L2_L1	= data_array[i]						;		
		repeat(L2_CLK)   @(posedge   clk)					;
		ready_L2_L1		= 1'b0								;

		while(stall)	repeat(L1_CLK)	@(posedge   clk)	;
	end

	repeat(50)	@(posedge   clk)	;

	// 28. Write: L1 Miss - L2 Miss. (Write back) Way1
	$display("%6d: Write-Miss-Miss.(Write back) Way1", $time)	;
	test_state	= 28											;

	for(i = INIT; i<TOTAL; i = i  + 1) begin
		address		= replace_array[i]							;
		write_data	= wdata_array[i]							;

		$display("%6d: Write Address %h", $time, address)		;
		repeat(2 * L1_CLK)	@(posedge   clk)					;
		repeat(2 * L2_CLK)	@(posedge   clk)					;
		ready_L2_L1		= 1'b1									;
		repeat(L2_CLK)   @(posedge   clk)						;
		ready_L2_L1		= 1'b0									;

		repeat(4 * L2_CLK + 8)	@(posedge   clk)				;
		ready_L2_L1		= 1'b1									;
		read_data_L2_L1	= data_array[i]							;		
		repeat(L2_CLK)   @(posedge   clk)						;
		ready_L2_L1		= 1'b0									;

		while(stall)	repeat(L1_CLK)	@(posedge   clk)		;
	end

	$finish	;
end

initial begin
	$dumpfile("tb_L1_D_top.vcd");
	$dumpvars(u_L1_D_top)		;
end

endmodule