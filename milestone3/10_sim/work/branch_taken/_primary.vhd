library verilog;
use verilog.vl_types.all;
entity branch_taken is
    port(
        Opcode_i        : in     vl_logic_vector(6 downto 0);
        A_Pc_i          : in     vl_logic_vector(31 downto 0);
        Rs1_data_i      : in     vl_logic_vector(31 downto 0);
        B_Alu_Data_i    : in     vl_logic_vector(31 downto 0);
        C_Alu_Data_i    : in     vl_logic_vector(31 downto 0);
        A_addr_Rs1_i    : in     vl_logic_vector(4 downto 0);
        B_addr_Rd_i     : in     vl_logic_vector(4 downto 0);
        C_addr_Rd_i     : in     vl_logic_vector(4 downto 0);
        B_regs_wr_en_i  : in     vl_logic;
        C_regs_wr_en_i  : in     vl_logic;
        imm_taken_i     : in     vl_logic_vector(31 downto 0);
        pcmux_sel_i     : out    vl_logic;
        pc_taken        : out    vl_logic_vector(31 downto 0)
    );
end branch_taken;
