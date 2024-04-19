`timescale 1ns/1ns
module tb_L2_controller #(
	parameter	L2_CLK	= 1,			// L2의 클락
	parameter	MEM_CLK	= 1,			// MEM의 클락
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
	test_state	= 0							;

	nrst		= 1'b1						;
	repeat(5 * L2_CLK)	@(posedge	clk)	;
	nrst		= 1'b0						;

	repeat(5 * L2_CLK)	@(posedge	clk)	;
	nrst		= 1'b1						;
	

	// 1-4. Read: L2 Miss - MEM Hit way0-3.
	for(j = 0; j < 4; j = j + 1) begin
		$display("%6d: Cache Init start - way%d", $time, j)	;
		test_state	= test_state + 1							;

		read_L1_L2	= 1'b1						;   // Initial reset

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin	// fill way0-->way1-->way2-->way3
			address		= address_array[i]				;

			$display("%6d: Read Address %h", $time, address);

			repeat(2 * L2_CLK)	@(posedge   clk)			;
			repeat(2 * MEM_CLK)  @(posedge   clk)			;
			ready_MEM_L2	= 1'b1								;
			repeat(MEM_CLK)	@(posedge   clk)				;
			ready_MEM_L2	= 1'b0								;
			repeat(2 * L2_CLK)	@(posedge   clk)			;
		end
		read_L1_L2   = 1'b0				;
		repeat(50)	@(posedge   clk)	;	// test_state 바뀔 때 구분.
											// Cache clock과 관련 X
	end

	repeat(50)   @(posedge   clk)	;

	// 5-8. Read: L2 Hit way0-3.

	for(j = 0; j<4; j = j + 1) begin
		$display("%6d: Read-Hit-way%d", $time, j)	;
		test_state	= test_state + 1				;
		
		read_L1_L2	= 1'b1				;

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
			address	= address_array[i]						;

			$display("%6d: Read Address %h", $time, address);
			repeat(3 * L2_CLK)	@(posedge   clk)				;
		end

		read_L1_L2   = 1'b0				;
		repeat(50)	@(posedge   clk)	;

	end

	repeat(50)	@(posedge   clk)	;

	// 9-12. Read: L2 Miss - MEM Hit (Replace way0-3)

	for(j = 0; j<4; j = j + 1) begin
		$display("%6d: Read-Miss-Hit (Replace way%d)", $time, j)	;
		test_state	= test_state + 1								;
		read_L1_L2	= 1'b1				;

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
			address			= replace_array[i]				;

			$display("%6d: Read Address %h", $time, address);

			repeat(2 * L2_CLK)	@(posedge   clk)			;
			repeat(2 * MEM_CLK)   @(posedge   clk)			;
			ready_MEM_L2	= 1'b1							;
			repeat(MEM_CLK)	@(posedge   clk)				;
			ready_MEM_L2	= 1'b0							;
			repeat(2 * L2_CLK)	@(posedge   clk)				;
		end

		read_L1_L2	= 1'b0				;
		repeat(50)	@(posedge   clk)	;
	end

	repeat(50)	@(posedge   clk)	;

	// 13. Flush
	$display("%6d: FLUSH", $time)	;
	test_state	= 13				;

	flush		= 1'b1				;
	repeat(L2_CLK)	@(posedge	clk);
	flush		= 1'b0				;

	repeat(50)	@(posedge   clk)	;

	$display("For MEM Miss")			;

	// 14-17. Read: L2 Miss - MEM Miss way0-3.

	for(j = 0; j<4; j = j + 1) begin
		$display("%6d: Cache Init start - way%d", $time, j)	;
		test_state	= test_state + 1						;
		read_L1_L2	= 1'b1	;

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
			address		= address_array[i]					;

			$display("%6d: Read Address %h", $time, address);

			repeat(2 * L2_CLK)	@(posedge   clk)			;
			repeat(4 * MEM_CLK + 8)  @(posedge   clk)		;
			ready_MEM_L2	= 1'b1							;
			repeat(MEM_CLK)	@(posedge   clk)				;
			ready_MEM_L2	= 1'b0							;
			repeat(2 * L2_CLK)	@(posedge   clk)				;
		end
		read_L1_L2	= 1'b0	;
		repeat(50)	@(posedge   clk)	;
	end

	repeat(50)	@(posedge   clk)	;

	// 18-21. Read: L2 Miss - MEM Miss (Replace way0-3)
	

	for(j = 0; j < 4; j = j + 1) begin
		$display("%6d: Read-Miss-Miss (Replace way%d)", $time, j)	;
		test_state	= test_state + 1								;
		read_L1_L2	= 1'b1	;
		

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
			address			= replace_array[i]				;

			$display("%6d: Read Address %h", $time, address);

			repeat(2 * L2_CLK)	@(posedge   clk)			;
			repeat(4 * MEM_CLK + 8)  @(posedge   clk)		;
			ready_MEM_L2	= 1'b1							;
			repeat(MEM_CLK)	@(posedge   clk)				;
			ready_MEM_L2	= 1'b0							;
			repeat(2 * L2_CLK)	@(posedge   clk)				;
		end
		read_L1_L2	= 1'b0				;
		repeat(50)   @(posedge   clk)	;

	end

		
	repeat(50)   @(posedge   clk)	;

	// init for write
	$display("%6d: FLUSH", $time)	;

	flush		= 1'b1				;
	repeat(L2_CLK)	@(posedge	clk);
	flush		= 1'b0				;

	repeat(50)   @(posedge   clk)	;

	// 22-25. Write: L2 Miss - MEM Hit. Way0-3
	

	for(j = 0; j < 4; j = j + 1) begin
		$display("%6d: Write-Miss-Hit. Way%d", $time, j)	;
		test_state	= test_state + 1						;
		write_L1_L2	= 1'b1	;

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
			address		= address_array[i]	;

			$display("%6d: Write Address %h", $time, address);
			repeat(2 * L2_CLK)	@(posedge   clk)			;
			repeat(2 * MEM_CLK)	@(posedge   clk)			;
			ready_MEM_L2		= 1'b1						;
			repeat(MEM_CLK)   @(posedge   clk)				;
			ready_MEM_L2		= 1'b0						;
			repeat(2 * L2_CLK)	@(posedge   clk)				;
		end
		write_L1_L2	= 1'b0				;
		repeat(50)   @(posedge   clk)	;

	end

	
	repeat(50)   @(posedge   clk)	;

   // 25-28. Read: L2 Hit way0-3.
	

   for(j = 0; j < 4; j = j + 1) begin
		$display("%6d: Read-Hit-way%d", $time, j)	;
		test_state	= test_state + 1				;
		read_L1_L2	= 1'b1				;

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
			address	= address_array[i]						;

			$display("%6d: Read Address %h", $time, address);
			repeat(4 * L2_CLK)	@(posedge   clk)				;
		end
		read_L1_L2	= 1'b0				;
		repeat(50)	@(posedge   clk)	;

   end

   
   repeat(50)	@(posedge   clk)	;

	// 29-32. Write: L2 Hit. Way0-3.
	

	for(j = 0; j < 4; j = j + 1) begin
	$display("%6d: Write L2 Hit. Way%d", $time, j)	;
	test_state	= test_state + 1					;
	write_L1_L2	= 1'b1								;

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
			address		= address_array[i]	;

			$display("%6d: Write Address %h", $time, address);
			repeat(3 * L2_CLK)	@(posedge   clk)			;
		end
	write_L1_L2	= 1'b0				;
	repeat(50)   @(posedge   clk)	;

	end

	
	repeat(50)   @(posedge   clk)	;

	// 33-36. Read: L2 Miss - MEM Hit (Write back) way0-3.
	

	for(j=0; j<4; j = j + 1) begin
	$display("%6d: Read-Miss-Hit (Write back) way%d", $time, j)	;
	test_state	= test_state + 1								;
	read_L1_L2	= 1'b1									;

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
			address			= replace_array[i]				;

			$display("%6d: Read Address %h", $time, address);

			repeat(2 * L2_CLK)	@(posedge   clk)			;
			repeat(2 * MEM_CLK)  @(posedge   clk)			;
			repeat(2 * MEM_CLK)  @(posedge   clk)			;
			ready_MEM_L2	= 1'b1							;
			repeat(MEM_CLK)	@(posedge   clk)				;
			ready_MEM_L2	= 1'b0							;
			repeat(2 * L2_CLK)	@(posedge   clk)				;
		end
		read_L1_L2	= 1'b0				;
		repeat(50)   @(posedge   clk)	;

	end

	
	repeat(50)	@(posedge   clk)	;

	// 37-40. Write: L2 Miss - MEM Miss. Way0-3.
	

	for(j=0;j<4; j=j+1) begin
		$display("%6d: Write-Miss-Miss. Way%d", $time, j)	;
		test_state	= test_state + 1					;
		write_L1_L2	= 1'b1									;

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
			address		= address_array[i]	;

			$display("%6d: Write Address %h", $time, address)	;
			repeat(2 * L2_CLK)	@(posedge   clk)				;
			repeat(4 * MEM_CLK + 8)	@(posedge   clk)			;
			ready_MEM_L2		= 1'b1								;
			repeat(MEM_CLK)   @(posedge   clk)					;
			ready_MEM_L2		= 1'b0								;
			repeat(2 * L2_CLK)   @(posedge   clk)					;
		end
		write_L1_L2	= 1'b0				;
		repeat(50)   @(posedge   clk)	;

	end

	
	repeat(50)	@(posedge   clk)	;

	// 41-44. Read: L2 Miss - MEM Miss (Write back) way0-3.
	

	for(j=0;j<4; j=j+1) begin
		$display("%6d: Read-Miss-Miss (Write back) way%d", $time, j);
		test_state	= test_state + 1								;
		read_L1_L2	= 1'b1									;

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
			address			= replace_array[i]				;

			$display("%6d: Read Address %h", $time, address);

			repeat(2 * L2_CLK)		@(posedge   clk)			;
			repeat(4 * MEM_CLK + 8)  @(posedge   clk)			;
			repeat(2 * MEM_CLK)  	@(posedge   clk)			;
			ready_MEM_L2	= 1'b1									;
			repeat(MEM_CLK)	@(posedge   clk)					;
			ready_MEM_L2	= 1'b0									;
			repeat(2 * L2_CLK)	@(posedge   clk)					;
		end
		read_L1_L2	= 1'b0				;
		repeat(50)	@(posedge   clk)	;
	end

	
	repeat(50)	@(posedge   clk)	;

	// 45. Write Init
	$display("%6d: (Write Init)", $time)	;
	test_state	= 45								;

	write_L1_L2	= 1'b1								;

	for(i = 0; i<TOTAL; i = i  + 1) begin
		address		= address_array[i]	;

		$display("%6d: Write Address %h", $time, address)	;

		repeat(2 * L2_CLK)	@(posedge   clk)				;
		repeat(2 * MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2		= 1'b1								;
		repeat(MEM_CLK)   @(posedge   clk)					;
		ready_MEM_L2		= 1'b0								;
		repeat(2 * L2_CLK)	@(posedge   clk)				;
	end

	write_L1_L2	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 46-49. Write: L2 Miss - MEM Hit. (Write back) Way0-3.
	
	for(j=0;j<4; j=j+1) begin
		$display("%6d: Write-Miss-Hit. (Write back) Way%d", $time, j)	;
		test_state	= test_state + 1									;
		write_L1_L2	= 1'b1								;

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin
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
			repeat(2 * L2_CLK)	@(posedge   clk)			;
		end
		write_L1_L2	= 1'b0				;
		repeat(50)	@(posedge   clk)	;
	end

	
	repeat(50)	@(posedge   clk)	;

	// 50-53. Write: L2 Miss - MEM Miss. (Write back) Way0-3.
	

	for(j=0;j<4; j=j+1) begin
		$display("%6d: Write-Miss-Hit. (Write back) Way%d", $time, j)	;
		test_state	= test_state + 1									;
		write_L1_L2	= 1'b1				;

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
			repeat(2 * L2_CLK)	@(posedge   clk)			;
		end
		write_L1_L2 = 1'b0;
		repeat(50)	@(posedge   clk)	;
	end

	repeat(50)	@(posedge   clk)	;

	$finish	;

end

initial begin
	$dumpfile("tb_L2_controller.vcd")	;
	$dumpvars(u_L2_controller)		;
end

endmodule