`timescale 1ns/1ns
module tb_L1_I_controller ();

reg				clk			;
reg				nrst		;

reg		[31:0]	address		; 
reg				read_C_L1	;
reg				flush		;
reg				ready_L2_L1	;

wire			stall		;
wire			refill		;
wire			read_L1_L2	;
wire			way			;
wire	[4:0]	index_L1_L2	;
wire	[20:0]	tag_L1_L2	;

L1_I_controller u_L1_I_controller (

	.clk			(clk			),
    .nrst			(nrst			),

    .tag_C_L1		(address[31:11]	),
    .index_C_L1		(address[10:6]	),
    .read_C_L1		(read_C_L1		),
    .flush			(flush			),
    .ready_L2_L1	(ready_L2_L1	),

    .stall			(stall			),
	.refill			(refill			),
	.way			(way			),
    .read_L1_L2		(read_L1_L2		),
   
	.index_L1_L2	(index_L1_L2	),
	.tag_L1_L2		(tag_L1_L2		)
);

// Signals for Testbench
reg		[63:0]	address_array	[0:9999]	;
reg		[63:0]	replace_array	[0:9999]	;
integer			i, j, EXIT					;

reg		[2:0]	test_state					;

always begin
#1   clk		= ~clk						;
end

// Init
initial begin: init
   test_state	= 3'd0	;

   clk			= 1'b1	;
   nrst      	= 1'b0	;
   address      = 64'b0	;
   read_C_L1	= 1'b0	;
   flush		= 1'b0	;
   ready_L2_L1	= 1'b0	;

	for(i = 0; i<30; i = i + 1) begin   // random addresses
		address_array[i]	= $urandom & 32'hFFFF_F03C | {i[5:0], 6'b000000}	;
		address_array[i+30]	= $urandom & 32'hFFFF_F03C | {i[5:0], 6'b000000}	;	// Same index
		$display("%2dth address:\t%8h", i, address_array[i])					;
	end
	for(i = 0; i<30; i = i + 1) begin   // random addresses with same index
		replace_array[i]	= $urandom & 32'hFFFF_F03C | {address_array[i][11:6], 6'b000000}	;
		replace_array[i+30]	= $urandom & 32'hFFFF_F03C | {address_array[i][11:6], 6'b000000}	;	// Same index
		$display("%2dth address\t:\t%8h", i, replace_array[i])									;
	end
end

initial begin: test

	// 0. Cache Init (Cold Miss) -> Read: Miss - (Memory) Hit
	$display("Cache Init start");

	nrst		= 1'b1			;
	repeat(5)	@(posedge	clk);
	nrst		= 1'b0			;

	repeat(5)	@(posedge	clk);
	nrst		= 1'b1			;
	read_C_L1	= 1'b1			;   // Initial reset

	for(i = 0; i<20; i = i + 1) begin	// for way1. Cold Miss
		address		= address_array[i]				;

		$display("%6d: Read Address %h", i, address);

		repeat(4)   @(posedge   clk)				;
		ready_L2_L1	= 1'b1							;
		@(posedge   clk)							;
		ready_L2_L1	= 1'b0							;
      
		while(stall)	@(posedge   clk)			;
	end

	for(i = 30; i<40; i = i + 1) begin	// for way2. Conflict Miss
		address		= address_array[i]				;

		$display("%6d: Read Address %h", i, address);

		repeat(4)   @(posedge   clk)				;
		ready_L2_L1	= 1'b1							;
		@(posedge   clk)							;
		ready_L2_L1	= 1'b0							;
      
		while(stall)	@(posedge   clk)			;
	end

	read_C_L1   = 1'b0				;
	repeat(50)   @(posedge   clk)	;

   // 1. Read: Hit
	$display("%6d: Read-Hit", $time);
	test_state	= 3'd1				;

	read_C_L1	= 1'b1				;

	for(i = 0; i<10; i = i + 1) begin	// read hit way 0
		address	= address_array[i]						;

		$display("%6d: Read Address %h", $time, address);
		@(posedge   clk)								;
		while(stall)	@(posedge   clk)				;
	end

	for(i = 30; i<40; i = i + 1) begin	// read hit way 1
		address	= address_array[i]						;

		$display("%6d: Read Address %h", $time, address);
		@(posedge   clk)								;
		while(stall)	@(posedge   clk)				;
	end

	read_C_L1	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 2. Read: Miss - (Memory) Miss
	$display("%6d: Read-Miss-Miss", $time)	;
	test_state	= 3'd2						;

	read_C_L1	= 1'b1						;

	for(i = 20; i<30; i = i + 1) begin	// Cold miss
		address			= address_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(10)   @(posedge   clk)					;
		ready_L2_L1		= 1'b1							;
		@(posedge   clk)								;
		ready_L2_L1		= 1'b0							;
		@(posedge   clk)								;
		while(stall) @(posedge   clk)					;
	end

	for(i = 40; i<50; i = i + 1) begin	// Conflict miss
		address			= address_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(10)   @(posedge   clk)					;
		ready_L2_L1		= 1'b1							;
		@(posedge   clk)								;
		ready_L2_L1		= 1'b0							;
		@(posedge   clk)								;
		while(stall) @(posedge   clk)					;
	end

	read_C_L1	= 1'b0				;
	repeat(50)	@(posedge   clk)	;

	// 3. Cache Replacement
	$display("%6d: Cache Replacement", $time)	;
	test_state	= 3'd3							;

	read_C_L1	= 1'b1							;

	for(i = 0; i<5; i = i + 1) begin	// replace way0, memory hit
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(4)   @(posedge   clk)					;
		ready_L2_L1		= 1'b1							;
		@(posedge   clk)								;
		ready_L2_L1		= 1'b0							;
		@(posedge   clk)								;
		while(stall) @(posedge   clk)					;
	end

	test_state	= 3'd4							;

	for(j = 0; j < 2; j = j + 1) begin
		for(i = 5; i < 10; i = i + 1) begin	// replace way1, memory hit
		address			= j ? replace_array[i] : address_array[i]	;

		$display("%6d: Read Address %h", $time, address)			;
		repeat(4)   @(posedge   clk)								;
		ready_L2_L1		= 1'b1										;
		@(posedge   clk)											;
		ready_L2_L1		= 1'b0										;
		@(posedge   clk)											;
		while(stall) @(posedge   clk)								;
		end
	end

	test_state	= 3'd5							;

	for(i = 10; i<15; i = i + 1) begin	// replace way0, memory miss
		address			= replace_array[i]				;

		$display("%6d: Read Address %h", $time, address);
		repeat(10)   @(posedge   clk)					;
		ready_L2_L1		= 1'b1							;
		@(posedge   clk)								;
		ready_L2_L1		= 1'b0							;
		@(posedge   clk)								;
		while(stall) @(posedge   clk)					;
	end

	test_state	= 3'd6							;

	for(j = 0; j < 2; j = j + 1) begin
		for(i = 15; i < 20; i = i + 1) begin	// replace way1, memory miss
		address			= j ? replace_array[i] : address_array[i]	;

		$display("%6d: Read Address %h", $time, address)			;
		repeat(10)   @(posedge   clk)								;
		ready_L2_L1		= 1'b1										;
		@(posedge   clk)											;
		ready_L2_L1		= 1'b0										;
		@(posedge   clk)											;
		while(stall) @(posedge   clk)								;
		end
	end

	// 7. Flush
	$display("%6d: FLUSH", $time)	;
	test_state	= 3'd7				;

	flush		= 1'b1				;

	repeat(50)	@(posedge   clk)	;
	$finish							;
end

initial begin
	$dumpfile("tb_L1_I_controller.vcd")	;
	$dumpvars(u_L1_I_controller)		;
end

endmodule