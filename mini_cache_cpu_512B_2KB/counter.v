module counter #(
	parameter ICNT = 60,	//60000으로 실행
	parameter JCNT = 10    //10000으로 실행
) (
	input		clk,
	input		rstn,
	input		read_C_L1I,
	input		miss_L1I_C,
	input		read_C_L1D,
	input		write_C_L1D,
	input		miss_L1D_C,
	input		read_L1_L2,
	input		write_L1_L2,
	input		miss_L2_L1,
	output reg	[7:0] data_o,
	output reg  done                    //추가 : done이 1이면 uart의 tx module의 start가 1이 됨
);

reg [31:0] clk_count;                //done을 uart의 clk_cnt (0~867) 까지만 1, 나머지는 0

reg	read_C_L1I_prev	;
reg	miss_L1I_C_prev	;
reg	read_C_L1D_prev	;
reg	write_C_L1D_prev;
reg	miss_L1D_C_prev	;
reg	read_L1_L2_prev	;
reg	write_L1_L2_prev;
reg	miss_L2_L1_prev	;

reg	[7:0] cnt_L1I_read;
reg	[7:0] cnt_L1I_miss;
reg	[7:0] cnt_L1D_read;
reg	[7:0] cnt_L1D_write;
reg	[7:0] cnt_L1D_miss;
reg	[7:0] cnt_L2_read;
reg	[7:0] cnt_L2_write;
reg	[7:0] cnt_L2_miss;

reg	[7:0] cnt_L1I_read_reg;
reg	[7:0] cnt_L1I_miss_reg;
reg	[7:0] cnt_L1D_read_reg;
reg	[7:0] cnt_L1D_write_reg;
reg	[7:0] cnt_L1D_miss_reg;
reg	[7:0] cnt_L2_read_reg;
reg	[7:0] cnt_L2_write_reg;
reg	[7:0] cnt_L2_miss_reg;

integer j;

always @(posedge clk) begin
	if(~rstn) begin
		cnt_L1I_read	<= 'b0;
		cnt_L1I_miss	<= 'b0;
		cnt_L1D_read	<= 'b0;
		cnt_L1D_write	<= 'b0;
		cnt_L1D_miss	<= 'b0;
		cnt_L2_read		<= 'b0;
		cnt_L2_write	<= 'b0;
		cnt_L2_miss		<= 'b0;
	end
	else begin
		if((read_C_L1I_prev ^ read_C_L1I) & read_C_L1I) begin            //  MISS RATE:   cnt_L1I_miss / cnt_L1I_read
			cnt_L1I_read	<= cnt_L1I_read + 1;
		end
		else begin
			cnt_L1I_read	<= cnt_L1I_read;
		end
		if((miss_L1I_C_prev ^ miss_L1I_C) & miss_L1I_C) begin
			cnt_L1I_miss	<= cnt_L1I_miss + 1;
		end
		else begin
			cnt_L1I_miss	<= cnt_L1I_miss;
		end
		
		
		if((read_C_L1D_prev ^ read_C_L1D) & read_C_L1D) begin            //  MISS RATE:   cnt_L1D_miss / (cnt_L1D_read + cnt_L1D_write)
			cnt_L1D_read	<= cnt_L1D_read + 1;
		end
		else begin
			cnt_L1D_read	<= cnt_L1D_read;
		end
		if((write_C_L1D_prev ^ write_C_L1D) & write_C_L1D) begin
			cnt_L1D_write	<= cnt_L1D_write + 1;
		end
		else begin
			cnt_L1D_write	<= cnt_L1D_write;
		end
		if((miss_L1D_C_prev ^ miss_L1D_C) & miss_L1D_C) begin
			cnt_L1D_miss	<= cnt_L1D_miss + 1;
		end
		else begin
			cnt_L1D_miss	<= cnt_L1D_miss;
		end
		
		
		if((read_L1_L2_prev ^ read_L1_L2) & read_L1_L2) begin            //  MISS RATE:   cnt_L2_miss / (cnt_L2_read + cnt_L2_write)
			cnt_L2_read	<= cnt_L2_read + 1;
		end
		else begin
			cnt_L2_read	<= cnt_L2_read;
		end
		if((write_L1_L2_prev ^ write_L1_L2) & write_L1_L2) begin
			cnt_L2_write	<= cnt_L2_write + 1;
		end
		else begin
			cnt_L2_write	<= cnt_L2_write;
		end
		if((miss_L2_L1_prev ^ miss_L2_L1) & miss_L2_L1) begin
			cnt_L2_miss	<= cnt_L2_miss + 1;
		end
		else begin
			cnt_L2_miss	<= cnt_L2_miss;
		end
	end
