`timescale 1ns / 1ps

module LFSR(CLK,RST,Init,x0,x1,x2);
input CLK,RST,Init;

output reg x0,x1,x2;

//Fibonacci  polinomio 1+x^2+x^3
always @(posedge CLK)
begin
    if (RST == 0)
    begin
        if (Init == 0)
        begin
            x1 <= x2;
            x2 <= (x2 ^ x0);  
            x0 <= x1;
        end 
        else
        begin
            x0 <= 0;
            x1 <= 0;
            x2 <= 1;
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
