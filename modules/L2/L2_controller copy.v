
module L2_controller (
    input clk,
    input nrst,
    input [17:0] tag_L1_L2, 
    input [7:0] index_L1_L2, 
    input read_L1_L2, flush,
    input ready_MEM_L2,
    input write_L1_L2,
    output ready_L2_L1,
    output refill, update, read_L2_MEM, write_L2_MEM,
    output [7:0] index_L2_MEM,
    output [17:0] tag_L2_MEM,
    output [17:0] write_tag_L2_MEM,
    output [1:0] way
);

parameter   S_IDLE          =   2'b00;
parameter   S_COMPARE       =   2'b01;
parameter   S_WRITE_BACK    =   2'b10;
parameter   S_ALLOCATE      =   2'b11;

parameter   cache_line_num  =   11'd1024;
parameter   cache_set_num   =   9'd256;   

// define TAG_ARR
reg [17:0] TAG_ARR [cache_line_num-1:0];       //캐시 라인마다
reg [cache_line_num-1:0] valid;
reg [cache_line_num-1:0] dirty;

reg [1:0] state, next_state;

reg miss;
reg hit;
reg read_L1_L2_reg;
reg refill_reg;                      //controller asserts refill, and the data array accepts the memory data
reg update_reg;                      //For write hits, controller asserts update and data array accepts the write data from the processor
reg read_L2_MEM_reg;
reg write_L2_MEM_reg;

reg [1:0] LRU_reg [cache_set_num-1:0];                          //LRU
reg [4:0] LRU_array_reg [cache_set_num-1:0];
reg [1:0] way_reg;                         //Way
reg check;                           //Check
genvar i;

assign update = update_reg;
assign refill = refill_reg;
assign read_L2_MEM = read_L2_MEM_reg;
assign write_L2_MEM = write_L2_MEM_reg;
assign stall = (state != S_IDLE);
assign tag_L2_MEM = tag_L1_L2;
assign write_tag_L2_MEM = TAG_ARR[{index_L1_L2,way_reg}];          // write back할 주소 tag
assign way = way_reg;
assign index_L2_MEM = index_L1_L2;

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
        S_IDLE          :       next_state      <=      ((read_L1_L2)||(write_L1_L2))         ?   S_COMPARE     :    S_IDLE;
        S_COMPARE       :       next_state      <=      hit                                 ?   S_IDLE        :    
                                                        (!miss)                             ?   S_COMPARE     :    
                                                        (write_L1_L2 && dirty[{index_L1_L2,way_reg}])   ?   S_WRITE_BACK  :    S_ALLOCATE; 
        S_ALLOCATE      :       next_state      <=      ready_MEM_L2                         ?   S_COMPARE     :    S_ALLOCATE;    
        S_WRITE_BACK    :       next_state      <=      ready_MEM_L2                         ?   S_ALLOCATE    :    S_WRITE_BACK;
    endcase
