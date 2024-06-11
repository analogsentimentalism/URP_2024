`timescale 1ns/1ns
module tb_dsnfifo ();

reg					clk;
reg					rstn;
reg		[31:0	]	data_i;
reg					valid_pulse_i;
wire	[7:0	]	data_o;
wire				valid_o;
wire				tx_data;
wire				ready;

data_separator u_ds (
	.clk			(	clk				), 
	.rstn			(	rstn			), 
	.data_i			(	data_i			), 
	.valid_pulse_i	(	valid_pulse_i	), 
	.data_o			(	data_o			), 
	.valid_o		(	valid_o			),
	.ready			(	ready			)
);

TX_2 u_tx(
    .clk(clk),
    .rstn(rstn),
    .din(data_o),
    .tx_start(valid_o),
    .tx_data(tx_data),
	.ready(ready)
);

initial begin
	forever #1 clk = ~clk;
end

initial begin
	clk				= 1'b1;
	rstn			= 1'b0;
	data_i			= 32'b0;
	valid_pulse_i	= 1'b0;
	repeat(5) @(posedge clk);
	rstn			= 1'b1;
	repeat(5) @(posedge clk);

	data_i	= 32'h1234;
	valid_pulse_i	= 1'b1;
	repeat(1) @(posedge clk);
	valid_pulse_i	= 1'b0;

	repeat(1) @(posedge clk);

	data_i	= 32'h5678;
	valid_pulse_i	= 1'b1;
	repeat(1) @(posedge clk);
	valid_pulse_i	= 1'b0;

	repeat(1) @(posedge clk);

	data_i	= 32'h9abc;
	valid_pulse_i	= 1'b1;
	repeat(1) @(posedge clk);
	valid_pulse_i	= 1'b0;
end

task write;
	input 	[31:0	] 	data;
	input				clock;
	output	[31:0	]	data_o;
	output				valid;
	begin

	end
endtask

endmodule