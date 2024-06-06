module fifo(
       input [7:0] data_in,
       input clk,
       input rstn,
       input wr_en,        // counter의 wr_en과 연결
       
       output reg [7:0] data_out,
       output reg rd_en
);


reg [7:0] fifo_tx_mem [63:0];  // time 1,2,3 에 해당하는 miss rate를 fifo에 저장하고 최종 출력한다. 한 번에 21개의 data_o를 내보냄. 따라서 세 번이면 63개.
reg [5:0] wr_pt;
reg [5:0] rd_pt;
reg [5:0] rd_pt_prev;

reg [31:0] count;             // baud rate와 clk speed 맞춤용
wire fifo_empty;
wire rd_en_reg;
reg rd_en_reg_prev;
reg wr_enable;



assign fifo_empty = (wr_pt == rd_pt);
assign rd_en_reg = !fifo_empty;


always @(posedge clk) begin
  rd_pt_prev <= rd_pt;
  wr_enable <= wr_en;
  rd_en_reg_prev <= rd_en_reg;
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
always @(posedge clk) begin
  if(!rstn || count== 26100) begin
    count <= 'b0;
  end
  else if(rd_en_reg) begin
    count <= count +1;
  end

end




// write
always @(posedge clk)
  begin
    if(!rstn) begin
      wr_pt <= 5'b00000;
    end
    else if(wr_enable)
      begin
        fifo_tx_mem[wr_pt] <= data_in;
        wr_pt <= wr_pt+1;
      end
  end
             



// rd_en
always @(posedge clk) begin
  if (!rstn) begin
    rd_en <= 'b0;
  end
  else if((!fifo_empty && rd_pt==0) || (!fifo_empty && (rd_pt!= rd_pt_prev))) begin  //1번 조건: fifo에 첫 데이터가 들어왔을 떄
    rd_en <= rd_en_reg;
  end
  else if (rd_en) begin    // 한사이클만 rd_en high 만들기
    rd_en <= ~rd_en;
  end
end


// read   
always@(posedge clk)
  begin
    if(!rstn) begin
      rd_pt <= 5'b00000;
    end
    else if((rd_en_reg && count == 26100) || ((rd_en_reg_prev ^ rd_en_reg) & rd_en_reg))
    begin
      data_out <= fifo_tx_mem[rd_pt];
      rd_pt <= rd_pt+1;
    end
  end
    

endmodule  
                  
                  
                  
                   
                   
                   
            
