module regfile_tb();

parameter CLK_PERIOD = 10;

logic clk_i = 0;
logic rst_ni;
logic regs_wr_en_i = 0;
logic [`VECTOR_RANGE] rd_data_i;
logic [`VECTOR_ADDR] rs1_addr_i;
logic [`VECTOR_ADDR] rs2_addr_i;
logic [`VECTOR_ADDR] rd_addr_i;

integer n;

logic [`VECTOR_RANGE] rs1_data_o;
logic [`VECTOR_RANGE] rs2_data_o;

logic [`VECTOR_RANGE] rs1_data_tc;
logic [`VECTOR_RANGE] rs2_data_tc;

regfile dut(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .regs_wr_en_i(regs_wr_en_i),
  .rd_data_i(rd_data_i),
  .rd_addr_i(rd_addr_i),
  .rs1_addr_i(rs1_addr_i),
  .rs2_addr_i(rs2_addr_i),
  .rs1_data_o(rs1_data_o),
  .rs2_data_o(rs2_data_o)
);

always #(CLK_PERIOD/ 2) clk_i <= ~clk_i;

task check();
  if ((rs1_data_o == rs1_data_tc) && (rs2_data_o == rs2_data_tc)) begin
     $display("[n=%2d] TEST PASS", n);
   end else begin
     $display("[n=%2d] TEST FAILED", n);
   end
 endtask

 initial begin 

   #0 n=0; rst_ni = 1'b0 ;rs1_addr_i = 5'b00010; rs2_addr_i = 5'b00101; #5 rs1_data_tc = 32'h0000_0000; rs2_data_tc = 32'h0000_00000; check();
 $display(" rst %b",rst_ni );
   $display(" wr %b",regs_wr_en_i );
  $display("clk %b",clk_i );
$display("rs1 %b",rs1_data_o );
$display("rs2 %b",rs2_data_o );

   #2 rst_ni = 1'b1; regs_wr_en_i = 1'b1; rd_addr_i = 5'b00010; rd_data_i = 32'hABCD_ABCD;
$display("clk %b",clk_i );
 $display(" addr %b", rd_addr_i);
 $display(" data %b", rd_data_i );

   #10 n=1; rst_ni = 1'b1; regs_wr_en_i = 1'b0;  rs1_addr_i = 5'b00010;#3 rs1_data_tc = 32'hABCD_ABCD; rs2_data_tc = 32'h0000_0000; check();
    $display("clk %b",clk_i );
 $display(" addri %b", rd_addr_i);
 $display(" rddata %b", rd_data_i );
 $display(" rs1addr %b", rs1_addr_i );
  $display(" rs1data %b", rs1_data_o );
  
#7 rst_ni = 1'b1; regs_wr_en_i = 1'b1; rd_addr_i = 5'b00101; rd_data_i = 32'hAAAA_AAAA;
#10 n = 2; rst_ni = 1'b1; regs_wr_en_i = 1'b0; rs1_addr_i = 5'b00010; rs2_addr_i = 5'b00101;#3 rs1_data_tc = 32'hABCD_ABCD; rs2_data_tc = 32'hAAAA_AAAA;  check();
$display(" rst %b",rst_ni );
 $display(" addri %b", rd_addr_i);
 $display(" rddata %b", rd_data_i );
 $display(" rs1addr %b", rs1_addr_i );
  $display(" rs1data %b", rs1_data_o );
   $display(" rs2addr %b", rs2_addr_i );
  $display(" rs2data %b", rs2_data_o );
   $finish;
 end
endmodule 