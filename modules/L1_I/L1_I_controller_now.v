

module L1_I_controller (
    input clk,
    input nrst,
    input [19:0] tag, 
    input [5:0] index, 
    input read_C_L1, flush,
    input ready_L2_L1,
    input write_C_L1,
    output stall, refill, update, read_L1_L2, write_L1_L2
);

parameter   S_IDLE          =   2'b00;
parameter   S_COMPARE       =   2'b01;
parameter   S_WRITE_BACK    =   2'b10;
parameter   S_ALLOCATE      =   2'b11;



// define TAG_ARR
reg [19:0] TAG_ARR [63:0];
reg [63:0] valid;
reg [63:0] dirty;

reg [1:0] state, next_state;

reg miss;
reg hit;
reg read_C_L1_reg;
reg refill_reg;
reg update_reg;
reg read_L1_L2_reg;
reg write_L1_L2_reg;
genvar i;

assign refill = refill_reg;
assign read_L1_L2 = read_L1_L2_reg;
assign write_L1_L2 = write_L1_L2_reg;
assign stall = state != S_IDLE;
// FSM
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        state <= S_IDLE;
    else
        state <= next_state;
end

always@(*)
begin
    case(state)
        S_IDLE          :       next_state      <=      ((read_C_L1)||(write_C_L1)) ?   S_COMPARE     :    S_IDLE;
        S_COMPARE       :       next_state      <=      hit                         ?   S_IDLE        :    
                                                        (!miss)                     ?   S_COMPARE     :    
                                                        (write_C_L1 && dirty[index])?   S_WRITE_BACK  :    S_ALLOCATE; 
        S_ALLOCATE      :       next_state      <=      ready_L2_L1                 ?   S_COMPARE     :    S_ALLOCATE;    
        S_WRITE_BACK    :       next_state      <=      ready_L2_L1                 ?   S_ALLOCATE    :    S_WRITE_BACK;
    endcase
end                    



// hit
always @ (posedge clk or negedge nrst)
begin
    if(!nrst)
        hit <= 1'b0;
    else if(state == S_COMPARE)
    begin
        if(valid[index] && (tag == TAG_ARR[index]))
            hit <= 1'b1;
        else
            hit <= 1'b0;
    end
    else
        hit <= 1'b0;
end

// miss
always @ (posedge clk or negedge nrst)
begin
    if(!nrst)
        miss <= 1'b0;
    else if(state == S_COMPARE)
    begin
        if(valid[index] && (tag == TAG_ARR[index]))
            miss <= 1'b0;
        else
            miss <= 1'b1;
    end
    else
        miss <= 1'b0;
end

// dirty
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        dirty <= 64'h0;
    else if((state == S_COMPARE) && hit && write_C_L1)
        dirty[index] <= 1'b1;
    else if((state == S_ALLOCATE) && ready_L2_L1)
        dirty[index] <= 1'b0;
    else
        dirty <= dirty;
end
// valid
always@(posedge clk or negedge nrst)
begin
    if (!nrst)
        valid <= 64'h0;
    else if ((state == S_IDLE) && flush)
        valid <= 64'h0;
    else if ((state == S_ALLOCATE) && ready_L2_L1)
        valid[index] <= 1'b1;
    else
        valid <= valid;
end

generate
    for (i=0; i<64; i = i+1)    begin
        always@(posedge clk or negedge nrst)
        begin
            if(!nrst)
                TAG_ARR[i] <= 20'h0;
            else if((state == S_ALLOCATE)&& ready_L2_L1 && (index == i))
                TAG_ARR[i] <= tag;
            else
                TAG_ARR[i] <= TAG_ARR[i];
        end
    end
endgenerate

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        refill_reg <= 1'b0;
    else if((state == S_ALLOCATE) && ready_L2_L1 && read_C_L1)
        refill_reg <= 1'b1;
    else
        refill_reg <= 1'b0;
end

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        update_reg <= 1'b0;
    else if ((state == S_ALLOCATE) && ready_L2_L1 && write_C_L1)
        update_reg <= 1'b1;
    else
        update_reg <= 1'b0;
end        

//read_L1_L2
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        read_L1_L2_reg <= 1'b0;
    else if(state == S_ALLOCATE)
        read_L1_L2_reg <= 1'b1;
    else
        read_C_L1_reg <= 1'b0;
end

//write_L1_L2
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        write_L1_L2_reg <= 1'b0;
    else if (state == S_WRITE_BACK)
        write_L1_L2_reg <= 1'b1;
    else   
        write_L1_L2_reg <= 1'b0;
end


endmodule
