module L1_L2_connect (
    input [3:0] write_index_L1D_L2,
    input [3:0] index_L1D_L2,
    input [3:0] index_L1I_L2,
    input [21:0] tag_L1D_L2,
    input [21:0] write_tag_L1D_L2,
    input [21:0] tag_L1I_L2,
    input read_L1I_L2, read_L1D_L2, write_L1D_L2,
    output read_L1_L2,

    input ready_L2_L1,
    output ready_L2_L1I, ready_L2_L1D,
    
    output [3:0] index_L1_L2,
    output [21:0] tag_L1_L2
);


    assign index_L1_L2 = (read_L1I_L2) ? index_L1I_L2 :
                            (read_L1D_L2) ? index_L1D_L2 : 
                            (write_L1D_L2) ? write_index_L1D_L2 : 4'h0;
    assign tag_L1_L2 = (read_L1I_L2) ? tag_L1I_L2 :
                            (read_L1D_L2) ? tag_L1D_L2 :
                            (write_L1D_L2) ? write_tag_L1D_L2 : 22'h0;

    assign ready_L2_L1D = (!read_L1I_L2) & (read_L1D_L2 | write_L1D_L2) ? ready_L2_L1 : 1'b0;
    assign ready_L2_L1I = (read_L1I_L2) ? ready_L2_L1 : 1'b0;
    assign read_L1_L2 = read_L1I_L2 | read_L1D_L2;    
endmodule