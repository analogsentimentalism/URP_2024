module L1_D_controller (
    input clk,
    input nrst,
    input [51:0] tag, 
    input [5:0] index, 
    input read_C_L1, flush,
    input ready_L2_L1,
    input write_C_L1,

    output stall, refill, update, read_L1_L2, write_L1_L2
);



reg [53:0] TAG_ARR_0;
reg [53:0] TAG_ARR_1;
reg [53:0] TAG_ARR_2;
reg [53:0] TAG_ARR_3;
reg [53:0] TAG_ARR_4;
reg [53:0] TAG_ARR_5;
reg [53:0] TAG_ARR_6;
reg [53:0] TAG_ARR_7;
reg [53:0] TAG_ARR_8;
reg [53:0] TAG_ARR_9;
reg [53:0] TAG_ARR_10;
reg [53:0] TAG_ARR_11;
reg [53:0] TAG_ARR_12;
reg [53:0] TAG_ARR_13;
reg [53:0] TAG_ARR_14;
reg [53:0] TAG_ARR_15;
reg [53:0] TAG_ARR_16;
reg [53:0] TAG_ARR_17;
reg [53:0] TAG_ARR_18;
reg [53:0] TAG_ARR_19;
reg [53:0] TAG_ARR_20;
reg [53:0] TAG_ARR_21;
reg [53:0] TAG_ARR_22;
reg [53:0] TAG_ARR_23;
reg [53:0] TAG_ARR_24;
reg [53:0] TAG_ARR_25;
reg [53:0] TAG_ARR_26;
reg [53:0] TAG_ARR_27;
reg [53:0] TAG_ARR_28;
reg [53:0] TAG_ARR_29;
reg [53:0] TAG_ARR_30;
reg [53:0] TAG_ARR_31;
reg [53:0] TAG_ARR_32;
reg [53:0] TAG_ARR_33;
reg [53:0] TAG_ARR_34;
reg [53:0] TAG_ARR_35;
reg [53:0] TAG_ARR_36;
reg [53:0] TAG_ARR_37;
reg [53:0] TAG_ARR_38;
reg [53:0] TAG_ARR_39;
reg [53:0] TAG_ARR_40;
reg [53:0] TAG_ARR_41;
reg [53:0] TAG_ARR_42;
reg [53:0] TAG_ARR_43;
reg [53:0] TAG_ARR_44;
reg [53:0] TAG_ARR_45;
reg [53:0] TAG_ARR_46;
reg [53:0] TAG_ARR_47;
reg [53:0] TAG_ARR_48;
reg [53:0] TAG_ARR_49;
reg [53:0] TAG_ARR_50;
reg [53:0] TAG_ARR_51;
reg [53:0] TAG_ARR_52;
reg [53:0] TAG_ARR_53;
reg [53:0] TAG_ARR_54;
reg [53:0] TAG_ARR_55;
reg [53:0] TAG_ARR_56;
reg [53:0] TAG_ARR_57;
reg [53:0] TAG_ARR_58;
reg [53:0] TAG_ARR_59;
reg [53:0] TAG_ARR_60;
reg [53:0] TAG_ARR_61;
reg [53:0] TAG_ARR_62;
reg [53:0] TAG_ARR_63;
reg miss;
reg hit;
reg read_C_L1_reg;
reg stall_reg;
reg refill_reg;
reg read_L1_L2_reg;

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
    else if(stall_reg == 1'b1)         // 한 주기동안만 1 유지 
        stall_reg <= 1'b0;
    else if(read_C_L1 == 1'b1)        // 읽기 신호 1이면 한 주기동안 1유지 
        stall_reg <= 1'b1;
    else stall_reg <= stall_reg;
end


// miss
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        miss <= 1'b0;
    else if(ready_L2_L1 == 1'b1)   // L2 캐시에서 L1 캐시로 데이터를 보낼 준비가 되었다면 miss를 0으로 바꿈
        miss <= 1'b0;
    else if (read_C_L1 == 1'b1) 
    begin
        case(index)
            0 :  miss <= ( (TAG_ARR_0[53] == 1'b1)&&(tag == TAG_ARR_0[51:0])) ? 1'b0 : 1'b1;  
            1 :  miss <= ( (TAG_ARR_1[53] == 1'b1)&&(tag == TAG_ARR_1[51:0])) ? 1'b0 : 1'b1;
            2 :  miss <= ( (TAG_ARR_2[53] == 1'b1)&&(tag == TAG_ARR_2[51:0])) ? 1'b0 : 1'b1;
            3 :  miss <= ( (TAG_ARR_3[53] == 1'b1)&&(tag == TAG_ARR_3[51:0])) ? 1'b0 : 1'b1;
            4 :  miss <= ( (TAG_ARR_4[53] == 1'b1)&&(tag == TAG_ARR_4[51:0])) ? 1'b0 : 1'b1;
            5 :  miss <= ( (TAG_ARR_5[53] == 1'b1)&&(tag == TAG_ARR_5[51:0])) ? 1'b0 : 1'b1;
            6 :  miss <= ( (TAG_ARR_6[53] == 1'b1)&&(tag == TAG_ARR_6[51:0])) ? 1'b0 : 1'b1;
            7 :  miss <= ( (TAG_ARR_7[53] == 1'b1)&&(tag == TAG_ARR_7[51:0])) ? 1'b0 : 1'b1;
            8 :  miss <= ( (TAG_ARR_8[53] == 1'b1)&&(tag == TAG_ARR_8[51:0])) ? 1'b0 : 1'b1;
            9 :  miss <= ( (TAG_ARR_9[53] == 1'b1)&&(tag == TAG_ARR_9[51:0])) ? 1'b0 : 1'b1;
            10 : miss <= ( (TAG_ARR_10[53] == 1'b1)&&(tag == TAG_ARR_10[51:0])) ? 1'b0 : 1'b1;   
            11 : miss <= ( (TAG_ARR_11[53] == 1'b1)&&(tag == TAG_ARR_11[51:0])) ? 1'b0 : 1'b1;   
            12 : miss <= ( (TAG_ARR_12[53] == 1'b1)&&(tag == TAG_ARR_12[51:0])) ? 1'b0 : 1'b1;   
            13 : miss <= ( (TAG_ARR_13[53] == 1'b1)&&(tag == TAG_ARR_13[51:0])) ? 1'b0 : 1'b1;   
            14 : miss <= ( (TAG_ARR_14[53] == 1'b1)&&(tag == TAG_ARR_14[51:0])) ? 1'b0 : 1'b1;   
            15 : miss <= ( (TAG_ARR_15[53] == 1'b1)&&(tag == TAG_ARR_15[51:0])) ? 1'b0 : 1'b1;   
            16 : miss <= ( (TAG_ARR_16[53] == 1'b1)&&(tag == TAG_ARR_16[51:0])) ? 1'b0 : 1'b1;   
            17 : miss <= ( (TAG_ARR_17[53] == 1'b1)&&(tag == TAG_ARR_17[51:0])) ? 1'b0 : 1'b1;   
            18 : miss <= ( (TAG_ARR_18[53] == 1'b1)&&(tag == TAG_ARR_18[51:0])) ? 1'b0 : 1'b1;   
            19 : miss <= ( (TAG_ARR_19[53] == 1'b1)&&(tag == TAG_ARR_19[51:0])) ? 1'b0 : 1'b1;   
            20 : miss <= ( (TAG_ARR_20[53] == 1'b1)&&(tag == TAG_ARR_20[51:0])) ? 1'b0 : 1'b1;   
            21 : miss <= ( (TAG_ARR_21[53] == 1'b1)&&(tag == TAG_ARR_21[51:0])) ? 1'b0 : 1'b1;   
            22 : miss <= ( (TAG_ARR_22[53] == 1'b1)&&(tag == TAG_ARR_22[51:0])) ? 1'b0 : 1'b1;   
            23 : miss <= ( (TAG_ARR_23[53] == 1'b1)&&(tag == TAG_ARR_23[51:0])) ? 1'b0 : 1'b1;   
            24 : miss <= ( (TAG_ARR_24[53] == 1'b1)&&(tag == TAG_ARR_24[51:0])) ? 1'b0 : 1'b1;   
            25 : miss <= ( (TAG_ARR_25[53] == 1'b1)&&(tag == TAG_ARR_25[51:0])) ? 1'b0 : 1'b1;   
            26 : miss <= ( (TAG_ARR_26[53] == 1'b1)&&(tag == TAG_ARR_26[51:0])) ? 1'b0 : 1'b1;   
            27 : miss <= ( (TAG_ARR_27[53] == 1'b1)&&(tag == TAG_ARR_27[51:0])) ? 1'b0 : 1'b1;   
            28 : miss <= ( (TAG_ARR_28[53] == 1'b1)&&(tag == TAG_ARR_28[51:0])) ? 1'b0 : 1'b1;   
            29 : miss <= ( (TAG_ARR_29[53] == 1'b1)&&(tag == TAG_ARR_29[51:0])) ? 1'b0 : 1'b1;   
            30 : miss <= ( (TAG_ARR_30[53] == 1'b1)&&(tag == TAG_ARR_30[51:0])) ? 1'b0 : 1'b1;   
            31 : miss <= ( (TAG_ARR_31[53] == 1'b1)&&(tag == TAG_ARR_31[51:0])) ? 1'b0 : 1'b1;   
            32 : miss <= ( (TAG_ARR_32[53] == 1'b1)&&(tag == TAG_ARR_32[51:0])) ? 1'b0 : 1'b1;   
            33 : miss <= ( (TAG_ARR_33[53] == 1'b1)&&(tag == TAG_ARR_33[51:0])) ? 1'b0 : 1'b1;   
            34 : miss <= ( (TAG_ARR_34[53] == 1'b1)&&(tag == TAG_ARR_34[51:0])) ? 1'b0 : 1'b1;   
            35 : miss <= ( (TAG_ARR_35[53] == 1'b1)&&(tag == TAG_ARR_35[51:0])) ? 1'b0 : 1'b1;   
            36 : miss <= ( (TAG_ARR_36[53] == 1'b1)&&(tag == TAG_ARR_36[51:0])) ? 1'b0 : 1'b1;   
            37 : miss <= ( (TAG_ARR_37[53] == 1'b1)&&(tag == TAG_ARR_37[51:0])) ? 1'b0 : 1'b1;   
            38 : miss <= ( (TAG_ARR_38[53] == 1'b1)&&(tag == TAG_ARR_38[51:0])) ? 1'b0 : 1'b1;   
            39 : miss <= ( (TAG_ARR_39[53] == 1'b1)&&(tag == TAG_ARR_39[51:0])) ? 1'b0 : 1'b1;   
            40 : miss <= ( (TAG_ARR_40[53] == 1'b1)&&(tag == TAG_ARR_40[51:0])) ? 1'b0 : 1'b1;   
            41 : miss <= ( (TAG_ARR_41[53] == 1'b1)&&(tag == TAG_ARR_41[51:0])) ? 1'b0 : 1'b1;   
            42 : miss <= ( (TAG_ARR_42[53] == 1'b1)&&(tag == TAG_ARR_42[51:0])) ? 1'b0 : 1'b1;   
            43 : miss <= ( (TAG_ARR_43[53] == 1'b1)&&(tag == TAG_ARR_43[51:0])) ? 1'b0 : 1'b1;   
            44 : miss <= ( (TAG_ARR_44[53] == 1'b1)&&(tag == TAG_ARR_44[51:0])) ? 1'b0 : 1'b1;   
            45 : miss <= ( (TAG_ARR_45[53] == 1'b1)&&(tag == TAG_ARR_45[51:0])) ? 1'b0 : 1'b1;   
            46 : miss <= ( (TAG_ARR_46[53] == 1'b1)&&(tag == TAG_ARR_46[51:0])) ? 1'b0 : 1'b1;   
            47 : miss <= ( (TAG_ARR_47[53] == 1'b1)&&(tag == TAG_ARR_47[51:0])) ? 1'b0 : 1'b1;   
            48 : miss <= ( (TAG_ARR_48[53] == 1'b1)&&(tag == TAG_ARR_48[51:0])) ? 1'b0 : 1'b1;   
            49 : miss <= ( (TAG_ARR_49[53] == 1'b1)&&(tag == TAG_ARR_49[51:0])) ? 1'b0 : 1'b1;   
            50 : miss <= ( (TAG_ARR_50[53] == 1'b1)&&(tag == TAG_ARR_50[51:0])) ? 1'b0 : 1'b1;   
            51 : miss <= ( (TAG_ARR_51[53] == 1'b1)&&(tag == TAG_ARR_51[51:0])) ? 1'b0 : 1'b1;   
            52 : miss <= ( (TAG_ARR_52[53] == 1'b1)&&(tag == TAG_ARR_52[51:0])) ? 1'b0 : 1'b1;   
            53 : miss <= ( (TAG_ARR_53[53] == 1'b1)&&(tag == TAG_ARR_53[51:0])) ? 1'b0 : 1'b1;   
            54 : miss <= ( (TAG_ARR_54[53] == 1'b1)&&(tag == TAG_ARR_54[51:0])) ? 1'b0 : 1'b1;   
            55 : miss <= ( (TAG_ARR_55[53] == 1'b1)&&(tag == TAG_ARR_55[51:0])) ? 1'b0 : 1'b1;   
            56 : miss <= ( (TAG_ARR_56[53] == 1'b1)&&(tag == TAG_ARR_56[51:0])) ? 1'b0 : 1'b1;   
            57 : miss <= ( (TAG_ARR_57[53] == 1'b1)&&(tag == TAG_ARR_57[51:0])) ? 1'b0 : 1'b1;   
            58 : miss <= ( (TAG_ARR_58[53] == 1'b1)&&(tag == TAG_ARR_58[51:0])) ? 1'b0 : 1'b1;   
            59 : miss <= ( (TAG_ARR_59[53] == 1'b1)&&(tag == TAG_ARR_59[51:0])) ? 1'b0 : 1'b1;   
            60 : miss <= ( (TAG_ARR_60[53] == 1'b1)&&(tag == TAG_ARR_60[51:0])) ? 1'b0 : 1'b1;   
            61 : miss <= ( (TAG_ARR_61[53] == 1'b1)&&(tag == TAG_ARR_61[51:0])) ? 1'b0 : 1'b1;   
            62 : miss <= ( (TAG_ARR_62[53] == 1'b1)&&(tag == TAG_ARR_62[51:0])) ? 1'b0 : 1'b1;   
            default : miss <= ( (TAG_ARR_63[53] == 1'b1)&&(tag == TAG_ARR_63[51:0])) ? 1'b0 : 1'b1;
        endcase 
    end  

    else
        miss <= miss;          
end


// Tag
always@(posedge clk or negedge nrst)    
begin
    if (!nrst)
    begin           
        TAG_ARR_0   <= 54'h0;
        TAG_ARR_1   <= 54'h0;
        TAG_ARR_2   <= 54'h0;
        TAG_ARR_3   <= 54'h0;
        TAG_ARR_4   <= 54'h0;
        TAG_ARR_5   <= 54'h0;
        TAG_ARR_6   <= 54'h0;
        TAG_ARR_7   <= 54'h0;
        TAG_ARR_8   <= 54'h0;
        TAG_ARR_9   <= 54'h0;
        TAG_ARR_10  <= 54'h0;
        TAG_ARR_11  <= 54'h0;
        TAG_ARR_12  <= 54'h0;
        TAG_ARR_13  <= 54'h0;
        TAG_ARR_14  <= 54'h0;
        TAG_ARR_15  <= 54'h0;
        TAG_ARR_16  <= 54'h0;
        TAG_ARR_17  <= 54'h0;
        TAG_ARR_18  <= 54'h0;
        TAG_ARR_19  <= 54'h0;
        TAG_ARR_20  <= 54'h0;
        TAG_ARR_21  <= 54'h0;
        TAG_ARR_22  <= 54'h0;
        TAG_ARR_23  <= 54'h0;
        TAG_ARR_24  <= 54'h0;
        TAG_ARR_25  <= 54'h0;
        TAG_ARR_26  <= 54'h0;
        TAG_ARR_27  <= 54'h0;
        TAG_ARR_28  <= 54'h0;
        TAG_ARR_29  <= 54'h0;
        TAG_ARR_30  <= 54'h0;
        TAG_ARR_31  <= 54'h0;
        TAG_ARR_32  <= 54'h0;
        TAG_ARR_33  <= 54'h0;
        TAG_ARR_34  <= 54'h0;
        TAG_ARR_35  <= 54'h0;
        TAG_ARR_36  <= 54'h0;
        TAG_ARR_37  <= 54'h0;
        TAG_ARR_38  <= 54'h0;
        TAG_ARR_39  <= 54'h0;
        TAG_ARR_40  <= 54'h0;
        TAG_ARR_41  <= 54'h0;
        TAG_ARR_42  <= 54'h0;
        TAG_ARR_43  <= 54'h0;
        TAG_ARR_44  <= 54'h0;
        TAG_ARR_45  <= 54'h0;
        TAG_ARR_46  <= 54'h0;
        TAG_ARR_47  <= 54'h0;
        TAG_ARR_48  <= 54'h0;
        TAG_ARR_49  <= 54'h0;
        TAG_ARR_50  <= 54'h0;
        TAG_ARR_51  <= 54'h0;
        TAG_ARR_52  <= 54'h0;
        TAG_ARR_53  <= 54'h0;
        TAG_ARR_54  <= 54'h0;
        TAG_ARR_55  <= 54'h0;
        TAG_ARR_56  <= 54'h0;
        TAG_ARR_57  <= 54'h0;
        TAG_ARR_58  <= 54'h0;
        TAG_ARR_59  <= 54'h0;
        TAG_ARR_60  <= 54'h0;
        TAG_ARR_61  <= 54'h0;
        TAG_ARR_62  <= 54'h0;
        TAG_ARR_63  <= 54'h0;
    end
    else if (flush == 1'b1)             // Flush
    begin           
        TAG_ARR_0[53]    <=   1'b0; 
        TAG_ARR_1[53]    <=   1'b0; 
        TAG_ARR_2[53]    <=   1'b0; 
        TAG_ARR_3[53]    <=   1'b0; 
        TAG_ARR_4[53]    <=   1'b0; 
        TAG_ARR_5[53]    <=   1'b0; 
        TAG_ARR_6[53]    <=   1'b0; 
        TAG_ARR_7[53]    <=   1'b0; 
        TAG_ARR_8[53]    <=   1'b0; 
        TAG_ARR_9[53]     <=   1'b0; 
        TAG_ARR_10[53]    <=   1'b0; 
        TAG_ARR_11[53]    <=   1'b0; 
        TAG_ARR_12[53]    <=   1'b0; 
        TAG_ARR_13[53]    <=   1'b0; 
        TAG_ARR_14[53]    <=   1'b0; 
        TAG_ARR_15[53]    <=   1'b0; 
        TAG_ARR_16[53]    <=   1'b0; 
        TAG_ARR_17[53]    <=   1'b0; 
        TAG_ARR_18[53]    <=   1'b0; 
        TAG_ARR_19[53]    <=   1'b0;
        TAG_ARR_20[53]    <=   1'b0;        
        TAG_ARR_21[53]    <=   1'b0;
        TAG_ARR_22[53]    <=   1'b0;
        TAG_ARR_23[53]    <=   1'b0;
        TAG_ARR_24[53]    <=   1'b0;
        TAG_ARR_25[53]    <=   1'b0;
        TAG_ARR_26[53]    <=   1'b0;
        TAG_ARR_27[53]    <=   1'b0;
        TAG_ARR_28[53]    <=   1'b0;
        TAG_ARR_29[53]    <=   1'b0;
        TAG_ARR_30[53]    <=   1'b0;
        TAG_ARR_31[53]    <=   1'b0;
        TAG_ARR_32[53]    <=   1'b0;
        TAG_ARR_33[53]    <=   1'b0;
        TAG_ARR_34[53]    <=   1'b0;
        TAG_ARR_35[53]    <=   1'b0;
        TAG_ARR_36[53]    <=   1'b0;
        TAG_ARR_37[53]    <=   1'b0;
        TAG_ARR_38[53]    <=   1'b0;
        TAG_ARR_39[53]    <=   1'b0;
        TAG_ARR_40[53]    <=   1'b0;
        TAG_ARR_41[53]    <=   1'b0;
        TAG_ARR_42[53]    <=   1'b0;
        TAG_ARR_43[53]    <=   1'b0;
        TAG_ARR_44[53]    <=   1'b0;
        TAG_ARR_45[53]    <=   1'b0;
        TAG_ARR_46[53]    <=   1'b0;
        TAG_ARR_47[53]    <=   1'b0;
        TAG_ARR_48[53]    <=   1'b0;
        TAG_ARR_49[53]    <=   1'b0;
        TAG_ARR_50[53]    <=   1'b0;
        TAG_ARR_51[53]    <=   1'b0;
        TAG_ARR_52[53]    <=   1'b0;
        TAG_ARR_53[53]    <=   1'b0;
        TAG_ARR_54[53]    <=   1'b0;
        TAG_ARR_55[53]    <=   1'b0;
        TAG_ARR_56[53]    <=   1'b0;
        TAG_ARR_57[53]    <=   1'b0;
        TAG_ARR_58[53]    <=   1'b0;
        TAG_ARR_59[53]    <=   1'b0;
        TAG_ARR_60[53]    <=   1'b0;
        TAG_ARR_61[53]    <=   1'b0;
        TAG_ARR_62[53]    <=   1'b0;
        TAG_ARR_63[53]    <=   1'b0;

    end
    else if(read_C_L1_reg == 1'b1)
    begin        
        case(index) 
            0 : begin TAG_ARR_0[51:0] <= ( miss == 1'b1) ? TAG_ARR_0[51:0] : tag;        TAG_ARR_0[53] <=  (ready_L2_L1 == 1'b0)  ? TAG_ARR_0[53] : 1'b1 ; end  
            1 : begin TAG_ARR_1[51:0] <= ( miss == 1'b1) ? TAG_ARR_1[51:0] : tag;        TAG_ARR_1[53] <=  (ready_L2_L1 == 1'b0)  ? TAG_ARR_1[53] : 1'b1 ; end 
            2 : begin TAG_ARR_2[51:0] <= ( miss == 1'b1) ? TAG_ARR_2[51:0] : tag;        TAG_ARR_2[53] <=  (ready_L2_L1 == 1'b0)  ? TAG_ARR_2[53] : 1'b1 ; end
            3 : begin TAG_ARR_3[51:0] <= ( miss == 1'b1) ? TAG_ARR_3[51:0] : tag;        TAG_ARR_3[53] <=  (ready_L2_L1 == 1'b0)  ? TAG_ARR_3[53] : 1'b1 ; end
            4 : begin TAG_ARR_4[51:0] <= ( miss == 1'b1) ? TAG_ARR_4[51:0] : tag;        TAG_ARR_4[53] <=  (ready_L2_L1 == 1'b0)  ? TAG_ARR_4[53] : 1'b1 ; end
            5 : begin TAG_ARR_5[51:0] <= ( miss == 1'b1) ? TAG_ARR_5[51:0] : tag;        TAG_ARR_5[53] <=  (ready_L2_L1 == 1'b0)  ? TAG_ARR_5[53] : 1'b1 ; end
            6 : begin TAG_ARR_6[51:0] <= ( miss == 1'b1) ? TAG_ARR_6[51:0] : tag;        TAG_ARR_6[53] <=  (ready_L2_L1 == 1'b0)  ? TAG_ARR_6[53] : 1'b1 ; end
            7 : begin TAG_ARR_7[51:0] <= ( miss == 1'b1) ? TAG_ARR_7[51:0] : tag;        TAG_ARR_7[53] <=  (ready_L2_L1 == 1'b0)  ? TAG_ARR_7[53] : 1'b1 ; end
            8 : begin TAG_ARR_8[51:0] <= ( miss == 1'b1) ? TAG_ARR_8[51:0] : tag;        TAG_ARR_8[53] <=  (ready_L2_L1 == 1'b0)  ? TAG_ARR_8[53] : 1'b1 ; end
            9 : begin TAG_ARR_9[51:0] <= ( miss == 1'b1) ? TAG_ARR_9[51:0] : tag;        TAG_ARR_9[53] <=  (ready_L2_L1 == 1'b0)  ? TAG_ARR_9[53] : 1'b1 ; end
            10 : begin TAG_ARR_10[51:0] <= ( miss == 1'b1) ? TAG_ARR_10[51:0] : tag;     TAG_ARR_10[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_10[53] : 1'b1 ; end
            12 : begin TAG_ARR_11[51:0] <= ( miss == 1'b1) ? TAG_ARR_11[51:0] : tag;     TAG_ARR_11[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_11[53] : 1'b1 ; end 
            12 : begin TAG_ARR_12[51:0] <= ( miss == 1'b1) ? TAG_ARR_12[51:0] : tag;     TAG_ARR_12[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_12[53] : 1'b1 ; end
            13 : begin TAG_ARR_13[51:0] <= ( miss == 1'b1) ? TAG_ARR_13[51:0] : tag;     TAG_ARR_13[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_13[53] : 1'b1 ; end
            14 : begin TAG_ARR_14[51:0] <= ( miss == 1'b1) ? TAG_ARR_14[51:0] : tag;     TAG_ARR_14[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_14[53] : 1'b1 ; end
            15 : begin TAG_ARR_15[51:0] <= ( miss == 1'b1) ? TAG_ARR_15[51:0] : tag;     TAG_ARR_15[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_15[53] : 1'b1 ; end
            16 : begin TAG_ARR_16[51:0] <= ( miss == 1'b1) ? TAG_ARR_16[51:0] : tag;     TAG_ARR_16[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_16[53] : 1'b1 ; end
            17 : begin TAG_ARR_17[51:0] <= ( miss == 1'b1) ? TAG_ARR_17[51:0] : tag;     TAG_ARR_17[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_17[53] : 1'b1 ; end
            18 : begin TAG_ARR_18[51:0] <= ( miss == 1'b1) ? TAG_ARR_18[51:0] : tag;     TAG_ARR_18[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_18[53] : 1'b1 ; end
            19 : begin TAG_ARR_19[51:0] <= ( miss == 1'b1) ? TAG_ARR_19[51:0] : tag;     TAG_ARR_19[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_19[53] : 1'b1 ; end
            20 : begin TAG_ARR_20[51:0] <= ( miss == 1'b1) ? TAG_ARR_20[51:0] : tag;     TAG_ARR_20[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_20[53] : 1'b1 ; end
            21 : begin TAG_ARR_21[51:0] <= ( miss == 1'b1) ? TAG_ARR_21[51:0] : tag;     TAG_ARR_21[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_21[53] : 1'b1 ; end
            22 : begin TAG_ARR_22[51:0] <= ( miss == 1'b1) ? TAG_ARR_22[51:0] : tag;     TAG_ARR_22[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_22[53] : 1'b1 ; end
            23 : begin TAG_ARR_23[51:0] <= ( miss == 1'b1) ? TAG_ARR_23[51:0] : tag;     TAG_ARR_23[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_23[53] : 1'b1 ; end
            24 : begin TAG_ARR_24[51:0] <= ( miss == 1'b1) ? TAG_ARR_24[51:0] : tag;     TAG_ARR_24[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_24[53] : 1'b1 ; end
            25 : begin TAG_ARR_25[51:0] <= ( miss == 1'b1) ? TAG_ARR_25[51:0] : tag;     TAG_ARR_25[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_25[53] : 1'b1 ; end
            26 : begin TAG_ARR_26[51:0] <= ( miss == 1'b1) ? TAG_ARR_26[51:0] : tag;     TAG_ARR_26[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_26[53] : 1'b1 ; end
            27 : begin TAG_ARR_27[51:0] <= ( miss == 1'b1) ? TAG_ARR_27[51:0] : tag;     TAG_ARR_27[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_27[53] : 1'b1 ; end
            28 : begin TAG_ARR_28[51:0] <= ( miss == 1'b1) ? TAG_ARR_28[51:0] : tag;     TAG_ARR_28[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_28[53] : 1'b1 ; end
            29 : begin TAG_ARR_29[51:0] <= ( miss == 1'b1) ? TAG_ARR_29[51:0] : tag;     TAG_ARR_29[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_29[53] : 1'b1 ; end
            30 : begin TAG_ARR_30[51:0] <= ( miss == 1'b1) ? TAG_ARR_30[51:0] : tag;     TAG_ARR_30[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_30[53] : 1'b1 ; end
            31 : begin TAG_ARR_31[51:0] <= ( miss == 1'b1) ? TAG_ARR_31[51:0] : tag;     TAG_ARR_31[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_31[53] : 1'b1 ; end
            32 : begin TAG_ARR_32[51:0] <= ( miss == 1'b1) ? TAG_ARR_32[51:0] : tag;     TAG_ARR_32[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_32[53] : 1'b1 ; end
            33 : begin TAG_ARR_33[51:0] <= ( miss == 1'b1) ? TAG_ARR_33[51:0] : tag;     TAG_ARR_33[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_33[53] : 1'b1 ; end
            34 : begin TAG_ARR_34[51:0] <= ( miss == 1'b1) ? TAG_ARR_34[51:0] : tag;     TAG_ARR_34[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_34[53] : 1'b1 ; end
            35 : begin TAG_ARR_35[51:0] <= ( miss == 1'b1) ? TAG_ARR_35[51:0] : tag;     TAG_ARR_35[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_35[53] : 1'b1 ; end
            36 : begin TAG_ARR_36[51:0] <= ( miss == 1'b1) ? TAG_ARR_36[51:0] : tag;     TAG_ARR_36[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_36[53] : 1'b1 ; end
            37 : begin TAG_ARR_37[51:0] <= ( miss == 1'b1) ? TAG_ARR_37[51:0] : tag;     TAG_ARR_37[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_37[53] : 1'b1 ; end
            38 : begin TAG_ARR_38[51:0] <= ( miss == 1'b1) ? TAG_ARR_38[51:0] : tag;     TAG_ARR_38[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_38[53] : 1'b1 ; end
            39 : begin TAG_ARR_39[51:0] <= ( miss == 1'b1) ? TAG_ARR_39[51:0] : tag;     TAG_ARR_39[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_39[53] : 1'b1 ; end
            40 : begin TAG_ARR_40[51:0] <= ( miss == 1'b1) ? TAG_ARR_40[51:0] : tag;     TAG_ARR_40[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_40[53] : 1'b1 ; end
            41 : begin TAG_ARR_41[51:0] <= ( miss == 1'b1) ? TAG_ARR_41[51:0] : tag;     TAG_ARR_41[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_41[53] : 1'b1 ; end
            42 : begin TAG_ARR_42[51:0] <= ( miss == 1'b1) ? TAG_ARR_42[51:0] : tag;     TAG_ARR_42[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_42[53] : 1'b1 ; end
            43 : begin TAG_ARR_43[51:0] <= ( miss == 1'b1) ? TAG_ARR_43[51:0] : tag;     TAG_ARR_43[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_43[53] : 1'b1 ; end
            44 : begin TAG_ARR_44[51:0] <= ( miss == 1'b1) ? TAG_ARR_44[51:0] : tag;     TAG_ARR_44[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_44[53] : 1'b1 ; end
            45 : begin TAG_ARR_45[51:0] <= ( miss == 1'b1) ? TAG_ARR_45[51:0] : tag;     TAG_ARR_45[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_45[53] : 1'b1 ; end
            46 : begin TAG_ARR_46[51:0] <= ( miss == 1'b1) ? TAG_ARR_46[51:0] : tag;     TAG_ARR_46[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_46[53] : 1'b1 ; end
            47 : begin TAG_ARR_47[51:0] <= ( miss == 1'b1) ? TAG_ARR_47[51:0] : tag;     TAG_ARR_47[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_47[53] : 1'b1 ; end
            48 : begin TAG_ARR_48[51:0] <= ( miss == 1'b1) ? TAG_ARR_48[51:0] : tag;     TAG_ARR_48[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_48[53] : 1'b1 ; end
            49 : begin TAG_ARR_49[51:0] <= ( miss == 1'b1) ? TAG_ARR_49[51:0] : tag;     TAG_ARR_49[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_49[53] : 1'b1 ; end
            50 : begin TAG_ARR_50[51:0] <= ( miss == 1'b1) ? TAG_ARR_50[51:0] : tag;     TAG_ARR_50[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_50[53] : 1'b1 ; end
            51 : begin TAG_ARR_51[51:0] <= ( miss == 1'b1) ? TAG_ARR_51[51:0] : tag;     TAG_ARR_51[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_51[53] : 1'b1 ; end
            52 : begin TAG_ARR_52[51:0] <= ( miss == 1'b1) ? TAG_ARR_52[51:0] : tag;     TAG_ARR_52[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_52[53] : 1'b1 ; end
            53 : begin TAG_ARR_53[51:0] <= ( miss == 1'b1) ? TAG_ARR_53[51:0] : tag;     TAG_ARR_53[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_53[53] : 1'b1 ; end
            54 : begin TAG_ARR_54[51:0] <= ( miss == 1'b1) ? TAG_ARR_54[51:0] : tag;     TAG_ARR_54[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_54[53] : 1'b1 ; end
            55 : begin TAG_ARR_55[51:0] <= ( miss == 1'b1) ? TAG_ARR_55[51:0] : tag;     TAG_ARR_55[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_55[53] : 1'b1 ; end
            56 : begin TAG_ARR_56[51:0] <= ( miss == 1'b1) ? TAG_ARR_56[51:0] : tag;     TAG_ARR_56[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_56[53] : 1'b1 ; end
            57 : begin TAG_ARR_57[51:0] <= ( miss == 1'b1) ? TAG_ARR_57[51:0] : tag;     TAG_ARR_57[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_57[53] : 1'b1 ; end
            58 : begin TAG_ARR_58[51:0] <= ( miss == 1'b1) ? TAG_ARR_58[51:0] : tag;     TAG_ARR_58[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_58[53] : 1'b1 ; end
            59 : begin TAG_ARR_59[51:0] <= ( miss == 1'b1) ? TAG_ARR_59[51:0] : tag;     TAG_ARR_59[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_59[53] : 1'b1 ; end
            60 : begin TAG_ARR_60[51:0] <= ( miss == 1'b1) ? TAG_ARR_60[51:0] : tag;     TAG_ARR_60[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_60[53] : 1'b1 ; end
            61 : begin TAG_ARR_61[51:0] <= ( miss == 1'b1) ? TAG_ARR_61[51:0] : tag;     TAG_ARR_61[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_61[53] : 1'b1 ; end
            62 : begin TAG_ARR_62[51:0] <= ( miss == 1'b1) ? TAG_ARR_62[51:0] : tag;     TAG_ARR_62[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_62[53] : 1'b1 ; end
            63 : begin TAG_ARR_63[51:0] <= ( miss == 1'b1) ? TAG_ARR_63[51:0] : tag;     TAG_ARR_63[53] <= ( ready_L2_L1 == 1'b0) ? TAG_ARR_63[53] : 1'b1 ; end
        endcase   
    end
    else
    begin
        TAG_ARR_0   <=  TAG_ARR_0;   
        TAG_ARR_1   <=  TAG_ARR_1;   
        TAG_ARR_2   <=  TAG_ARR_2;   
        TAG_ARR_3   <=  TAG_ARR_3;   
        TAG_ARR_4   <=  TAG_ARR_4;   
        TAG_ARR_5   <=  TAG_ARR_5;   
        TAG_ARR_6   <=  TAG_ARR_6;   
        TAG_ARR_7   <=  TAG_ARR_7;   
        TAG_ARR_8   <=  TAG_ARR_8;   
        TAG_ARR_9   <=  TAG_ARR_9;   
        TAG_ARR_10  <=  TAG_ARR_10;  
        TAG_ARR_11  <=  TAG_ARR_11;  
        TAG_ARR_12  <=  TAG_ARR_12;  
        TAG_ARR_13  <=  TAG_ARR_13;  
        TAG_ARR_14  <=  TAG_ARR_14;  
        TAG_ARR_15  <=  TAG_ARR_15;  
        TAG_ARR_16  <=  TAG_ARR_16;  
        TAG_ARR_17  <=  TAG_ARR_17;  
        TAG_ARR_18  <=  TAG_ARR_18;  
        TAG_ARR_19  <=  TAG_ARR_19;  
        TAG_ARR_20  <=  TAG_ARR_20;  
        TAG_ARR_21  <=  TAG_ARR_21;  
        TAG_ARR_22  <=  TAG_ARR_22;  
        TAG_ARR_23  <=  TAG_ARR_23;  
        TAG_ARR_24  <=  TAG_ARR_24;  
        TAG_ARR_25  <=  TAG_ARR_25;  
        TAG_ARR_26  <=  TAG_ARR_26;  
        TAG_ARR_27  <=  TAG_ARR_27;  
        TAG_ARR_28  <=  TAG_ARR_28;  
        TAG_ARR_29  <=  TAG_ARR_29;  
        TAG_ARR_30  <=  TAG_ARR_30;  
        TAG_ARR_31  <=  TAG_ARR_31;  
        TAG_ARR_32  <=  TAG_ARR_32;  
        TAG_ARR_33  <=  TAG_ARR_33;  
        TAG_ARR_34  <=  TAG_ARR_34;  
        TAG_ARR_35  <=  TAG_ARR_35;  
        TAG_ARR_36  <=  TAG_ARR_36;  
        TAG_ARR_37  <=  TAG_ARR_37;  
        TAG_ARR_38  <=  TAG_ARR_38;  
        TAG_ARR_39  <=  TAG_ARR_39;  
        TAG_ARR_40  <=  TAG_ARR_40;  
        TAG_ARR_41  <=  TAG_ARR_41;  
        TAG_ARR_42  <=  TAG_ARR_42;  
        TAG_ARR_43  <=  TAG_ARR_43;  
        TAG_ARR_44  <=  TAG_ARR_44;  
        TAG_ARR_45  <=  TAG_ARR_45;  
        TAG_ARR_46  <=  TAG_ARR_46;  
        TAG_ARR_47  <=  TAG_ARR_47;  
        TAG_ARR_48  <=  TAG_ARR_48;  
        TAG_ARR_49  <=  TAG_ARR_49;  
        TAG_ARR_50  <=  TAG_ARR_50;  
        TAG_ARR_51  <=  TAG_ARR_51;  
        TAG_ARR_52  <=  TAG_ARR_52;  
        TAG_ARR_53  <=  TAG_ARR_53;  
        TAG_ARR_54  <=  TAG_ARR_54;  
        TAG_ARR_55  <=  TAG_ARR_55;  
        TAG_ARR_56  <=  TAG_ARR_56;  
        TAG_ARR_57  <=  TAG_ARR_57;  
        TAG_ARR_58  <=  TAG_ARR_58;  
        TAG_ARR_59  <=  TAG_ARR_59;  
        TAG_ARR_60  <=  TAG_ARR_60;  
        TAG_ARR_61  <=  TAG_ARR_61;  
        TAG_ARR_62  <=  TAG_ARR_62;  
        TAG_ARR_63  <=  TAG_ARR_63;
    end
end  



// Refill
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



// Read_L1_L2
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