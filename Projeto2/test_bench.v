`timescale 1ns / 100ps

module Controlador;

reg clk, rst, bist_start;
wire out_synced_d, out_sync_err_d, bist_end;

main main(clk,rst,bist_start,bist_end,pass_fail,in_k,in_j,in_en,out_synced_d,out_sync_err_d);

initial
begin  
	bist_start = 0;
	clk = 0;
	rst = 1;
    #200 rst = 0;
    #200 bist_start = 1;     //300
    wait(bist_end == 1);
    #400 $finish;      //34400
end

always #50 clk=~clk;

endmodule
