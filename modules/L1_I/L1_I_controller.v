# vi:foldmethod=marker
module L1_D_controller (
    input clk,
    input nrst,
    input tag[51:0], 
    input index[5:0], 
    input read_C_L1, flush,
    input ready_L2_L1,
    output stall, refill, update, read_L1_L2, write_L1_L2
)
// define TAG_ARR
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
// stall
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        stall <= 0;
    else if(miss == 1)
        stall <= 1;
    else if(stall == 1)
        stall <= 0;
    else if(read_C_L1 == 1)
        stall <= 1;
    else stall <= stall;
end
// miss
always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        miss <= 0;
    else if (read_C_L1 == 1)
    begin
        case(index)
            0 :  miss <= (if (TAG_ARR_0[53] == 1)&&(tag == TAG_ARR_0[51:0])) ? 0 : 1;  
            1 :  miss <= (if (TAG_ARR_1[53] == 1)&&(tag == TAG_ARR_1[51:0])) ? 0 : 1;
            2 :  miss <= (if (TAG_ARR_2[53] == 1)&&(tag == TAG_ARR_2[51:0])) ? 0 : 1;
            3 :  miss <= (if (TAG_ARR_3[53] == 1)&&(tag == TAG_ARR_3[51:0])) ? 0 : 1;
            4 :  miss <= (if (TAG_ARR_4[53] == 1)&&(tag == TAG_ARR_4[51:0])) ? 0 : 1;
            5 :  miss <= (if (TAG_ARR_5[53] == 1)&&(tag == TAG_ARR_5[51:0])) ? 0 : 1;
            6 :  miss <= (if (TAG_ARR_6[53] == 1)&&(tag == TAG_ARR_6[51:0])) ? 0 : 1;
            7 :  miss <= (if (TAG_ARR_7[53] == 1)&&(tag == TAG_ARR_7[51:0])) ? 0 : 1;
            8 :  miss <= (if (TAG_ARR_8[53] == 1)&&(tag == TAG_ARR_8[51:0])) ? 0 : 1;
            9 :  miss <= (if (TAG_ARR_9[53] == 1)&&(tag == TAG_ARR_9[51:0])) ? 0 : 1;
            10 : miss <= (if (TAG_ARR_10[53] == 1)&&(tag == TAG_ARR_10[51:0])) ? 0 : 1;   
            11 : miss <= (if (TAG_ARR_11[53] == 1)&&(tag == TAG_ARR_11[51:0])) ? 0 : 1;   
            12 : miss <= (if (TAG_ARR_12[53] == 1)&&(tag == TAG_ARR_12[51:0])) ? 0 : 1;   
            13 : miss <= (if (TAG_ARR_13[53] == 1)&&(tag == TAG_ARR_13[51:0])) ? 0 : 1;   
            14 : miss <= (if (TAG_ARR_14[53] == 1)&&(tag == TAG_ARR_14[51:0])) ? 0 : 1;   
            15 : miss <= (if (TAG_ARR_15[53] == 1)&&(tag == TAG_ARR_15[51:0])) ? 0 : 1;   
            16 : miss <= (if (TAG_ARR_16[53] == 1)&&(tag == TAG_ARR_16[51:0])) ? 0 : 1;   
            17 : miss <= (if (TAG_ARR_17[53] == 1)&&(tag == TAG_ARR_17[51:0])) ? 0 : 1;   
            18 : miss <= (if (TAG_ARR_18[53] == 1)&&(tag == TAG_ARR_18[51:0])) ? 0 : 1;   
            19 : miss <= (if (TAG_ARR_19[53] == 1)&&(tag == TAG_ARR_19[51:0])) ? 0 : 1;   
            20 : miss <= (if (TAG_ARR_20[53] == 1)&&(tag == TAG_ARR_20[51:0])) ? 0 : 1;   
            21 : miss <= (if (TAG_ARR_21[53] == 1)&&(tag == TAG_ARR_21[51:0])) ? 0 : 1;   
            22 : miss <= (if (TAG_ARR_22[53] == 1)&&(tag == TAG_ARR_22[51:0])) ? 0 : 1;   
            23 : miss <= (if (TAG_ARR_23[53] == 1)&&(tag == TAG_ARR_23[51:0])) ? 0 : 1;   
            24 : miss <= (if (TAG_ARR_24[53] == 1)&&(tag == TAG_ARR_24[51:0])) ? 0 : 1;   
            25 : miss <= (if (TAG_ARR_25[53] == 1)&&(tag == TAG_ARR_25[51:0])) ? 0 : 1;   
            26 : miss <= (if (TAG_ARR_26[53] == 1)&&(tag == TAG_ARR_26[51:0])) ? 0 : 1;   
            27 : miss <= (if (TAG_ARR_27[53] == 1)&&(tag == TAG_ARR_27[51:0])) ? 0 : 1;   
            28 : miss <= (if (TAG_ARR_28[53] == 1)&&(tag == TAG_ARR_28[51:0])) ? 0 : 1;   
            29 : miss <= (if (TAG_ARR_29[53] == 1)&&(tag == TAG_ARR_29[51:0])) ? 0 : 1;   
            30 : miss <= (if (TAG_ARR_30[53] == 1)&&(tag == TAG_ARR_30[51:0])) ? 0 : 1;   
            31 : miss <= (if (TAG_ARR_31[53] == 1)&&(tag == TAG_ARR_31[51:0])) ? 0 : 1;   
            32 : miss <= (if (TAG_ARR_32[53] == 1)&&(tag == TAG_ARR_32[51:0])) ? 0 : 1;   
            33 : miss <= (if (TAG_ARR_33[53] == 1)&&(tag == TAG_ARR_33[51:0])) ? 0 : 1;   
            34 : miss <= (if (TAG_ARR_34[53] == 1)&&(tag == TAG_ARR_34[51:0])) ? 0 : 1;   
            35 : miss <= (if (TAG_ARR_35[53] == 1)&&(tag == TAG_ARR_35[51:0])) ? 0 : 1;   
            36 : miss <= (if (TAG_ARR_36[53] == 1)&&(tag == TAG_ARR_36[51:0])) ? 0 : 1;   
            37 : miss <= (if (TAG_ARR_37[53] == 1)&&(tag == TAG_ARR_37[51:0])) ? 0 : 1;   
            38 : miss <= (if (TAG_ARR_38[53] == 1)&&(tag == TAG_ARR_38[51:0])) ? 0 : 1;   
            39 : miss <= (if (TAG_ARR_39[53] == 1)&&(tag == TAG_ARR_39[51:0])) ? 0 : 1;   
            40 : miss <= (if (TAG_ARR_40[53] == 1)&&(tag == TAG_ARR_40[51:0])) ? 0 : 1;   
            41 : miss <= (if (TAG_ARR_41[53] == 1)&&(tag == TAG_ARR_41[51:0])) ? 0 : 1;   
            42 : miss <= (if (TAG_ARR_42[53] == 1)&&(tag == TAG_ARR_42[51:0])) ? 0 : 1;   
            43 : miss <= (if (TAG_ARR_43[53] == 1)&&(tag == TAG_ARR_43[51:0])) ? 0 : 1;   
            44 : miss <= (if (TAG_ARR_44[53] == 1)&&(tag == TAG_ARR_44[51:0])) ? 0 : 1;   
            45 : miss <= (if (TAG_ARR_45[53] == 1)&&(tag == TAG_ARR_45[51:0])) ? 0 : 1;   
            46 : miss <= (if (TAG_ARR_46[53] == 1)&&(tag == TAG_ARR_46[51:0])) ? 0 : 1;   
            47 : miss <= (if (TAG_ARR_47[53] == 1)&&(tag == TAG_ARR_47[51:0])) ? 0 : 1;   
            48 : miss <= (if (TAG_ARR_48[53] == 1)&&(tag == TAG_ARR_48[51:0])) ? 0 : 1;   
            49 : miss <= (if (TAG_ARR_49[53] == 1)&&(tag == TAG_ARR_49[51:0])) ? 0 : 1;   
            50 : miss <= (if (TAG_ARR_50[53] == 1)&&(tag == TAG_ARR_50[51:0])) ? 0 : 1;   
            51 : miss <= (if (TAG_ARR_51[53] == 1)&&(tag == TAG_ARR_51[51:0])) ? 0 : 1;   
            52 : miss <= (if (TAG_ARR_52[53] == 1)&&(tag == TAG_ARR_52[51:0])) ? 0 : 1;   
            53 : miss <= (if (TAG_ARR_53[53] == 1)&&(tag == TAG_ARR_53[51:0])) ? 0 : 1;   
            54 : miss <= (if (TAG_ARR_54[53] == 1)&&(tag == TAG_ARR_54[51:0])) ? 0 : 1;   
            55 : miss <= (if (TAG_ARR_55[53] == 1)&&(tag == TAG_ARR_55[51:0])) ? 0 : 1;   
            56 : miss <= (if (TAG_ARR_56[53] == 1)&&(tag == TAG_ARR_56[51:0])) ? 0 : 1;   
            57 : miss <= (if (TAG_ARR_57[53] == 1)&&(tag == TAG_ARR_57[51:0])) ? 0 : 1;   
            58 : miss <= (if (TAG_ARR_58[53] == 1)&&(tag == TAG_ARR_58[51:0])) ? 0 : 1;   
            59 : miss <= (if (TAG_ARR_59[53] == 1)&&(tag == TAG_ARR_59[51:0])) ? 0 : 1;   
            60 : miss <= (if (TAG_ARR_60[53] == 1)&&(tag == TAG_ARR_60[51:0])) ? 0 : 1;   
            61 : miss <= (if (TAG_ARR_61[53] == 1)&&(tag == TAG_ARR_61[51:0])) ? 0 : 1;   
            62 : miss <= (if (TAG_ARR_62[53] == 1)&&(tag == TAG_ARR_62[51:0])) ? 0 : 1;   
            default : miss <= (if (TAG_ARR_63[53] == 1)&&(tag == TAG_ARR_63[51:0])) ? 0 : 1;
        endcase   
    else if(ready_L2_L1 == 1)
        miss <= 0;
    else
        miss <= miss;          
