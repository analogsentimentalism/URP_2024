module fifo(
       input [7:0] data_in,
       input clk,
       input rstn,
       input wr_en,        // counter의 wr_en과 연결
       
       output reg [7:0] data_out,
       output reg done
);

reg cpu_done_prev;
reg [63:0] fifo_tx_mem [7:0];  // time 1,2,3 에 해당하는 miss rate를 fifo에 저장하고 최종 출력한다. 한 번에 21개의 data_o를 내보냄. 따라서 세 번이면 63개.
reg [5:0] wr_pt;
reg [5:0] rd_pt;

reg rd_en;
reg [11:0] count;             // baud rate와 clk speed 맞춤용
wire fifo_empty;


assign fifo_empty = (wr_pt == rd_pt);



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



// count
always (posedge clk) begin
  if(!rstn) begin
    count <= 'b0;
  end
  else if(rd_en) begin
    count <= count +1;
  end
  else if(count == 2604) begin
    count <= 'b0;
  end
  else count <= count;
end




// wr_en
always @(posedge clk) begin
  if(!rstn) begin
    wr_en <= 0;
  end
end




// rd_en
always @(posedge clk) begin
  if (!rstn) begin
    rd_en <= 0;
  end
  else if(fifo_empty) begin
    rd_en <=1;
  end
end



// write
always @(posedge clk)
  begin
    if(wr_en)
      begin
        fifo_tx_mem[wr_pt] <= data_in;
        wr_pt <= wr_pt+1;
      end
  end
             
              

// read   
always@(posedge clk)
  begin
    if(rd_en && count == 2604)
    begin
      data_out <= fifo_tx_mem[rd_Pt];
      rd_pt <= rd_pt+1;
    end
  end
    

endmodule  
                  
                  
                  
                   
                   
                   
            