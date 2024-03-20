library verilog;
use verilog.vl_types.all;
entity L1_I_controller is
    generic(
        S_IDLE          : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        S_COMPARE       : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        S_WRITE_BACK    : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        S_ALLOCATE      : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        nrst            : in     vl_logic;
        tag             : in     vl_logic_vector(19 downto 0);
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
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of S_IDLE : constant is 1;
    attribute mti_svvh_generic_type of S_COMPARE : constant is 1;
    attribute mti_svvh_generic_type of S_WRITE_BACK : constant is 1;
    attribute mti_svvh_generic_type of S_ALLOCATE : constant is 1;
end L1_I_controller;