end
always@(posedge clk or negedge nrst)    //tag
begin
    if (!nrst)
    begin           // reset
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
    else if (flush == 1)
    begin           // flush
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
        TAG_ARR_63[53]    <=   1'b1;
    end
    else if(read_C_L1 == 1)
    begin        
        case(index)
            0 : begin TAG_ARR_0[51:0] <= (if miss == 0) ? TAG_ARR_0[51:0] : tag;     
            1 : begin TAG_ARR_1[51:0] <= (if miss == 0) ? TAG_ARR_1[51:0] : tag;   
            2 : begin TAG_ARR_2[51:0] <= (if miss == 0) ? TAG_ARR_2[51:0] : tag;   
            3 : begin TAG_ARR_3[51:0] <= (if miss == 0) ? TAG_ARR_3[51:0] : tag;   
            4 : begin TAG_ARR_4[51:0] <= (if miss == 0) ? TAG_ARR_4[51:0] : tag;   
            5 : begin TAG_ARR_5[51:0] <= (if miss == 0) ? TAG_ARR_5[51:0] : tag;   
            6 : begin TAG_ARR_6[51:0] <= (if miss == 0) ? TAG_ARR_6[51:0] : tag;   
            7 : begin TAG_ARR_7[51:0] <= (if miss == 0) ? TAG_ARR_7[51:0] : tag;   
            8 : begin TAG_ARR_8[51:0] <= (if miss == 0) ? TAG_ARR_8[51:0] : tag;   
            9 : begin TAG_ARR_9[51:0] <= (if miss == 0) ? TAG_ARR_9[51:0] : tag;   
            10 : begin TAG_ARR_10[51:0] <= (if miss == 0) ? TAG_ARR_10[51:0] : tag;   
            12 : begin TAG_ARR_11[51:0] <= (if miss == 0) ? TAG_ARR_11[51:0] : tag;   
            12 : begin TAG_ARR_12[51:0] <= (if miss == 0) ? TAG_ARR_12[51:0] : tag;   
            13 : begin TAG_ARR_13[51:0] <= (if miss == 0) ? TAG_ARR_13[51:0] : tag;   
            14 : begin TAG_ARR_14[51:0] <= (if miss == 0) ? TAG_ARR_14[51:0] : tag;   
            15 : begin TAG_ARR_15[51:0] <= (if miss == 0) ? TAG_ARR_15[51:0] : tag;   
            16 : begin TAG_ARR_16[51:0] <= (if miss == 0) ? TAG_ARR_16[51:0] : tag;   
            17 : begin TAG_ARR_17[51:0] <= (if miss == 0) ? TAG_ARR_17[51:0] : tag;   
            18 : begin TAG_ARR_18[51:0] <= (if miss == 0) ? TAG_ARR_18[51:0] : tag;   
            19 : begin TAG_ARR_19[51:0] <= (if miss == 0) ? TAG_ARR_19[51:0] : tag;   
            20 : begin TAG_ARR_20[51:0] <= (if miss == 0) ? TAG_ARR_20[51:0] : tag;   
            21 : begin TAG_ARR_21[51:0] <= (if miss == 0) ? TAG_ARR_21[51:0] : tag;   
            22 : begin TAG_ARR_22[51:0] <= (if miss == 0) ? TAG_ARR_22[51:0] : tag;   
            23 : begin TAG_ARR_23[51:0] <= (if miss == 0) ? TAG_ARR_23[51:0] : tag;   
            24 : begin TAG_ARR_24[51:0] <= (if miss == 0) ? TAG_ARR_24[51:0] : tag;   
            25 : begin TAG_ARR_25[51:0] <= (if miss == 0) ? TAG_ARR_25[51:0] : tag;   
            26 : begin TAG_ARR_26[51:0] <= (if miss == 0) ? TAG_ARR_26[51:0] : tag;   
            27 : begin TAG_ARR_27[51:0] <= (if miss == 0) ? TAG_ARR_27[51:0] : tag;   
            28 : begin TAG_ARR_28[51:0] <= (if miss == 0) ? TAG_ARR_28[51:0] : tag;   
            29 : begin TAG_ARR_29[51:0] <= (if miss == 0) ? TAG_ARR_29[51:0] : tag;   
            30 : begin TAG_ARR_30[51:0] <= (if miss == 0) ? TAG_ARR_30[51:0] : tag;   
            31 : begin TAG_ARR_31[51:0] <= (if miss == 0) ? TAG_ARR_31[51:0] : tag;   
            32 : begin TAG_ARR_32[51:0] <= (if miss == 0) ? TAG_ARR_32[51:0] : tag;   
            33 : begin TAG_ARR_33[51:0] <= (if miss == 0) ? TAG_ARR_33[51:0] : tag;   
            34 : begin TAG_ARR_34[51:0] <= (if miss == 0) ? TAG_ARR_34[51:0] : tag;   
            35 : begin TAG_ARR_35[51:0] <= (if miss == 0) ? TAG_ARR_35[51:0] : tag;   
            36 : begin TAG_ARR_36[51:0] <= (if miss == 0) ? TAG_ARR_36[51:0] : tag;   
            37 : begin TAG_ARR_37[51:0] <= (if miss == 0) ? TAG_ARR_37[51:0] : tag;   
            38 : begin TAG_ARR_38[51:0] <= (if miss == 0) ? TAG_ARR_38[51:0] : tag;   
            39 : begin TAG_ARR_39[51:0] <= (if miss == 0) ? TAG_ARR_39[51:0] : tag;   
            40 : begin TAG_ARR_40[51:0] <= (if miss == 0) ? TAG_ARR_40[51:0] : tag;   
            41 : begin TAG_ARR_41[51:0] <= (if miss == 0) ? TAG_ARR_41[51:0] : tag;   
            42 : begin TAG_ARR_42[51:0] <= (if miss == 0) ? TAG_ARR_42[51:0] : tag;   
            43 : begin TAG_ARR_43[51:0] <= (if miss == 0) ? TAG_ARR_43[51:0] : tag;   
            44 : begin TAG_ARR_44[51:0] <= (if miss == 0) ? TAG_ARR_44[51:0] : tag;   
            45 : begin TAG_ARR_45[51:0] <= (if miss == 0) ? TAG_ARR_45[51:0] : tag;   
            46 : begin TAG_ARR_46[51:0] <= (if miss == 0) ? TAG_ARR_46[51:0] : tag;   
            47 : begin TAG_ARR_47[51:0] <= (if miss == 0) ? TAG_ARR_47[51:0] : tag;   
            48 : begin TAG_ARR_48[51:0] <= (if miss == 0) ? TAG_ARR_48[51:0] : tag;   
            49 : begin TAG_ARR_49[51:0] <= (if miss == 0) ? TAG_ARR_49[51:0] : tag;   
            50 : begin TAG_ARR_50[51:0] <= (if miss == 0) ? TAG_ARR_50[51:0] : tag;   
            51 : begin TAG_ARR_51[51:0] <= (if miss == 0) ? TAG_ARR_51[51:0] : tag;   
            52 : begin TAG_ARR_52[51:0] <= (if miss == 0) ? TAG_ARR_52[51:0] : tag;   
            53 : begin TAG_ARR_53[51:0] <= (if miss == 0) ? TAG_ARR_53[51:0] : tag;   
            54 : begin TAG_ARR_54[51:0] <= (if miss == 0) ? TAG_ARR_54[51:0] : tag;   
            55 : begin TAG_ARR_55[51:0] <= (if miss == 0) ? TAG_ARR_55[51:0] : tag;   
            56 : begin TAG_ARR_56[51:0] <= (if miss == 0) ? TAG_ARR_56[51:0] : tag;   
            57 : begin TAG_ARR_57[51:0] <= (if miss == 0) ? TAG_ARR_57[51:0] : tag;   
            58 : begin TAG_ARR_58[51:0] <= (if miss == 0) ? TAG_ARR_58[51:0] : tag;   
            59 : begin TAG_ARR_59[51:0] <= (if miss == 0) ? TAG_ARR_59[51:0] : tag;   
            60 : begin TAG_ARR_60[51:0] <= (if miss == 0) ? TAG_ARR_60[51:0] : tag;   
            61 : begin TAG_ARR_61[51:0] <= (if miss == 0) ? TAG_ARR_61[51:0] : tag;   
            62 : begin TAG_ARR_62[51:0] <= (if miss == 0) ? TAG_ARR_62[51:0] : tag;   
            63 : begin TAG_ARR_63[51:0] <= (if miss == 0) ? TAG_ARR_63[51:0] : tag;
        endcase   
    end
    else
    begin
        TAG_ARR_0   <=  TAG_ARR_0   
        TAG_ARR_1   <=  TAG_ARR_1   
        TAG_ARR_2   <=  TAG_ARR_2   
        TAG_ARR_3   <=  TAG_ARR_3   
        TAG_ARR_4   <=  TAG_ARR_4   
        TAG_ARR_5   <=  TAG_ARR_5   
        TAG_ARR_6   <=  TAG_ARR_6   
        TAG_ARR_7   <=  TAG_ARR_7   
        TAG_ARR_8   <=  TAG_ARR_8   
        TAG_ARR_9   <=  TAG_ARR_9   
        TAG_ARR_10  <=  TAG_ARR_10  
        TAG_ARR_11  <=  TAG_ARR_11  
        TAG_ARR_12  <=  TAG_ARR_12  
        TAG_ARR_13  <=  TAG_ARR_13  
        TAG_ARR_14  <=  TAG_ARR_14  
        TAG_ARR_15  <=  TAG_ARR_15  
        TAG_ARR_16  <=  TAG_ARR_16  
        TAG_ARR_17  <=  TAG_ARR_17  
        TAG_ARR_18  <=  TAG_ARR_18  
        TAG_ARR_19  <=  TAG_ARR_19  
        TAG_ARR_20  <=  TAG_ARR_20  
        TAG_ARR_21  <=  TAG_ARR_21  
        TAG_ARR_22  <=  TAG_ARR_22  
        TAG_ARR_23  <=  TAG_ARR_23  
        TAG_ARR_24  <=  TAG_ARR_24  
        TAG_ARR_25  <=  TAG_ARR_25  
        TAG_ARR_26  <=  TAG_ARR_26  
        TAG_ARR_27  <=  TAG_ARR_27  
        TAG_ARR_28  <=  TAG_ARR_28  
        TAG_ARR_29  <=  TAG_ARR_29  
        TAG_ARR_30  <=  TAG_ARR_30  
        TAG_ARR_31  <=  TAG_ARR_31  
        TAG_ARR_32  <=  TAG_ARR_32  
        TAG_ARR_33  <=  TAG_ARR_33  
        TAG_ARR_34  <=  TAG_ARR_34  
        TAG_ARR_35  <=  TAG_ARR_35  
        TAG_ARR_36  <=  TAG_ARR_36  
        TAG_ARR_37  <=  TAG_ARR_37  
        TAG_ARR_38  <=  TAG_ARR_38  
        TAG_ARR_39  <=  TAG_ARR_39  
        TAG_ARR_40  <=  TAG_ARR_40  
        TAG_ARR_41  <=  TAG_ARR_41  
        TAG_ARR_42  <=  TAG_ARR_42  
        TAG_ARR_43  <=  TAG_ARR_43  
        TAG_ARR_44  <=  TAG_ARR_44  
        TAG_ARR_45  <=  TAG_ARR_45  
        TAG_ARR_46  <=  TAG_ARR_46  
        TAG_ARR_47  <=  TAG_ARR_47  
        TAG_ARR_48  <=  TAG_ARR_48  
        TAG_ARR_49  <=  TAG_ARR_49  
        TAG_ARR_50  <=  TAG_ARR_50  
        TAG_ARR_51  <=  TAG_ARR_51  
        TAG_ARR_52  <=  TAG_ARR_52  
        TAG_ARR_53  <=  TAG_ARR_53  
        TAG_ARR_54  <=  TAG_ARR_54  
        TAG_ARR_55  <=  TAG_ARR_55  
        TAG_ARR_56  <=  TAG_ARR_56  
        TAG_ARR_57  <=  TAG_ARR_57  
        TAG_ARR_58  <=  TAG_ARR_58  
        TAG_ARR_59  <=  TAG_ARR_59  
        TAG_ARR_60  <=  TAG_ARR_60  
        TAG_ARR_61  <=  TAG_ARR_61  
        TAG_ARR_62  <=  TAG_ARR_62  
        TAG_ARR_63  <=  TAG_ARR_63
    end
end  

always@(posedge clk or negedge nrst)
begin
    if (!nrst)
        miss <= 0;
    else if()