library verilog;
use verilog.vl_types.all;
entity HazardDetector is
    port(
        IF_ID_Rs1       : in     vl_logic_vector(4 downto 0);
        IF_ID_Rs2       : in     vl_logic_vector(4 downto 0);
        ID_EX_Rd        : in     vl_logic_vector(4 downto 0);
        ID_EX_lsu_rd    : in     vl_logic;
        stall           : out    vl_logic
    );
end HazardDetector;
