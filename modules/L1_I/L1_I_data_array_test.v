
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
reg [511:0] DATA_ARR [63:0];
reg [31:0] read_data_L1_C_reg;
assign read_data_L1_C = read_data_L1_C_reg;
genvar i;

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
generate
    for (i=0; i<64; i= i+1) begin
        always@(posedge clk or negedge nrst)
        begin
            DATA_ARR[i] <= 512'h0;
        end
        else if ((reflill == 1'b1) && (index == i))
            DATA_ARR[i] <= read_data_L2_L1;
        end
        else
            DATA_ARR[i] <= DATA_ARR[i]
        end
    end
endgenerate 

endmodule   