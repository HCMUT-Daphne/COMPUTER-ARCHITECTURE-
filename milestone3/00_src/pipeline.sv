module pipeline(
  input  logic clk_i,
  input  logic rst_ni,

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

logic br_unsigned;
logic regs_wr_en;
logic alumux1_sel;
logic alumux2_sel;
logic [3:0] alu_op;
logic lsu_wr_en;
logic lsu_rd_en;
logic [1:0] wbmux_sel;
logic [`VECTOR_RANGE] inst;


ctrl_unit control(inst,br_unsigned,regs_wr_en,alumux1_sel,alumux2_sel,lsu_wr_en,lsu_rd_en,alu_op,wbmux_sel);

data_transfer executes(clk_i,rst_ni,br_unsigned,regs_wr_en,alumux1_sel,alumux2_sel,alu_op,lsu_wr_en,lsu_rd_en,wbmux_sel,io_sw_i,io_key_i,io_lcd_o,io_ledg_o,io_ledr_o,io_hex7_o,io_hex6_o,io_hex5_o,io_hex4_o,io_hex3_o,io_hex2_o,io_hex1_o,io_hex0_o,inst);

endmodule