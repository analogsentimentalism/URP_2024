module instruction_rom #(
	parameter	RAM_WIDTH	= 32,
	parameter	RAM_DEPTH   = 32'h3000,
	parameter	INIT_FILE   = "test.txt",
	parameter	START_ADDR   = 32'h0,
	parameter	TNUM      = 22,
	parameter	INUM      = 26 - TNUM,
	parameter	NUM_INST	= 667
) (
	input					clk,
	input					rstn,
	input					enb,
	input					ready_MEM,
	output		[25:0	]	init_address,
	output 	reg				ready_MEM_L2,
	output	reg	[511:0	]	read_data_MEM_L2         
);

wire	[RAM_WIDTH-1:0	]	douta;
reg		[3:0			]	cnt;
reg		[25:0			]	addra_r;
wire	[30:0			]	addra;
wire						invalid;
reg		[31:0			]	cnt_inst;

assign	addra			= {addra_r - START_ADDR[6+:26], cnt} - START_ADDR[5:2];
assign	invalid			= ({addra_r - START_ADDR[6+:26], cnt} < START_ADDR[5:2]) | (addra >= RAM_DEPTH);
assign	init_address	= addra_r;

rom #(
	.RAM_WIDTH	(	RAM_WIDTH	),
	.RAM_DEPTH	(	RAM_DEPTH	),
	.INIT_FILE	(	INIT_FILE	)
) u_rom (
	.clk	(	clk								),
	.addra	(	addra[clogb2(RAM_DEPTH-1)-1:0]	),
	.en		(	1'b1							),
	.dout	(	douta							)
);

reg		state;
reg		flag;

always @(posedge clk) begin
	if (~rstn) begin
		read_data_MEM_L2	<= {512{1'b0}};
		ready_MEM_L2		<= 1'b0;
		addra_r				<= START_ADDR[6+:26];
		cnt					<= 4'b0;
		state				<= 1'b0;
		flag				<= 1'b0;
		cnt_inst			<= 32'b0;
	end
	else begin
		flag	<= 1'b1;
		if(cnt == 4'd15 & (~ready_MEM | ~flag)) begin
			ready_MEM_L2	<= 1'b1;
		end
		else if (ready_MEM) begin
			ready_MEM_L2	<= 1'b0;
		end
		if (~enb & ((cnt_inst < NUM_INST) | ready_MEM | ~flag)) begin
			if(ready_MEM | |cnt | state) begin
				if(state) begin
					cnt_inst <= cnt_inst + 1;
					state	<= 1'b0;
					
					if (invalid) begin
						read_data_MEM_L2[cnt*RAM_WIDTH+:RAM_WIDTH]   <= 32'b0;
					end
					else begin
						read_data_MEM_L2[cnt*RAM_WIDTH+:RAM_WIDTH]   <= douta;
					end

					if(cnt == 4'd15) begin
						cnt				<= 4'd0;
						addra_r			<= addra_r + 1'd1;
					end
					else begin
						cnt				<= cnt + 1;
					end
				end
				else begin
					state	<= 1'b1;
				end
			end
		end
	end
end

  function integer clogb2;
	input integer depth;
	  for (clogb2=0; depth>0; clogb2=clogb2+1)
		depth = depth >> 1;
  endfunction
endmodule