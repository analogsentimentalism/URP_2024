`timescale 1ns/1ns

module tb_L1_D_top ();

reg					clk;
reg					nrst;

reg		[63:0]		address; 
reg					read_C_L1;
reg					write_C_L1;
reg					flush;
reg					ready_L2_L1;

wire				stall;
wire				read_L1_L2;
wire				write_L1_L2;

reg		[31:0]		write_data;
wire	[31:0]		read_data_L1_C;
reg		[511:0]		read_data_L2_L1;

L1_D_top u_L1_D_top (
    .clk				(clk),
    .nrst				(nrst),

    .tag				(address[63:12]),
    .index				(address[11:6]),
	.offset				(address[5:0]),
    .read_C_L1			(read_C_L1),
    .write_C_L1			(write_C_L1),
    .flush				(flush),
    .ready_L2_L1		(ready_L2_L1),

    .stall				(stall),
    .read_L1_L2			(read_L1_L2),
    .write_L1_L2		(write_L1_L2),

	.write_data			(write_data),
	.read_data_L1_C		(read_data_L1_C),
	.read_data_L2_L1	(read_data_L2_L1)
);

reg		[63:0]		address_array			[0:9999];
reg		[511:0]		read_data_L2_L1_array	[0:9999];
integer	i, j, EXIT;

always begin
#1	clk			= ~clk;
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
		address_array[i]			= $urandom << 32 | $urandom;
		for(j = 0; j<16; j = j + 1) begin
			read_data_L2_L1_array[i][(j+1)*32:j*32]	= $urandom;
		end
	end
end

initial begin: test

// 0. Init
	$display("Init start");
	nrst		= 1'b1;
#10	nrst		= 1'b0;

#10	nrst		= 1'b1;
	read_C_L1	= 1'b1;

	for(i = 0; i<10; i = i + 1) begin
		address			= address_array[i];
		read_data_L2_L1	=
		$display("%4d: Address %h", i, address);

		ready_L2_L1	= 1'b1;
	#2	ready_L2_L1	= 1'b0;
	#6;
	end

#100;

// 1. Data Read

	$display("%4d: Read, Hit", $time);
// 1-1. Hit
	for(i = 0; i<10; i = i + 1) begin
		address		= address_array[i];
		$display("%4d: Address %h", $time, address);
	#10;
	end

#100;

// 1-2. Miss - (Memory) Hit
	$display("%4d: Read, Miss - Hit", $time);
	for(i = 10; i<20; i = i + 1) begin
		address		= address_array[i];
		$display("%4d: Address %h", $time, address);
	#2	
		ready_L2_L1	= 1'b1;
	#2
		ready_L2_L1	= 1'b0;
	#6;
	end

#100;

// 1-3. Miss - (Memory) Miss
	$display("%4d: Read, Miss - Miss", $time);
	for(i = 20; i<30; i = i + 1) begin
		address		= address_array[i];
		$display("%4d: Address %h", $time, address);
		#10
		ready_L2_L1	= 1'b1;
		#2
		ready_L2_L1	= 1'b0;
		#8;
	end

#100;

// 2. Data Write

// 2-1. Not Changed

// 2-2. Write back

// 3. Flushed
	$display("%4d: FLUSH", $time);
	flush	= 1'b1;

#100;

// 4. Reset
	$display("%4d: FLUSH", $time);
	nrst	= 1'b0;

#100;

// 5. Cache Replacement
	nrst		= 1'b1;
	flush		= 1'b0;
	read_C_L1	= 1'b1;
	for(i = 0; i<100; i = i + 1) begin
		address		= address_array[i];
		$display("%4d: Address %h", i, address);

	#2	ready_L2_L1	= 1'b1;
	#2	ready_L2_L1	= 1'b0;
	#6;
	end

	$stop;
end

endmodule