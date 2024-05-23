module rom #(
   parameter RAM_WIDTH = 32,
   parameter RAM_DEPTH = 2048,
   parameter INIT_FILE = "C:/Users/82108/bram_instruction/bram_instruction.srcs/sources_1/new/test.txt"
) (
   input                        clk,
   input   [clogb2(RAM_DEPTH-1)-1:0]    addra,
   input                        en,
   output   [RAM_WIDTH-1:0]            dout
);

(*rom_style = "block" *) reg [RAM_WIDTH-1:0] ROM [0:RAM_DEPTH-1];
(*rom_style = "block" *) reg [RAM_WIDTH-1:0] temp;


generate
if (INIT_FILE != "") begin: use_init_file
   initial
   $readmemh(INIT_FILE, ROM, 0, RAM_DEPTH-1);
end else begin: init_bram_to_zero
   integer ram_index;
   initial
   for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
      ROM[ram_index] = {RAM_WIDTH{1'b0}};
end
endgenerate

always @(posedge clk) begin
   if (en) begin
      temp   <= ROM[addra];
   end
end

assign   dout   = temp;

function integer clogb2;
input integer depth;
   for (clogb2=0; depth>0; clogb2=clogb2+1)
   depth = depth >> 1;
endfunction

endmodule