`timescale 1ns / 1ps

module MISR(CLK,RST,bist_end,e0,e1,e2,hf);
input CLK,RST,bist_end,e0,e1,e2;
reg h0,h1,h2,h3,h4,h5,h6,h7;
output reg [7:0] hf;

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
        h5 <= (e2 ^ h4);
        h6 <= (e1 ^ h5);
        h7 <= (e0 ^ (h6 ^(h5 ^(h4 ^(h3 ^ (h2 ^( h1 ^ h0 ))))))); 

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
	end

        hf <= {h0,h1,h2,h3,h4,h5,h6,h7}; 
end
endmodule

