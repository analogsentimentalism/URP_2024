`timescale 1ns/1ns
//	2 port라서 tag / data 둘 다 넣으려고 했는데,
//	controller 쪽이 좀 복잡해보여서 일단 data_array 역할만 함.

module L1_I_bram #(
	parameter	TNUM			= 21,
	parameter	INUM			= 26-TNUM,
	parameter	WAY				= 2,		// >= 2
	parameter	BIT_WIDTH_high	= 32,
	parameter	BIT_WIDTH_low	= 512,
	parameter	RAM_WIDTH		= 512,
	parameter	RAM_PERFORMANCE	= "LOW_LATENCY",
	parameter	INIT_FILE		= "",
	parameter	RAM_DEPTH		= 1 << (INUM + clogb2(WAY-1))
) (
	input							clk,
	input							nrst,

	input	[INUM-1:0]				index_C_L1,
	input	[5:0]					offset,
	input	[clogb2(WAY-1)-1:0]		way,

	input							refill,

	input	[BIT_WIDTH_low-1:0]		read_data_L2_L1,

	output	[BIT_WIDTH_high-1:0]	read_data_L1_C
);

wire	[RAM_WIDTH-1:0]		read_data_temp;
reg							refill_n;

assign	read_data_L1_C		= refill_n ? read_data_L2_L1[{offset[5:2],5'b00000} +: BIT_WIDTH_high] :
								read_data_temp[{offset[5:2],5'b00000} +: BIT_WIDTH_high];

xilinx_true_dual_port_no_change_2_clock_ram #(
    .RAM_WIDTH(RAM_WIDTH),                       // Specify RAM data width
    .RAM_DEPTH(RAM_DEPTH),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE(RAM_PERFORMANCE), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE(INIT_FILE)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
) bram_core (
    .addra({index_C_L1, way}),   // Port A address bus, width determined from RAM_DEPTH
    .addrb({clogb2(RAM_DEPTH-1){1'b0}}),   // Port B address bus, width determined from RAM_DEPTH
    .dina(read_data_L2_L1),     // Port A RAM input data, width determined from RAM_WIDTH
    .dinb({RAM_WIDTH{1'b0}}),     // Port B RAM input data, width determined from RAM_WIDTH
    .clka(clk),     // Port A clock
    .clkb(1'b0),     // Port B clock
    .wea(refill),       // Port A write enable
    .web(1'b0),       // Port B write enable
    .ena(1'b1),       // Port A RAM Enable, for additional power savings, disable port when not in use
    .enb(1'b0),       // Port B RAM Enable, for additional power savings, disable port when not in use
    .rsta(~nrst),     // Port A output reset (does not affect memory contents)
    .rstb(~nrst),     // Port B output reset (does not affect memory contents)
    .regcea(1'b0), // Port A output register enable
    .regceb(1'b0), // Port B output register enable
    .douta(read_data_temp),   // Port A RAM output data, width determined from RAM_WIDTH
    .doutb()    // Port B RAM output data, width determined from RAM_WIDTH
);

always @(posedge clk) begin
	if(~nrst) begin
		refill_n	<= 1'b0;
	end
	else begin
		refill_n	<= refill;
	end
end

function integer clogb2;
input integer depth;
	for (clogb2=0; depth>0; clogb2=clogb2+1)
	depth = depth >> 1;
endfunction

endmodule