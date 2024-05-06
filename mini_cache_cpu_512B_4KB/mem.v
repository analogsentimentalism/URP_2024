module mem (
	input				read_L2_MEM,
	input				write_L2_MEM,
	input				clk,
	input				rstn,
	input	[7:0]		index_L2_MEM,
	input	[17:0]		tag_L2_MEM,
	input				read_C_L1,
	// input	[17:0]		write_tag_L2_MEM,
	// input	[511:0]		write_data_L2_MEM,
	output	reg			ready_MEM_L2,
	output	reg	[511:0]	read_data_MEM_L2
);

integer i;
reg	[9:0] reg_cnt;
reg	flag;

reg	[31:0] mem_cell	[0:1023];

always @(posedge clk) begin
	if (!rstn) begin
		flag <= 0;
		ready_MEM_L2 <= 0;
		reg_cnt <= 0;
	end
	else begin
		flag	<= read_L2_MEM;
		if((read_L2_MEM | write_L2_MEM) & ~flag) begin
			if(read_C_L1 & (tag_L2_MEM == 'b0)) begin
				reg_cnt	<= reg_cnt + 1;
			end
			ready_MEM_L2		<= 1'b1;
		end
		else ready_MEM_L2	<= 1'b0;
		
	end
end

always @(*) begin
	if (!rstn) begin
		for (i=0;i<16;i=i+1) begin
			read_data_MEM_L2[i*32+:32]	<= 'b0;
		end
	end
	else begin
		for (i=0;i<16;i=i+1) begin
			read_data_MEM_L2[i*32+:32]	<= tag_L2_MEM ? 'b0 : mem_cell[i+16*(reg_cnt-1)];
		end
	end

end

initial begin
	$readmemh("test_code.txt", mem_cell);
end

endmodule