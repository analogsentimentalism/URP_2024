module fifo(
       input [7:0] data_in,
       input clk,
       input rstn,
       input wr_en,        // counter의 wr_en과 연결
       
       output reg [7:0] data_out,
       output reg rd_en
);


reg [63:0] fifo_tx_mem [7:0];  // time 1,2,3 에 해당하는 miss rate를 fifo에 저장하고 최종 출력한다. 한 번에 21개의 data_o를 내보냄. 따라서 세 번이면 63개.
reg [5:0] wr_pt;
reg [5:0] rd_pt;
reg [5:0] rd_pt_prev;

reg [11:0] count;             // baud rate와 clk speed 맞춤용
wire fifo_empty;
reg rd_en_reg;

assign fifo_empty = (wr_pt == rd_pt);



always @(posedge clk) begin
  rd_pt_prev <= rd_pt;
end


// rd_en
always @(posedge clk) begin
  if((!fifo_empty && rd_pt==0) || (!fifo_empty && (rd_pt!= rd_pt_prev))) begin
    rd_en <= rd_en_reg;
  end
  else if (rd_en) begin    // 한사이클만 rd_en high 만들기
    rd_en <= ~rd_en;
  end
end



// pointer
always @(posedge clk)
  begin
    if(!rstn) begin
      wr_pt <= 5'b00000;
      rd_pt <= 5'b00000;
    end
  end



// count
always (posedge clk) begin
  if(!rstn) begin
    count <= 'b0;
  end
  else if(rd_en_reg) begin
    count <= count +1;
  end
  else if(count == 26100) begin
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
    rd_en_reg <= 0;
  end
  else if(!fifo_empty) begin
    rd_en_reg <=1;
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
    if(rd_en_reg && count == 26100)
    begin
      data_out <= fifo_tx_mem[rd_pt];
      rd_pt <= rd_pt+1;
    end
  end
    

endmodule  
                  
                  
                  
                   
                   
                   
            