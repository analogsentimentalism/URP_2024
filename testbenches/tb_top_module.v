`timescale 1ns/1ns
`define	PERIOD	1

module tb_top #(
	parameter	TOTAL		= 1024,			// 전체 address 개수
	parameter	L1_INDEX	= 64,			// L1 캐시 Index 수
	parameter	TNUM		= 21,			// # Tag bits
	parameter	INUM		= 26 - TNUM		// # Index bits
) ();

// for CORE
reg				clk							;
reg				nrst						;

reg		[31:0]	address						;
reg				flush						;
reg				read_C_L1					;
reg				write_C_L1					;
reg		[31:0]	write_data					;

wire			stall						;
wire	[31:0]	read_data_L1_C				;

// for MEM
wire		[511:0]	read_data_MEM_L2			;
wire				ready_MEM_L2				;

wire			read_L2_MEM					;
wire			write_L2_MEM				;
wire	[7:0]	index_L2_MEM				;
wire	[17:0]	tag_L2_MEM					;
wire	[17:0]	write_tag_L2_MEM			;
wire	[511:0]	write_data_L2_MEM			;

// for Test
integer			i, j						;

integer			test_state					;
integer			aa, ra, ia					;
integer			wd, rd, ri					;

reg		[31:0]	address_array		[0:TOTAL-1]	;
reg		[31:0]	replace_array		[0:TOTAL-1]	;
reg		[31:0]	instruction_array	[0:TOTAL-1]	;
reg		[31:0]	wdata_array			[0:TOTAL-1]	;
reg		[511:0]	rdata_array			[0:TOTAL-1]	;
reg		[511:0]	rinstruction_array	[0:TOTAL-1]	;


top #() u_top (
	.clk				(	clk					),
	.nrst				(	nrst				),

	.address			(	address				),
	.flush				(	flush				),
	.read_C_L1			(	read_C_L1			),
	.write_C_L1			(	write_C_L1			),
	.write_data			(	write_data			),

	.stall				(	stall				),
	.read_data_L1_C		(	read_data_L1_C		),

	.read_data_MEM_L2	(	read_data_MEM_L2	),
	.ready_MEM_L2		(	ready_MEM_L2		),

	.read_L2_MEM		(	read_L2_MEM			),
	.write_L2_MEM		(	write_L2_MEM		),
	.index_L2_MEM		(	index_L2_MEM		),
	.tag_L2_MEM			(	tag_L2_MEM			),
	.write_tag_L2_MEM	(	write_tag_L2_MEM	),
	.write_data_L2_MEM	(	write_data_L2_MEM	)
);

mem #() u_mem (
	.clk				(	clk					),
	.rstn				(	nrst				),
	.read_L2_MEM		(	read_L2_MEM			),
	.write_L2_MEM		(	write_L2_MEM		),
	.ready_MEM_L2		(	ready_MEM_L2		),
	.read_data_MEM_L2	(	read_data_MEM_L2	)
);


`define	print(NUMBER, STRING)	\
$display("%d\t:\tTest state:\t%d", $time, NUMBER)	;	\
$display(STRING)					;

task read (
	input	[31:0]	adrs
);
	begin
		read_C_L1			= 'b1							;
		address				= adrs							;
		repeat(`PERIOD*2)	@(posedge	clk)					;
		while(stall)	repeat(`PERIOD)	@(posedge	clk)	;
		read_C_L1			= 'b0							;
	end
endtask

task write (
	input	[31:0]	adrs,
	input	[31:0]	wdata
);
	begin
		write_C_L1			= 'b1							;
		address				= adrs							;
		write_data			= wdata							;
		repeat(`PERIOD*2)	@(posedge	clk)					;
		while(stall)	repeat(`PERIOD)	@(posedge	clk)	;
		write_C_L1			= 'b0							;
	end
endtask

// task do_ready_MEM (
// 	input	[511:0]	rdata_array
// );
// 	begin
// 		read_data_MEM_L2	= rdata_array		;
// 		ready_MEM_L2		= 'b1				;
// 		repeat(`PERIOD)		@(posedge	clk)	;
// 		ready_MEM_L2		= 'b0				;
// 	end
// endtask

// task do_write_L1 (
// 	input	[31:0]	adrs,
// 	input	[31:0]	wdata
// );
// 	begin
// 		write_C_L1			= 'b1			;
// 		address				= adrs			;
// 		repeat(`PERIOD * 4)	@(posedge	clk)								;	// L1 read fin (miss or hit)

// 	end
// endtask

// task do_read_L1 (
// 	input	[31:0]	adrs,
// 	input	[511:0]	rdata_array
// );
// 	begin
// 		read_C_L1			= 'b1											;
// 		address				= adrs											;
// 		repeat(`PERIOD)		@(posedge	clk)								;	// L1 IDLE DONE														
// 		repeat(`PERIOD*2)	@(posedge	clk)								;	// L1 COMP DONE
// 		if (stall) begin														// L1 Miss or Dirty
// 			repeat(`PERIOD)	@(posedge	clk)			;
// 			if (u_top.read_L1_L2) begin											// L1 Miss
// 				repeat(`PERIOD*2)	@(posedge	clk)	;						// L2 COMP
// 				read_data_MEM_L2	= rdata_array		;
// 				ready_MEM_L2		= 'b1				;	// ready
// 				repeat(`PERIOD)		@(posedge	clk)	;
// 				ready_MEM_L2		= 'b0				;
// 			end
// 			else if ()begin

// 			end
// 		end


