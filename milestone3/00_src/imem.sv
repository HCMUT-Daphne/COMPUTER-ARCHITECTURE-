module imem (
  input  logic clk_i,
  input  logic rst_ni,
  input  logic [`VECTOR_RANGE] addr_i,
  output logic [`VECTOR_RANGE] inst_o
);

  reg [`VECTOR_RANGE] memory [0:`SIZE_IMEM-1];
  
  initial begin : readfiles
    memory = '{`SIZE_IMEM{32'h0000_0000}};
    $readmemh(`FILE_INST_HEX, memory);
  end

  always_comb begin : imem_always
    if (!rst_ni) begin
      inst_o <= 32'h0000_0000;
    end else begin
      inst_o <= memory[f_srl(addr_i, 5'h02)]; //addr/4 -> addr>>2
    end
  end

endmodule
