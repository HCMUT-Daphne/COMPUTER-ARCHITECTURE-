
`timescale 1ns/1ps

module vending_machine_tb(input clock_tb);

	
    // Inputs
    logic clk_i;
    logic nickel_i;
    logic dime_i;
    logic quarter_i;

    // Outputs
    logic [2:0] change_o;
    logic soda_o;

// Test case variables
    logic [3:0] num_tb;
    logic [2:0] coin_i_tb;
    logic [2:0] change_o_tb;
    logic soda_o_tb;

    // Clock generation
    always begin
			#5 clk_i <= ~clk_i;
	end
    
    always @(posedge clk_i) begin
        {quarter_i, dime_i, nickel_i} = coin_i_tb;
    end

    vending_machine dut (
        .clk_i(clk_i),
        .nickel_i(nickel_i),
        .dime_i(dime_i),
        .quarter_i(quarter_i),
        .change_o(change_o),
        .soda_o(soda_o)
    );
    
    task test(
        
        input logic [2:0] change_x,
        input logic soda_x
    );

        
        assert ((change_o == change_x) && (soda_o == soda_x)) begin
            $display("TEST PASSED");
        end else begin
            $display("TEST FAILED");
        end

    endtask

    initial begin
        num_tb = 1	;
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb);
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 2	;
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb);
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b001; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 3	;
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb);
            #5; coin_i_tb = 3'b100; change_o_tb = 3'b100; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 4	;
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b000; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 5	;
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b100; change_o_tb = 3'b011; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 6	;
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 7	;
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b001; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 8	;
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b100; change_o_tb = 3'b100; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 9	;
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b100; change_o_tb = 3'b010; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb); 

        
        num_tb = 10;
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 11;
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b001; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 12;
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b001; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b100; change_o_tb = 3'b100; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb);
        
        num_tb = 13;
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb); 
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b000; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb); 
        
        num_tb = 14;
            #5; coin_i_tb = 3'b010; change_o_tb = 3'b000; soda_o_tb = 1'b0; test(change_o_tb, soda_o_tb);
            #5; coin_i_tb = 3'b100; change_o_tb = 3'b011; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb); 
        
        num_tb = 15;
            #5; coin_i_tb = 3'b100; change_o_tb = 3'b001; soda_o_tb = 1'b1; test(change_o_tb, soda_o_tb); 
    end

endmodule
