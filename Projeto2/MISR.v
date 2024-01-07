`timescale 1ns / 1ps

module MISR(CLK,e0,e1,e2,hf);
input CLK,e0,e1,e2;
reg h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14,h15,h16,h17,h18,h19,h20;
output reg [20:0] hf;

always @(posedge CLK)
begin
    h0 <= !(e2 || h1);
    h1 <= !(e1 || h0); 
    h2 <= !(e0 || !(h2 || !(h1||h0))); 
//    h3 <= !(h2 || h1);
//    h4 <= !(h3 || h2);
//    h5 <= !(h4 || h3);
//    h6 <= !(h5 || h4);
//    h7 <= !(h6 || h5);
//    h8 <= !(h7 || h6);
//    h9 <= !(h8 || h7); 
//    h10 <= !(h9 || h10);
//    h11 <= !(h10 || h9);
//    h12 <= !(h11 || h10);
//    h13 <= !(h12 || h11);
//    h14 <= !(h13 || h12);
//    h15 <= !(h14 || h11); 
//    h16 <= !(h15 || h12);
//    h17 <= !(h16 || h13);
//    h18 <= !(h17 || h14);
//    h19 <= !(h18 || h15);
//    h20 <= !(h19 || h16);
    hf <= {h0,h1,h2};
end
endmodule
