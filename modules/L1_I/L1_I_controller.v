
module L1_I_controller (
    input clk,
    input nrst,
    input [51:0] tag, 
    input [5:0] index, 
    input read_C_L1, flush,
    input ready_L2_L1,
    input write_C_L1,
    output stall, refill, update, read_L1_L2, write_L1_L2
);

// define TAG_ARR
reg [53:0] TAG_ARR [63:0];
reg miss;
reg hit;
reg read_C_L1_reg;
reg stall_reg;
reg refill_reg;
reg read_L1_L2_reg;
genvar i;
assign stall = stall_reg;
assign refill = refill_reg;
assign read_L1_L2 = read_L1_L2_reg;

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        read_C_L1_reg <= 1'b0;
    else   
        read_C_L1_reg <= read_C_L1;
end
// stall
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        stall_reg <= 1'b0;
    else if(miss == 1'b1)
        stall_reg <= 1'b1;
    else if(stall_reg == 1'b1)
        stall_reg <= 1'b0;
    else if(read_C_L1 == 1'b1)
        stall_reg <= 1'b1;
    else stall_reg <= stall_reg;
end

// miss
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        miss <= 1'b0;
    else if(ready_L2_L1 == 1'b1)
        miss <= 1'b0;
    else if (read_C_L1 == 1'b1)
    begin
        miss <= ((TAG_ARR[index][53] == 1'b1) && (tag == TAG_ARR[index][51:0])) ? 1'b0 : 1'b1; 
    end  
    else
        miss <= miss;          
end
generate
	for (i=0; i<64; i= i+1) begin
		always@(posedge clk or negedge nrst)
		begin
		if (!nrst)
			TAG_ARR[i] <= 54'h0;
		else if (flush == 1'b1)
			TAG_ARR[i][53] <= 1'b0;
		else if((read_C_L1_reg == 1'b1) && (index == i))
		begin
			TAG_ARR[i][51:0] <= (miss == 1'b1) ? TAG_ARR[i][51:0] : tag;
			TAG_ARR[i][53] <= (ready_L2_L1 == 1'b0) ? TAG_ARR[i][53] : 1'b1;
		end
		else
			TAG_ARR[i] <= TAG_ARR[i];
		end
	end
endgenerate


always@(posedge clk or negedge nrst)
begin
    if (!nrst)
        refill_reg <= 1'b0;
    else if(ready_L2_L1)
        refill_reg <= 1'b1;
    else if(refill_reg == 1'b1)
        refill_reg <= 1'b0;
    else
        refill_reg <= refill_reg;
end

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        read_L1_L2_reg <= 1'b0;
    else if (miss == 1)
        read_L1_L2_reg <= 1'b1;
    else if (ready_L2_L1 == 1'b1)
        read_L1_L2_reg <= 1'b0; 
    else
        read_L1_L2_reg <= read_L1_L2_reg;
end

endmodule