# vi:foldmethod=marker
module L1_D_controller (
    input clk,
    input nrst,
    input tag[51:0], index[5:0], read_C_L1, flush,
    input ready_L2_L1,
    output stall, refill, update, read_L1_L2, write_L1_L2
)

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
    else if (flush == 1)
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
        TAG_ARR_63[53]    <=   1'b1;
    end
    else if(read_C_L1 == 1)
    begin
        case(index)
            0 : TAG_ARR_0[51:0] <= tag;   
            1 : TAG_ARR_1[51:0] <= tag;   
            2 : TAG_ARR_2[51:0] <= tag;   
            3 : TAG_ARR_3[51:0] <= tag;   
            4 : TAG_ARR_4[51:0] <= tag;   
            5 : TAG_ARR_5[51:0] <= tag;   
            6 : TAG_ARR_6[51:0] <= tag;   
            7 : TAG_ARR_7[51:0] <= tag;   
            8 : TAG_ARR_8[51:0] <= tag;   
            9 : TAG_ARR_9[51:0] <= tag;   
            10 : TAG_ARR_10[51:0] <= tag;   
            11 : TAG_ARR_11[51:0] <= tag;   
            12 : TAG_ARR_12[51:0] <= tag;   
            13 : TAG_ARR_13[51:0] <= tag;   
            14 : TAG_ARR_14[51:0] <= tag;   
            15 : TAG_ARR_15[51:0] <= tag;   
            16 : TAG_ARR_16[51:0] <= tag;   
            17 : TAG_ARR_17[51:0] <= tag;   
            18 : TAG_ARR_18[51:0] <= tag;   
            19 : TAG_ARR_19[51:0] <= tag;   
            20 : TAG_ARR_20[51:0] <= tag;   
            21 : TAG_ARR_21[51:0] <= tag;   
            22 : TAG_ARR_22[51:0] <= tag;   
            23 : TAG_ARR_23[51:0] <= tag;   
            24 : TAG_ARR_24[51:0] <= tag;   
            25 : TAG_ARR_25[51:0] <= tag;   
            26 : TAG_ARR_26[51:0] <= tag;   
            27 : TAG_ARR_27[51:0] <= tag;   
            28 : TAG_ARR_28[51:0] <= tag;   
            29 : TAG_ARR_29[51:0] <= tag;   
            30 : TAG_ARR_30[51:0] <= tag;   
            31 : TAG_ARR_31[51:0] <= tag;   
            32 : TAG_ARR_32[51:0] <= tag;   
            33 : TAG_ARR_33[51:0] <= tag;   
            34 : TAG_ARR_34[51:0] <= tag;   
            35 : TAG_ARR_35[51:0] <= tag;   
            36 : TAG_ARR_36[51:0] <= tag;   
            37 : TAG_ARR_37[51:0] <= tag;   
            38 : TAG_ARR_38[51:0] <= tag;   
            39 : TAG_ARR_39[51:0] <= tag;   
            40 : TAG_ARR_40[51:0] <= tag;   
            41 : TAG_ARR_41[51:0] <= tag;   
            42 : TAG_ARR_42[51:0] <= tag;   
            43 : TAG_ARR_43[51:0] <= tag;   
            44 : TAG_ARR_44[51:0] <= tag;   
            45 : TAG_ARR_45[51:0] <= tag;   
            46 : TAG_ARR_46[51:0] <= tag;   
            47 : TAG_ARR_47[51:0] <= tag;   
            48 : TAG_ARR_48[51:0] <= tag;   
            49 : TAG_ARR_49[51:0] <= tag;   
            50 : TAG_ARR_50[51:0] <= tag;   
            51 : TAG_ARR_51[51:0] <= tag;   
            52 : TAG_ARR_52[51:0] <= tag;   
            53 : TAG_ARR_53[51:0] <= tag;   
            54 : TAG_ARR_54[51:0] <= tag;   
            55 : TAG_ARR_55[51:0] <= tag;   
            56 : TAG_ARR_56[51:0] <= tag;   
            57 : TAG_ARR_57[51:0] <= tag;   
            58 : TAG_ARR_58[51:0] <= tag;   
            59 : TAG_ARR_59[51:0] <= tag;   
            60 : TAG_ARR_60[51:0] <= tag;   
            61 : TAG_ARR_61[51:0] <= tag;   
            62 : TAG_ARR_62[51:0] <= tag;   
            63 : TAG_ARR_63[51:0] <= tag;
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
    