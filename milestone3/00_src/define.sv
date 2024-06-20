`define WIDTH           32

`define FILE_INST_HEX   "../00_src/code/app/abc.hex"
`define SIZE_IMEM       2048
`define SIZE_REGS       32
`define SIZE_DMEM       256

`define VECTOR_RANGE    31:0
`define VECTOR_ADDR     4:0

`define OPCODE          6:0
`define RD_ADDR         11:7
`define FUNCT3          14:12
`define RS1_ADDR        19:15
`define RS2_ADDR        24:20
`define FUNCT7          31:25
`define IMM             31:20

`define ENABLE          1'b1
`define DISABLE         1'b0

`define TRUE            1'b1
`define FALSE           1'b0

`define DATA_0          1'b0
`define DATA_1          1'b1

`define DATA_00         2'b00
`define DATA_01         2'b01
`define DATA_10         2'b10
`define DATA_11         2'b11

`define R_OPCODE        7'b0110011
`define I_OPCODE        7'b0010011
`define IL_OPCODE       7'b0000011
`define IJ_OPCODE       7'b1100111
`define IE_OPCODE       7'b1110011
`define S_OPCODE        7'b0100011
`define B_OPCODE        7'b1100011
`define J_OPCODE        7'b1101111
`define UL_OPCODE       7'b0110111
`define UA_OPCODE       7'b0010111

`define ALU_ADD_OP      4'b0000
`define ALU_SUB_OP      4'b0001
`define ALU_XOR_OP      4'b0010
`define ALU_OR_OP       4'b0011
`define ALU_AND_OP      4'b0100
`define ALU_SLL_OP      4'b0101
`define ALU_SRL_OP      4'b0110
`define ALU_SRA_OP      4'b0111
`define ALU_SLT_OP      4'b1000
`define ALU_SLTU_OP     4'b1001
`define ALU_UI_OP       4'b1010

//`define IO_SW           12'h900
//`define IO_LCD          12'h8a0
//`define IO_LEDG         12'h890
//`define IO_LEDR         12'h880
//`define IO_HEX7         12'h870
//`define IO_HEX6         12'h860
//`define IO_HEX5         12'h850
//`define IO_HEX4         12'h840
//`define IO_HEX3         12'h830
//`define IO_HEX2         12'h820
//`define IO_HEX1         12'h810
//`define IO_HEX0         12'h800

`define IO_SW           8'h90
`define IO_KEY          8'h8f
`define IO_LCD          8'h8a
`define IO_LEDG         8'h89
`define IO_LEDR         8'h88
`define IO_HEX7         8'h87
`define IO_HEX6         8'h86
`define IO_HEX5         8'h85
`define IO_HEX4         8'h84
`define IO_HEX3         8'h83
`define IO_HEX2         8'h82
`define IO_HEX1         8'h81
`define IO_HEX0         8'h80