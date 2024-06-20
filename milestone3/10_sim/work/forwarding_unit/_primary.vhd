library verilog;
use verilog.vl_types.all;
entity forwarding_unit is
    port(
        Rs1_addr_i      : in     vl_logic_vector(4 downto 0);
        Rs2_addr_i      : in     vl_logic_vector(4 downto 0);
        EX_MEM_Rd_i     : in     vl_logic_vector(4 downto 0);
        MEM_WB_Rd_i     : in     vl_logic_vector(4 downto 0);
        EX_MEM_Regs_wr_en_i: in     vl_logic;
        MEM_WB_Regs_wr_en_i: in     vl_logic;
        alumux1_sel_o   : out    vl_logic_vector(1 downto 0);
        alumux2_sel_o   : out    vl_logic_vector(1 downto 0)
    );
end forwarding_unit;
