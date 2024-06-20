module singlecycle(
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
  output logic [`VECTOR_RANGE] io_hex0_o,
  output logic [`VECTOR_RANGE] pc_debug
);

  logic [`VECTOR_RANGE] pc, nxt_pc, pc_four;
  logic [`VECTOR_RANGE] inst, operand_a, operand_b, alu_data, imm;
  logic [`VECTOR_RANGE] rs1_data, rs2_data, ld_data, wb_data;
  logic pcmux_sel, alumux1_sel, alumux2_sel;
  logic [1:0] wbmux_sel;
  logic [3:0] alu_op;
  logic pc_en, regs_wr_en, lsu_st_en;
  logic br_unsigned, br_less, br_equal;
  
  ctrl_unit control_unit(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .inst_i(inst),
    .br_equal_i(br_equal),
    .br_less_i(br_less),
    .pc_en_o(pc_en),
    .regs_wr_en_o(regs_wr_en),
    .lsu_st_en_o(lsu_st_en),
    .pcmux_sel_o(pcmux_sel),
    .alumux1_sel_o(alumux1_sel),
    .alumux2_sel_o(alumux2_sel),
    .br_unsigned_o(br_unsigned),
    .alu_op_o(alu_op),
    .wbmux_sel_o(wbmux_sel)
  );

  adder add4(
    .operand_a_i(pc),
    .operand_b_i(32'h0000_0004),
    .result_o(pc_four)
  );

  mux2input pcmux(
    .select_i(pcmux_sel),
    .input_0_i(pc_four),
    .input_1_i(alu_data),
    .output_o(nxt_pc)
  );

  pc program_counter(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .pc_en_i(pc_en),
    .pc_i(nxt_pc),
    .pc_o(pc)
  );
   
  imem instruction_memory(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .addr_i(pc),
    .inst_o(inst)
  );  

  regfile registers(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .regs_wr_en_i(regs_wr_en),
    .rs1_addr_i(inst[`RS1_ADDR]),
    .rs2_addr_i(inst[`RS2_ADDR]),
    .rd_addr_i(inst[`RD_ADDR]),
    .rd_data_i(wb_data),
    .rs1_data_o(rs1_data),
    .rs2_data_o(rs2_data)
  );

  immgen immediate_generator (
    .inst_i(inst),
    .imm_o(imm)
  );

  mux2input alumux1(
    .select_i(alumux1_sel),
    .input_0_i(rs1_data),
    .input_1_i(pc),
    .output_o(operand_a)
  );

  mux2input alumux2(
    .select_i(alumux2_sel),
    .input_0_i(rs2_data),
    .input_1_i(imm),
    .output_o(operand_b)
  );

  alu alu_m(
    .alu_op_i(alu_op),
    .operand_a_i(operand_a),
    .operand_b_i(operand_b),
    .alu_data_o(alu_data)
  );

  lsu load_store_unit(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .st_en_i(lsu_st_en),
    .st_data_i(rs2_data),
    .addr_i(alu_data),
    .data_rd_o(ld_data),

    .io_sw_i(io_sw_i),
    .io_key_i(io_key_i),
    .io_lcd_o(io_lcd_o),
    .io_ledg_o(io_ledg_o),
    .io_ledr_o(io_ledr_o),
    .io_hex7_o(io_hex7_o),
    .io_hex6_o(io_hex6_o),
    .io_hex5_o(io_hex5_o),
    .io_hex4_o(io_hex4_o),
    .io_hex3_o(io_hex3_o),
    .io_hex2_o(io_hex2_o),
    .io_hex1_o(io_hex1_o),
    .io_hex0_o(io_hex0_o)
  );

  mux4input wbmux(
    .select_i(wbmux_sel),
    .input_0_i(alu_data),
    .input_1_i(ld_data),
    .input_2_i(pc_four),
    .input_3_i(32'h0000_0000),
    .output_o(wb_data)
  );

  brcomp branch_comparator(
    .br_unsigned_i(br_unsigned),
    .rs1_data_i(rs1_data),
    .rs2_data_i(rs2_data),
    .br_equal_o(br_equal),
    .br_less_o(br_less)    
  );

  assign pc_debug       = pc;

endmodule
