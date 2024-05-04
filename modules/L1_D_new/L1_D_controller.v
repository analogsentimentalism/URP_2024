
module L1_D_controller (
    input clk,
    input nrst,
    input [20:0] tag_C_L1, 
    input [4:0] index_C_L1, 
    input read_C_L1, flush,
    input ready_L2_L1,
    input write_C_L1,
    output stall, refill, update, read_L1_L2, write_L1_L2,
    output [7:0] index_L1_L2,
    output [17:0] tag_L1_L2,
    output [17:0] write_tag_L1_L2,
    output [7:0] write_index_L1_L2,
    output way,
    output L1D_miss_o
);

parameter   S_IDLE          =   2'b00;
parameter   S_COMPARE       =   2'b01;
parameter   S_WRITE_BACK    =   2'b10;
parameter   S_ALLOCATE      =   2'b11;



// define TAG_ARR
reg [20:0] TAG_ARR [63:0];       //캐시 라인마다
reg [63:0] valid;
reg [63:0] dirty;

reg [1:0] state, next_state;

reg miss;
reg hit;
reg read_C_L1_reg;
reg refill_reg;                      //controller asserts refill, and the data array accepts the memory data
reg update_reg;                      //For write hits, controller asserts update and data array accepts the write data from the processor
reg read_L1_L2_reg;
reg write_L1_L2_reg;

reg [31:0] LRU_reg;                         //LRU
reg way_reg;                         //Way
reg check;                           //Check
genvar i;

assign update = update_reg;
assign refill = refill_reg;
assign read_L1_L2 = read_L1_L2_reg;
assign write_L1_L2 = write_L1_L2_reg;
assign stall = (state != S_IDLE);
assign tag_L1_L2 = tag_C_L1[20:3];
assign write_tag_L1_L2 = TAG_ARR[{index_C_L1,way_reg}][20:3];          // write back할 주소 tag
assign write_index_L1_L2 = {TAG_ARR[{index_C_L1,way_reg}][2:0], index_C_L1};
assign way = way_reg;
assign index_L1_L2 = {tag_C_L1[2:0],index_C_L1};
assign L1D_miss_o;
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
        S_IDLE          :       next_state      <=      ((read_C_L1)||(write_C_L1))         ?   S_COMPARE     :    S_IDLE;
        S_COMPARE       :       next_state      <=      hit                                 ?   S_IDLE        :    
                                                        (!miss)                             ?   S_COMPARE     :    
                                                        (write_C_L1 && dirty[{index_C_L1,way_reg}])   ?   S_WRITE_BACK  :    S_ALLOCATE; 
        S_ALLOCATE      :       next_state      <=      ready_L2_L1                         ?   S_COMPARE     :    S_ALLOCATE;    
        S_WRITE_BACK    :       next_state      <=      ready_L2_L1                         ?   S_ALLOCATE    :    S_WRITE_BACK;
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
        else if (!valid[{index_C_L1,1'b1}])
            way_reg <= 1'b1;
        else if (tag_C_L1 == TAG_ARR[{index_C_L1,1'b0}] )
            way_reg <= 1'b0;
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

// dirty
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        dirty <= 64'h0;
    else if((state == S_COMPARE) && hit && write_C_L1)
        dirty[{index_C_L1,way_reg}] <= 1'b1;
    else if((state == S_ALLOCATE) && ready_L2_L1)
        dirty[{index_C_L1,way_reg}] <= 1'b0;            //read일 때는 맞음. 그럼 write일 때는 로드할 땐 0, 쓰고 나서 1로 바꿔준다
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
        valid[{index_C_L1,way_reg}] <= 1'b1;
    else
        valid <= valid;
end

generate
    for (i=0; i<64; i = i+1)    begin
        always@(posedge clk or negedge nrst)
        begin
            if(!nrst)
                TAG_ARR[i] <= 21'h0;
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

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        update_reg <= 1'b0;
    else if ((state == S_COMPARE) && hit && write_C_L1)    // 수정: hit 일 때만 update=1로 올려준다
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
        read_L1_L2_reg <= 1'b0;
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