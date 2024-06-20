//function compare less than unsigned
function automatic logic f_lessu;
  input logic [31:0] a, b;
  logic [32:0] tmp;
  begin
    tmp = a + ~b + 32'h0000_0001;
    f_lessu = (tmp[32] == 1'b1) ? 1'b1 : 1'b0;
  end
endfunction

//function compare less than signed
function automatic logic f_less;
input logic [31:0] a, b;
begin
    case ({a[31], b[31]})
      //a is negative, b is negative
      2'b11: f_less = f_lessu(a, b) ? `FALSE : `TRUE;
      //a is negative, b is positive
      2'b10: f_less = `TRUE;
      //a is positive, b is negative
      2'b01: f_less = `FALSE;
      //a is positive, b is positive
      2'b00: f_less = f_lessu(a, b) ? `TRUE : `FALSE;
    endcase
end
endfunction

//function shift left logical
function automatic logic [31:0] f_sll;
  input logic [31:0] num;
  input logic [4:0] shift;
  begin
    f_sll = (shift[0]) ? {  num[30:0], 1'h0     } :   num[31:0];
    f_sll = (shift[1]) ? {f_sll[29:0], 2'h0     } : f_sll[31:0];
    f_sll = (shift[2]) ? {f_sll[27:0], 4'h0     } : f_sll[31:0];
    f_sll = (shift[3]) ? {f_sll[23:0], 8'h00    } : f_sll[31:0];
    f_sll = (shift[4]) ? {f_sll[15:0], 16'h0000 } : f_sll[31:0];
  end
endfunction

//function shift right logical
function automatic logic [31:0] f_srl;
  input logic [31:0] num;
  input logic [4:0] shift;
  begin
    f_srl = (shift[0]) ? {1'h0,       num[31:1] } :   num[31:0];
    f_srl = (shift[1]) ? {2'h0,     f_srl[31:2] } : f_srl[31:0];
    f_srl = (shift[2]) ? {4'h0,     f_srl[31:4] } : f_srl[31:0];
    f_srl = (shift[3]) ? {8'h00,    f_srl[31:8] } : f_srl[31:0];
    f_srl = (shift[4]) ? {16'h0000, f_srl[31:16]} : f_srl[31:0];
  end
endfunction

//function shift right arithmetic
function automatic logic [31:0] f_sra;
  input logic [31:0] num;
  input logic [4:0] shift;
  begin
    f_sra = (shift[0]) ? {{ 1{num[31]}},   num[31:1] } :   num[31:0];
    f_sra = (shift[1]) ? {{ 2{num[31]}}, f_sra[31:2] } : f_sra[31:0];
    f_sra = (shift[2]) ? {{ 4{num[31]}}, f_sra[31:4] } : f_sra[31:0];
    f_sra = (shift[3]) ? {{ 8{num[31]}}, f_sra[31:8] } : f_sra[31:0];
    f_sra = (shift[4]) ? {{16{num[31]}}, f_sra[31:16]} : f_sra[31:0];
  end
endfunction
