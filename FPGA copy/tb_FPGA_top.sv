`timescale   1ns/1ns
module tb_FPGA_top ();

reg      clk            ;
reg      rst            ;
reg      enb            ;
wire   data_o         ;
wire   [15:0]   test_led;

    //////  DDR2 Model  //////
    wire ddr2_ck_p, ddr2_ck_n, ddr2_cke, ddr2_cs_n, ddr2_ras_n, ddr2_cas_n, ddr2_we_n, ddr2_odt;
    wire[15:0] ddr2_dq;
    wire[1:0] ddr2_dqs_n;
    wire[1:0] ddr2_dqs_p;
    wire[12:0] ddr2_addr;
    wire[2:0] ddr2_ba;
    wire[1:0] ddr2_dm;

     ddr2_model fake_ddr2(
         .ck(ddr2_ck_p),
         .ck_n(ddr2_ck_n),
         .cke(ddr2_cke),
         .cs_n(ddr2_cs_n),
         .ras_n(ddr2_ras_n),
         .cas_n(ddr2_cas_n),
         .we_n(ddr2_we_n),
         .dm_rdqs(ddr2_dm),
         .ba(ddr2_ba),
         .addr(ddr2_addr),
         .dq(ddr2_dq),
         .dqs(ddr2_dqs_p),
         .dqs_n(ddr2_dqs_n),
         .rdqs_n(),
         .odt(ddr2_odt)
         );

FPGA_top u_FPGA_top (
   .clk(clk),
   .rst(rst),
   .enb(enb),
   .tx_data(data_o),
   .ddr2_dq(ddr2_dq),
    .ddr2_dqs_n(ddr2_dqs_n),
    .ddr2_dqs_p(ddr2_dqs_p),
    .ddr2_addr(ddr2_addr),
    .ddr2_ba(ddr2_ba),
    .ddr2_ras_n(ddr2_ras_n),
    .ddr2_cas_n(ddr2_cas_n),
    .ddr2_we_n(ddr2_we_n),
    .ddr2_ck_p(ddr2_ck_p),
    .ddr2_ck_n(ddr2_ck_n),
    .ddr2_cke(ddr2_cke),
    .ddr2_cs_n(ddr2_cs_n),
    .ddr2_dm(ddr2_dm),
    .ddr2_odt(ddr2_odt),
   .LED(LED)
);



initial begin
   forever #5 clk = ~clk;
end

initial begin
   $display("START!!!!");
   clk   = 'b1;
   rst = 'b1;
   enb   = 'b0;
	repeat(10) @(posedge clk);
   rst = 'b0;
	repeat(10000) @(posedge clk);
   enb = 'b1;
end

endmodule