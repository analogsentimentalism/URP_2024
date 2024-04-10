module L1_L2_connect (
    input [7:0] write_index_L1D_L2,
    input [7:0] index_L1D_L2,
    input [7:0] index_L1I_L2,
    input [17:0] tag_L1D_L2,
    input [17:0] write_tag_L1D_L2,
    input [17:0] tag_L1I_L2,
    input read_L1I_L2, read_L1D_L2, write_L1D_L2,

    output [7:0] index_L1_L2,
    output [17:0] tag_L1_L2
);


    assign index_L1_L2 = (read_L1I_L2) ? index_L1I_L2 :
                            (read_L1D_L2) ? index_L1D_L2 : 
                            (write_L1D_L2) ? write_index_L1D_L2 : 8'h0;
    assign tag_L1_L2 = (read_L1I_L2) ? tag_L1I_L2 :
                            (read_L1D_L2) ? tag_L1D_L2 :
                            (write_L1D_L2) ? write_tag_L1D_L2 : 18'h0;

endmodule