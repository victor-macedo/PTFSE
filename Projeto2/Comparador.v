`timescale 1ns / 1ps

module Comparador(CLK, RST,Finish, hf,passnfail);
input CLK,RST,Finish;
input [5:0]hf;
output reg passnfail;

always @(*)
begin
    if (Finish == 1)
    begin
        if (hf == 15'b10010011100000) //Valor obtido atraves da simulacao
        passnfail <= 1;
        else
        passnfail <= 0;
    end
end
endmodule
