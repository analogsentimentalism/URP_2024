`timescale 1ns/1ns
module tb_L1_D_controller ();

reg               clk;
reg               nrst;

reg      [31:0]      address; 
reg               read_C_L1;
reg               write_C_L1;
reg               flush;
reg               ready_L2_L1;

wire            stall;
wire            refill;
wire            update;
wire            way;
wire            read_L1_L2;
wire            write_L1_L2;
wire   [4:0]      index_L1_L2;
wire   [20:0]      tag_L1_L2;
wire   [20:0]      write_tag_L1_L2;

L1_D_controller u_L1_D_controller (

    .clk            (clk),
    .nrst            (nrst),

    .tag_C_L1         (address[31:11]),
    .index_C_L1         (address[10:6]),
    .read_C_L1         (read_C_L1),
    .flush            (flush),
    .ready_L2_L1      (ready_L2_L1),
    .write_C_L1         (write_C_L1),

    .stall            (stall),
   .refill            (refill),
   .way            (way),
   .update            (update),
    .read_L1_L2         (read_L1_L2),
    .write_L1_L2      (write_L1_L2),
   
   .index_L1_L2      (index_L1_L2),
   .tag_L1_L2         (tag_L1_L2),
   .write_tag_L1_L2   (write_tag_L1_L2)
);

// Signals for Testbench
reg      [63:0]      address_array   [0:9999];
integer   i, j, EXIT;

reg      [2:0]      test_state;

always begin
#1   clk         = ~clk;
end

// Init
initial begin: init
   test_state   =   3'd0;

   clk         =   1'b1;
   nrst      =   1'b0;
   address      =   64'b0;
   read_C_L1   =   1'b0;
   write_C_L1   =   1'b0;
   flush      =   1'b0;
   ready_L2_L1   =   1'b0;

   for(i = 0; i<30; i = i + 1) begin   // random addresses
      address_array[i]   =   $urandom & 32'hFFFF_F03C | {i[5:0], 6'b000000};
      $display("%2dth address:\t%8h", i, address_array[i]);
   end
   for(i = 0; i<30; i = i + 1) begin   // random addresses with same index
      address_array[i + 30]   =   $urandom & 32'hFFFF_F03C | {address_array[i][11:6], 6'b000000};
      $display("%2dth address\t:\t%8h", i + 30, address_array[i + 30]);
   end
end

initial begin: test

   // 0. Cache Init (Write)
   $display("Cache Init (Write) start");

   nrst      =   1'b1;
   repeat(5)   @(posedge   clk);
   nrst      =   1'b0;

   repeat(5)   @(posedge   clk);
   nrst      =   1'b1;
   write_C_L1   =   1'b1;   // Initial reset

   for(i = 0; i<10; i = i + 1) begin
      address      = address_array[i];

      $display("%6d: Read Address %h", i, address);

      repeat(4)   @(posedge   clk);
      ready_L2_L1   =   1'b1;
      @(posedge   clk);
      ready_L2_L1   =   1'b0;
      
      while(stall) #2;
   end

   write_C_L1   =   1'b0;
   repeat(50)   @(posedge   clk);

   // 1. Read: Hit
   $display("%6d: Read-Hit", $time);
   test_state   =   3'd1;

   read_C_L1   =   1'b1;

   for(i = 0; i<10; i = i + 1) begin
      address      =   address_array[i];

      $display("%6d: Read Address %h", $time, address);
      @(posedge   clk);
      while(stall) @(posedge   clk);
   end

   read_C_L1   =   1'b0;
   repeat(50)   @(posedge   clk);

   // 2. Read: Miss - (Memory) Hit
   $display("%6d: Read-Miss-Hit", $time);
   test_state   =   3'd2;

   read_C_L1   =   1'b1;

   for(i = 10; i<20; i = i + 1) begin
      address      =   address_array[i];

      $display("%6d: Read Address %h", $time, address);
      repeat(4)   @(posedge   clk);
      ready_L2_L1   =   1'b1;
      @(posedge   clk);
      ready_L2_L1   =   1'b0;
      @(posedge   clk);
      while(stall) #2;
   end

   read_C_L1   =   1'b0;
#100;

   // 3. Read: Miss - (Memory) Miss
   $display("%6d: Read-Miss-Miss", $time);
   test_state   =   3'd3;

   read_C_L1   =   1'b1;

   for(i = 20; i<30; i = i + 1) begin
      address      =   address_array[i];

      $display("%6d: Read Address %h", $time, address);
      repeat(10)   @(posedge   clk);
      ready_L2_L1   =   1'b1;
      @(posedge   clk);
      ready_L2_L1   =   1'b0;
      @(posedge   clk);
      while(stall) @(posedge   clk);
   end

   read_C_L1   =   1'b0;
   repeat(50)   @(posedge   clk);

   // 4. Cache Replacement: Hit
   $display("%6d: Cache Replacement-Hit", $time);
   test_state   =   3'd4;

   read_C_L1   =   1'b1;

   for(i = 30; i<60; i = i + 1) begin
      address      =   address_array[i];

      $display("%6d: Read Address %h", $time, address);
      repeat(5)   @(posedge   clk);
      if(write_L1_L2)   begin   // for write
         $display("%6d: Write Back", $time);
         @(posedge   clk);
         ready_L2_L1   =   1'b1;
         @(posedge   clk);
         ready_L2_L1   =   1'b0;
      end

      $display("%6d: Read", $time);
      repeat(2)   @(posedge   clk);
      ready_L2_L1   =   1'b1;   // for read
      @(posedge   clk);
      ready_L2_L1   =   1'b0;
      @(posedge   clk);
      while(stall) @(posedge   clk);
   end
   
   read_C_L1   =   1'b0;

   repeat(50)   @(posedge   clk);

   // 5. Cache Replacement: Miss
   $display("%6d: Cache Replacement-Miss", $time);
   test_state   =   3'd5;

   write_C_L1   =   1'b1;

   for(i = 30; i<40; i = i + 1) begin
      address      =   address_array[i];

      $display("%6d: Write Address (for dirty) %h", $time, address);
      repeat(5)   @(posedge   clk);
      ready_L2_L1   =   1'b1;
      @(posedge   clk);
      ready_L2_L1   =   1'b0;
      @(posedge   clk);
      while(stall) @(posedge   clk);
   end

   write_C_L1   =   1'b0;

   read_C_L1   =1'b1;

   for(i = 0; i<30; i = i + 1) begin
      address      =   address_array[i];
      repeat(5)   @(posedge   clk);
      if(write_L1_L2)   begin   // for dirty
         $display("%6d: Write Back", $time);
         @(posedge   clk);
         ready_L2_L1   =   1'b1;
         @(posedge   clk);
         ready_L2_L1   =   1'b0;
      end

      $display("%6d: Read", $time);
      repeat(10)   @(posedge   clk);
      ready_L2_L1   =   1'b1;   // for read
      @(posedge   clk);
      ready_L2_L1   =   1'b0;
      @(posedge   clk);
      while(stall) @(posedge   clk);
   end

   repeat(50)   @(posedge   clk);

   // 6. Flush
   $display("%6d: FLUSH", $time);
   test_state   =   3'd6;

   flush   =   1'b1;

   repeat(50)   @(posedge   clk);
   $finish;
end

initial begin
   $dumpfile("tb_L1_D_controller_for_I.vcd");
   $dumpvars(u_L1_D_controller);
end

endmodule