module ctrl_unit (
  input  reg [`VECTOR_RANGE] inst_i,
 
  output logic br_unsigned_o,
  output logic regs_wr_en_o,
  output logic alumux1_sel_o, alumux2_sel_o,
  output logic lsu_wr_en_o,
  output logic lsu_rd_en_o,
  output reg [3:0] alu_op_o,
  output logic [1:0] wbmux_sel_o
);

  always_comb begin :control
        case ({inst_i[`OPCODE], inst_i[`FUNCT3]})
          {`B_OPCODE, 3'h6} : br_unsigned_o = `ENABLE;
          {`B_OPCODE, 3'h7} : br_unsigned_o = `ENABLE;
          default           : br_unsigned_o = `DISABLE;
        endcase

        case (inst_i[`OPCODE])
          `B_OPCODE  : alumux1_sel_o = `DATA_1;
          `J_OPCODE  : alumux1_sel_o = `DATA_1;
          default    : alumux1_sel_o = `DATA_0;
        endcase

        //ALU MUX2
        case (inst_i[`OPCODE])
          `R_OPCODE  : alumux2_sel_o = `DATA_0;
          default    : alumux2_sel_o = `DATA_1;
        endcase

        //ALU OPERATIONS
        case({inst_i[`OPCODE], inst_i[`FUNCT3]})
          {`R_OPCODE, 3'h0} : alu_op_o = (inst_i[`FUNCT7] == 7'h00) ? `ALU_ADD_OP : `ALU_SUB_OP;
          {`R_OPCODE, 3'h1} : alu_op_o = `ALU_SLL_OP;
          {`R_OPCODE, 3'h2} : alu_op_o = `ALU_SLT_OP;
          {`R_OPCODE, 3'h3} : alu_op_o = `ALU_SLTU_OP;
          {`R_OPCODE, 3'h4} : alu_op_o = `ALU_XOR_OP;
          {`R_OPCODE, 3'h5} : alu_op_o = (inst_i[`FUNCT7] == 7'h00) ? `ALU_SRL_OP : `ALU_SRA_OP;
          {`R_OPCODE, 3'h6} : alu_op_o = `ALU_OR_OP;
          {`R_OPCODE, 3'h7} : alu_op_o = `ALU_AND_OP;
          {`I_OPCODE, 3'h0} : alu_op_o = `ALU_ADD_OP;
          {`I_OPCODE, 3'h1} : alu_op_o = `ALU_SLL_OP;
          {`I_OPCODE, 3'h2} : alu_op_o = `ALU_SLT_OP;
          {`I_OPCODE, 3'h3} : alu_op_o = `ALU_SLTU_OP;
          {`I_OPCODE, 3'h4} : alu_op_o = `ALU_XOR_OP;
          {`I_OPCODE, 3'h5} : alu_op_o = (inst_i[`FUNCT7] == 7'h00) ? `ALU_SRL_OP : `ALU_SRA_OP;
          {`I_OPCODE, 3'h6} : alu_op_o = `ALU_OR_OP;
          {`I_OPCODE, 3'h7} : alu_op_o = `ALU_AND_OP;
          default           : alu_op_o = `ALU_ADD_OP;
        endcase

        lsu_wr_en_o   = (inst_i[`OPCODE] == `S_OPCODE) ? `ENABLE : `DISABLE;
        //LSU_read
        case(inst_i[`OPCODE]) 
          `IL_OPCODE : lsu_rd_en_o <= `DATA_1;
          default    : lsu_rd_en_o <= `DATA_0;
        endcase
        //Regfile Mux Select
        case (inst_i[`OPCODE])
          `IL_OPCODE : wbmux_sel_o <= `DATA_01;
          `J_OPCODE  : wbmux_sel_o <= `DATA_10;
          `IJ_OPCODE : wbmux_sel_o <= `DATA_10;
          default    : wbmux_sel_o <= `DATA_00;
        endcase

        regs_wr_en_o  = (inst_i[`OPCODE] == `S_OPCODE || inst_i[`OPCODE] == `B_OPCODE) ? `DISABLE : `ENABLE;
  end

endmodule