end                    
always @(posedge clk or negedge nrst) begin
    if(!nrst)
        check <=1'b0;
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
        way_reg <= 2'b00;
    else if ((state == S_COMPARE) & !check) begin            //idle-->compare 상태로 왔을 때
        
        
        if (!valid[{index_L1_L2,2'b00}])
            way_reg <= 2'b00;
        else if (!valid[{index_L1_L2,2'b01}])
            way_reg <= 2'b01;
        else if (!valid[{index_L1_L2, 2'b10}])
            way_reg <= 2'b10;
        else if (!valid[{index_L1_L2, 2'b11}])
            way_reg <= 2'b11; 

        else if (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b00}] )
            way_reg <= 2'b00;
        else if (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b01}] )
            way_reg <= 2'b01;
        else if (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b10}] )
            way_reg <= 2'b10;
        else if (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b11}] )
            way_reg <= 2'b11;
        else begin
            case(LRU_array_reg[index_L1_L2])
                5'b00000 : way_reg <= 2'b00;
                5'b00001 : way_reg <= 2'b00;
                5'b00010 : way_reg <= 2'b00;
                5'b00011 : way_reg <= 2'b00;
                5'b00100 : way_reg <= 2'b00;
                5'b00101 : way_reg <= 2'b00;
                5'b00110 : way_reg <= 2'b01;
                5'b00111 : way_reg <= 2'b01;
                5'b01000 : way_reg <= 2'b01;
                5'b01001 : way_reg <= 2'b01;
                5'b01010 : way_reg <= 2'b01;
                5'b01011 : way_reg <= 2'b01;
                5'b01100 : way_reg <= 2'b10;
                5'b01101 : way_reg <= 2'b10;
                5'b01110 : way_reg <= 2'b10;
                5'b01111 : way_reg <= 2'b10;
                5'b10000 : way_reg <= 2'b10;
                5'b10001 : way_reg <= 2'b10;
                5'b10010 : way_reg <= 2'b11;
                5'b10011 : way_reg <= 2'b11;
                5'b10100 : way_reg <= 2'b11;
                5'b10101 : way_reg <= 2'b11;
                5'b10110 : way_reg <= 2'b11;
                5'b10111 : way_reg <= 2'b11;
                default : way_reg <= way_reg;
            endcase
        end
    end
    else 
        way_reg <= way_reg;
end
//LRU (if LRU == 0 -> way 0 replace, LRU == 1 -> way 1 replace)
generate
    for (i=0; i<cache_line_num; i = i+1)    begin
        always@(posedge clk or negedge nrst)
        begin
            if(!nrst)
                LRU_array_reg[i] <= 5'h0;
            else if(state == S_COMPARE) begin
                if (hit) begin
                    case(LRU_array_reg)
                        5'b00000 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01001 : (way == 2'b01) ? 5'b00011 : (way == 2'b10) ? 5'b00001 : 5'b00000; // 1234
                        5'b00001 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01011 : (way == 2'b01) ? 5'b00101 : (way == 2'b10) ? 5'b00001 : 5'b00000; // 1243
                        5'b00010 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01111 : (way == 2'b01) ? 5'b00011 : (way == 2'b10) ? 5'b00001 : 5'b00010; // 1324
                        5'b00011 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10001 : (way == 2'b01) ? 5'b00011 : (way == 2'b10) ? 5'b00100 : 5'b00010; // 1342
                        5'b00100 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10101 : (way == 2'b01) ? 5'b00101 : (way == 2'b10) ? 5'b00100 : 5'b00000; // 1423
                        5'b00101 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10111 : (way == 2'b01) ? 5'b00101 : (way == 2'b10) ? 5'b00100 : 5'b00010; // 1432
                        5'b00110 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01001 : (way == 2'b01) ? 5'b00011 : (way == 2'b10) ? 5'b00111 : 5'b00110; // 2134
                        5'b00111 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01011 : (way == 2'b01) ? 5'b00101 : (way == 2'b10) ? 5'b00111 : 5'b00110; // 2143
                        5'b01000 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01001 : (way == 2'b01) ? 5'b01101 : (way == 2'b10) ? 5'b00111 : 5'b01000; // 2314
                        5'b01001 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01001 : (way == 2'b01) ? 5'b10000 : (way == 2'b10) ? 5'b01010 : 5'b01000; // 2341
                        5'b01010 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01011 : (way == 2'b01) ? 5'b10011 : (way == 2'b10) ? 5'b01010 : 5'b00110; // 2413
                        5'b01011 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01011 : (way == 2'b01) ? 5'b10110 : (way == 2'b10) ? 5'b01010 : 5'b01000; // 2431
                        5'b01100 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01111 : (way == 2'b01) ? 5'b01101 : (way == 2'b10) ? 5'b00001 : 5'b01100; // 3124
                        5'b01101 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10001 : (way == 2'b01) ? 5'b01101 : (way == 2'b10) ? 5'b00100 : 5'b01100; // 3142
                        5'b01110 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01111 : (way == 2'b01) ? 5'b01101 : (way == 2'b10) ? 5'b00111 : 5'b01110; // 3214
                        5'b01111 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b01111 : (way == 2'b01) ? 5'b10000 : (way == 2'b10) ? 5'b01010 : 5'b01110; // 3241
                        5'b10000 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10001 : (way == 2'b01) ? 5'b10000 : (way == 2'b10) ? 5'b10010 : 5'b01100; // 3412
                        5'b10001 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10001 : (way == 2'b01) ? 5'b10000 : (way == 2'b10) ? 5'b10100 : 5'b01110; // 3421
                        5'b10010 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10101 : (way == 2'b01) ? 5'b10011 : (way == 2'b10) ? 5'b10010 : 5'b00000; // 4123
                        5'b10011 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10111 : (way == 2'b01) ? 5'b10011 : (way == 2'b10) ? 5'b10010 : 5'b00010; // 4132
                        5'b10100 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10101 : (way == 2'b01) ? 5'b10011 : (way == 2'b10) ? 5'b10100 : 5'b00110; // 4213
                        5'b10101 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10101 : (way == 2'b01) ? 5'b10110 : (way == 2'b10) ? 5'b10100 : 5'b01000; // 4231
                        5'b10110 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10111 : (way == 2'b01) ? 5'b10110 : (way == 2'b10) ? 5'b10010 : 5'b01100; // 4312
                        5'b10111 : LRU_array_reg[i] <= (way == 2'b00) ? 5'b10111 : (way == 2'b01) ? 5'b10110 : (way == 2'b10) ? 5'b10100 : 5'b01110; // 4321
                        default : LRU_array_reg[i] <= LRU_array_reg[i];
                    endcase
                end
                else
                    LRU_array_reg[i] <= LRU_array_reg[i];
            end    
        end
    end
endgenerate

