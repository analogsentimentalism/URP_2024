module mem #() (
	input				read_L2_MEM,
	input				write_L2_MEM,
	input				clk,
	input				rstn,
	output	reg			ready_MEM_L2,
	output	reg	[511:0]	read_data_MEM_L2
);

integer cnt;
reg	flag;

always @(posedge clk) begin
	if (!rstn) begin
		cnt = 0;
		flag = 0;
		read_data_MEM_L2 = 0;
		ready_MEM_L2 = 0;
	end
	else begin
		if((read_L2_MEM | write_L2_MEM) & ~flag) begin
				cnt					<= cnt + 'b1;
				ready_MEM_L2		<= 1'b1;
		end
		else ready_MEM_L2	<= 1'b0;
		flag	<= read_L2_MEM;
		read_data_MEM_L2	<= {16{3'b111, cnt[28:0]}};
	end
end

endmodule