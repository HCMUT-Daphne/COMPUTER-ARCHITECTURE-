module brunit
(
    //input
    input logic br_less_i, br_equal_i,
    input logic [`VECTOR_RANGE] inst_i,


    //output
    output logic pcmux_sel_o

);

  always_comb begin
    casex ({inst_i[`OPCODE], inst_i[`FUNCT3]})
          {`B_OPCODE,  3'b000}  : pcmux_sel_o <= (br_equal_i)  ? `DATA_0 : `DATA_1; //beq
          {`B_OPCODE,  3'b001}  : pcmux_sel_o <= (!br_equal_i) ? `DATA_0 : `DATA_1; //bne
          {`B_OPCODE,  3'b1x0}  : pcmux_sel_o <= (br_less_i)   ? `DATA_0 : `DATA_1; //blt bltu
          {`B_OPCODE,  3'b1x1}  : pcmux_sel_o <= (!br_less_i)  ? `DATA_0 : `DATA_1; //bge bgeu
          {`J_OPCODE,  3'bxxx}  : pcmux_sel_o <= `DATA_0;
          {`IJ_OPCODE, 3'b000}  : pcmux_sel_o <= `DATA_0;
          default               : pcmux_sel_o <= `DATA_0;
        endcase
  end
endmodule
