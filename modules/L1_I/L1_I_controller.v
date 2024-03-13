# vi:foldmethod=marker
module L1_D_controller {
    input clk,
    input nrst,
    input tag[51:0], index[5:0], read_C_L1, flush,
    input ready_L2_L1,
    output stall, refill, update, read_L1_L2, write_L1_L2
}

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


always@(posedge clk or !nrst)
{
    if (!nrst)
    {
        TAG_ARR_0   = 54'h0;
        TAG_ARR_1   = 54'h0;
        TAG_ARR_2   = 54'h0;
        TAG_ARR_3   = 54'h0;
        TAG_ARR_4   = 54'h0;
        TAG_ARR_5   = 54'h0;
        TAG_ARR_6   = 54'h0;
        TAG_ARR_7   = 54'h0;
        TAG_ARR_8   = 54'h0;
        TAG_ARR_9   = 54'h0;
        TAG_ARR_10  = 54'h0;
        TAG_ARR_11  = 54'h0;
        TAG_ARR_12  = 54'h0;
        TAG_ARR_13  = 54'h0;
        TAG_ARR_14  = 54'h0;
        TAG_ARR_15  = 54'h0;
        TAG_ARR_16  = 54'h0;
        TAG_ARR_17  = 54'h0;
        TAG_ARR_18  = 54'h0;
        TAG_ARR_19  = 54'h0;
        TAG_ARR_20  = 54'h0;
        TAG_ARR_21  = 54'h0;
        TAG_ARR_22  = 54'h0;
        TAG_ARR_23  = 54'h0;
        TAG_ARR_24  = 54'h0;
        TAG_ARR_25  = 54'h0;
        TAG_ARR_26  = 54'h0;
        TAG_ARR_27  = 54'h0;
        TAG_ARR_28  = 54'h0;
        TAG_ARR_29  = 54'h0;
        TAG_ARR_30  = 54'h0;
        TAG_ARR_31  = 54'h0;
        TAG_ARR_32  = 54'h0;
        TAG_ARR_33  = 54'h0;
        TAG_ARR_34  = 54'h0;
        TAG_ARR_35  = 54'h0;
        TAG_ARR_36  = 54'h0;
        TAG_ARR_37  = 54'h0;
        TAG_ARR_38  = 54'h0;
        TAG_ARR_39  = 54'h0;
        TAG_ARR_40  = 54'h0;
        TAG_ARR_41  = 54'h0;
        TAG_ARR_42  = 54'h0;
        TAG_ARR_43  = 54'h0;
        TAG_ARR_44  = 54'h0;
        TAG_ARR_45  = 54'h0;
        TAG_ARR_46  = 54'h0;
        TAG_ARR_47  = 54'h0;
        TAG_ARR_48  = 54'h0;
        TAG_ARR_49  = 54'h0;
        TAG_ARR_50  = 54'h0;
        TAG_ARR_51  = 54'h0;
        TAG_ARR_52  = 54'h0;
        TAG_ARR_53  = 54'h0;
        TAG_ARR_54  = 54'h0;
        TAG_ARR_55  = 54'h0;
        TAG_ARR_56  = 54'h0;
        TAG_ARR_57  = 54'h0;
        TAG_ARR_58  = 54'h0;
        TAG_ARR_59  = 54'h0;
        TAG_ARR_60  = 54'h0;
        TAG_ARR_61  = 54'h0;
        TAG_ARR_62  = 54'h0;
        TAG_ARR_63  = 54'h0;
    }
    else if (flush == 1)
    {
        TAG_ARR_0[0]    =   1'b0; 
        TAG_ARR_1[0]    =   1'b0; 
        TAG_ARR_2[0]    =   1'b0; 
        TAG_ARR_3[0]    =   1'b0; 
        TAG_ARR_4[0]    =   1'b0; 
        TAG_ARR_5[0]    =   1'b0; 
        TAG_ARR_6[0]    =   1'b0; 
        TAG_ARR_7[0]    =   1'b0; 
        TAG_ARR_8[0]    =   1'b0; 
        TAG_ARR_9[0]     =   1'b0; 
        TAG_ARR_10[0]    =   1'b0; 
        TAG_ARR_11[0]    =   1'b0; 
        TAG_ARR_12[0]    =   1'b0; 
        TAG_ARR_13[0]    =   1'b0; 
        TAG_ARR_14[0]    =   1'b0; 
        TAG_ARR_15[0]    =   1'b0; 
        TAG_ARR_16[0]    =   1'b0; 
        TAG_ARR_17[0]    =   1'b0; 
        TAG_ARR_18[0]    =   1'b0; 
        TAG_ARR_19[0]    =   1'b0;
        TAG_ARR_20[0]    =   1'b0;        
        TAG_ARR_21[0]    =   1'b0;
        TAG_ARR_22[0]    =   1'b0;
        TAG_ARR_23[0]    =   1'b0;
        TAG_ARR_24[0]    =   1'b0;
        TAG_ARR_25[0]    =   1'b0;
        TAG_ARR_26[0]    =   1'b0;
        TAG_ARR_27[0]    =   1'b0;
        TAG_ARR_28[0]    =   1'b0;
        TAG_ARR_29[0]    =   1'b0;
        TAG_ARR_30[0]    =   1'b0;
        TAG_ARR_31[0]    =   1'b0;
        TAG_ARR_32[0]    =   1'b0;
        TAG_ARR_33[0]    =   1'b0;
        TAG_ARR_34[0]    =   1'b0;
        TAG_ARR_35[0]    =   1'b0;
        TAG_ARR_36[0]    =   1'b0;
        TAG_ARR_37[0]    =   1'b0;
        TAG_ARR_38[0]    =   1'b0;
        TAG_ARR_39[0]    =   1'b0;
        TAG_ARR_40[0]    =   1'b0;
        TAG_ARR_41[0]    =   1'b0;
        TAG_ARR_42[0]    =   1'b0;
        TAG_ARR_43[0]    =   1'b0;
        TAG_ARR_44[0]    =   1'b0;
        TAG_ARR_45[0]    =   1'b0;
        TAG_ARR_46[0]    =   1'b0;
        TAG_ARR_47[0]    =   1'b0;
        TAG_ARR_48[0]    =   1'b0;
        TAG_ARR_49[0]    =   1'b0;
        TAG_ARR_50[0]    =   1'b0;
        TAG_ARR_51[0]    =   1'b0;
        TAG_ARR_52[0]    =   1'b0;
        TAG_ARR_53[0]    =   1'b0;
        TAG_ARR_54[0]    =   1'b0;
        TAG_ARR_55[0]    =   1'b0;
        TAG_ARR_56[0]    =   1'b0;
        TAG_ARR_57[0]    =   1'b0;
        TAG_ARR_58[0]    =   1'b0;
        TAG_ARR_59[0]    =   1'b0;
        TAG_ARR_60[0]    =   1'b0;
        TAG_ARR_61[0]    =   1'b0;
        TAG_ARR_62[0]    =   1'b0;
        TAG_ARR_63[0]    =   1'b0;
    }
    else if(read_C_L1 == 1)
    {
        case(index)
            0 : 
    }