end

//clk count 초기화 / +1
always @(posedge clk) begin
	if(~rstn || j == 0 || j == JCNT || j == 2*JCNT || j == 3*JCNT || j == 4*JCNT || j == 5*JCNT || j == 6*JCNT || clk_count == 867) begin
		clk_count <= 0;
	end
	else if (done) begin
	clk_count <= clk_count +1;
	end
	else clk_count <= clk_count;
end
	

//done 신호 제어
always @(posedge clk) begin             
	if(~rstn) begin
		done <= 0;
	end
	else if (j==JCNT || j== 2*JCNT || j== 3*JCNT || j== 4*JCNT || j== 5*JCNT || j== 6*JCNT) begin
		done <= 1;
	end
	else if(done) begin
		if(clk_count ==867) begin
			done <= ~done;
		end
	end
	else begin
		done <= done;
	end
end


always @(posedge clk) begin
	if(~rstn) begin
		j		<= 0;
		data_o	<= 0;
		
		read_C_L1I_prev		<= 'b0;
		miss_L1I_C_prev		<= 'b0;
		read_C_L1D_prev		<= 'b0;
		write_C_L1D_prev	<= 'b0;
		miss_L1D_C_prev		<= 'b0;
		read_L1_L2_prev		<= 'b0;
		write_L1_L2_prev	<= 'b0;
		miss_L2_L1_prev		<= 'b0;
	end
	else begin
		read_C_L1I_prev		<= read_C_L1I;
		miss_L1I_C_prev		<= miss_L1I_C;
		read_C_L1D_prev		<= read_C_L1D;
		write_C_L1D_prev	<= write_C_L1D;
		miss_L1D_C_prev		<= miss_L1D_C;
		read_L1_L2_prev		<= read_L1_L2;
		write_L1_L2_prev	<= write_L1_L2;
		miss_L2_L1_prev		<= miss_L2_L1;
		if (j == 'b0) begin
			cnt_L1I_read_reg	<= cnt_L1I_read;
			cnt_L1I_miss_reg	<= cnt_L1I_miss;
			cnt_L1D_read_reg	<= cnt_L1D_read;
			cnt_L1D_write_reg	<= cnt_L1D_write;
			cnt_L1D_miss_reg	<= cnt_L1D_miss;
			cnt_L2_read_reg		<= cnt_L2_read;
			cnt_L2_write_reg	<= cnt_L2_write;
			cnt_L2_miss_reg		<= cnt_L2_miss;
			j <= j + 1;
		end
		else if(j == JCNT) begin	
			data_o	<= cnt_L1I_miss_reg;
			j <= j + 1;
		end
		else if (j == JCNT * 2) begin
			data_o	<= cnt_L1I_read_reg;
			j <= j + 1;
		end


		else if(j == JCNT*3) begin
			data_o	<= cnt_L1D_miss_reg;
			j <= j + 1;
		end
		else if (j == JCNT * 4) begin
			data_o	<= cnt_L1D_read_reg + cnt_L1D_write_reg;
			j <= j + 1;
		end


		else if(j == JCNT*5) begin
			data_o	<= cnt_L2_miss_reg;
			j <= j + 1;
		end
		else if (j == JCNT * 6) begin
			data_o	<= cnt_L2_read_reg + cnt_L2_write_reg;
			j <= 0;
		end
		else begin
			j <= j + 1;
		end
	end
end

endmodule