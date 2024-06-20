module ctrl_unit (
  input  logic clk_i,
  input  logic rst_ni,
   
  input  reg [`VECTOR_RANGE] inst_i,
  input  logic br_equal_i, br_less_i,

  output logic pc_en_o, regs_wr_en_o, lsu_st_en_o,
  output logic pcmux_sel_o, alumux1_sel_o, alumux2_sel_o, br_unsigned_o,
  output reg [3:0] alu_op_o,
  output logic [1:0] wbmux_sel_o
);

  parameter ST_FETCH     = 3'h1;
  parameter ST_DECODE    = 3'h2;
  parameter ST_EXECUTE   = 3'h3;
  parameter ST_MEMORY    = 3'h4;
  parameter ST_WRITEBACK = 3'h5;
 
  reg [2:0] stage, next_stage;

  always_ff @(posedge clk_i or negedge rst_ni) begin : ctrl_always_1
    if (!rst_ni) begin
      stage <= ST_FETCH;
    end else begin
      stage <= next_stage;
    end
  end

  always @(*) begin : ctrl_always_2
    case (stage)
      ST_FETCH: begin
        

        pc_en_o       <= `DISABLE;
        regs_wr_en_o  = `DISABLE;
        br_unsigned_o = `DISABLE;
        lsu_st_en_o   = `DISABLE;
        
        next_stage    = ST_DECODE;
      end

      ST_DECODE: begin
        pc_en_o       <= `DISABLE;
        regs_wr_en_o  = `DISABLE;
        case ({inst_i[`OPCODE], inst_i[`FUNCT3]})
          {`B_OPCODE, 3'h6} : br_unsigned_o = `ENABLE;
          {`B_OPCODE, 3'h7} : br_unsigned_o = `ENABLE;
          default           : br_unsigned_o = `DISABLE;
        endcase
        lsu_st_en_o   = `DISABLE;

        next_stage    = ST_EXECUTE;
      end

      ST_EXECUTE: begin
        // ALU MUX1
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

        pc_en_o       <= `DISABLE;
        regs_wr_en_o  = `DISABLE;
        br_unsigned_o = `DISABLE;
        lsu_st_en_o   = `DISABLE;

        next_stage    = ST_MEMORY;
      end

      ST_MEMORY: begin
        pc_en_o       <= `DISABLE;
        regs_wr_en_o  = `DISABLE;
        br_unsigned_o = `DISABLE;
        //Enable Store
        lsu_st_en_o   = (inst_i[`OPCODE] == `S_OPCODE) ? `ENABLE : `DISABLE;

        //Regfile Mux Select
        case (inst_i[`OPCODE])
          `IL_OPCODE : wbmux_sel_o <= `DATA_01;
          `J_OPCODE  : wbmux_sel_o <= `DATA_10;
          `IJ_OPCODE : wbmux_sel_o <= `DATA_10;
          default    : wbmux_sel_o <= `DATA_00;
        endcase

        next_stage    = ST_WRITEBACK;
      end

      ST_WRITEBACK: begin
        


        pc_en_o       <= `ENABLE;
        regs_wr_en_o  = (inst_i[`OPCODE] == `S_OPCODE || inst_i[`OPCODE] == `B_OPCODE) ? `DISABLE : `ENABLE;
        br_unsigned_o = `DISABLE;
        lsu_st_en_o   = `DISABLE;

        // CONTROL MUX TO PC
        casex ({inst_i[`OPCODE], inst_i[`FUNCT3]})
          {`B_OPCODE,  3'b000}  : pcmux_sel_o <= (br_equal_i)  ? `DATA_1 : `DATA_0; //beq
          {`B_OPCODE,  3'b001}  : pcmux_sel_o <= (!br_equal_i) ? `DATA_1 : `DATA_0; //bne
          {`B_OPCODE,  3'b1x0}  : pcmux_sel_o <= (br_less_i)   ? `DATA_1 : `DATA_0; //blt bltu
          {`B_OPCODE,  3'b1x1}  : pcmux_sel_o <= (!br_less_i)  ? `DATA_1 : `DATA_0; //bge bgeu
          {`J_OPCODE,  3'bxxx}  : pcmux_sel_o <= `DATA_1;
          {`IJ_OPCODE, 3'b000}  : pcmux_sel_o <= `DATA_1;
          default               : pcmux_sel_o <= `DATA_0;
        endcase

        next_stage = ST_FETCH;
      end   
       
      default: next_stage = ST_FETCH;
    endcase
  end

endmodule
