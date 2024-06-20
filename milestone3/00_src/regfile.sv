module regfile(
  input  logic clk_i,
  input  logic rst_ni,
  input  logic regs_wr_en_i,

  input  logic [`VECTOR_ADDR] rd_addr_i,
  input  logic [`VECTOR_ADDR] rs1_addr_i,
  input  logic [`VECTOR_ADDR] rs2_addr_i,
  input  logic [`VECTOR_RANGE] rd_data_i,
  output logic [`VECTOR_RANGE] rs1_data_o,
  output logic [`VECTOR_RANGE] rs2_data_o
);

  logic [`VECTOR_RANGE] registers [0:`SIZE_REGS-1];

  initial begin : regfile_initial
    registers = '{32{32'h0000_0000}};
  end

  always @(posedge clk_i) begin : regfile_always
         if (regs_wr_en_i) begin
        registers[rd_addr_i] = (rd_addr_i == 5'b00000) ? 32'h0000_0000 : rd_data_i; 
      end
    if (!rst_ni) begin
      rs1_data_o = 32'h0000_0000;
      rs2_data_o = 32'h0000_0000;

      registers = '{32{32'h0000_0000}};
    end  
       rs1_data_o = registers[rs1_addr_i];
       rs2_data_o = registers[rs2_addr_i];

    $writememh("../00_src/memory/regfile.hex", registers);

  end


endmodule
