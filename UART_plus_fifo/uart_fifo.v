//FIFO to Transmitter
//Sends a byte of data to Transmitter from buffer one by one

module fifo(

       input [7:0] data_in,
       input clk,
       input rstn,
       
       output reg [7:0] data_out
);


reg [63:0] fifo_tx_mem [7:0];  // time 1,2,3 에 해당하는 miss rate를 fifo에 저장하고 최종 출력한다. 한 번에 21개의 data_o를 내보냄. 따라서 세 번이면 63개.
reg [5:0] wr_pt;
reg [5:0] rd_pt;

reg wr_en;
reg rd_en;
       


// pointer
always @(posedge clk)
  begin
    if(!rstn) begin
      wr_pt <= 5'b00000;
      rd_pt <= 5'b00000;
    end
    else begin
      wr_pt <= wr_pt;
      rd_pt <= rd_pt;
    end
  end



always @(posedge clk)
  begin
    if(wr_en)
      begin
        fifo_tx_mem[wr_pt] <= data_in;
        wr_pt <= wr_pt+1;
      end
  end
             
              

         
always@(posedge clk)
  begin
    if(rd_en)
    begin
      data_out <= fifo_tx_mem[rd_Pt];
      rd_pt <= rd_pt+1;
    end
  end
    

endmodule  
                  
                  
                  
                   
                   
                   
            