`timescale 1ns/1ns
module tb_counter ();
    reg		clk,
	reg		rstn,
	reg		read_C_L1I,
	reg		miss_L1I_C,
	reg		read_C_L1D,
	reg		write_C_L1D,
	reg		miss_L1D_C,
	reg		read_L1_L2,
	reg		write_L1_L2,
	reg		miss_L2_L1,
	wire	[7:0] data_o,
	wire    done;         


    counter u_counter(
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
        .data_o(data_o),
        .done(done)
    );


    initial clk=1;
    forever #5 clk=~clk;

    initial begin
        read_C_L1I =1;
        miss_L1I_C =1;

        #20
        read_C_L1 =0;

        #20 $stop;
    end
endmodule
