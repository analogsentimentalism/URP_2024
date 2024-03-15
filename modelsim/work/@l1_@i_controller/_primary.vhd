library verilog;
use verilog.vl_types.all;
entity L1_I_controller is
    port(
        clk             : in     vl_logic;
        nrst            : in     vl_logic;
        tag             : in     vl_logic_vector(51 downto 0);
        index           : in     vl_logic_vector(5 downto 0);
        read_C_L1       : in     vl_logic;
        flush           : in     vl_logic;
        ready_L2_L1     : in     vl_logic;
        write_C_L1      : in     vl_logic;
        stall           : out    vl_logic;
        refill          : out    vl_logic;
        update          : out    vl_logic;
        read_L1_L2      : out    vl_logic;
        write_L1_L2     : out    vl_logic
    );
end L1_I_controller;
