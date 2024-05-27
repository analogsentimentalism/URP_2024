module dram(
    input clk,
    input nrst,
  //  input clk_ref,
       inout [15:0]                         ddr2_dq,

   inout [1:0]                        ddr2_dqs_n,

   inout [1:0]                        ddr2_dqs_p,

   // Outputs

   output [12:0]                       ddr2_addr,

   output [2:0]                      ddr2_ba,

   output                                       ddr2_ras_n,

   output                                       ddr2_cas_n,

   output                                       ddr2_we_n,

   output [0:0]                        ddr2_ck_p,

   output [0:0]                        ddr2_ck_n,

   output [0:0]                       ddr2_cke,

   output [0:0]           ddr2_cs_n,

   output [1:0]                        ddr2_dm,

   output [0:0]                       ddr2_odt
);

    reg [6:0] init_counter;
    wire [31:0] addra;
    wire en;
    wire [31:0] dout;
    wire app_rdy;
    wire app_wdf_rdy;
    wire ui_clk;
    reg sys_rst;
    
    wire [127:0] app_rd_data;
    wire app_rd_data_end;
    wire app_rd_data_valid;
      wire ui_clk_sync_rst;
  wire app_zq_ack;
  wire app_sr_active;
  wire app_ref_ack;
  wire init_calib_complete;
    always@(posedge clk) begin
        if(init_counter === 7'bxxxxxxx)
            sys_rst <= 1'b1;
        else
            sys_rst <= 1'b0; 
    end
    always@(posedge clk) begin
        if (init_counter === 7'bxxxxxxx)
            init_counter <= 7'h0;
        else
            if(init_counter == 7'd100)
                init_counter <= init_counter;
            else if(app_rdy == 1'b1)
                init_counter <= init_counter + 7'h1;
    end
    assign en = 1'b1;
    assign addra = (init_counter == 7'd100) ? 32'h0 : {25'h0,init_counter};
    assign wren = 1'b1;
        
    
bram_instruction u_bram_instruction(
    .addra(addra),
    .clk(clk),
    .en(en),
    .dout(dout)
);

mig_7series_0 u_mig_7series_0(
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
    .sys_clk_i(clk),
    //.sys_clk_n(~clk),
    //.clk_ref_i(clk_ref),
    //.clk_ref_n(~clk_ref),
    .app_addr(addra),
    .app_cmd(3'b000),
    .app_en(en),
    .app_wdf_data({96'h0,dout}),
    .app_wdf_end(1'b1),
    .app_wdf_mask(16'hffff),
    .app_wdf_wren(wren),
    . app_rd_data(app_rd_data),
    .app_rd_data_end(app_rd_data_end),
    .app_rd_data_valid(app_rd_data_valid),
    . app_rdy(app_rdy),
    .app_wdf_rdy(app_wdf_rdy),
    .app_sr_req(1'b0),
    .app_ref_req(1'b0),
    .app_zq_req(1'b0),
    . app_sr_active(app_sr_active),
    .app_ref_ack(app_ref_ack),
    .app_zq_ack(app_zq_ack),
    .ui_clk(ui_clk),
    .ui_clk_sync_rst(ui_clk_sync_rst),
    .init_calib_complete(),
    .sys_rst(1'b1)
  );

  endmodule