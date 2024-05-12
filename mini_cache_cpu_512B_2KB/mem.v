module mem (
	input				read_L2_MEM,
	input				write_L2_MEM,
	input				read_C_L1I,
	input				read_C_L1D,
	input				write_C_L1D,
	input				clk,
	input				rstn,
	input	[4:0]		index_L2_MEM,
	input	[20:0]		tag_L2_MEM,
	input	[4:0]		opcode,
	// input	[17:0]		write_tag_L2_MEM,
	// input	[511:0]		write_data_L2_MEM,
	output	reg			ready_MEM_L2,
	output	reg	[511:0]	read_data_MEM_L2
);

integer i;
reg	[9:0] reg_cnt;
reg	flag;
reg	flag_id;

(* RAM_STYLE="BLOCK" *)
reg	[31:0] mem_cell	[0:22965];

reg read_L2_MEM_reg;
reg write_L2_MEM_reg;


always @(posedge clk) begin
	if (!rstn) begin
		flag <= 0;
		ready_MEM_L2 <= 0;
	end
	else begin
		read_L2_MEM_reg <= read_L2_MEM;
		write_L2_MEM_reg <= write_L2_MEM;
		if (read_L2_MEM) begin
			if (~flag) begin
				flag	<= (read_L2_MEM_reg ^ read_L2_MEM) & read_L2_MEM;
				ready_MEM_L2	<= (read_L2_MEM_reg ^ read_L2_MEM) & read_L2_MEM;
			end
			else begin
				flag	<= 'b0;
				ready_MEM_L2	<= 'b0;
			end
		end
		else if (write_L2_MEM) begin
			if (~flag) begin
				flag	<= (write_L2_MEM_reg ^ write_L2_MEM) & write_L2_MEM;
				ready_MEM_L2	<= (write_L2_MEM_reg ^ write_L2_MEM) & write_L2_MEM;
			end
			else begin
				flag	<= 'b0;
				ready_MEM_L2	<= 'b0;
			end
		end
		else begin
			flag	<= 'b0;
			ready_MEM_L2	<= 'b0;
		end

	end
end

always @(*) begin
	if (!rstn) begin
		flag_id <= 'b0;
		reg_cnt <= 0;
		for (i=0;i<16;i=i+1) begin
			read_data_MEM_L2[i*32+:32]	<= 'b0;
		end
	end
	else begin
		if(read_L2_MEM) begin
			if(read_C_L1I & ~flag_id) begin
				flag_id	<= 'b1;
				for (i=0;i<16;i=i+1) begin
					read_data_MEM_L2[i*32+:32]	<=	mem_cell[i+16*(reg_cnt)];
				end
				reg_cnt <= reg_cnt + 1;
			end
			else if (read_C_L1D | write_C_L1D) begin
				for (i=0;i<16;i=i+1) begin
					read_data_MEM_L2[i*32+:32]	<= 'b0;
				end
			end
			else begin
				read_data_MEM_L2	<= read_data_MEM_L2;
			end
		end
		else begin
			flag_id	<= 'b0;
			read_data_MEM_L2	<= read_data_MEM_L2;
		end
	end
end

initial begin
	$readmemh("test_code.txt", mem_cell);
end

endmodule