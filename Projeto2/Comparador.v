`timescale 1ns / 1ps

module Comparador(CLK,Finish, hf,passnfail);
input CLK,Finish;
input [11:0]hf;
output reg passnfail;

always @(*)
begin
    if (Finish == 1)
    begin
        if (hf == 21'h151035) //Valor obtido atraves da simulacao
        passnfail <= 1;
        else
        passnfail <= 0;
    end
end
endmodule
