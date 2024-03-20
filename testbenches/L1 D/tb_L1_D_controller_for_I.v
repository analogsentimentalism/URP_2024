`timescale 1ns/1ns
module tb_L1_D_controller ();

reg					clk;
reg					nrst;

reg		[31:0]		address; 
reg					read_C_L1;
reg					write_C_L1;
reg					flush;
reg					ready_L2_L1;

wire				stall;
wire				refill;
wire				update;
wire				read_L1_L2;
wire				write_L1_L2;

L1_I_controller u_L1_D_controller (
    .clk				(clk),
    .nrst				(nrst),

    .tag				(address[31:12]),
    .index				(address[11:6]),
    .read_C_L1			(read_C_L1),
    .flush				(flush),
    .ready_L2_L1		(ready_L2_L1),
    .write_C_L1			(write_C_L1),

    .stall				(stall),
	.refill				(refill),
    .read_L1_L2			(read_L1_L2),
    .write_L1_L2		(write_L1_L2)
);

// Signals for Testbench
reg		[63:0]		address_array	[0:9999];
integer	i, j, EXIT;

reg		[2:0]		test_state;

always begin
#1	clk			= ~clk;
end

// Init
initial begin: init
	test_state	=	3'd0;

	clk			=	1'b1;
	nrst		<=	1'b0;
	address		<=	64'b0;
	read_C_L1	<=	1'b0;
	write_C_L1	<=	1'b0;
	flush		<=	1'b0;
	ready_L2_L1	<=	1'b0;

	for(i = 0; i<1000; i = i + 1) begin
		address_array[i]	<=	$urandom & 32'hFFFF_FFFC;
	end
end

initial begin: test

	// 0. Cache Init
	$display("Init start");

	nrst		<=	1'b1;
#10	nrst		<=	1'b0;

#10	nrst		<=	1'b1;
	read_C_L1	<=	1'b1;
#4;
	for(i = 0; i<10; i = i + 1) begin
		address		<= address_array[i];

		$display("%4d: Address %h", i, address);

	#2	ready_L2_L1	<=	1'b1;
	#2	ready_L2_L1	<=	1'b0;
	#6;
	end

	read_C_L1	<=	1'b0;
#100;

	// 1. Data Read

	// 1-1. Hit
	$display("%4d: Read, Hit", $time);
	test_state	=	3'd1;

	read_C_L1	<=	1'b1;
#4;
	for(i = 0; i<10; i = i + 1) begin
		address		<=	address_array[i];

		$display("%4d: Address %h", $time, address);
	#10;
	end

	read_C_L1	<=	1'b0;
#100;

	// 1-2. Miss - (Memory) Hit
	$display("%4d: Read, Miss - Hit", $time);
	test_state	=	3'd2;

	read_C_L1	<=	1'b1;
#4;
	for(i = 10; i<20; i = i + 1) begin
		address		<=	address_array[i];

		$display("%4d: Address %h", $time, address);
	#2	
		ready_L2_L1	<=	1'b1;
	#2
		ready_L2_L1	<=	1'b0;
	#6;
	end

	read_C_L1	<=	1'b0;
#100;

	// 1-3. Miss - (Memory) Miss
	$display("%4d: Read, Miss - Miss", $time);
	test_state	=	3'd3;

	read_C_L1	<=	1'b1;
#4;
	for(i = 20; i<30; i = i + 1) begin
		address		<=	address_array[i];

		$display("%4d: Address %h", $time, address);
		#10
		ready_L2_L1	<=	1'b1;
		#2
		ready_L2_L1	<=	1'b0;
		#8;
	end

	read_C_L1	<=	1'b0;
#100;

	// 2. Data Write

	// 2-1. Not Changed
	test_state	=	3'd4;

	// 2-2. Write back
	test_state	=	3'd5;

	// 3. Flush
	$display("%4d: FLUSH", $time);
	test_state	=	3'd6;

	flush	<=	1'b1;

#100;

	// (4. Reset) -> deleted
	// 	$display("%4d: FLUSH", $time);
	// 	nrst	= 1'b0;

	// #100;

	// 4. Cache Replacement
	$display("%4d: Cache Replacement", $time);
	test_state	=	3'd7;

	nrst		<=	1'b1;
	flush		<=	1'b0;
	read_C_L1	<=	1'b1;

	for(i = 0; i<100; i = i + 1) begin
		address		<=	address_array[i];

		$display("%4d: Address %h", i, address);

	#2	ready_L2_L1	<=	1'b1;
	#2	ready_L2_L1	<=	1'b0;
	#6;
	end

	$stop;
end

initial begin
	$dumpvars(u_L1_D_controller);
	$dumpfile("dump.vcd");
end


endmodule