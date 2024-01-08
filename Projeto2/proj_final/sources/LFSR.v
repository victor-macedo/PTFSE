`timescale 1ns / 1ps

module LFSR(CLK,RST,Poly,x0,x1,x2);
input CLK,RST,Poly;
output reg x0,x1,x2;

//Fibonacci  polinomio 1+x^2+x^3
always @(posedge CLK)
begin
    if (RST == 0)
    begin
        if (Poly == 0)  //Troca o polinomio
        begin
            x2 <= (x2 ^ x0);  
            x1 <= x2;
            x0 <= x1;
        end 
        else
        begin  
            x2 <= (x1 ^ x0); 
            x1 <= x2;
            x0 <= x1;
        end
    end    
    else
    begin
        x0 <= 1;
        x1 <= 1;
        x2 <= 1;
    end
end
endmodule
