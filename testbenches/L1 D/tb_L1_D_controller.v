`timescale 1ns/1ps
module tb_L1_D_controller ();

reg                 clk;
reg                 nrst;

reg     [63:0]      address; 
reg                 read_C_L1;
reg                 write_C_L1;
reg                 flush;
reg                 ready;

wire                stall;
wire                refill;
wire                update;
wire                read_L1_L2;
wire                write_L1_L2;

L1_D_controller u_L1_D_controller (
    .clk            (clk),
    .nrst           (nrst),

    .tag            (address[63:12]),
    .index          (address[11:6]),
    .read_C_L1      (read_C_L1),
    .write_C_L1     (write_C_L1),
    .flush          (flush),
    .stall          (stall),

    .refill         (refill),
    .update         (update),

    .read_L1_L2     (read_L1_L2),
    .write_L1_L2    (write_L1_L2),
    .ready          (ready),
);

always begin
    #5 clk = ~clk;
end

initial begin

// 0. Init

#0  clk     = 1'b0;
    nrst    = 1'b1;
    address = 64'b0;
    for()

// 1. Data Read

// 1-1. Hit

// 1-2. Miss - (Memory) Hit

// 1-3. Miss - (Memory) Miss

// 2. Data Write

// 2-1. Not Changed

// 2-2. Write back

// 3. Flushed

// 4. Reset


    
end

endmodule