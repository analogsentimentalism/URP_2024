
module L1_I_controller (
    input clk,
    input nrst,
    input [23:0] tag_C_L1, 
    input [1:0] index_C_L1, 
    input read_C_L1, flush,
    input ready_L2_L1,
    output stall, refill, read_L1_L2, 
    output [4:0] index_L1_L2,
    output [20:0] tag_L1_L2,
    output way,
    output L1I_miss_o
);

parameter   S_IDLE          =   2'b00;
parameter   S_COMPARE       =   2'b01;
parameter   S_ALLOCATE      =   2'b11;



// define TAG_ARR
reg [23:0] TAG_ARR [7:0];       //캐시 라인마다
reg [7:0] valid;


reg [1:0] state, next_state;

reg miss;
reg hit;
reg read_C_L1_reg;
reg refill_reg;                      //controller asserts refill, and the data array accepts the memory data
reg read_L1_L2_reg;


reg [3:0] LRU_reg;                         //LRU
reg way_reg;                         //Way
reg check;                           //Check
genvar i;

assign refill = refill_reg;
assign read_L1_L2 = read_L1_L2_reg;
assign stall = (state != S_IDLE);
assign tag_L1_L2 = tag_C_L1[23:3];
assign way = way_reg;
assign index_L1_L2 = {tag_C_L1[2:0], index_C_L1};
assign L1I_miss_o = miss;
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
        S_IDLE          :       next_state      <=      (read_C_L1)                         ?   S_COMPARE     :    S_IDLE;
        S_COMPARE       :       next_state      <=      hit                                 ?   S_IDLE        :    
                                                        (!miss)                             ?   S_COMPARE     :    S_ALLOCATE; 
        S_ALLOCATE      :       next_state      <=      ready_L2_L1                         ?   S_COMPARE     :    S_ALLOCATE;    
        default         :       next_state      <=      S_IDLE;
    endcase
end                    
always @(posedge clk or negedge nrst) begin
    if(!nrst)
        check<=1'b0;
    else if (state == S_ALLOCATE)
        check <= 1'b1;
    else if (state == S_IDLE)
        check <= 1'b0;
    else
        check <= check;
end
//way
always @(posedge clk or negedge nrst) begin
    if(!nrst)
        way_reg <= 1'b0;
    else if ((state == S_COMPARE) & !check) begin            //idle-->compare 상태로 왔을 때
        if (!valid[{index_C_L1,1'b0}])
            way_reg <= 1'b0;
        else if (tag_C_L1 == TAG_ARR[{index_C_L1,1'b0}] )
            way_reg <= 1'b0;
        else if (!valid[{index_C_L1,1'b1}])
            way_reg <= 1'b1;
        else if (tag_C_L1 == TAG_ARR[{index_C_L1,1'b1}] )
            way_reg <= 1'b1;
        else
            way_reg <= LRU_reg [index_C_L1];
    end
    else 
        way_reg <= way_reg;
end
//LRU (if LRU == 0 -> way 0 replace, LRU == 1 -> way 1 replace)
always@(posedge clk or negedge nrst) begin
    if(!nrst)
        LRU_reg <= 1'b0;
    else if (state == S_COMPARE) begin
        if (hit)
            LRU_reg [index_C_L1] <= !way;
        else
            LRU_reg [index_C_L1] <= LRU_reg [index_C_L1];
    end
    else
        LRU_reg <= LRU_reg;
end 

// hit
always @ (posedge clk or negedge nrst)
begin
    if(!nrst)
        hit <= 1'b0;
    else if(state == S_COMPARE)
    begin
        if (hit)                 //hit을 한 클럭만 주기 위해서?
            hit <= 1'b0;
        else if((valid[{index_C_L1,1'b0}] && (tag_C_L1 == TAG_ARR[{index_C_L1,1'b0}] )) || (valid[{index_C_L1,1'b1}] && (tag_C_L1 == TAG_ARR[{index_C_L1,1'b1}])))
            hit <= 1'b1;
        else 
            hit <= hit;
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
        if(miss)
            miss <= 1'b0;
        else if((valid[{index_C_L1,1'b0}] && (tag_C_L1 == TAG_ARR[{index_C_L1,1'b0}] )) || (valid[{index_C_L1,1'b1}] && (tag_C_L1 == TAG_ARR[{index_C_L1,1'b1}])))
            miss <= 1'b0;
        else
            miss <= 1'b1;
    end
    else
        miss <= 1'b0;
end


// valid
always@(posedge clk or negedge nrst)
begin
    if (!nrst)
        valid <= 8'h0;
    else if ((state == S_IDLE) && flush)
        valid <= 8'h0;
    else if ((state == S_ALLOCATE) && ready_L2_L1)
        valid[{index_C_L1,way_reg}] <= 1'b1;
    else
        valid <= valid;
end

generate
    for (i=0; i<8; i = i+1)    begin : block5
        always@(posedge clk or negedge nrst)
        begin
            if(!nrst)
                TAG_ARR[i] <= 24'h0;
            else if((state == S_ALLOCATE)&& ready_L2_L1 && ({index_C_L1,way_reg} == i))
                TAG_ARR[i] <= tag_C_L1;
            else
                TAG_ARR[i] <= TAG_ARR[i];
        end
    end
endgenerate

always@(posedge clk or negedge nrst)       
begin
    if(!nrst)
        refill_reg <= 1'b0;
    else if((state == S_ALLOCATE) && ready_L2_L1)   //수정
        refill_reg <= 1'b1;
    else
        refill_reg <= 1'b0;
end

//read_L1_L2
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        read_L1_L2_reg <= 1'b0;
    else if(state == S_ALLOCATE)
        read_L1_L2_reg <= 1'b1;
    else
        read_L1_L2_reg <= 1'b0;
end


endmodule