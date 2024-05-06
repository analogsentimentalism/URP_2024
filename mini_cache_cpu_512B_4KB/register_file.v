module register_file(
    output [31:0] RD1, RD2,     // Register 1, 2 Data
    input  [4:0] RR1, RR2, WR,  // Register Read 1, 2, // Write Register
    input  [31:0] WD,           // Data of Write Register
    input  RegWrite, clk, rst
);

reg [31:0] Register_file [0:31];

assign RD1 = Register_file[RR1];
assign RD2 = Register_file[RR2];

always @ (posedge clk) begin
    if (rst) begin
        Register_file[0]  <= 32'b0; // $zero
        Register_file[1]  <= 32'b0; // $ra
        Register_file[2]  <= 32'b0; // $sp
        Register_file[3]  <= 32'b0; // $gp
        Register_file[4]  <= 32'b0; // $tp
        Register_file[5]  <= 32'b0; // $t0
        Register_file[6]  <= 32'b0; // $t1
        Register_file[7]  <= 32'b0; // $t2
        Register_file[8]  <= 32'b0; // $s0/fp
        Register_file[9]  <= 32'b0; // $s1
        Register_file[10] <= 32'b0; // $a0
        Register_file[11] <= 32'b0; // $a1
        Register_file[12] <= 32'b0; // $a2
        Register_file[13] <= 32'b0; // $a3
        Register_file[14] <= 32'b0; // $a4
        Register_file[15] <= 32'b0; // $a5
        Register_file[16] <= 32'b0; // $a6
        Register_file[17] <= 32'b0; // $a7
        Register_file[18] <= 32'b0; // $s2
        Register_file[19] <= 32'b0; // $s3
        Register_file[20] <= 32'b0; // $s4
        Register_file[21] <= 32'b0; // $s5
        Register_file[22] <= 32'b0; // $s6
        Register_file[23] <= 32'b0; // $s7
        Register_file[24] <= 32'b0; // $s8
        Register_file[25] <= 32'b0; // $s9
        Register_file[26] <= 32'b0; // $s10
        Register_file[27] <= 32'b0; // $s11
        Register_file[28] <= 32'b0; // $t3
        Register_file[29] <= 32'b0; // $t4
        Register_file[30] <= 32'b0; // $t5
        Register_file[31] <= 32'b0; // $t6
    end
    else if (RegWrite) begin
        if (|WR) begin
            Register_file[WR] <= WD;    
        end
    end
end

endmodule