module mux4_2sel
    (input logic [`VECTOR_RANGE] d00, d01, d10, d11,
     input logic s0,
     input logic [1:0] s1,
     output logic [`VECTOR_RANGE] y);

always_comb begin
  if(s0==1'b1) 
    y = d11;
  else if(s1==2'b01)
    y = d01;
  else if(s1==2'b10)
    y = d10;
  else 
    y = d00;
end

endmodule : mux4_2sel
