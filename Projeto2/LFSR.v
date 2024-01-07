`timescale 1ns / 1ps

module LFSR(CLK,RST,Seed,Poly,x0,x1,x2);
input CLK,RST,Seed,Poly;
reg x3;
output reg x0,x1,x2;

//Fibonacci  polinomio 1+x^2+x^3
always @(posedge CLK)
begin
    if (RST == 0)
    begin
        if (Poly == 0)  //Troca o polinomio
        begin
            x3 <= (x3 ^ x2);
            x2 <= x3;  
            x1 <= x2;
            x0 <= x1;
        end 
        else
        begin
            x3 <= (x2 ^ x1);  
            x2 <= x3; 
            x1 <= x2;
            x0 <= x1;
        end
        if (Seed == 1)
        begin
            x0 <= 1;
            x1 <= 1;
            x2 <= 1;
            x3 <= 1;
        end
    end    
    else
    begin
        x0 <= 0;
        x1 <= 0;
        x2 <= 0;
        x3 <= 1;
    end
end
endmodule
