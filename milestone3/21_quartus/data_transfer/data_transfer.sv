`include "../../00_src/define.sv"
`include "../../00_src/func.sv"
`include "../../00_src/ctrl_unit.sv"
`include "../../00_src/adder.sv"
`include "../../00_src/brunit.sv"
`include "../../00_src/imem.sv"
`include "../../00_src/regfile.sv"
`include "../../00_src/immgen.sv"
`include "../../00_src/mux2input.sv"
`include "../../00_src/mux4input.sv"
`include "../../00_src/alu.sv"
`include "../../00_src/lsu.sv"
`include "../../00_src/brcomp.sv"
`include "../../00_src/HazardDetector.sv"
`include "../../00_src/branch_taken.sv"
`include "../../00_src/flipflop.sv"
`include "../../00_src/forwarding_unit.sv"
`include "../../00_src/mux4_2sel.sv"




module data_transfer
(
    input logic clk_i,rst_ni,
    input logic br_unsigned_i,
    input logic regs_wr_en_i,
    input logic alumux1_sel_i,
    input logic alumux2_sel_i,
    input logic [3:0] alu_op_i,
    input logic lsu_wr_en_i,
    input logic [1:0] wbmux_sel_i,
 
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
    output logic [`VECTOR_RANGE] inst_o
);
//IF_ID
typedef struct packed{
        logic [31:0]     Curr_Pc_o;
        logic [31:0]    Curr_Inst_o;
 } IF_ID_regs;

//ID_EX
typedef struct packed{
        logic br_unsigned_o;
        logic alumux1_sel_o;
        logic alumux2_sel_o;
        logic [3:0] alu_op_o;
        logic lsu_wr_en_o;
        logic regs_wr_en_o;
        logic [1:0] wbmux_sel_o;
        logic [`VECTOR_RANGE] Curr_Pc_o;
        logic [`VECTOR_RANGE] Rs1_data_o;
        logic [`VECTOR_RANGE] Rs2_data_o;
        logic [`VECTOR_ADDR] Rd_addr_o;
        logic [`VECTOR_RANGE] Curr_Inst_o;
} ID_EX_regs;

//EX_MEM
typedef struct packed{
        logic lsu_wr_en_o;
        logic regs_wr_en_o;
        logic [1:0] wbmux_sel_o;
        logic [`VECTOR_RANGE] Pc_4;
        logic [`VECTOR_RANGE] Alu_data_o;
        logic [`VECTOR_RANGE] Rs2_data_o;
        logic [`VECTOR_ADDR] Rd_addr_o;
} EX_MEM_regs;

//MEM_RB
typedef struct packed{
        logic regs_wr_en_o;
        logic [1:0] wbmux_sel_o;
        logic [`VECTOR_RANGE] Pc_4;
        logic [`VECTOR_RANGE] Alu_data_o;
        logic [`VECTOR_RANGE] lsu_data_o;
        logic [`VECTOR_ADDR] Rd_addr_o;
} MEM_WB_regs;    

IF_ID_regs A;
ID_EX_regs B;
EX_MEM_regs C;
MEM_WB_regs D;

logic [`VECTOR_RANGE] Pc, Pc_plus4, Next_pc;
logic [`VECTOR_RANGE] Alu_data, Inst, Rs1_data, Rs2_data, Rd_data;
logic Stall;
logic [1:0] fw_alumux1_sel; 
logic [1:0] fw_alumux2_sel;
logic br_less, br_equal;

logic [`VECTOR_RANGE] Pc_1, Pc_2, Pc_3;
assign Pc_3 = B.Curr_Pc_o+4;
logic pcmux_sel, check;
logic [`VECTOR_RANGE] Pc_taken;
adder Pcadd(Pc_2,32'h0000_0004, Pc_plus4);
mux2input taken_mux(Pc,Pc_taken,pcmux_sel,Pc_2);
mux2input taken_mux1(Pc,Pc_taken,pcmux_sel,Pc_1);
mux2input taken_mux2(Pc_plus4,Pc_3,check,Next_pc);
flipflop  Pc_regs(clk_i,rst_ni,Next_pc, Stall, Pc);

//imem
imem InstMem(clk_i,rst_ni,Pc_1,Inst);

//IF_ID_regs A
always_ff @(posedge clk_i)
begin
    if ((!rst_ni) || (check))
    begin 
        A.Curr_Pc_o <= 0;
        A.Curr_Inst_o <= 0;
    end
    else if (!Stall && !check)
    begin 
        A.Curr_Pc_o <= Pc_1;
        A.Curr_Inst_o <= Inst;
    end
end

logic [`VECTOR_RANGE] imm_A;

immgen A_imm(A.Curr_Inst_o,imm_A);
branch_taken A_Taken(A.Curr_Inst_o[`OPCODE],A.Curr_Pc_o,Rs1_data,Alu_data,C.Alu_data_o,A.Curr_Inst_o[19:15],B.Rd_addr_o,C.Rd_addr_o,B.regs_wr_en_o,C.regs_wr_en_o,imm,pcmux_sel,Pc_taken);


//HazardDetector
HazardDetector detect(A.Curr_Inst_o[19:15],A.Curr_Inst_o[24:20],B.Rd_addr_o,!B.lsu_wr_en_o,Stall);

//PC update
assign inst_o = A.Curr_Inst_o;

//Regfiles
regfile Regfile(clk_i,rst_ni,D.regs_wr_en_o, D.Rd_addr_o, A.Curr_Inst_o[19:15], A.Curr_Inst_o[24:20],Rd_data,Rs1_data,Rs2_data);

