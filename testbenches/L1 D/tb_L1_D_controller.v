`timescale 1ns/100ps
module tb_L1_D_controller ();

reg					clk;
reg					nrst;

reg		[63:0]		address; 
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
    .clk			(clk),
    .nrst			(nrst),

    .tag			(address[63:12]),
    .index			(address[11:6]),
    .read_C_L1		(read_C_L1),
    // .write_C_L1		(write_C_L1),
    .flush			(flush),
    .stall			(stall),

    .refill			(refill),
    .update			(update),

    .read_L1_L2		(read_L1_L2),
    .write_L1_L2	(write_L1_L2),
    .ready_L2_L1	(ready_L2_L1)
);

// Signals for Testbench

reg		[63:0]		address_array	[0:9999];
integer	i;

always begin
	#1	clk		= ~clk;
end

initial begin: init
	clk			= 1'b0;
	nrst		= 1'b0;
	address		= 64'b0;
	read_C_L1	= 1'b0;
	write_C_L1	= 1'b0;
	flush		= 1'b0;
	ready_L2_L1	= 1'b0;

	for(i = 0; i<1000; i = i + 1) begin
		address_array[i]	= $urandom << 32 | $urandom;
	end
end

initial begin: test

// 0. Init
	$display("Init start");
	#5	nrst	= 1'b1;
	#5	nrst	= 1'b0;

	nrst		= 1'b1;
	read_C_L1	= 1'b1;

	for(i = 0; i<10; i = i + 1) begin
		address		= address_array[i];
		$display("%4d: Address %h", i, address);
		#1;
		ready_L2_L1	= 1'b1;
		#1;
		ready_L2_L1	= 1'b0;
	end

	#100

// 1. Data Read

	$display("Read, Hit");
// 1-1. Hit
	for(i = 0; i<10; i = i + 1) begin
		address		= address_array[i];
		$display("%4d: Address %h", i, address);
		ready_L2_L1	= 1'b1;
		#1;
		ready_L2_L1	= 1'b0;
		#2;
	end

	#100

// 1-2. Miss - (Memory) Hit
	for(i = 10; i<20; i = i + 1) begin
		address		= address_array[i];
		$display("Address %h", address);
		ready_L2_L1	= 1'b1;
		#1;
		ready_L2_L1	= 1'b0;
		#2;
	end

// 1-3. Miss - (Memory) Miss

// 2. Data Write

// 2-1. Not Changed

// 2-2. Write back

// 3. Flushed

// 4. Reset


	$stop;
end

endmodule