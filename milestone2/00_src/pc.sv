module pc (
  input  logic clk_i,
  input  logic rst_ni,
  input  logic pc_en_i,
    
  input  reg [`VECTOR_RANGE] pc_i,
  output reg [`VECTOR_RANGE] pc_o
);

  always_ff @(posedge clk_i or negedge rst_ni) begin : pc_always
    if (!rst_ni) begin
      pc_o <= 32'h0000_0000;
    end else begin
      if (pc_en_i) begin
        pc_o <= pc_i;
      end
    end
  end
  
endmodule
