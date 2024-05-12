module L2_bram_connect #(
	parameter	RAM_WIDTH	= 32,
	parameter	RAM_DEPTH	= 32'h800_0000,
	parameter	RAM_PERFORMANCE = "HIGH_PERFORMANCE",
	parameter	INIT_FILE	= "instructions.txt",
	parameter	START_ADDR	= 32'h10094,
	parameter	TNUM		= 22,
	parameter	INUM		= 26 - TNUM
) (
	input					read_L2_MEM,
	input					write_L2_MEM,
	input					clk,
	input					rstn,
	input		[TNUM-1:0]	tag_L2_MEM,
	input		[INUM-1:0]	index_L2_MEM,
	input		[TNUM-1:0]	write_tag_L2_MEM,
	input		[511:0]		write_data_L2_MEM,
	output	reg				ready_MEM_L2,
	output	reg	[511:0]		read_data_MEM_L2			
);

wire	[RAM_WIDTH-1:0]	douta		;
wire	[RAM_WIDTH-1:0]	doutb		;
reg		[3:0]			cnt			;
wire	[25:0]			addra		;
wire	[31:0]			addra_temp	;
wire	[25:0]			addra_r		;
wire	[25:0]			addra_w		;

reg		[RAM_WIDTH-1:0]	dina		;
reg		ready_temp	;
wire	[3:0]	rear;

assign	addra_r	= {tag_L2_MEM, index_L2_MEM}		;
assign	addra_w	= {write_tag_L2_MEM, index_L2_MEM}	;
assign	addra_temp	= {(write_L2_MEM ? addra_w : addra_r), 6'b0} - START_ADDR;
assign	addra	= addra_temp [31:6];
assign	rear	= cnt - START_ADDR[5:2];

xilinx_true_dual_port_no_change_2_clock_ram #(
    .RAM_WIDTH(RAM_WIDTH),                       // Specify RAM data width
    .RAM_DEPTH(RAM_DEPTH),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE(RAM_PERFORMANCE), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE(INIT_FILE)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
) u_2port_bram (
    .addra({addra + (cnt >= START_ADDR[5:2]), rear}),   // Port A address bus, width determined from RAM_DEPTH
    .addrb('b0),   // Port B address bus, width determined from RAM_DEPTH
    .dina(dina),     // Port A RAM input data, width determined from RAM_WIDTH
    .dinb('b0),     // Port B RAM input data, width determined from RAM_WIDTH
    .clka(clk),     // Port A clock
    .clkb('b0),     // Port B clock
    .wea(write_L2_MEM),       // Port A write enable
    .web('b0),       // Port B write enable
    .ena('b1),       // Port A RAM Enable, for additional power savings, disable port when not in use
    .enb('b0),       // Port B RAM Enable, for additional power savings, disable port when not in use
    .rsta(~rstn),     // Port A output reset (does not affect memory contents)
    .rstb('b0),     // Port B output reset (does not affect memory contents)
    .regcea('b1), // Port A output register enable
    .regceb('b0), // Port B output register enable
    .douta(douta),   // Port A RAM output data, width determined from RAM_WIDTH
    .doutb(doutb)    // Port B RAM output data, width determined from RAM_WIDTH
);

reg	[1:0]	state;

always @(posedge clk) begin
	if (~rstn) begin
		read_data_MEM_L2	<= 'b0	;
		cnt					<= 'b0	;
		state				<= 'b0	;
		ready_temp			<= 'b0	;
		dina				<= 'b0	;
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
		else if (write_L2_MEM) begin
			state	<= state + 1;
			if (~state[1]) begin
				cnt	<= cnt;
				read_data_MEM_L2	<= read_data_MEM_L2		;
				ready_temp	<= 'b0	;
				dina		<= write_data_L2_MEM[cnt*RAM_WIDTH+:RAM_WIDTH];
			end
			else begin
				state	<= 'b0;
				ready_temp	<= (cnt == 'd15);
				cnt	<= cnt + 1	;
				read_data_MEM_L2[cnt+:RAM_WIDTH]	<= douta		;
			end
		end
		else begin
			ready_temp	<= 'b0	;
			cnt	<= cnt	;
			read_data_MEM_L2	<= read_data_MEM_L2	;
			state	<= state	;
			dina	<= 'b0		;
		end
	end
end

always @(posedge clk) begin
	ready_MEM_L2	<= ready_temp	;
end

endmodule