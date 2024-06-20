module adder(
  input  logic [`VECTOR_RANGE] operand_a_i,
  input  logic [`VECTOR_RANGE] operand_b_i,
  output logic [`VECTOR_RANGE] result_o
);

  assign result_o = operand_a_i + operand_b_i;
  
endmodule
