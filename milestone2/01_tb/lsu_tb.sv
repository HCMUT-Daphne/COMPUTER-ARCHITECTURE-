module lsu_tb();
  
  parameter CLK_PERIOD = 10; //per nano second

  //declare variable
  logic clk_i;
  logic rst_ni;
  logic st_en_i;
  logic [`VECTOR_RANGE] st_data_i;
  logic [`VECTOR_RANGE] addr_i;
  logic [`VECTOR_RANGE] data_rd_o;

  integer n;
  logic [`VECTOR_RANGE] data_rd_tc;

  //design under test
  lsu dut(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .st_en_i(st_en_i),
    .st_data_i(st_data_i),
    .addr_i(addr_i),
    .data_rd_o(data_rd_o),
    .io_sw_i(),
    .io_lcd_o(),
    .io_ledg_o(),
    .io_ledr_o(),
    .io_hex0_o(),
    .io_hex1_o(),
    .io_hex2_o(),
    .io_hex3_o(),
    .io_hex4_o(),
    .io_hex5_o(),
    .io_hex6_o(),
    .io_hex7_o()
  );

  //clock generation
  always #(CLK_PERIOD / 2) clk_i <= ~clk_i;

  //task check
  task check();
    
    if (data_rd_o === data_rd_tc) begin
      $display("[n=%2d] test passed", n);
    end else begin
      $display("[n=%2d] TEST FAILED", n);
    end
    
  endtask

  //initial
  initial begin
    #0  n=1; rst_ni=1'b0; st_en_i=1'b0; st_data_i=32'hABCD_EFFF; addr_i=32'h0000_0001; 
      data_rd_tc=32'h0000_0000; #25 check();

    #25 n=2; rst_ni=1'b0; st_en_i=1'b1; st_data_i=32'hABCD_EFFF; addr_i=32'h0000_0001;
      data_rd_tc=32'h0000_0000; #25 check();

    #25 n=3; rst_ni=1'b1; st_en_i=1'b1; st_data_i=32'hABCD_EFFF; addr_i=32'h0000_0002;
      data_rd_tc=32'h0000_0000; #25 check();

    #25 n=4; rst_ni=1'b1; st_en_i=1'b0; st_data_i=32'h0624_B352; addr_i=32'h0000_0002;
      data_rd_tc=32'hABCD_EFFF; #25 check();

    $finish;
  end

endmodule














