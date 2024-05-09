module COMP32b(    // unsigned
    output Less,
    input [31:0] A, B,
    input uMod      // 1:UnsignedMode, 0:SignedMode
);

wire uresult, sresult;

assign uresult = A < B;
assign sresult = (A[31] & B[31]) ? (A > B) : (~(A[31] | B[31]) ? (A < B) : A[31]);

assign Less = uMod ? uresult : sresult;

endmodule
