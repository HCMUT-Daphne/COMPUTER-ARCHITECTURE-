module HazardDetector
    (input logic [4:0] IF_ID_Rs1,
     input logic [4:0] IF_ID_Rs2,
     input logic [4:0] ID_EX_Rd,
     input logic ID_EX_Memread,
     output logic stall
    );

    assign stall = (ID_EX_Memread) ? ((ID_EX_Rd == IF_ID_Rs1) || (ID_EX_Rd == IF_ID_Rs2)) : 0;

endmodule
