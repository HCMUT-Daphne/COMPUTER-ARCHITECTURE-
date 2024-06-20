module mux2input ( 
  input  logic [`VECTOR_RANGE] input_0_i,
  input  logic [`VECTOR_RANGE] input_1_i,
  input  logic select_i, 
  output logic [`VECTOR_RANGE] output_o
);
  
  always_comb begin : mux2input_always
    case (select_i)
      `DATA_0: output_o = input_0_i;
      `DATA_1: output_o = input_1_i;
    endcase
  end

endmodule
