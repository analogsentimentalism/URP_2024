`timescale 1ns/1ns
module tb_L1_I_controller #(
	parameter	L1_CLK	= 1,			// L1의 클락
	parameter	L2_CLK	= 1,			// L2의 클락
	parameter	TOTAL	= 64,			// 전체 address 개수
	parameter	INIT	= 32,			// 처음 채울 개수
	parameter	TNUM	= 21,			// # Tag bits
	parameter	INUM	= 26 - TNUM,	// # Index bits
	parameter	TNUM_2	= 18,			// # Tag bits for L2
	parameter	INUM_2	= 26 - TNUM_2	// # Index bits for L2
) ();

reg						clk				;
reg						nrst			;

reg		[31:0]			address			; 
reg						read_C_L1		;
reg						flush			;
reg						ready_L2_L1		;

wire					stall			;
wire					refill			;
wire					read_L1_L2		;
wire					way				;
wire	[INUM_2 - 1:0]	index_L1_L2		;
wire	[TNUM_2 - 1:0]	tag_L1_L2		;

L1_I_controller u_L1_I_controller (

	.clk			(	clk					),
    .nrst			(	nrst				),

    .tag_C_L1		(	address[31-:TNUM]	),
    .index_C_L1		(	address[6+:INUM]	),
    .read_C_L1		(	read_C_L1			),
    .flush			(	flush				),
    .ready_L2_L1	(	ready_L2_L1			),

    .stall			(	stall				),
	.refill			(	refill				),
	.way			(	way					),
    .read_L1_L2		(	read_L1_L2			),
   
	.index_L1_L2	(	index_L1_L2			),
	.tag_L1_L2		(	tag_L1_L2			)
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
	read_C_L1	= '0	;
	flush		= '0	;
	ready_L2_L1	= '0	;

	aa	= $fopen("../testbenches/etc/tb_L1_I_controller_address_array.txt", "wb");
	ra	= $fopen("../testbenches/etc/tb_L1_I_controller_replace_array.txt", "wb");

	@(posedge clk);	// 파일 오픈 적용이 잘 안될까봐

	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses
		address_array[i]	= $urandom & 32'hFFFF_F83C | {i[0+:INUM], 6'd0};
		$fwrite(aa, "%h\n", address_array[i])									;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses with same index
		replace_array[i]	= $urandom & 32'hFFFF_F83C | {address_array[i][6+:INUM], 6'd0}	;
		$fwriteh(ra, "%h\n",replace_array[i])													;
	end

	$fclose(aa);
	$fclose(ra);
end


initial begin: test

	// 1. Read: L1 Miss - L2 Hit way0.
	$display("%6d: Cache Init start - way0", $time)		;
	test_state	= 1							;

	nrst		= 1'b1						;
	repeat(5 * L1_CLK)	@(posedge	clk)	;
	nrst		= 1'b0						;

	repeat(5 * L1_CLK)	@(posedge	clk)	;
	nrst		= 1'b1						;
	read_C_L1	= 1'b1						;   // Initial reset

	for(i = 0; i<INIT; i = i + 1) begin	// fill way0.
		address		= address_array[i]				;

		$display("%6d: Read Address %h", $time, address);

		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)  @(posedge   clk)			;
		ready_L2_L1	= 1'b1								;
		repeat(L2_CLK)	@(posedge   clk)				;
		ready_L2_L1	= 1'b0								;
      
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
		
		sequence s1;
		$fell(refill) #(2*L1_CLK) $fell(stall);
 		endsequence
	
		property p1;
		@(posedge clk) s1;
		endproperty

		a1: assert property(p1)
	        $display("property p1 succeeded");
   		else
   			$display("property p1 failed");

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
		repeat(L2_CLK)	@(posedge   clk)				;
		ready_L2_L1	= 1'b0								;
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	// 11. Read: L1 Miss - L2 Miss (Replace way1)
	$display("%6d: Read-Miss-Miss (Replace way1)", $time)	;
	test_state	= 11										;

	for(i = INIT; i<TOTAL; i = i + 1) begin
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(2 * L1_CLK)	@(posedge   clk)			;
		repeat(2 * L2_CLK)   @(posedge   clk)			;		
		ready_L2_L1		= 1'b1							;
		repeat(L2_CLK)   @(posedge   clk)				;
		ready_L2_L1		= 1'b0							;
		repeat(L1_CLK)	@(posedge   clk)				;
		while(stall)	repeat(L1_CLK)	@(posedge   clk);
	end

	$finish	;
end

initial begin
	$dumpfile("tb_L1_I_controller.vcd")	;
	$dumpvars(u_L1_I_controller)		;
end

endmodule