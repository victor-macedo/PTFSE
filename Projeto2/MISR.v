`timescale 1ns / 1ps

module MISR(CLK,e0,e1,e2,h0,h1,h2,hf);
input CLK,e0,e1,e2;
output reg h0,h1,h2,hf;

always @(posedge CLK)
begin
    h0 <= !(e2 || h1);
    h1 <= !(e1 || h0);
    h2 <= !(e0 || !(h2 || !(h1||h0))); 
    hf <= h2 & h1 & h;
end
endmodule
