`timescale 1ns/1ns
module tb_mem();

reg clk;
reg nrst;
reg read_L2_MEM;
reg write_L2_MEM;
wire ready_MEM_L2;
wire [511:0] read_data_MEM_L2;

mem #() u_mem (
	.clk				(	clk					),
	.rstn				(	nrst				),
	.read_L2_MEM		(	read_L2_MEM			),
	.write_L2_MEM		(	write_L2_MEM		),
	.ready_MEM_L2		(	ready_MEM_L2		),
	.read_data_MEM_L2	(	read_data_MEM_L2	)
);

initial begin
	forever #1 clk = ~ clk;
end

initial begin
	clk = 1;
	nrst=0;
	read_L2_MEM = 0;
#5;
	nrst=1;
	#5;
	read_L2_MEM = 1;
	#10;
	read_L2_MEM = 0;
end

endmodule