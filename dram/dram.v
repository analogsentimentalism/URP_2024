`timescale 1ns / 1ps
//`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2016 09:56:26 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dram(
    input clk,
    input clk_ref,
    output app_rd_data_valid_o,
    output app_rdy_o,
    output app_wdf_rdy_o,
    output app_rd_data_or,
    output app_rd_data_end_o,
   
    // Memory interface ports
    output [12:0] ddr2_addr,  // output [15:0]        ddr3_addr
    output [2:0] ddr2_ba,  // output [2:0]        ddr3_ba
    output  ddr2_cas_n,  // output            ddr3_cas_n
    output [0:0] ddr2_ck_n,  // output [0:0]        ddr3_ck_n
    output [0:0] ddr2_ck_p,  // output [0:0]        ddr3_ck_p
    output [0:0] ddr2_cke,  // output [0:0]        ddr3_cke
    output ddr2_ras_n,  // output            ddr3_ras_n
    output ddr2_we_n,  // output            ddr3_we_n
    inout [15:0] ddr2_dq,  // inout [63:0]        ddr3_dq
    inout [1:0] ddr2_dqs_n,  // inout [7:0]        ddr3_dqs_n
    inout [1:0] ddr2_dqs_p  // inout [7:0]        ddr3_dqs_p
    //output init_calib_complete,  // output            init_calib_complete
      
    );

parameter state_0 = 0;
parameter state_read = 1;
parameter state_write = 2;
parameter enddd = 3;


reg [1:0] current_state = state_0;
reg [1:0] next_state;
   
wire clk_100; 
wire clk_200; 

          
reg [26:0] app_addr;
reg [2:0] app_cmd;
reg app_en;
reg [127:0] app_wdf_data;
reg app_wdf_end;
reg app_wdf_wren;
wire [127:0] app_rd_data;
wire app_rd_data_end;
wire app_rd_data_valid;
wire app_rdy;
reg app_zq_req;
reg app_sr_req;
reg app_ref_req;
wire app_sr_active;
wire app_ref_ack;
wire app_zq_ack;
reg [15:0] app_wdf_mask;
reg reset;
wire [31:0] count;          
wire init_calib;
reg enable;


wire [119:0] ddr3_ila_basic;          
wire [390:0] ddr3_ila_wrpath;          
wire [1023:0] ddr3_ila_rdpath;          
wire [5:0] dbg_pi_counter_read_val;          
wire [8:0] dbg_po_counter_read_val;   

wire [13:0] ddr3_vio_sync_out;
wire dbg_sel_pi_incdec;
wire dbg_sel_po_incdec;
wire [2:0] dbg_byte_sel;

