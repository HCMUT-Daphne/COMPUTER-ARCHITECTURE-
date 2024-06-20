`include "../00_src/define.sv"
`include "../00_src/func.sv"
`include "../00_src/ctrl_unit.sv"
`include "../00_src/adder.sv"
`include "../00_src/brunit.sv"
`include "../00_src/imem.sv"
`include "../00_src/regfile.sv"
`include "../00_src/immgen.sv"
`include "../00_src/mux2input.sv"
`include "../00_src/mux4input.sv"
`include "../00_src/alu.sv"
`include "../00_src/lsu.sv"
`include "../00_src/brcomp.sv"
`include "../00_src/pipeline.sv"
`include "../00_src/HazardDetector.sv"
`include "../00_src/branch_taken.sv"
`include "../00_src/data_transfer.sv"
`include "../00_src/flipflop.sv"
`include "../00_src/forwarding_unit.sv"
`include "../00_src/mux4_2sel.sv"


module wrapper (
  input  logic CLOCK_50,
  
  input  logic [3:0]  KEY,
  input  logic [17:0] SW,
  output logic [16:0] LEDR,
  output logic [7:0]  LEDG, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, LCD_DATA, 
  output logic LCD_RW, LCD_EN, LCD_RS, LCD_ON, LCD_BLON
);
	
  logic [`VECTOR_RANGE] io_sw, io_key, io_lcd, io_ledr, io_ledg;
  logic [`VECTOR_RANGE] io_hex7, io_hex6, io_hex5, io_hex4, io_hex3, io_hex2, io_hex1, io_hex0;

  
  //BEBOUNCE_RESET_BEGIN
  logic [`VECTOR_RANGE] counter;
  logic reset_n;
  initial begin
    counter <= 32'h0;
	 reset_n <= 1'b1;
  end
  always_ff @(posedge CLOCK_50) begin
	counter <= (SW[17]) ? counter + 32'h1 : 32'h0;
	reset_n <= (counter < 32'h500000) ? 1'b1 : 1'b0;
  end
  //BEBOUNCE_RESET_END
  
  
  
  always_ff @(posedge CLOCK_50) begin
    io_sw 				= {15'h0, SW[16:0]};
	 io_key				= {28'h0, KEY[3:0]};
	 
	  LEDR[16:0] 		= io_ledr[16:0];
	  LEDG[7:0]			= io_ledg[7:0];
	 
	  HEX7[7:0]			= io_hex7[7:0];
	  HEX6[7:0]			= io_hex6[7:0];
	  HEX5[7:0]			= io_hex5[7:0];
	  HEX4[7:0]			= io_hex4[7:0];
	  HEX3[7:0]			= io_hex3[7:0];
	  HEX2[7:0]			= io_hex2[7:0];
	  HEX1[7:0]			= io_hex1[7:0];
	  HEX0[7:0]			= io_hex0[7:0];
	 
	  LCD_ON				= io_lcd[31];
	  LCD_EN				= io_lcd[10];
	  LCD_RS				= io_lcd[9];
	  LCD_RW				= io_lcd[8];
	 
	  LCD_DATA[7:0]  	= io_lcd[7:0];

	 
  end
  
  pipeline wrapper(
    .clk_i				(CLOCK_50),
	 .rst_ni				(reset_n),
	 .io_sw_i			(io_sw),
	 .io_key_i			(io_key),
	 .io_lcd_o			(io_lcd),
	 .io_ledg_o			(ledg),
	 .io_ledr_o			(ledr),
	 .io_hex7_o			(io_hex7),
	 .io_hex6_o			(io_hex6),
	 .io_hex5_o			(io_hex5),
	 .io_hex4_o			(io_hex4),
	 .io_hex3_o			(io_hex3),
	 .io_hex2_o			(io_hex2),
	 .io_hex1_o			(io_hex1),
	 .io_hex0_o			(io_hex0)
 	);	
endmodule