`timescale 1ns / 1ps

module MISR(CLK,RST,bist_end,e0,e1,e2,hf);
input CLK,RST,bist_end,e0,e1,e2;
reg h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14,h15,h16,h17,h18,h19,h20,h21,h22,h23 ;
output reg [23:0] hf;

always @(posedge CLK)
begin
    if (RST == 0)
    begin
    
        if (bist_end == 0) 
        begin
        h0 <= h1;
        h1 <= (h2^h1);
        h2 <= (h3^h3);
        h3 <= (h4^h0);
        h4 <= (h5^h7);
        h5 <= (h6^h2);
        h6 <= (h7^h14);
        h7 <= (h8^h3);
        h8 <= (h9^h10);
        h9 <= (h10^h6);
        h10 <= (h11^h17);
        h11 <= (h12^h8);
        h12 <= (h13^h5);
        h13 <= (h14^h7);
        h14 <= (h15^h9);
        h15 <= (h16^h13); 
        h16 <= (h17^h11);
        h17 <= (h18^h15);
        h18 <= (h19^h12);
        h19 <= (h20^h17);
        h20 <= (h21^h0);    
        h21 <= (e2 ^ h20);
        h22 <= (e1 ^ h21);
        h23 <= (e0 ^ (h22^(h21^(h20^(h19^ (h18^(h17^(h16^(h15^(h14^(h13^(h12^(h11^(h10 ^ (h9 ^ (h8 ^(h7 ^ (h6 ^(h5 ^(h4 ^(h3 ^ (h2 ^( h1 ^ h0 ))))))))))))))))))))))); 

        hf <= {h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14,h15,h16,h17,h18,h19,h20,h21,h22,h23};
        end
    end
    else if (RST == 1)
    begin
    h0 <= 1;
        h1 <= 0;
        h2 <= 1;
        h3 <= 1;
        h4 <= 1;
        h5 <= 0;
        h6 <= 1;
        h7 <= 1;
        h8 <= 0;
        h9 <= 1;
        h10 <= 1;
        h11 <= 1;
        h12 <= 0;
        h13 <= 1;
        h14 <= 1;
        h15 <= 0; 
        h16 <= 1;
        h17 <= 1;    
        h18 <= 0;
        h19 <= 1;
        h20 <= 1;
        h21 <= 0;
        h22 <= 0;
        h23 <= 1;

        hf <= {h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14,h15,h16,h17,h18,h19,h20,h21,h22,h23}; 
        end
end
endmodule

