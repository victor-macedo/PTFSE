`timescale 1ns / 1ps


module Comparador(RST,Bist_end, hf,passnfail);
input RST,Bist_end;
input [7:0]hf;
output reg passnfail;

always @(posedge Bist_end)
begin
    if (hf == 10010010) //Valor obtido atraves da simulacao
    passnfail <= 1;
    else
    passnfail <= 0;
end
endmodule
