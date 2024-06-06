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
        .tx_data(tx_data)
    );



    initial clk=1;
    always #5 clk = ~clk;  // T: 10ns



    initial begin:test

    rstn = 1;


    read_C_L1I = 0;
    miss_L1I_C = 0;

    read_C_L1D = 0;
    write_C_L1D = 0;
    miss_L1D_C = 0;

    read_L1_L2 = 0;
    write_L1_L2 = 0;
    miss_L2_L1 = 0;
    u_counter_tx_top.u_counter.data_o = 0;
    repeat(100)	@(posedge clk);  //1000


    rstn = 0;
    repeat(100)	@(posedge clk);  //2000



    
    rstn = 1;
    read_C_L1I = 1;
    repeat(10)	@(posedge clk); //2100


    read_C_L1I = 0;
    read_C_L1D = 1;
    miss_L1D_C = 1;
    repeat(10)	@(posedge clk);  //2200


    read_C_L1D = 0;
    miss_L1D_C = 0;
    repeat(10)	@(posedge clk);  //2300


    write_C_L1D = 1;
    miss_L1D_C = 1;
    write_L1_L2 = 1;
    repeat(10)	@(posedge clk);  //2400


    write_C_L1D = 0;
    miss_L1D_C = 0;
    write_L1_L2 = 0;

    read_C_L1D = 1;
    miss_L1D_C = 1;
    read_L1_L2 = 1;
    repeat(10)	@(posedge clk);  //2500


    read_C_L1D = 0;
    miss_L1D_C = 0;
    read_L1_L2 = 0;

    read_C_L1I = 1;
    miss_L1I_C = 1;
    repeat(10)	@(posedge clk);  //2600 


    read_C_L1I = 0;
    miss_L1I_C = 0;
    repeat(10)	@(posedge clk);  //2700


    read_C_L1I = 1;
    miss_L1I_C = 1;
    repeat(10)	@(posedge clk);  //2800


    read_C_L1I = 0;
    miss_L1I_C = 0;

    write_C_L1D = 1;
    miss_L1D_C = 1;
    write_L1_L2 = 1;
    repeat(10)	@(posedge clk);  //2900


    write_C_L1D = 0;
    miss_L1D_C = 0;
    write_L1_L2 = 0;

    read_C_L1I = 1;
    repeat(10)	@(posedge clk);   //3000


    read_C_L1I = 0;

    read_C_L1D = 1;
    miss_L1D_C = 1;
    read_L1_L2 = 1;
    repeat(10)	@(posedge clk);  //3100 


    read_C_L1D = 0;
    miss_L1D_C = 0;
    read_L1_L2 = 0;
    repeat(10)	@(posedge clk);  //3200

    read_C_L1I = 1;
    repeat(10) @(posedge clk);  //3300

    read_C_L1I = 0;
    repeat(10) @(posedge clk);  //3400

    read_C_L1I = 1;
    repeat(10) @(posedge clk);  //3500

    read_C_L1I = 0;
    repeat(10) @(posedge clk);  //3600
    read_C_L1I = 1;
    repeat(10) @(posedge clk);  //3700

    read_C_L1I = 0;
    repeat(10) @(posedge clk);  //3800
    read_C_L1I = 1;
    repeat(10) @(posedge clk);  //3900

    read_C_L1I = 0;
    repeat(10) @(posedge clk);  //4000
    read_C_L1I = 1;
    repeat(10) @(posedge clk);  //4100

    read_C_L1I = 0;
    repeat(10) @(posedge clk);  //4200
    read_C_L1I = 1;
    repeat(10) @(posedge clk);  //4300

    read_C_L1I = 0;
    repeat(10) @(posedge clk);  //4400

    read_C_L1I = 1;

    repeat(50) @(posedge clk);  //4900

    read_C_L1I = 0;
    repeat(10) @(posedge clk);  //5000    signal -> high, wr_en ->high, j->0

    read_C_L1D = 1;
    miss_L1D_C = 1;
    read_L1_L2 = 1;
    repeat(100) @(posedge clk);  //6000

    $stop;

    end


    endmodule



