module data_separator (
	clk, rstn, data_i, valid_pulse_i, data_o, valid_o
);

input					clk;
input					rstn;
input		[31:0	]	data_i;
input					valid_pulse_i;
output	reg	[7:0	]	data_o;
output	reg				valid_o;

reg			[9:0	]	addra,	addrb;
reg			[1:0	]	cnt;

wire		[31:0	]	doutb;
wire					wen;
wire					empty;			

assign	empty		= (addra == addrb);
assign	wen			= valid_pulse_i;

xilinx_true_dual_port_no_change_2_clock_ram #(
	.RAM_DEPTH			(	32'd1024		),
	.RAM_PERFORMANCE	(	"LOW_LATENCY"	),
	.INIT_FILE			(	""				)
) buffer (
    .addra(addra),   // Port A address bus, width determined from RAM_DEPTH
    .addrb(addrb),   // Port B address bus, width determined from RAM_DEPTH
    .dina(data_i),     // Port A RAM input data, width determined from RAM_WIDTH
    .dinb(),     // Port B RAM input data, width determined from RAM_WIDTH
    .clka(clk),     // Port A clock
    .clkb(clk),     // Port B clock
    .wea(wen),       // Port A write enable
    .web(1'b0),       // Port B write enable
    .ena(1'b1),       // Port A RAM Enable, for additional power savings, disable port when not in use
    .enb(1'b1),       // Port B RAM Enable, for additional power savings, disable port when not in use
    .rsta(),     // Port A output reset (does not affect memory contents)
    .rstb(),     // Port B output reset (does not affect memory contents)
    .regcea(), // Port A output register enable
    .regceb(), // Port B output register enable
    .douta(),   // Port A RAM output data, width determined from RAM_WIDTH
    .doutb(doutb)    // Port B RAM output data, width determined from RAM_WIDTH
);

always @(posedge clk) begin
	if (~rstn) begin
		addra	<= 10'b0;
		addrb	<= 10'b0;
		cnt		<= 2'b0;
		valid_o	<= 1'b0;
		data_o	<= 8'b0;
	end
	else begin
		data_o		<= doutb[(3-cnt)*8+:8];
		if(wen) begin
			addra	<= addra + 1'b1;
		end
		// for read
		if (~empty | |cnt) begin
			cnt	<= cnt + 1'b1;
			if(&cnt) begin
				addrb	<= addrb + 1'b1;
			end
		end

		valid_o	<= ~empty | |cnt;
	end
end

endmodule