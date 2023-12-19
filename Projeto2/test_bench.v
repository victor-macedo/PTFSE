`timescale 1ns / 100ps

module Controlador;

reg clk, rst, bist_start;
wire out_synced_d, out_sync_err_d;

main main(CLK,RST,bist_start,bist_end,pass_fail,in_k,in_j,in_en,out_synced_d,out_sync_err_d);

initial
begin  
        clk = 0;
        
end

always #50 clk=~clk;

initial
begin
    #0 bist_start = 0;       //0
    #100 bist_start = 1;     //300
    #100000 $finish;      //34400
end

endmodule