wire dbg_pi_f_inc;
wire dbg_pi_f_dec;
wire dbg_po_f_inc;
wire dbg_po_f_dec;
wire dbg_po_f_stg23_sel;


 
 counter counting(
              .clk(ui_clk),
              .reset(reset),
              .count(count),
              .en(enable)
              );

        mig_7series_0 u_mig_7series_0 (
      
          // Memory interface ports
          .ddr2_addr                      (ddr2_addr),  // output [15:0]        ddr3_addr
          .ddr2_ba                        (ddr2_ba),  // output [2:0]        ddr3_ba
          .ddr2_cas_n                     (ddr2_cas_n),  // output            ddr3_cas_n
          .ddr2_ck_n                      (ddr2_ck_n),  // output [0:0]        ddr3_ck_n
          .ddr2_ck_p                      (ddr2_ck_p),  // output [0:0]        ddr3_ck_p
          .ddr2_cke                       (ddr2_cke),  // output [0:0]        ddr3_cke
          .ddr2_ras_n                     (ddr2_ras_n),  // output            ddr3_ras_n
          .ddr2_we_n                      (ddr2_we_n),  // output            ddr3_we_n
          .ddr2_dq                        (ddr2_dq),  // inout [63:0]        ddr3_dq
          .ddr2_dqs_n                     (ddr2_dqs_n),  // inout [7:0]        ddr3_dqs_n
          .ddr2_dqs_p                     (ddr2_dqs_p),  // inout [7:0]        ddr3_dqs_p
          .init_calib_complete            (init_calib_complete),  // output            init_calib_complete
            
          // Application interface ports
          .app_addr                       (count[26:0]),  // input [29:0]        app_addr
          .app_cmd                        (app_cmd),  // input [2:0]        app_cmd
          .app_en                         (app_en),  // input                app_en
          .app_wdf_data                   ({4{32'h00AAAA00}}),  // input [511:0]        app_wdf_data
          .app_wdf_end                    (app_wdf_end),  // input                app_wdf_end
          .app_wdf_wren                   (app_wdf_wren),  // input                app_wdf_wren
          .app_rd_data                    (app_rd_data),  // output [511:0]        app_rd_data
          .app_rd_data_end                (app_rd_data_end),  // output            app_rd_data_end
          .app_rd_data_valid              (app_rd_data_valid),  // output            app_rd_data_valid
          .app_rdy                        (app_rdy),  // output            app_rdy
          .app_wdf_rdy                    (app_wdf_rdy),  // output            app_wdf_rdy
          .app_sr_req                     (1'b0),  // input            app_sr_req
          .app_ref_req                    (app_ref_req),  // input            app_ref_req
          .app_zq_req                     (app_zq_req),  // input            app_zq_req
          .app_sr_active                  (),  // output            app_sr_active
          .app_ref_ack                    (app_ref_ack),  // output            app_ref_ack
          .app_zq_ack                     (app_zq_ack),  // output            app_zq_ack
          .ui_clk                         (ui_clk),  // output            ui_clk
          .ui_clk_sync_rst                (),  // output            ui_clk_sync_rst
          .app_wdf_mask                   (app_wdf_mask),  // input [63:0]        app_wdf_mask

          // System Clock Ports
          .sys_clk_p                       (clk),
                    .sys_clk_n                       (~clk),
          // Reference Clock Ports
          .clk_ref_p                      (clk_ref),
          .clk_ref_n                      (~clk_ref),
          .sys_rst                        (1'b1) // input sys_rst
          );



wire reset1;
wire begin_sig;
assign begin_sig = ui_clk;
   
assign app_rd_data_valid_o = app_rd_data_valid;
assign app_rdy_o = app_rdy;
assign app_wdf_rdy_o = app_wdf_rdy;
assign app_rd_data_or = |app_rd_data;
assign app_rd_data_end_o = app_rd_data_end;

always @ (posedge ui_clk)
    begin
        current_state <=  next_state;
    end
 
always @( current_state )
    begin
        case( current_state )
            state_0: begin
                        enable <= 1'b0;
                        app_en <= 1'b0;
                        reset <= 1'b1;
                        app_wdf_end <= 1'b0;
                        app_cmd <= 3'b000;
                        app_wdf_wren <= 1'b0;
                        app_zq_req <= 1'b0;
                        app_ref_req <= 1'b0;
                        app_wdf_mask <= 16'hffff;
                        if ( init_calib_complete == 1'b1 && begin_sig == 1'b1)
                            //next_state <= state_write;
                            next_state <= state_write;
                        else
                            next_state <= state_0;
                     end



            state_write: begin
                        
                        
                        app_zq_req <= 1'b0;
                        app_ref_req <= 1'b0;
                        
                        if( app_wdf_rdy == 1'b1 && app_rdy == 1'b1 )
                            begin
                                enable <= 1'b1;
                                app_en <= 1'b1;
                                //reset <= 1'b0;
                                app_cmd <= 3'b000;
                                app_wdf_wren <= 1'b1;

                                app_wdf_mask <= 64'h0000000F;
                                app_wdf_end <= 1'b1;
                                
                                if( count >= 32'h0000F00 )
                                    begin
                                        next_state <= state_read;
                                        reset <= 1'b1;
                                        enable <= 1'b1;
                                    end
                                else
                                    begin
                                        next_state <= state_write;
                                        reset <= 1'b0;
                                        enable <= 1'b1;
                                    end                             
                            end
                        else
                            begin
                                enable <= 1'b0;
                                app_en <= app_en;
                                
                                app_cmd <= app_cmd;
                                app_wdf_wren <= app_wdf_wren;
                                
                                next_state <= state_write;
                                reset <= 1'b0;
                                app_wdf_end <= 1'b0;
                            end       
                     end


            state_read: begin
                        //enable <= 1'b0;

                        app_zq_req <= 1'b0;
                        app_ref_req <= 1'b0;
                        if( app_rdy == 1'b1 )
                            begin
                                //reset <= 1'b0;
                                app_en <= 1'b1;
                                app_cmd <= 3'b001;
                                app_wdf_wren <= 1'b0;
                                app_wdf_mask <= 64'h0000000F;
                                app_wdf_end <= 1'b0;
                                enable <= 1'b1;
                                
                                if( count >= 32'h0000F00 )
                                    begin
                                        next_state <= state_0;
                                        reset <= 1'b1;
                                        enable <= 1'b1;
                                    end
                                else
                                    begin
                                        next_state <= state_read;
                                        reset <= 1'b0;
                                        enable <= 1'b1;
                                    end                             
                            end
                        else
                            begin
                                enable <= 1'b0;
                                next_state <= state_read;
                                reset <= 1'b0;
                                app_en <= 1'b0;
                            end       
                     end

        endcase
    end
endmodule