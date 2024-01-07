`timescale 1ns / 1ps

module MISR(CLK,RST,bist_end,e0,e1,e2,hf);
input CLK,RST,bist_end,e0,e1,e2;
reg h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11;
output reg [11:0] hf;

always @(posedge CLK)
begin
    if (RST == 0)
    begin
        if (bist_end == 0) 
        begin
            h0 <= h1;
            h1 <= h2;
            h2 <= h3;
            h3 <= h4;
            h4 <= h5;
            h5 <= h6;
            h6 <= h7;
            h7 <= h8;
            h8 <= h9;
            h9 <= (e2 ^ h8);
            h10 <= (e1 ^ h9);
            h11 <= (e0 ^ (h10 ^ (h9 ^ (h8 ^(h7 ^ (h6 ^(h5 ^(h4 ^(h3 ^ (h2 ^( h1 ^ h0 ))))))))))); 
            hf <= {h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11};
        end
    end    
    else
    begin
        h0 <= 1;
        h1 <= 1;
        h2 <= 1;
        h3 <= 1;
        h4 <= 1;
        h5 <= 1;
        h6 <= 1;
        h7 <= 1;
        h8 <= 1;
        h9 <= 1;
        h10 <= 1;
        h11 <= 1;
         hf <= {h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11};
        end
end
endmodule
