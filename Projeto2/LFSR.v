`timescale 1ns / 1ps

module LFSR(CLK,RST,Seed,x0,x1,x2);
input CLK,RST,Seed;

output reg x0,x1,x2;

//Fibonacci  polinomio 1+x^2+x^3
always @(posedge CLK)
begin
    if (RST == 0)
    begin
        if (Seed == 0)  //Reseed
        begin
            x1 <= x2;
            x2 <= (x2 ^ x0);  
            x0 <= x1;
        end 
        else
        begin
            x1 <= x2;
            x2 <= (x0 ^ x1);  
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
