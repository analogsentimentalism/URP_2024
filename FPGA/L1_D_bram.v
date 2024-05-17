`timescale 1ns/1ns
//	2 port라서 tag / data 둘 다 넣으려고 했는데,
//	controller 쪽이 좀 복잡해보여서 일단 data_array 역할만 함.

module L1_D_bram #(
	parameter	TNUM			= 24,
	parameter	INUM			= 26-TNUM,
	parameter	WAY				= 2,	// >= 2
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
	input							update,

	input	[BIT_WIDTH_high-1:0]	write_data_C_L1,
	input	[BIT_WIDTH_low-1:0]		read_data_L2_L1,

	output	[BIT_WIDTH_low-1:0]		write_data_L1_L2,
	output	[BIT_WIDTH_high-1:0]	read_data_L1_C
);

// reg							update_reg;
// reg							refill_reg;

wire	[RAM_WIDTH-1:0]		read_data_temp;
wire	[RAM_WIDTH-1:0]		dina_temp;
wire	[RAM_WIDTH-1:0]		dina;

assign	read_data_L1_C		= read_data_temp[{offset[5:2],5'b00000} +: 32];
assign	write_data_L1_L2	= read_data_temp;



assign	dina_temp			= read_data_temp
								& ~({BIT_WIDTH_high{1'b1}} << {offset[5:2],5'b00000})
								| (write_data_C_L1 << {offset[5:2],5'b00000});

assign	dina				= refill ? read_data_L2_L1 : (update ? dina_temp : 'b0);

// always @(posedge clk) begin
// 	if (~nrst) begin
// 		update_reg	<= 'b0;
// 		refill_reg	<= 'b0;
// 	end
// 	else begin
// 		update_reg	<= update;
// 		refill_reg	<= refill;
// 	end
// end

xilinx_true_dual_port_no_change_2_clock_ram #(
    .RAM_WIDTH(RAM_WIDTH),                       // Specify RAM data width
    .RAM_DEPTH(RAM_DEPTH),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE(RAM_PERFORMANCE), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE(INIT_FILE)                        // Specify name/location of RAM initialization file if using one (leave blank if not)
) bram_core (
    .addra({index_C_L1, way}),   // Port A address bus, width determined from RAM_DEPTH
    .addrb({clogb2(RAM_DEPTH-1){1'b0}}),   // Port B address bus, width determined from RAM_DEPTH
    .dina(dina),     // Port A RAM input data, width determined from RAM_WIDTH
    .dinb({RAM_WIDTH{1'b0}}),     // Port B RAM input data, width determined from RAM_WIDTH
    .clka(clk),     // Port A clock
    .clkb(1'b0),     // Port B clock
    .wea(refill | update),       // Port A write enable
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

function integer clogb2;
input integer depth;
	for (clogb2=0; depth>0; clogb2=clogb2+1)
	depth = depth >> 1;
endfunction

endmodule