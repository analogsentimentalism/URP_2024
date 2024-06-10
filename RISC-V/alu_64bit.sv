module Alu64
  (
    input [63:0] a,b,
    input [3:0] ALuop,
    output reg [63:0] Result,
    output reg zero
    
  );
  
  always @(*)
    begin
      case (ALuop)
        4'b0000: Result = a & b;
        4'b0001: Result = a | b;
        4'b0010: Result = a + b;
        4'b0110: Result = a - b;
        4'b1100: Result = ~(a | b); //nor
      endcase
      if (Result == 0)
        zero = 1;
      else
        zero = 0;
    end
endmodule

//64비트 짜리 alu이다. and, or, add, sub, nor 을 수행할 수 있다.
//결과값은 0인지 알려주는 신호가 추가적으로 존재한다.