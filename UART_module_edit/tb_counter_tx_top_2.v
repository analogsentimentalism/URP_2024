    `timescale 1ns/1ns

    module tb_counter_tx_top_2();

    reg		clk;
    reg		rstn;
    reg		read_C_L1I;
    reg		miss_L1I_C;
    reg		read_C_L1D;
    reg		write_C_L1D;
    reg		miss_L1D_C;
    reg		read_L1_L2;
    reg		write_L1_L2;
    reg		miss_L2_L1;
    reg     cpu_done;

    wire    tx_data;




    counter_tx_top_2 u_counter_tx_top(
        .clk(clk),
        .rstn(rstn),
        .read_C_L1I(read_C_L1I),
        .miss_L1I_C(miss_L1I_C),
        .read_C_L1D(read_C_L1D),
        .write_C_L1D(write_C_L1D),
        .miss_L1D_C(miss_L1D_C),
        .read_L1_L2(read_L1_L2),
        .write_L1_L2(write_L1_L2),
        .miss_L2_L1(miss_L2_L1),
        .cpu_done(cpu_done),
        .tx_data(tx_data)
    );



    initial clk=1;
    always #5 clk = ~clk;



    initial begin:test

    rstn = 1;
    cpu_done = 0;

    read_C_L1I = 0;
    miss_L1I_C = 0;

    read_C_L1D = 0;
    write_C_L1D = 0;
    miss_L1D_C = 0;

    read_L1_L2 = 0;
    write_L1_L2 = 0;
    miss_L2_L1 = 0;
    u_counter_tx_top.u_counter.data_o = 0;
    repeat(100)	@(posedge clk);


    rstn = 0;
    repeat(100)	@(posedge clk);


    // j==0
    
    rstn = 1;
    read_C_L1I = 1;
    repeat(10)	@(posedge clk);


    read_C_L1I = 0;
    read_C_L1D = 1;
    miss_L1D_C = 1;
    repeat(10)	@(posedge clk);


    read_C_L1D = 0;
    miss_L1D_C = 0;
    repeat(10)	@(posedge clk);


    write_C_L1D = 1;
    miss_L1D_C = 1;
    write_L1_L2 = 1;
    repeat(10)	@(posedge clk);


    write_C_L1D = 0;
    miss_L1D_C = 0;
    write_L1_L2 = 0;

    read_C_L1D = 1;
    miss_L1D_C = 1;
    read_L1_L2 = 1;
    repeat(10)	@(posedge clk);


    read_C_L1D = 0;
    miss_L1D_C = 0;
    read_L1_L2 = 0;

    read_C_L1I = 1;
    miss_L1I_C = 1;
    repeat(10)	@(posedge clk);


    read_C_L1I = 0;
    miss_L1I_C = 0;
    repeat(10)	@(posedge clk);


    read_C_L1I = 1;
    miss_L1I_C = 1;
    repeat(10)	@(posedge clk);


    read_C_L1I = 0;
    miss_L1I_C = 0;

    write_C_L1D = 1;
    miss_L1D_C = 1;
    write_L1_L2 = 1;
    repeat(10)	@(posedge clk);


    write_C_L1D = 0;
    miss_L1D_C = 0;
    write_L1_L2 = 0;

    read_C_L1I = 1;
    repeat(10)	@(posedge clk);


    read_C_L1I = 0;

    read_C_L1D = 1;
    miss_L1D_C = 1;
    read_L1_L2 = 1;
    repeat(10)	@(posedge clk);


    read_C_L1D = 0;
    miss_L1D_C = 0;
    read_L1_L2 = 0;
    repeat(10)	@(posedge clk);

    read_C_L1I = 1;
    repeat(10) @(posedge clk);

    read_C_L1I = 0;
    repeat(10) @(posedge clk);

    read_C_L1I = 1;
    repeat(10) @(posedge clk);

    read_C_L1I = 0;
    repeat(10) @(posedge clk);
    read_C_L1I = 1;
    repeat(10) @(posedge clk);

    read_C_L1I = 0;
    repeat(10) @(posedge clk);
    read_C_L1I = 1;
    repeat(10) @(posedge clk);

    read_C_L1I = 0;
    repeat(10) @(posedge clk);
    read_C_L1I = 1;
    repeat(10) @(posedge clk);

    read_C_L1I = 0;
    repeat(10) @(posedge clk);
    read_C_L1I = 1;
    repeat(10) @(posedge clk);

    read_C_L1I = 0;
    repeat(10) @(posedge clk);


    cpu_done = 1;
    repeat(25000) @(posedge clk);

    $stop;

    end


    endmodule



