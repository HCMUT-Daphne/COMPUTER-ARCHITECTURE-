parameter VALUE_PRICE     = 7'b0010100;
parameter VALUE_NICKEL    = 7'b0000101;
parameter VALUE_DIME      = 7'b0001010;
parameter VALUE_QUARTER   = 7'b0011001;

parameter CHANGE_0_CENT   = 3'b000;
parameter CHANGE_5_CENT   = 3'b001;
parameter CHANGE_10_CENT  = 3'b010;
parameter CHANGE_15_CENT  = 3'b011;
parameter CHANGE_20_CENT  = 3'b100;

parameter ENABLE          = 1'b1;
parameter RESET           = 1'b0;

module vending_machine(
    input logic clk_i,

    input logic nickel_i,
    input logic dime_i,
    input logic quarter_i,

    output logic [2:0] change_o,
    output logic soda_o
);
    parameter STATE_STANDBY = 1'b0;
    parameter STATE_DEPOSIT = 1'b1;
    logic state_register;
    logic [6:0] money_inserted;

    always_ff @(posedge clk_i) begin : process_state
        case(state_register)
            STATE_STANDBY: begin
                soda_o = RESET;
                change_o = CHANGE_0_CENT;
                
                if (quarter_i) begin
                    money_inserted <= money_inserted + VALUE_QUARTER;
                    state_register = STATE_DEPOSIT;
                end else if (dime_i) begin
                    money_inserted <= money_inserted + VALUE_DIME;
                    state_register = STATE_DEPOSIT;
                end else if (nickel_i) begin
                    money_inserted <= money_inserted + VALUE_NICKEL;
                    state_register = STATE_DEPOSIT;
                end
            end

            STATE_DEPOSIT: begin
                if (money_inserted >= VALUE_PRICE) begin
                    case (money_inserted)
                        7'b0010100: change_o = CHANGE_0_CENT;
                        7'b0011001: change_o = CHANGE_5_CENT;
                        7'b0011110: change_o = CHANGE_10_CENT;
                        7'b0100011: change_o = CHANGE_15_CENT;
                        7'b0101000: change_o = CHANGE_20_CENT;
                    endcase

                    soda_o = ENABLE;
                    money_inserted <= 7'b0000000;
                    state_register = STATE_STANDBY;
                end else begin
                    if (quarter_i) begin
                        money_inserted <= money_inserted + VALUE_QUARTER;
                    end else if (dime_i) begin
                        money_inserted <= money_inserted + VALUE_DIME;
                    end else if (nickel_i) begin
                        money_inserted <= money_inserted + VALUE_NICKEL;
                    end
                end
            end    
        endcase
    end

endmodule
