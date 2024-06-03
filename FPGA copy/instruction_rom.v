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
	output					ready_MEM_L2,
	output	reg	[511:0]		read_data_MEM_L2			
);

wire	[RAM_WIDTH-1:0]	douta		;
reg		[3:0]			cnt			;
wire	[25:0]			addra_r		;
wire	[29:0]			addra		;

reg		ready_temp	;

assign	addra_r	= {tag_L2_MEM, index_L2_MEM};
assign	addra	= {addra_r - START_ADDR[6+:26], cnt} - START_ADDR[5:2];

rom #(
	.RAM_WIDTH		(	RAM_WIDTH	),
	.RAM_DEPTH		(	RAM_DEPTH	),
	.INIT_FILE		(	INIT_FILE	)
) u_rom (
	.clk			(	clk			),
	.addra			(	addra		),
	.en				(	1'b1		),
	.dout			(	douta		)
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
				ready_temp	<= 'b0	;
			end
			else begin
				state	<= 'b0;
				if(cnt == 'd15) begin
					ready_temp	<= 'b1;
					cnt	<= 'b0;
				end
				else begin
					cnt	<= cnt + 1;
				end
				read_data_MEM_L2[cnt*RAM_WIDTH+:RAM_WIDTH]	<= douta		;
				
			end
		end
		else begin
			ready_temp	<= 'b0;
		end
	end
end

assign	ready_MEM_L2	= ready_temp;

endmodule