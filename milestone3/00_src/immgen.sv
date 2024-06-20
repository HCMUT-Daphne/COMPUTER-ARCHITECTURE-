module immgen (
  input  logic [`VECTOR_RANGE] inst_i,
  output logic [`VECTOR_RANGE] imm_o
);

  always @ (inst_i) begin : immgen_always
    case (inst_i[`OPCODE])
      //I-TYPE
      `I_OPCODE: begin
        if (inst_i[`FUNCT3] == 3'h3) begin : SetLessThanImmUnsigned
          imm_o = {{20{1'b0}}, inst_i[31:20]};
        end else if (inst_i[`FUNCT3] == 3'h1 || inst_i[`FUNCT3] == 3'h5) begin : ShiftLogicalImm
          imm_o = {{20{1'b0}}, inst_i[31:20]};
        end else begin
          imm_o = {{20{inst_i[31]}}, inst_i[31:20]};
        end
      end

      //I-TYPE: LOAD
      `IL_OPCODE: begin
        if (inst_i[`FUNCT3] == 3'h4 || inst_i[`FUNCT3] == 3'h5) begin : LoadUnsigned
          imm_o = {{20{1'b0}}, inst_i[31:20]};
        end else begin
          imm_o = {{20{inst_i[31]}}, inst_i[31:20]};
        end
      end

      //I-TYPE: JUMP AND LINK logic
      `IJ_OPCODE: begin
        imm_o = {{20{inst_i[31]}}, inst_i[31:20]};
      end

      //I-TYPE: ENVIRONMENT
      `IE_OPCODE: begin
        imm_o = {{20{inst_i[31]}}, inst_i[31:20]};
      end

      //S-TYPE
      `S_OPCODE: begin
        imm_o = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
      end

      //B-TYPE
      `B_OPCODE: begin
        if (inst_i[`FUNCT3] == 3'h6 || inst_i[`FUNCT3] == 3'h7) begin : BranchUnsigned
          imm_o = {{19{1'b0}}, inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
        end else begin
          imm_o = {{19{inst_i[31]}}, inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
        end  
      end

      //J-TYPE
      `J_OPCODE: begin
        imm_o = {{11{inst_i[31]}}, inst_i[31], inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
      end

      //U-TYPE
      `UL_OPCODE, `UA_OPCODE: begin
          imm_o = {inst_i[31:12], 12'h000};
      end

      //DEFAULT
      default: imm_o = 32'h0000_0000;
    endcase
  end

endmodule