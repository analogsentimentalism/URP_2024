module instruction_rom #(
	parameter	RAM_WIDTH	= 32,
	parameter	RAM_DEPTH	= 32'h800_0000,
	parameter	INIT_FILE	= "test.txt",
	parameter	START_ADDR	= 32'h10094,
	parameter	TNUM		= 22,
	parameter	INUM		= 26 - TNUM
) (
	input					read_L2_MEM,
	input					clk,
	input					rstn,
	input		[TNUM-1:0]	tag_L2_MEM,
	input		[INUM-1:0]	index_L2_MEM,
	output	reg				ready_MEM_L2,
	output	reg	[511:0]		read_data_MEM_L2			
);

wire	[RAM_WIDTH-1:0]	douta		;
reg		[4:0]			cnt			;
wire	[25:0]			addra		;
wire	[31:0]			addra_temp	;
wire	[25:0]			addra_r		;
wire	[25:0]			addra_w		;

reg		ready_temp	;
wire	[3:0]	rear;

assign	addra_r	= {tag_L2_MEM, index_L2_MEM}		;
assign	addra_temp	= {addra_r, 6'b0} - START_ADDR;
assign	addra	= addra_temp [31:6];
assign	rear	= cnt[3:0] - START_ADDR[5:2];


rom #(
	.RAM_WIDTH		(	RAM_WIDTH	),
	.RAM_DEPTH		(	RAM_DEPTH	),
	.INIT_FILE		(	INIT_FILE	)
) u_rom (
	.clk			(	clk												),
	.addra			(	{addra[0+:7] + (cnt >= START_ADDR[5:2]), rear}	),
	.en				(	1'b1											),
	.dout			(	douta											)
);

reg	[1:0]	state;

always @(posedge clk) begin
	if (~rstn) begin
		read_data_MEM_L2	<= 'b0	;
		cnt					<= 'b0	;
		state				<= 'b0	;
		ready_temp			<= 'b0	;
	end
	else begin
		if (read_L2_MEM) begin
			state	<= state + 1;
			if (~state[1]) begin
				cnt	<= cnt;
				read_data_MEM_L2	<= read_data_MEM_L2		;
				ready_temp	<= 'b0	;
			end
			else begin
				state	<= 'b0;
				cnt	<= cnt + 1;
				read_data_MEM_L2[cnt*RAM_WIDTH+:RAM_WIDTH]	<= douta		;
				ready_temp	<= (cnt == 'd15);
			end
		end
		else begin
			ready_temp	<= 'b0	;
			cnt	<= cnt	;
			read_data_MEM_L2	<= read_data_MEM_L2	;
			state	<= state	;
		end
	end
end

always @(posedge clk) begin
	ready_MEM_L2	<= ready_temp	;
end

endmodule