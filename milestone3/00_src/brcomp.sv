module brcomp(
  input  logic br_unsigned_i,
  input  logic [`VECTOR_RANGE] rs1_data_i,
  input  logic [`VECTOR_RANGE] rs2_data_i,
  output logic br_equal_o,
  output logic br_less_o  
);

     always @(*) begin : brcomp_always
    //check equal
    br_equal_o = (rs1_data_i == rs2_data_i) ? `TRUE : `FALSE;

    //check less than
    if (br_unsigned_i) begin : unsign_comp
      br_less_o = f_lessu(rs1_data_i, rs2_data_i) ? `TRUE : `FALSE;
    end else begin : sign_comp
      br_less_o =  f_less(rs1_data_i, rs2_data_i) ? `TRUE : `FALSE;
    end

  end

endmodule