// 		else if (write_L2_MEM)
// 		end
// 																				// Hit
// 		while (stall & ~read_L2_MEM) repeat(`PERIOD)	@(posedge	clk)	;	// wait MEM read

// 		while (stall) repeat(`PERIOD)		@(posedge	clk)				;
// 		read_C_L1			= 'b0											;
// 	end
// endtask

initial begin: clk_gen
	forever #1 clk = ~ clk	;
end

// Init
initial begin: init
	clk				= '1	;
	nrst      		= '0	;
	address     	= '0	;
	read_C_L1		= '0	;
	write_C_L1		= '0	;
	flush			= '0	;

	aa	= $fopen("../testbenches/etc/tb_top_address_array.txt", "wb"		);
	ra	= $fopen("../testbenches/etc/tb_top_replace_array.txt", "wb"		);
	ia	= $fopen("../testbenches/etc/tb_top_instruction_array.txt", "wb"	);
	wd	= $fopen("../testbenches/etc/tb_top_write_data.txt", "wb"			);
	rd	= $fopen("../testbenches/etc/tb_top_read_data.txt", "wb"			);
	ri	= $fopen("../testbenches/etc/tb_top_read_instruction.txt", "wb"		);

	@(posedge clk);	// 파일 오픈 적용이 잘 안될까봐

	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses
		address_array[i]	= $urandom & 32'h0FFF_C03F | {4'h1, {(22-INUM){1'd0}}, i[0+:INUM], 6'd0}	;
		$fwrite(aa, "0x%h\n", address_array[i])								;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses with same index
		replace_array[i]	= $urandom & 32'hFFFF_C03F | {address_array[i][6+:INUM], 6'd0}	;
		$fwriteh(ra, "0x%h\n",replace_array[i])												;
	end
	for(i = 0; i<TOTAL; i = i + 1) begin   // random addresses
		instruction_array[i]	= $urandom & 32'h0FFF_C03F | {4'h0, {(22-INUM){1'd0}}, i[0+:INUM], 6'd0}	;
		$fwrite(aa, "0x%h\n", instruction_array[i])								;
	end
	// std::randomize(data_array);
	for(i = 0; i<TOTAL; i = i + 1) begin
		wdata_array[i]	= $urandom		;
		$fwrite(wd, "%d\n", wdata_array[i])	;
	end
	// std::randomize(rdata_array);
	for(i = 0; i<TOTAL; i = i + 1) begin
		for(j = 0; j<512; j = j + 32) begin
			rdata_array[i][j+:32]	= $urandom			;
			$fwrite(rd, "%d ", rdata_array[i][j+:32])	;
		end
		$fwrite(rd, "\n");
	end
	for(i = 0; i<TOTAL; i = i + 1) begin
		for(j = 0; j<512; j = j + 32) begin
			rinstruction_array[i][j+:32]	= $urandom			;
			$fwrite(ri, "%d ", rinstruction_array[i][j+:32])	;
		end
		$fwrite(ri, "\n");
	end
	$fclose(aa)	;
	$fclose(ra)	;
	$fclose(ia)	;
	$fclose(wd)	;
	$fclose(rd)	;
	$fclose(ri)	;
end

// data_array 이용해서 전부 랜덤으로 하다가, 검증 쉽게 하려고 순차로 바꿈.

initial begin: test
	test_state	= 0							;
	`print(test_state, "Init reset")

	nrst		= 'b1						;
	repeat(`PERIOD * 5)	@(posedge	clk)	;
	nrst		= 'b0						;

	repeat(`PERIOD * 5)	@(posedge	clk)	;
	nrst		= 'b1						;

repeat(`PERIOD * 10)	@(posedge	clk)	;

	// 1. Write all L2
	test_state = 1;
	`print(test_state, "Write all L2")

	for(i=0;i<TOTAL;i=i+1) begin
		write(address_array[i], wdata_array[i])					;
		$display("%d\t:\twrite:\t%h", $time, wdata_array[i])	;
	end

test_state	= 0	;
#100			;

	// 2. Fill all I
	test_state = 2;
	`print(test_state, "Fill all I in L1")

	for(i=0;i<L1_INDEX;i=i+1) begin
		read(instruction_array[i])											;
		$display("%d\t:\tread_data_L1_C (I):\t%h", $time, read_data_L1_C)	;
	end

test_state	= 0	;
#100			;

	// 3. Hit all I
	test_state = 3;
	`print(test_state, "Hit all I in L1")

	for(i=0;i<L1_INDEX;i=i+1) begin
		read(instruction_array[i]);
		$display("%d\t:\tread_data_L1_C (I):\t%h", $time, read_data_L1_C)	;
	end

test_state	= 0	;
#100			;

	// 4. Hit all D
	test_state = 4;
	`print(test_state, "Hit all D")

	for(i=0;i<L1_INDEX;i=i+1) begin
		read(address_array[i])					;
		$display("%d\t:\tread_data_L1_C (D):\t%h", $time, read_data_L1_C)	;
	end

test_state	= 0	;
#100			;

	// 5. Write all D
	test_state = 5;
	`print(test_state, "Write all D")

	for(i=0;i<TOTAL;i=i+1) begin
		write(address_array[i], {4'b0111, wdata_array[i][27:0]})			;
	end

test_state	= 0	;
#100			;

	// 6. Read all D in L2 (Write back)
	test_state = 6;
	`print(test_state, "Fill all D in L2")

	for(i=0;i<L1_INDEX;i=i+1) begin
		read(replace_array[i])					;
		$display("%d\t:\tread_data_L1_C (D):\t%h", $time, read_data_L1_C)	;
	end

	$finish();

end

endmodule