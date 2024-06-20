module mux4input (
  input  logic [`VECTOR_RANGE] input_0_i,
  input  logic [`VECTOR_RANGE] input_1_i,
  input  logic [`VECTOR_RANGE] input_2_i,
  input  logic [`VECTOR_RANGE] input_3_i,
  input  logic [1:0] select_i,
  output logic [`VECTOR_RANGE] output_o
);
  
  always_comb begin : mux4input_always
    case (select_i)
      `DATA_00: output_o = input_0_i;
      `DATA_01: output_o = input_1_i;
      `DATA_10: output_o = input_2_i;
      `DATA_11: output_o = input_3_i;
    endcase
  end

endmodule
