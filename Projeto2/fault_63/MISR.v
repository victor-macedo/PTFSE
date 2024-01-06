`timescale 1ns / 1ps

module MISR(CLK,e0,e1,e2,hf);
input CLK,e0,e1,e2;
reg h0,h1,h2,h3,h4,h5,h6,h7;
output reg [7:0] hf;

always @(posedge CLK)
begin
    h0 <= !(e2 || h1);
    h1 <= !(e1 || h0);
    h2 <= !(e0 || !(h2 || !(h1||h0))); 
    h3 <= !(h2 || h1);
    h4 <= !(h3 || h2);
    h5 <= !(h4 || h3);
    h6 <= !(h5 || h4);
    h7 <= !(h6 || h5);
    hf <= {h7,h6,h5,h4,h3,h2, h1, h0};
end
endmodule
