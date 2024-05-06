module BranchComp(
    output BrEq, BrLT,
    input [31:0] RD1, RD2,
    input BrUn              // 1 at Unsigned compare
);

wire NotEqual;
wire [31:0] XORResult;
// Equal part
assign XORResult = (RD1 ^ RD2);
assign NotEqual = |XORResult;

assign BrEq = ~NotEqual;

// COMP part
COMP32b COMPARE(BrLT, RD1, RD2, BrUn);

endmodule