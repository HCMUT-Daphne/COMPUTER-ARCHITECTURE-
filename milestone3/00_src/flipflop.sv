module flipflop
    (
     input logic clk_i, rst_ni,
     input logic [31:0] d,
     input logic stall,

     output logic [31:0] q
    );

    always_ff @(posedge clk_i)
    begin
        if (!rst_ni) q <= 0;
        else if (!stall) q<=d;
    end        
endmodule : flipflop
