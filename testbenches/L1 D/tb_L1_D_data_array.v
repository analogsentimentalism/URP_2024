`timescale 1ns/1ns
module tb_L1_D_data_array();

reg					clk;
reg					nrst;

reg		[511:0]		write_data;
reg		[5:0]		index;
reg		[5:0]		offset;
reg					update_L1;
reg					refill_L1;

wire	[511:0]		read_data;
wire				stall_L1;

L1_D_data_array u_L1_D_data_array (
	.clk			(clk), 
	.nrst			(nrst), 
	.read_data		(read_data), 
	.write_data		(write_data), 
	.index			(index), 
	.offset			(offset), 
	.update_L1		(update_L1), 
	.refill_L1		(refill_L1), 
	.data_block_L2	(data_block_L2)
);





endmodule