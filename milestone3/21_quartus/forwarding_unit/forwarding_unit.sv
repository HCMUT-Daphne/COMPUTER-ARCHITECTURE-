module forwarding_unit
    (
     input logic [4:0] Rs1_addr_i,
     input logic [4:0] Rs2_addr_i,
     input logic [4:0] EX_MEM_Rd_i,
     input logic [4:0] MEM_WB_Rd_i,
     input logic EX_MEM_Regs_wr_en_i,
     input logic MEM_WB_Regs_wr_en_i,
     output logic [1:0] alumux1_sel_o,
     output logic [1:0] alumux2_sel_o
    );
   //00:no Forward; 10:Forward from MEM; 01:Forward from WB
    assign alumux1_sel_o = ((EX_MEM_Regs_wr_en_i) && (EX_MEM_Rd_i != 0) && (EX_MEM_Rd_i == Rs1_addr_i)) ? 2'b10 :
                       ((MEM_WB_Regs_wr_en_i) && (MEM_WB_Rd_i != 0) && (MEM_WB_Rd_i == Rs1_addr_i)) ? 2'b01 : 2'b00;

    assign alumux2_sel_o = ((EX_MEM_Regs_wr_en_i) && (EX_MEM_Rd_i != 0) && (EX_MEM_Rd_i == Rs2_addr_i)) ? 2'b10 :
                       ((MEM_WB_Regs_wr_en_i) && (MEM_WB_Rd_i != 0) && (MEM_WB_Rd_i == Rs2_addr_i)) ? 2'b01 : 2'b00;


endmodule
