`timescale 1ns/1ns
module tb_L2_top #(
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
reg		[511:0]			write_data			;
reg		[511:0]			read_data_MEM_L2	;

reg						read_L1_L2			;
reg						flush				;
reg						ready_MEM_L2		;
reg						write_L1_L2			;

wire					ready_L2_L1			;
wire					read_L2_MEM			;
wire					write_L2_MEM		;

wire	[INUM_2 - 1:0]	index_L2_MEM		;
wire	[TNUM_2 - 1:0]	tag_L2_MEM			;
wire	[INUM_2 - 1:0]	write_index_L2_MEM	;
wire	[TNUM_2 - 1:0]	write_tag_L2_MEM	;

wire	[511:0]			read_data_L2_L1		;
wire	[511:0]			write_data_L2_MEM	;

L2_top u_L2_top (
	.clk				(	clk					),
    .nrst				(	nrst				),

    .tag_L1_L2			(	address[31-:TNUM]	),
    .index_L1_L2		(	address[6+:INUM]	),
	.write_data			(	write_data			),
	.read_data_MEM_L2	(	read_data_MEM_L2	),

    .read_L1_L2			(	read_L1_L2			),
    .flush				(	flush				),
    .ready_MEM_L2		(	ready_MEM_L2		),

	.write_L1_L2		(	write_L1_L2			),
	.ready_L2_L1		(	ready_L2_L1			),
    .read_L2_MEM		(	read_L2_MEM			),
	.write_L2_MEM		(	write_L2_MEM		),

	.index_L2_MEM		(	index_L2_MEM		),
	.tag_L2_MEM			(	tag_L2_MEM			),
	.write_tag_L2_MEM	(	tag_L2_MEM			),

	.read_data_L2_L1	(	read_data_L2_L1		),
	.write_data_L2_MEM	(	write_data_L2_MEM	)
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
	read_L1_L2	= '0	;
	flush		= '0	;
	ready_MEM_L2	= '0	;
	write_L1_L2	= '0	;

	aa	= $fopen("../testbenches/etc/tb_L2_top_address_array.txt", "wb")	;
	ra	= $fopen("../testbenches/etc/tb_L2_top_replace_array.txt", "wb")	;
	d	= $fopen("../testbenches/etc/tb_L2_top_data_array.txt", "wb")		;
	r	= $fopen("../testbenches/etc/tb_L2_top_rdata_array.txt", "wb")	;
	w	= $fopen("../testbenches/etc/tb_L2_top_wdata_array.txt", "wb")	;
	w_2	= $fopen("../testbenches/etc/tb_L2_top_wdata_array_2.txt", "wb")	;

	@(posedge clk);	// 파일 오픈 적용이 잘 안될까봐

	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses
		address_array[i]	= $urandom & 32'hFFFF_C03F | {i[0+:INUM], 6'd0}	;
		$fwrite(aa, "0x%h\n", address_array[i])								;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses with same index
		replace_array[i]	= $urandom & 32'hFFFF_C03F | {address_array[i][6+:INUM], 6'd0}	;
		$fwriteh(ra, "0x%h\n",replace_array[i])												;
	end
	// std::randomize(data_array);
	for(i = 0; i<TOTAL; i = i + 1) begin
		for(j = 0; j<512; j = j + 32) begin
			data_array[i][j+:32]	= $urandom		;
			$fwrite(d, "%d ", data_array[i][j+:32])	;
		end
		$fwrite(d, "\n");
	end
	// std::randomize(rdata_array);
	for(i = 0; i<TOTAL; i = i + 1) begin
		for(j = 0; j<512; j = j + 32) begin
			rdata_array[i][j+:32]	= $urandom			;
			$fwrite(r, "%d ", rdata_array[i][j+:32])	;
		end
		$fwrite(r, "\n");
	end
	// std::randomize(data_array);
	for(i = 0; i<TOTAL; i = i + 1) begin
		for(j = 0; j<512; j = j + 32) begin
			wdata_array[i][j+:32]	= $urandom		;
			$fwrite(w, "%d ", wdata_array[i][j+:32])	;
		end
		$fwrite(w, "\n");
	end
	// std::randomize(rdata_array);
	for(i = 0; i<TOTAL; i = i + 1) begin
		for(j = 0; j<512; j = j + 32) begin
			wdata_array_2[i][j+:32]	= $urandom			;
			$fwrite(w_2, "%d ", wdata_array_2[i][j+:32])	;
		end
		$fwrite(w_2, "\n");
	end
	$fclose(aa)	;
	$fclose(ra)	;
	$fclose(d)	;
	$fclose(r)	;
	$fclose(w)	;
	$fclose(w_2);
end


// test state 1~4
    property p1;
		@(posedge clk) (read_L1_L2 && $rose(read_L2_MEM)) |-> $rose(ready_MEM_L2) && read_data_MEM_L2;
	endproperty

	a1: assert property(p1)
	    $display("Read and Ready Handshake success");
   		else
   		$display("Handshake failed");


	property p2;
		@(posedge clk) (read_L1_L2 &&  !$stable(read_data_MEM_L2)) |-> ##2 (read_data_L2_L1==read_data_MEM_L2);
	endproperty 

	a2: assert property(p2)
		$display("Mem read data to L1 delivery success");
		else
		$display("Deilvery failed");












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

		for(i = INIT*j; i<INIT*(j+1); i = i + 1) begin	// fill way0.
			address		= address_array[i]				;

			$display("%6d: Read Address %h\tindex:\t%3d", $time, address, address[6+:INUM]);

			repeat(2 * L2_CLK)	@(posedge   clk)			;
			repeat(2 * MEM_CLK)  @(posedge   clk)			;
			ready_MEM_L2	= 1'b1								;
			read_data_MEM_L2	= data_array[i]					;
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
			read_data_MEM_L2	= data_array[i]				;
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
			read_data_MEM_L2	= data_array[i]				;
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
			read_data_MEM_L2	= rdata_array[i]			;
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
			write_data	= wdata_array[i]	;

			$display("%6d: Write Address %h", $time, address);
			repeat(2 * L2_CLK)	@(posedge   clk)			;
			repeat(2 * MEM_CLK)	@(posedge   clk)			;
			ready_MEM_L2		= 1'b1						;
			repeat(MEM_CLK)   @(posedge   clk)				;
			ready_MEM_L2		= 1'b0						;
			repeat(2 * L2_CLK)	@(posedge   clk)			;
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
			write_data	= wdata_array_2[i]	;

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
			read_data_MEM_L2	= rdata_array[i]			;
			repeat(MEM_CLK)	@(posedge   clk)				;
			ready_MEM_L2	= 1'b0							;
			repeat(2 * L2_CLK)	@(posedge   clk)			;
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
			write_data	= wdata_array[i]	;

			$display("%6d: Write Address %h", $time, address)	;
			repeat(2 * L2_CLK)	@(posedge   clk)				;
			repeat(4 * MEM_CLK + 8)	@(posedge   clk)			;
			ready_MEM_L2		= 1'b1							;
			repeat(MEM_CLK)   @(posedge   clk)					;
			ready_MEM_L2		= 1'b0							;
			repeat(2 * L2_CLK)   @(posedge   clk)				;
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
			ready_MEM_L2		= 1'b1							;
			read_data_MEM_L2	= rdata_array[i]				;
			repeat(MEM_CLK)	@(posedge   clk)					;
			ready_MEM_L2	= 1'b0								;
			repeat(2 * L2_CLK)	@(posedge   clk)				;
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
		write_data	= wdata_array[i]	;

		$display("%6d: Write Address %h", $time, address)	;

		repeat(2 * L2_CLK)	@(posedge   clk)				;
		repeat(2 * MEM_CLK)	@(posedge   clk)				;
		ready_MEM_L2		= 1'b1							;
		repeat(MEM_CLK)   @(posedge   clk)					;
		ready_MEM_L2		= 1'b0							;
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
			write_data	= wdata_array_2[i]	;

			$display("%6d: Write Address %h", $time, address);
			repeat(2 * L2_CLK)	@(posedge   clk)			;
			repeat(2 * MEM_CLK)	@(posedge   clk)			;
			ready_MEM_L2		= 1'b1						;
			repeat(MEM_CLK)   @(posedge   clk)				;
			ready_MEM_L2		= 1'b0						;

			repeat(2 * MEM_CLK)	@(posedge   clk)			;
			ready_MEM_L2		= 1'b1						;
			repeat(MEM_CLK)   @(posedge   clk)				;
			ready_MEM_L2		= 1'b0						;
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
	$dumpfile("tb_L2_top.vcd");
	$dumpvars(u_L2_top)		;
end

endmodule