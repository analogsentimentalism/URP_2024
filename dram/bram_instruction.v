`timescale 1us / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/23 15:08:07
// Design Name: 
// Module Name: instruction_bram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bram_instruction(
        input [31:0] addra,
        input en,
        input clk,
        output [31:0] dout
    );
   rom #(
    .RAM_WIDTH(32),                       // Specify RAM data width
    .RAM_DEPTH(2048),                     // Specify RAM depth (number of entries)
    .INIT_FILE("C:/Users/82108/bram_instruction/bram_instruction.srcs/sources_1/new/test.txt")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) your_instance_name (
    .clk(clk),   // Port A address bus, width determined from RAM_DEPTH
    .addra(addra),   // Port B address bus, width determined from RAM_DEPTH
    .en(en),       // Port A RAM Enable, for additional power savings, disable port when not in use
    .dout(dout)   // Port A RAM output data, width determined from RAM_WIDTH
  );

endmodule
