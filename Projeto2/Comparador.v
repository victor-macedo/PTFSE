`timescale 1ns / 1ps


module Comparador(RST,Finish, hf,passnfail);
input RST,Finish;
input [7:0]hf;
output reg passnfail;

always @(Finish)
begin
    if (hf == 10010010) //Valor obtido atraves da simulacao
    passnfail <= 1;
    else
    passnfail <= 0;
end
endmodule
