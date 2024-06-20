module alu (
  input  logic [3:0] alu_op_i,
  input  logic [`VECTOR_RANGE] operand_a_i,
  input  logic [`VECTOR_RANGE] operand_b_i,
  output logic [`VECTOR_RANGE] alu_data_o
);
  logic [`VECTOR_RANGE] alu_tmp;
  
  always_comb begin : alu_always
    case (alu_op_i)
      `ALU_ADD_OP   : alu_tmp = $signed(operand_a_i) + $signed(operand_b_i);
      `ALU_SUB_OP   : alu_tmp = $signed(operand_a_i) + $signed(~operand_b_i + 32'h0000_0001);
      `ALU_XOR_OP   : alu_tmp = operand_a_i ^ operand_b_i;
      `ALU_OR_OP    : alu_tmp = operand_a_i | operand_b_i;
      `ALU_AND_OP   : alu_tmp = operand_a_i & operand_b_i;
      `ALU_SLL_OP   : alu_tmp = f_sll(operand_a_i, operand_b_i[4:0]);
      `ALU_SRL_OP   : alu_tmp = f_srl(operand_a_i, operand_b_i[4:0]);
      `ALU_SRA_OP   : alu_tmp = f_sra(operand_a_i, operand_b_i[4:0]);
      `ALU_SLT_OP   : alu_tmp = f_less(operand_a_i, operand_b_i)  ? 32'h0000_0001 : 32'h0000_0000;
      `ALU_SLTU_OP  : alu_tmp = f_lessu(operand_a_i, operand_b_i) ? 32'h0000_0001 : 32'h0000_0000;
      `ALU_UI_OP    : alu_tmp = operand_b_i;
      default       : alu_tmp = 32'h0000_0000;
    endcase
  end

  assign alu_data_o = alu_tmp;
  
endmodule
