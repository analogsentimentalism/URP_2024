`timescale 1ns/1ns
module L1_I_controller #(
	parameter	TNUM	= 21,
	parameter	INUM	= 26 - TNUM,
	parameter	TNUM2	= 18,
	parameter	INUM2	= 26 - TNUM2,
	parameter	WAY		= 2,
	parameter	DEPTH	= 1 << (INUM + clogb2(WAY-1))
) (
    input clk,
    input nrst,
    input [TNUM-1:0] tag_C_L1, 
    input [INUM-1:0] index_C_L1, 
    input read_C_L1, flush,
    input ready_L2_L1,
    output stall, refill, read_L1_L2, 
    output [INUM2-1:0] index_L1_L2,
    output [TNUM2-1:0] tag_L1_L2,
    output [clogb2(WAY-1)-1:0]	way,
    output L1I_miss_o
);

parameter   S_IDLE          =   2'b00;
parameter   S_COMPARE       =   2'b01;
parameter   S_ALLOCATE      =   2'b11;



// define TAG_ARR
reg [TNUM-1:0] TAG_ARR [DEPTH-1:0];       //캐시 ?��?��마다
reg [DEPTH-1:0] valid;


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
assign tag_L1_L2 = tag_C_L1[TNUM-1-:TNUM2];
assign way = way_reg;
assign index_L1_L2 = {tag_C_L1[TNUM-TNUM2-1:0], index_C_L1};
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
    else if ((state == S_COMPARE) & !check) begin            //idle-->compare ?��?���? ?��?�� ?��
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
        if (hit)                 //hit?�� ?�� ?��?���? 주기 ?��?��?��?
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
        valid <= {clogb2(DEPTH-1){1'h0}};
    else if ((state == S_IDLE) && flush)
        valid <= {clogb2(DEPTH-1){1'h0}};
    else if ((state == S_ALLOCATE) && ready_L2_L1)
        valid[{index_C_L1,way_reg}] <= 1'b1;
    else
        valid <= valid;
end

generate
    for (i=0; i<DEPTH; i = i+1)    begin: tag_logic
        always@(posedge clk or negedge nrst)
        begin
            if(!nrst)
                TAG_ARR[i] <= {TNUM{1'h0}};
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
    else if((state == S_ALLOCATE) && ready_L2_L1)   //?��?��
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

function integer clogb2;
input integer depth;
	for (clogb2=0; depth>0; clogb2=clogb2+1)
	depth = depth >> 1;
endfunction

endmodule