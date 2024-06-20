library verilog;
use verilog.vl_types.all;
entity flipflop is
    port(
        clk_i           : in     vl_logic;
        rst_ni          : in     vl_logic;
        d               : in     vl_logic_vector(31 downto 0);
        stall           : in     vl_logic;
        q               : out    vl_logic_vector(31 downto 0)
    );
end flipflop;
