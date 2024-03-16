module L1_I_data_array (
    input clk,
    input nrst,
    input [5:0] index,
    input [5:0] offset,
    input [31:0] write_data,
    output [31:0] read_data_L1_C,
    input [511:0] read_data_L2_L1,
    input update, refill
);

reg [511:0] DATA_ARR_0;
reg [511:0] DATA_ARR_1;
reg [511:0] DATA_ARR_2;
reg [511:0] DATA_ARR_3;
reg [511:0] DATA_ARR_4;
reg [511:0] DATA_ARR_5;
reg [511:0] DATA_ARR_6;
reg [511:0] DATA_ARR_7;
reg [511:0] DATA_ARR_8;
reg [511:0] DATA_ARR_9;
reg [511:0] DATA_ARR_10;
reg [511:0] DATA_ARR_11;
reg [511:0] DATA_ARR_12;
reg [511:0] DATA_ARR_13;
reg [511:0] DATA_ARR_14;
reg [511:0] DATA_ARR_15;
reg [511:0] DATA_ARR_16;
reg [511:0] DATA_ARR_17;
reg [511:0] DATA_ARR_18;
reg [511:0] DATA_ARR_19;
reg [511:0] DATA_ARR_20;
reg [511:0] DATA_ARR_21;
reg [511:0] DATA_ARR_22;
reg [511:0] DATA_ARR_23;
reg [511:0] DATA_ARR_24;
reg [511:0] DATA_ARR_25;
reg [511:0] DATA_ARR_26;
reg [511:0] DATA_ARR_27;
reg [511:0] DATA_ARR_28;
reg [511:0] DATA_ARR_29;
reg [511:0] DATA_ARR_30;
reg [511:0] DATA_ARR_31;
reg [511:0] DATA_ARR_32;
reg [511:0] DATA_ARR_33;
reg [511:0] DATA_ARR_34;
reg [511:0] DATA_ARR_35;
reg [511:0] DATA_ARR_36;
reg [511:0] DATA_ARR_37;
reg [511:0] DATA_ARR_38;
reg [511:0] DATA_ARR_39;
reg [511:0] DATA_ARR_40;
reg [511:0] DATA_ARR_41;
reg [511:0] DATA_ARR_42;
reg [511:0] DATA_ARR_43;
reg [511:0] DATA_ARR_44;
reg [511:0] DATA_ARR_45;
reg [511:0] DATA_ARR_46;
reg [511:0] DATA_ARR_47;
reg [511:0] DATA_ARR_48;
reg [511:0] DATA_ARR_49;
reg [511:0] DATA_ARR_50;
reg [511:0] DATA_ARR_51;
reg [511:0] DATA_ARR_52;
reg [511:0] DATA_ARR_53;
reg [511:0] DATA_ARR_54;
reg [511:0] DATA_ARR_55;
reg [511:0] DATA_ARR_56;
reg [511:0] DATA_ARR_57;
reg [511:0] DATA_ARR_58;
reg [511:0] DATA_ARR_59;
reg [511:0] DATA_ARR_60;
reg [511:0] DATA_ARR_61;
reg [511:0] DATA_ARR_62;
reg [511:0] DATA_ARR_63;

