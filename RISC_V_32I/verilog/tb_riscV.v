`timescale 1ns/1ps

module tb_riscV();

reg clk, clk_mem, rst, inst_wen, enb;
reg [31:0] inst_data;
reg [6:0] inst_addr;
wire [31:0] WB_o;

reg [31:0] insts [0:38];

initial begin
    rst = 1;
    clk = 1;
	clk_mem = 1;
    enb = 0;
    inst_wen = 0;
    inst_addr = 0;
    inst_data = 0;
    #30
    rst = 0;
    #10
    enb = 1;
    // $display("%32h", TEST.DATAMEM.MEM_Data[88]);
    // $display("%32h", TEST.DATAMEM.MEM_Data[56]);
    // $display("%32h", TEST.DATAMEM.MEM_Data[57]);
end

riscV32I TEST(
	clk, clk_mem, rst, enb
);

initial begin
	forever #20 clk <= ~clk;
end

initial begin
	forever #5 clk_mem <= ~clk_mem;
end

endmodule