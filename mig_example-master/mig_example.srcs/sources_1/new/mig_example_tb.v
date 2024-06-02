`timescale 1ns/1ns

module mig_example_tb();

    reg clk, rst_n;
    wire[15:0] LED;
    reg read_L2_MEM;
    reg write_L2_MEM;
    reg [15:0] tag_L2_MEM;
    reg [9:0] index_L2_MEM;
    reg [15:0] write_tag_L2_MEM;
    reg [511:0] write_data_L2_MEM;

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

    //////////  DUT  //////////
    mig_example_top dut(
        .CLK100MHZ(clk),
        .CPU_RESETN(rst_n),
        
        .LED(LED),
        .read_L2_MEM(read_L2_MEM),
        .write_L2_MEM(write_L2_MEM),
        .tag_L2_MEM(tag_L2_MEM),
        .index_L2_MEM(index_L2_MEM),
        .write_tag_L2_MEM(write_tag_L2_MEM),
        .write_data_L2_MEM(write_data_L2_MEM),
        .read_data_MEM_L2(read_data_MEM_L2),
        .ready_MEM_L2(ready_MEM_L2),
        .ddr2_addr(ddr2_addr),
        .ddr2_ba(ddr2_ba),
        .ddr2_cas_n(ddr2_cas_n),
        .ddr2_ck_n(ddr2_ck_n),
        .ddr2_ck_p(ddr2_ck_p),
        .ddr2_cke(ddr2_cke),
        .ddr2_ras_n(ddr2_ras_n),
        .ddr2_we_n(ddr2_we_n),
        .ddr2_dq(ddr2_dq),
        .ddr2_dqs_n(ddr2_dqs_n),
        .ddr2_dqs_p(ddr2_dqs_p),
        .ddr2_cs_n(ddr2_cs_n),
        .ddr2_dm(ddr2_dm),
        .ddr2_odt(ddr2_odt)
        );

    //////////  Test Process   //////////

    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    initial
    begin
        rst_n = 0;
        read_L2_MEM = 0;
        write_L2_MEM = 0;
        tag_L2_MEM = 16'h0;
        index_L2_MEM = 10'h0;
        write_tag_L2_MEM = 16'h0;
        write_data_L2_MEM = 512'h0;
        #15 rst_n = 1;
#20;
        write_L2_MEM = 1;
        write_tag_L2_MEM = 16'h234;
        index_L2_MEM = 10'h3FF;
        write_data_L2_MEM = 512'hDEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF;

        // Wait for write to complete
        wait (ready_MEM_L2 == 1);
        write_L2_MEM = 0;

        // Read operation
        #2000;
        read_L2_MEM = 1;
        tag_L2_MEM = 16'h234;
        index_L2_MEM = 10'h3FF;
        wait (ready_MEM_L2 == 1);
        read_L2_MEM = 0;
        #30;
    $stop;
        // Wait for read to complete

    end

endmodule