reg [31:0] read_data_L1_C_reg;
assign read_data_L1_C = read_data_L1_C_reg;

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
        read_data_L1_C_reg <= 32'h0;
    else
        case(index)
            0 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            1 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            2 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            3 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            4 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            5 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            6 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            7 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            8 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            9 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            10 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            11 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            12 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            13 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            14 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            15 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            16 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            17 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            18 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            19 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            20 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            21 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            22 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            23 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            24 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            25 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            26 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            27 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            28 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            29 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            30 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            31 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            32 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            33 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            34 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            35 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            36 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            37 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            38 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            39 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            40 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            41 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            42 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            43 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            44 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            45 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            46 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            47 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            48 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            49 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            50 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            51 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            52 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            53 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            54 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            55 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            56 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            57 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            58 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            59 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            60 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            61 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            62 : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
            default : read_data_L1_C_reg <= DATA_ARR_0[{offset[5:1],5'b00000} +: 32];
         endcase 
end

always@(posedge clk or negedge nrst)
begin
    if(!nrst)
    begin
        DATA_ARR_0 <= 512'h0;  
        DATA_ARR_1 <= 512'h0;  
        DATA_ARR_2 <= 512'h0;
        DATA_ARR_3 <= 512'h0;
        DATA_ARR_4 <= 512'h0;
        DATA_ARR_5 <= 512'h0;
        DATA_ARR_6 <= 512'h0;
        DATA_ARR_7 <= 512'h0;
        DATA_ARR_8 <= 512'h0;
        DATA_ARR_9 <= 512'h0;
        DATA_ARR_10 <= 512'h0;
        DATA_ARR_11 <= 512'h0;
        DATA_ARR_12 <= 512'h0;
        DATA_ARR_13 <= 512'h0;
        DATA_ARR_14 <= 512'h0;
        DATA_ARR_15 <= 512'h0;
        DATA_ARR_16 <= 512'h0;
        DATA_ARR_17 <= 512'h0;
        DATA_ARR_18 <= 512'h0;
        DATA_ARR_19 <= 512'h0;
        DATA_ARR_20 <= 512'h0;
        DATA_ARR_21 <= 512'h0;
        DATA_ARR_22 <= 512'h0;
        DATA_ARR_23 <= 512'h0;
        DATA_ARR_24 <= 512'h0;
        DATA_ARR_25 <= 512'h0;
        DATA_ARR_26 <= 512'h0;
        DATA_ARR_27 <= 512'h0;
        DATA_ARR_28 <= 512'h0;
        DATA_ARR_29 <= 512'h0;
        DATA_ARR_30 <= 512'h0;
        DATA_ARR_31 <= 512'h0;
        DATA_ARR_32 <= 512'h0;
        DATA_ARR_33 <= 512'h0;
        DATA_ARR_34 <= 512'h0;
        DATA_ARR_35 <= 512'h0;
        DATA_ARR_36 <= 512'h0;
        DATA_ARR_37 <= 512'h0;
        DATA_ARR_38 <= 512'h0;
        DATA_ARR_39 <= 512'h0;
        DATA_ARR_40 <= 512'h0;
        DATA_ARR_41 <= 512'h0;
        DATA_ARR_42 <= 512'h0;
        DATA_ARR_43 <= 512'h0;
        DATA_ARR_44 <= 512'h0;
        DATA_ARR_45 <= 512'h0;
        DATA_ARR_46 <= 512'h0;
        DATA_ARR_47 <= 512'h0;
        DATA_ARR_48 <= 512'h0;
        DATA_ARR_49 <= 512'h0;
        DATA_ARR_50 <= 512'h0;
        DATA_ARR_51 <= 512'h0;
        DATA_ARR_52 <= 512'h0;
        DATA_ARR_53 <= 512'h0;
        DATA_ARR_54 <= 512'h0;
        DATA_ARR_55 <= 512'h0;
        DATA_ARR_56 <= 512'h0;
        DATA_ARR_57 <= 512'h0;
        DATA_ARR_58 <= 512'h0;
        DATA_ARR_59 <= 512'h0;
        DATA_ARR_60 <= 512'h0;
        DATA_ARR_61 <= 512'h0;
        DATA_ARR_62 <= 512'h0;
        DATA_ARR_63 <= 512'h0;
    end
    else if (refill == 1'b1)
    begin
        case(index)
            0 : DATA_ARR_0 <= read_data_L2_L1;
            1 : DATA_ARR_1 <= read_data_L2_L1;
            2 : DATA_ARR_2 <= read_data_L2_L1;
            3 : DATA_ARR_3 <= read_data_L2_L1;
            4 : DATA_ARR_4 <= read_data_L2_L1;
            5 : DATA_ARR_5 <= read_data_L2_L1;
            6 : DATA_ARR_6 <= read_data_L2_L1;
            7 : DATA_ARR_7 <= read_data_L2_L1;
            8 : DATA_ARR_8 <= read_data_L2_L1;
            9 : DATA_ARR_9 <= read_data_L2_L1;
            10 : DATA_ARR_10 <= read_data_L2_L1;
            11 : DATA_ARR_11 <= read_data_L2_L1;
            12 : DATA_ARR_12 <= read_data_L2_L1;
            13 : DATA_ARR_13 <= read_data_L2_L1;
            14 : DATA_ARR_14 <= read_data_L2_L1;
            15 : DATA_ARR_15 <= read_data_L2_L1;
            16 : DATA_ARR_16 <= read_data_L2_L1;
            17 : DATA_ARR_17 <= read_data_L2_L1;
            18 : DATA_ARR_18 <= read_data_L2_L1;
            19 : DATA_ARR_19 <= read_data_L2_L1;
            20 : DATA_ARR_20 <= read_data_L2_L1;
            21 : DATA_ARR_21 <= read_data_L2_L1;
            22 : DATA_ARR_22 <= read_data_L2_L1;
            23 : DATA_ARR_23 <= read_data_L2_L1;
            24 : DATA_ARR_24 <= read_data_L2_L1;
            25 : DATA_ARR_25 <= read_data_L2_L1;
            26 : DATA_ARR_26 <= read_data_L2_L1;
            27 : DATA_ARR_27 <= read_data_L2_L1;
            28 : DATA_ARR_28 <= read_data_L2_L1;
            29 : DATA_ARR_29 <= read_data_L2_L1;
            30 : DATA_ARR_30 <= read_data_L2_L1;
            31 : DATA_ARR_31 <= read_data_L2_L1;
            32 : DATA_ARR_32 <= read_data_L2_L1;
            33 : DATA_ARR_33 <= read_data_L2_L1;
            34 : DATA_ARR_34 <= read_data_L2_L1;
            35 : DATA_ARR_35 <= read_data_L2_L1;
            36 : DATA_ARR_36 <= read_data_L2_L1;
            37 : DATA_ARR_37 <= read_data_L2_L1;
            38 : DATA_ARR_38 <= read_data_L2_L1;
            39 : DATA_ARR_39 <= read_data_L2_L1;
            40 : DATA_ARR_40 <= read_data_L2_L1;
            41 : DATA_ARR_41 <= read_data_L2_L1;
            42 : DATA_ARR_42 <= read_data_L2_L1;
            43 : DATA_ARR_43 <= read_data_L2_L1;
            44 : DATA_ARR_44 <= read_data_L2_L1;
            45 : DATA_ARR_45 <= read_data_L2_L1;
            46 : DATA_ARR_46 <= read_data_L2_L1;
            47 : DATA_ARR_47 <= read_data_L2_L1;
            48 : DATA_ARR_48 <= read_data_L2_L1;
            49 : DATA_ARR_49 <= read_data_L2_L1;
            50 : DATA_ARR_50 <= read_data_L2_L1;
            51 : DATA_ARR_51 <= read_data_L2_L1;
            52 : DATA_ARR_52 <= read_data_L2_L1;
            53 : DATA_ARR_53 <= read_data_L2_L1;
            54 : DATA_ARR_54 <= read_data_L2_L1;
            55 : DATA_ARR_55 <= read_data_L2_L1;
            56 : DATA_ARR_56 <= read_data_L2_L1;
            57 : DATA_ARR_57 <= read_data_L2_L1;
            58 : DATA_ARR_58 <= read_data_L2_L1;
            59 : DATA_ARR_59 <= read_data_L2_L1;
            60 : DATA_ARR_60 <= read_data_L2_L1;
            61 : DATA_ARR_61 <= read_data_L2_L1;
            62 : DATA_ARR_62 <= read_data_L2_L1;
            default : DATA_ARR_63 <= read_data_L2_L1;
        endcase
    end
    else
    begin
        DATA_ARR_0 <= DATA_ARR_0;        
        DATA_ARR_1 <= DATA_ARR_1;        
        DATA_ARR_2 <= DATA_ARR_2;        
        DATA_ARR_3 <= DATA_ARR_3;        
        DATA_ARR_4 <= DATA_ARR_4;        
        DATA_ARR_5 <= DATA_ARR_5;        
        DATA_ARR_6 <= DATA_ARR_6;        
        DATA_ARR_7 <= DATA_ARR_7;        
        DATA_ARR_8 <= DATA_ARR_8;        
        DATA_ARR_9 <= DATA_ARR_9;        
        DATA_ARR_10 <= DATA_ARR_10;        
        DATA_ARR_11 <= DATA_ARR_11;        
        DATA_ARR_12 <= DATA_ARR_12;        
        DATA_ARR_13 <= DATA_ARR_13;        
        DATA_ARR_14 <= DATA_ARR_14;        
        DATA_ARR_15 <= DATA_ARR_15;        
        DATA_ARR_16 <= DATA_ARR_16;        
        DATA_ARR_17 <= DATA_ARR_17;        
        DATA_ARR_18 <= DATA_ARR_18;        
        DATA_ARR_19 <= DATA_ARR_19;        
        DATA_ARR_20 <= DATA_ARR_20;        
        DATA_ARR_21 <= DATA_ARR_21;        
        DATA_ARR_22 <= DATA_ARR_22;        
        DATA_ARR_23 <= DATA_ARR_23;        
        DATA_ARR_24 <= DATA_ARR_24;        
        DATA_ARR_25 <= DATA_ARR_25;        
        DATA_ARR_26 <= DATA_ARR_26;        
        DATA_ARR_27 <= DATA_ARR_27;        
        DATA_ARR_28 <= DATA_ARR_28;        
        DATA_ARR_29 <= DATA_ARR_29;        
        DATA_ARR_30 <= DATA_ARR_30;        
        DATA_ARR_31 <= DATA_ARR_31;        
        DATA_ARR_32 <= DATA_ARR_32;        
        DATA_ARR_33 <= DATA_ARR_33;        
        DATA_ARR_34 <= DATA_ARR_34;        
        DATA_ARR_35 <= DATA_ARR_35;        
        DATA_ARR_36 <= DATA_ARR_36;        
        DATA_ARR_37 <= DATA_ARR_37;        
        DATA_ARR_38 <= DATA_ARR_38;        
        DATA_ARR_39 <= DATA_ARR_39;        
        DATA_ARR_40 <= DATA_ARR_40;        
        DATA_ARR_41 <= DATA_ARR_41;        
        DATA_ARR_42 <= DATA_ARR_42;        
        DATA_ARR_43 <= DATA_ARR_43;        
        DATA_ARR_44 <= DATA_ARR_44;        
        DATA_ARR_45 <= DATA_ARR_45;        
        DATA_ARR_46 <= DATA_ARR_46;        
        DATA_ARR_47 <= DATA_ARR_47;        
        DATA_ARR_48 <= DATA_ARR_48;        
        DATA_ARR_49 <= DATA_ARR_49;        
        DATA_ARR_50 <= DATA_ARR_50;        
        DATA_ARR_51 <= DATA_ARR_51;        
        DATA_ARR_52 <= DATA_ARR_52;        
        DATA_ARR_53 <= DATA_ARR_53;        
        DATA_ARR_54 <= DATA_ARR_54;        
        DATA_ARR_55 <= DATA_ARR_55;        
        DATA_ARR_56 <= DATA_ARR_56;        
        DATA_ARR_57 <= DATA_ARR_57;        
        DATA_ARR_58 <= DATA_ARR_58;        
        DATA_ARR_59 <= DATA_ARR_59;        
        DATA_ARR_60 <= DATA_ARR_60;        
        DATA_ARR_61 <= DATA_ARR_61;        
        DATA_ARR_62 <= DATA_ARR_62;        
        DATA_ARR_63 <= DATA_ARR_63;     
    end
end
endmodule   