module counter_2 (
	input		clk,
	input		rstn,
	input		read_C_L1I,//
	input		miss_L1I_C,
	input		read_C_L1D,//
	input		write_C_L1D,
	input		miss_L1D_C,
	input		read_L1_L2,//
	input		write_L1_L2,//
	input		miss_L2_L1,
    
	
    output reg	[31:0] data_out1,
	output reg  wr_en
);

reg signal;							// clk count ê°ì´ time 1,2,3 ì¤ íëì¼ ë highë¡ ì¬ë¼ê°ê³ , ëª¨ë  ë°ì´í°ë¥¼ ë³´ë´ë©´ ë¤ì Low
reg [31:0] clk_count;                

reg	read_C_L1I_prev	;
reg	miss_L1I_C_prev	;
reg	read_C_L1D_prev	;
reg	write_C_L1D_prev;
reg	miss_L1D_C_prev	;
reg	read_L1_L2_prev	;
reg	write_L1_L2_prev;
reg	miss_L2_L1_prev	;


reg	[11:0] cnt_L1I_read;
reg	[11:0] cnt_L1I_miss;
reg	[11:0] cnt_L1D_read;
reg	[11:0] cnt_L1D_write;
reg	[11:0] cnt_L1D_miss;
reg	[11:0] cnt_L2_read;
reg	[11:0] cnt_L2_write;
reg	[11:0] cnt_L2_miss;


reg	[11:0] cnt_L1I_read_reg;
reg	[11:0] cnt_L1I_miss_reg;
//reg	[11:0] cnt_L1D_read_reg;
//reg	[11:0] cnt_L1D_write_reg;
reg	[11:0] cnt_L1D_miss_reg;
//reg	[11:0] cnt_L2_read_reg;
//reg	[11:0] cnt_L2_write_reg;
reg	[11:0] cnt_L2_miss_reg;
reg [11:0] cnt_L1D_reg;
reg [11:0] cnt_L2_reg;



integer j;



always @(posedge clk) begin
	if(!rstn) begin
		clk_count <= 'b0;
	end
	else clk_count <= clk_count +1;
end



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





always @(posedge clk) begin
	if(~rstn) begin
		j		<= 0;
		data_out1	<= 0;
		signal  <= 0;
		wr_en	<= 0;
		
		read_C_L1I_prev		<= 'b0;
		miss_L1I_C_prev		<= 'b0;
		read_C_L1D_prev		<= 'b0;
		write_C_L1D_prev	<= 'b0;
		miss_L1D_C_prev		<= 'b0;
		read_L1_L2_prev		<= 'b0;
		write_L1_L2_prev	<= 'b0;
		miss_L2_L1_prev		<= 'b0;

		cnt_L1I_read_reg	<= 'b0;
		cnt_L1I_miss_reg	<= 'b0;
		//cnt_L1D_read_reg	<= 'b0;
		//cnt_L1D_write_reg	<= 'b0;
		cnt_L1D_miss_reg	<= 'b0;
		//cnt_L2_read_reg		<= 'b0;
		//cnt_L2_write_reg	<= 'b0;
		cnt_L2_miss_reg		<= 'b0;
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

        	
        if (clk_count == 500 || clk_count == 1500 || clk_count == 2500) begin
            
			cnt_L1I_read_reg	<= cnt_L1I_read;
			cnt_L1I_miss_reg	<= cnt_L1I_miss;
			//cnt_L1D_read_reg	<= cnt_L1D_read;
			//cnt_L1D_write_reg	<= cnt_L1D_write;
			cnt_L1D_miss_reg	<= cnt_L1D_miss;
			//cnt_L2_read_reg		<= cnt_L2_read;
			//cnt_L2_write_reg	<= cnt_L2_write;
			cnt_L2_miss_reg		<= cnt_L2_miss;
			cnt_L1D_reg			<= (cnt_L1D_read + cnt_L1D_write);
			cnt_L2_reg 			<= (cnt_L2_read + cnt_L2_write);
			signal				<= 1;
			wr_en				<= 1;
			j 					<= 0;
		end

		else begin
			if (signal) begin 

				// L1 I count
            	if (j == 0) begin
                	data_out1	<= {8'b0110_0001, 8'b0110_0001, 4'b0000, cnt_L1I_miss_reg}; // aa~
			    	j <= j + 1;
		    	end
            	



				//L1 D count
				else if (j == 1) begin
					data_out1	<= {8'b0110_0010, 8'b0110_0010, 4'b0000, cnt_L1D_miss_reg};  // bb~
					j <= j + 1;
				end
				


				//L2 count
				else if (j == 2) begin
					data_out1	<= {8'b0110_0011, 8'b0110_0011, 4'b0000, cnt_L2_miss_reg};  // cc~
					j <= j + 1;
					signal <= 0;
					wr_en  <= 0;
				end

			

			end
		end
	end
end
	

endmodule



