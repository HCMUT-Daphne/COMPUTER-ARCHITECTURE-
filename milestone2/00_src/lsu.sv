module lsu(
  input  logic clk_i,
  input  logic rst_ni,
  
  input  logic st_en_i,
  input  logic [`VECTOR_RANGE] st_data_i,
  input  logic [`VECTOR_RANGE] addr_i,
  output logic [`VECTOR_RANGE] data_rd_o,

  input  logic [`VECTOR_RANGE] io_sw_i,
  input  logic [`VECTOR_RANGE] io_key_i,
  output logic [`VECTOR_RANGE] io_lcd_o,
  output logic [`VECTOR_RANGE] io_ledg_o,
  output logic [`VECTOR_RANGE] io_ledr_o,
  output logic [`VECTOR_RANGE] io_hex7_o,
  output logic [`VECTOR_RANGE] io_hex6_o,
  output logic [`VECTOR_RANGE] io_hex5_o,
  output logic [`VECTOR_RANGE] io_hex4_o,
  output logic [`VECTOR_RANGE] io_hex3_o,
  output logic [`VECTOR_RANGE] io_hex2_o,
  output logic [`VECTOR_RANGE] io_hex1_o,
  output logic [`VECTOR_RANGE] io_hex0_o
);

  logic [`VECTOR_RANGE] memory [0:`SIZE_DMEM-1];

  initial begin : lsu_initial
    memory = '{`SIZE_DMEM{32'h0000_0000}};
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : lsu_always
    if (!rst_ni) begin
      data_rd_o = 32'h0000_0000;
      io_lcd_o  = 32'h0000_0000;
      io_ledg_o = 32'h0000_0000;
      io_ledr_o = 32'h0000_0000;
      io_hex7_o = 32'h0000_0000;
      io_hex6_o = 32'h0000_0000;
      io_hex5_o = 32'h0000_0000;
      io_hex4_o = 32'h0000_0000;
      io_hex3_o = 32'h0000_0000;
      io_hex2_o = 32'h0000_0000;
      io_hex1_o = 32'h0000_0000;
      io_hex0_o = 32'h0000_0000;
      memory    = '{`SIZE_DMEM{32'h0000_0000}};
    end else begin
      //Read
      data_rd_o = memory[addr_i/4];
      io_lcd_o  = memory[`IO_LCD];
      io_ledg_o = memory[`IO_LEDG];
      io_ledr_o = memory[`IO_LEDR];
      io_hex7_o = memory[`IO_HEX7];
      io_hex6_o = memory[`IO_HEX6];
      io_hex5_o = memory[`IO_HEX5];
      io_hex4_o = memory[`IO_HEX4];
      io_hex3_o = memory[`IO_HEX3];
      io_hex2_o = memory[`IO_HEX2];
      io_hex1_o = memory[`IO_HEX1];
      io_hex0_o = memory[`IO_HEX0];

      //Write
      memory[`IO_SW]  = io_sw_i[`VECTOR_RANGE];
      memory[`IO_KEY] = io_key_i[`VECTOR_RANGE];
      if (st_en_i) begin   
        memory[addr_i/4] = st_data_i;
      end
    end
    
    $writememh("./memory/dmem.hex", memory);

  end

endmodule