// ready_L2_L1
always @(posedge clk or negedge nrst) begin
    if (!nrst)
        ready_L2_L1 <= 1'b0;
    else if (hit)
        ready_L2_L1 <= 1'b1;
    else
        ready_L2_L1 <= 1'b0;
end


//always@(posedge clk or negedge nrst) begin
//    if(!nrst)
//        LRU_reg <= 1'b0;
//    else if (state == S_COMPARE) begin
//        if (hit)
//            LRU_reg [index_C_L1] <= !way;
//        else
//            LRU_reg [index_C_L1] <= LRU_reg [index_C_L1];
//    end
//    else
//        LRU_reg <= LRU_reg;
//end 

// hit
always @ (posedge clk or negedge nrst)
begin
    if(!nrst)
        hit <= 1'b0;
    else if(state == S_COMPARE)
    begin
        if (hit)                 //hit을 한 클럭만 주기 위해서?
            hit <= 1'b0;
        else if(read_L1_L2 && 
                ((valid[{index_L1_L2,2'b00}] && (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b00}])) || 
                (valid[{index_L1_L2,2'b01}] && (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b01}])) ||
                (valid[{index_L1_L2,2'b10}] && (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b10}])) ||
                (valid[{index_L1_L2,2'b11}] && (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b11}]))))
            hit <= 1'b1;
        else if(write_L1_L2 && 
                ((valid[{index_L1_L2,2'b00}] && (write_tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b00}])) || 
                (valid[{index_L1_L2,2'b01}] && (write_tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b01}])) ||
                (valid[{index_L1_L2,2'b10}] && (write_tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b10}])) ||
                (valid[{index_L1_L2,2'b11}] && (write_tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b11}]))))
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
        else if((valid[{index_L1_L2,2'b00}] && (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b00}])) || 
                (valid[{index_L1_L2,2'b01}] && (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b01}])) ||
                (valid[{index_L1_L2,2'b10}] && (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b10}])) ||
                (valid[{index_L1_L2,2'b11}] && (tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b11}])))
            miss <= 1'b0;
        else if(write_L1_L2 && 
                ((valid[{index_L1_L2,2'b00}] && (write_tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b00}])) || 
                (valid[{index_L1_L2,2'b01}] && (write_tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b01}])) ||
                (valid[{index_L1_L2,2'b10}] && (write_tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b10}])) ||
                (valid[{index_L1_L2,2'b11}] && (write_tag_L1_L2 == TAG_ARR[{index_L1_L2,2'b11}]))))
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
        dirty <= 1024'h0;
    else if((state == S_COMPARE) && hit && write_L1_L2)
        dirty[{index_L1_L2,way_reg}] <= 1'b1;
    else if((state == S_ALLOCATE) && ready_MEM_L2)
        dirty[{index_L1_L2,way_reg}] <= 1'b0;            //read일 때는 맞음. 그럼 write일 때는 로드할 땐 0, 쓰고 나서 1로 바꿔준다
    else
        dirty <= dirty;
end
// valid
always@(posedge clk or negedge nrst)
begin
    if (!nrst)
        valid <= 1024'h0;
    else if ((state == S_IDLE) && flush)
        valid <= 1024'h0;
    else if ((state == S_ALLOCATE) && ready_MEM_L2)
        valid[{index_L1_L2,way_reg}] <= 1'b1;
    else
        valid <= valid;
end

generate
    for (i=0; i<cache_line_num; i = i+1)    begin
        always@(posedge clk or negedge nrst)
        begin
            if(!nrst)
                TAG_ARR[i] <= 18'h0;
            else if((state == S_ALLOCATE)&& ready_MEM_L2 && ({index_L1_L2,way_reg} == i))
                TAG_ARR[i] <= tag_L1_L2;
            else
                TAG_ARR[i] <= TAG_ARR[i];
        end
    end
endgenerate

always@(posedge clk or negedge nrst)       
begin
    if(!nrst)
        refill_reg <= 1'b0;
    else if((state == S_ALLOCATE) && ready_MEM_L2)   //수정
        refill_reg <= 1'b1;
    else
        refill_reg <= 1'b0;
end

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        update_reg <= 1'b0;
    else if ((state == S_COMPARE) && hit && write_L1_L2)    // 수정: hit 일 때만 update=1로 올려준다
        update_reg <= 1'b1;
    else
        update_reg <= 1'b0;
end        

//read_L1_L2
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        read_L2_MEM_reg <= 1'b0;
    else if(state == S_ALLOCATE)
        read_L2_MEM_reg <= 1'b1;
    else
        read_L2_MEM_reg <= 1'b0;
end

//write_L1_L2
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        write_L2_MEM_reg <= 1'b0;
    else if (state == S_WRITE_BACK)
        write_L2_MEM_reg <= 1'b1;
    else   
        write_L2_MEM_reg <= 1'b0;
end


endmodule