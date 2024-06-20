module branch_taken(
 input logic [6:0] Opcode_i,
 input logic [31:0] A_Pc_i,
 input logic [31:0] Rs1_data_i,
 input logic [31:0] B_Alu_Data_i,
 input logic [31:0] C_Alu_Data_i,
 input logic [4:0] A_addr_Rs1_i,
 input logic [4:0] B_addr_Rd_i,
 input logic [4:0] C_addr_Rd_i,
 input logic B_regs_wr_en_i,
 input logic C_regs_wr_en_i,
 input [31:0] imm_taken_i,
 output pc_mux_sel_i,
 output [31:0] pc_taken	
);
  logic [31:0] data;
  assign data = ((B_regs_wr_en_i) && (B_addr_Rd_i != 0) && (B_addr_Rd_i == A_addr_Rs1_i)) ? B_Alu_Data_i:
                ((C_regs_wr_en_i) && (C_addr_Rd_i != 0) && (C_addr_Rd_i == A_addr_Rs1_i)) ? C_Alu_Data_i : Rs1_data_i;
  assign pc_mux_sel_i = (Opcode_i == 7'b1100011 || Opcode_i == 7'b1100111 || Opcode_i == 7'b1101111) ? 1'b1 : 1'b0;
  assign pc_taken = (Opcode_i == 7'b1100011 || Opcode_i == 7'b1101111) ? (A_Pc_i + imm_taken_i) :  (Opcode_i == 7'b1100111) ? (data + imm_taken_i) : 14'b0;

endmodule : branch_taken
