`timescale 1ns/1ns
module tb_L1_D_controller ();

reg					clk;
reg					nrst;

reg		[31:0]		address; 
reg					read_C_L1;
reg					write_C_L1;
reg					flush;
reg					ready_L2_L1;
reg					write_L1_L2_done;

wire				stall;
wire				refill;
wire				update;
wire				read_L1_L2;
wire				write_L1_L2;

L1_D_controller u_L1_D_controller (
    .clk				(clk),
    .nrst				(nrst),

    .tag				(address[31:12]),
    .index				(address[11:6]),
    .read_C_L1			(read_C_L1),
    .flush				(flush),
    .ready_L2_L1		(ready_L2_L1),
    .write_C_L1			(write_C_L1),
	.write_L1_L2_done	(write_L1_L2_done),

    .stall				(stall),
	.refill				(refill),
	.update				(update),
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
	nrst		=	1'b0;
	address		=	64'b0;
	read_C_L1	=	1'b0;
	write_C_L1	=	1'b0;
	flush		=	1'b0;
	ready_L2_L1	=	1'b0;

	for(i = 0; i<30; i = i + 1) begin
		address_array[i]	=	$urandom & 32'hFFFF_F03C | {i[5:0], 6'b000000};
		$display("%2d\t:\t%8h", i, address_array[i]);
	end
	for(i = 0; i<30; i = i + 1) begin
		address_array[i + 30]	=	$urandom & 32'hFFFF_F03C | {address_array[i][11:6], 6'b000000};
		$display("%2d\t:\t%8h", i + 30, address_array[i + 30]);
	end
end

initial begin: test

	// 0. Cache Init (Write)
	$display("Cache Init (Write) start");

	nrst		=	1'b1;
#10	nrst		=	1'b0;

#10	nrst		=	1'b1;
	write_C_L1	=	1'b1;	// Initial reset

	for(i = 0; i<10; i = i + 1) begin
		address		= address_array[i];

		$display("%4d: Address %h", i, address);

	#8	ready_L2_L1	=	1'b1;
	#2	ready_L2_L1	=	1'b0;
		
		while(stall) #2;
	end

	write_C_L1	=	1'b0;
#100;

	// 1. Read: Hit
	$display("%4d: Read-Hit", $time);
	test_state	=	3'd1;

	read_C_L1	=	1'b1;

	for(i = 0; i<10; i = i + 1) begin
		address		=	address_array[i];

		$display("%4d: Address %h", $time, address);
	#2;
		while(stall) #2;
	end

	read_C_L1	=	1'b0;
#100;

	// 2. Read: Miss - (Memory) Hit
	$display("%4d: Read-Miss-Hit", $time);
	test_state	=	3'd2;

	read_C_L1	=	1'b1;

	for(i = 10; i<20; i = i + 1) begin
		address		=	address_array[i];

		$display("%4d: Address %h", $time, address);
	#8	
		ready_L2_L1	=	1'b1;
	#2
		ready_L2_L1	=	1'b0;
	#2;
		while(stall) #2;
	end

	read_C_L1	=	1'b0;
#100;

	// 3. Read: Miss - (Memory) Miss
	$display("%4d: Read-Miss-Miss", $time);
	test_state	=	3'd3;

	read_C_L1	=	1'b1;

	for(i = 20; i<30; i = i + 1) begin
		address		=	address_array[i];

		$display("%4d: Address %h", $time, address);
	#20
		ready_L2_L1	=	1'b1;
	#2
		ready_L2_L1	=	1'b0;
	#2;
		while(stall) #2;
	end

	read_C_L1	=	1'b0;
#100;

	// 4. Cache Replacement: Hit
	$display("%4d: Cache Replacement-Hit", $time);
	test_state	=	3'd4;

	read_C_L1	=	1'b1;


	for(i = 30; i<60; i = i + 1) begin
		address		=	address_array[i];

		$display("%4d: Address %h", $time, address);
	#20
		ready_L2_L1	=	1'b1;
	#2
		ready_L2_L1	=	1'b0;
	#2;
		while(stall) #2;
	end
	
#100;

	// 5. Cache Replacement: Miss
	$display("%4d: Cache Replacement-Miss", $time);
	test_state	=	3'd5;

	write_C_L1	=	1'b1;

	for(i = 30; i<40; i = i + 1) begin
		address		=	address_array[i];

		$display("%4d: Address %h", $time, address);
	#20
		ready_L2_L1	=	1'b1;
	#2
		ready_L2_L1	=	1'b0;
	#2;
		while(stall) #2;
	end

	write_C_L1	=	1'b0;

	read_C_L1	=1'b1;

	for(i = 0; i<30; i = i + 1) begin
		address		=	address_array[i];
	#2;
		while(stall) #2;
	end

#100;

	// 6. Flush
	$display("%4d: FLUSH", $time);
	test_state	=	3'd6;

	flush	=	1'b1;

#100;
	$stop;
end

initial begin
	$dumpfile("tb_L1_D_controller_for_I.vcd");
	$dumpvars(u_L1_D_controller);
end


endmodule