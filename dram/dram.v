module dram(
    input clk,
    input nrst
);

    reg [6:0] init_counter;
    wire [31:0] addra;
    wire en;
    wire [31:0] dout;
    wire app_rdy;
    wire app_wdf_rdy;
    always@(posedge clk) begin
        if (init_counter === 7'bxxxxxxx)
            init_counter <= 7'h0;
        else
            if(init_counter == 7'd100)
                init_counter <= init_counter;
            else
                init_counter <= init_counter + 7'h1;
    end
    assign en = (init_counter < 7'd101);
    assign addra = (init_counter == 7'd100) ? 32'h0 : {25'h0,init_counter};        
    
bram_instruction u_bram_instruction(
    .addra(addra),
    .clk(clk),
    .en(en),
    .dout(dout)
);

mig_7series_0 u_mig_7series_0(
    .sys_clk_p(clk),
    .sys_clk_n(clk),
    .clk_ref_p(clk),
    .clk_ref_n(clk),
    .app_addr(addra),
    .app_cmd(3'b000),
    .app_en(en),
    .app_wdf_data({96'h0,dout}),
    .app_wdf_end(1'b1),
    .app_wdf_mask(16'hffff),
    .app_wdf_wren(en),
    . app_rd_data(),
    .app_rd_data_end(),
    .app_rd_data_valid(),
    . app_rdy(app_rdy),
    .app_wdf_rdy(app_wdf_rdy),
    .app_sr_req(1'b1),
    .app_ref_req(1'b1),
    .app_zq_req(1'b1),
    . app_sr_active(),
    .app_ref_ack(),
    .app_zq_ack(),
    .ui_clk(),
    .ui_clk_sync_rst(),
    .init_calib_complete(),
    .sys_rst()
  );
  
  endmodule