// ID_EX_regs B 
always_ff @(posedge clk_i)
begin
    if ((!rst_ni) || (Stall) || (check))
    begin 
         B.br_unsigned_o <= 0;
         B.alumux1_sel_o <= 0;
         B.alumux2_sel_o <= 0;
         B.alu_op_o <= 0;
         B.lsu_wr_en_o <= 0;
         B.regs_wr_en_o <= 0;
         B.wbmux_sel_o <= 0;
         B.Curr_Pc_o <= 0;
         B.Rs1_data_o <= 0;
         B.Rs2_data_o <= 0;
         B.Rd_addr_o <= 0;
         B.Curr_Inst_o <= 0;
    end
    else
    begin
         B.br_unsigned_o <= br_unsigned_i;
         B.alumux1_sel_o <= alumux1_sel_i;
         B.alumux2_sel_o <= alumux2_sel_i;
         B.alu_op_o <= alu_op_i;
         B.lsu_wr_en_o <= lsu_wr_en_i;
         B.regs_wr_en_o <= regs_wr_en_i;
         B.wbmux_sel_o <= wbmux_sel_i;
         B.Curr_Pc_o <= A.Curr_Pc_o;
         B.Rs1_data_o <= Rs1_data;
         B.Rs2_data_o <= Rs2_data;
         B.Rd_addr_o <= A.Curr_Inst_o[11:7];
         B.Curr_Inst_o <= A.Curr_Inst_o;
    end
end

//Forwarding 
forwarding_unit forward(B.Curr_Inst_o[19:15],B.Curr_Inst_o[24:20],C.Rd_addr_o,D.Rd_addr_o,C.regs_wr_en_o,D.regs_wr_en_o,fw_alumux1_sel,fw_alumux2_sel);

//Brand Check
logic[`VECTOR_RANGE] brand_a,brand_b;
mux4input branda(B.Rs1_data_o, Rd_data, C.Alu_data_o, B.Rs1_data_o, alumux1_sel_i, brand_a);
mux4input brandb(B.Rs2_data_o, Rd_data, C.Alu_data_o, B.Rs2_data_o, alumux2_sel_i, brand_b);
brcomp brc(brand_a,brand_b, B.br_unsigned_o, br_equal, br_less);
brunit bru(br_less, br_equal, B.Curr_Inst_o, check);

logic [`VECTOR_RANGE] data2;
mux4input Data2(B.Rs2_data_o,Rd_data,C.Alu_data_o,B.Rs2_data_o,alumux2_sel,data2);

//ALU
logic [`VECTOR_RANGE] imm_B;
immgen B_imm(B.Curr_Inst_o,imm_B);
logic [`VECTOR_RANGE] operand_a, operand_b;
mux4_2sel  oper_a(B.Rs1_data_o,Rd_data,C.Alu_data_o,B.Curr_Pc_o,B.alumux1_sel_o,fw_alumux1_sel,operand_a);
mux4_2sel  oper_b(B.Rs2_data_o,Rd_data,C.Alu_data_o,imm_B,B.alumux2_sel_o,fw_alumux2_sel,operand_b);
alu alu(operand_a,operand_b,B.alu_op_o,Alu_data);

//EX_MEM_regs C;
always_ff @(posedge clk_i)
begin
    if(!rst_ni)
    begin
        C.lsu_wr_en_o<= 0;
        C.regs_wr_en_o<= 0;
        C.wbmux_sel_o<= 0;
        C.Pc_4<= 0;
        C.Alu_data_o<= 0;
        C.Rs2_data_o<= 0;
        C.Rd_addr_o<= 0;
    end
    else
    begin
        C.lsu_wr_en_o<= B.lsu_wr_en_o;
        C.regs_wr_en_o<= B.regs_wr_en_o;
        C.wbmux_sel_o<= B.wbmux_sel_o;
        C.Pc_4<= B.Curr_Pc_o + 4;
        C.Alu_data_o<= Alu_data ;
        C.Rs2_data_o<= data2;
        C.Rd_addr_o<= B.Rd_addr_o;
    end
end

//lsu
logic[`VECTOR_RANGE] data_lsu;
lsu Data_LSU(clk_i,rst_ni,C.lsu_wr_en_o,C.Rs2_data_o,C.Alu_data_o,data_lsu,io_sw_i,io_key_i,io_lcd_o,io_ledg_o,io_ledr_o,io_hex7_o,io_hex6_o,io_hex5_o,io_hex4_o,io_hex3_o,io_hex2_o,io_hex1_o,io_hex0_o);

//MEM_WB_regs D
always_ff @(posedge clk_i)
begin 
    if(!rst_ni)
    begin
        D.regs_wr_en_o<=0;
        D.wbmux_sel_o<=0;
        D.Pc_4<=0;
        D.Alu_data_o<=0;
        D.lsu_data_o<=0;
        D.Rd_addr_o<=0;
    end
    else
    begin
        D.regs_wr_en_o<=C.regs_wr_en_o;
        D.wbmux_sel_o<=C.wbmux_sel_o;
        D.Pc_4<=C.Pc_4;
        D.Alu_data_o<=C.Alu_data_o;
        D.lsu_data_o<=data_lsu;
        D.Rd_addr_o<=C.Rd_addr_o;
    end
end

mux4input muxdata(D.Alu_data_o,D.lsu_data_o,D.Pc_4,D.Alu_data_o,D.wbmux_sel_o,Rd_data);

endmodule