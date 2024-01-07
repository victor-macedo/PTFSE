`timescale 1ns / 1ps

module MISR(CLK,e0,e1,e2,hf, bist_end);
input CLK,e0,e1,e2, bist_end;
reg h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11  ;
output reg [11:0] hf;

always @(posedge CLK)
begin
    if(bist_end == 0)
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
    	h9 <= !(e2 || h8);
    	h10 <= !(e1 || h9);
    	h11 <= !(e0 ||  !(h10 || !(h9 || !(h8 || !(h7 || !(h6 || !(h5 || !(h4 || !(h3 || !(h2 || !(h1 ||h0 ))))))))))); 

//    h0 <= !(e2 || h1);
//    h1 <= !(e1 || h0); 
//    h2 <= !(e0 || !(h2 || !(h1||h0))); 
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
    	hf <= {h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11};
	end
end
endmodule