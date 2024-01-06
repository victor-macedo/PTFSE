`timescale 1ns / 100ps

module main_test_bench;

reg clk, rst, bist_start, k, j, en;
wire pass_nfail, bist_end,synced_d,err_d;

main under_test(.CLK(clk),.RST(rst), .bist_start(bist_start),
                .in_k(k),.in_j(j),.in_en(en), .out_synced_d(synced_d),.out_sync_err_d(err_d),
                .pass_fail(pass_nfail), .bist_end(bist_end));

initial
begin  
        clk = 0;
        k = 0;
        j= 0;
        en =0;
        #0 rst = 0;         //0
        #40 rst = 1;        //10
        #80 rst = 0;        //90
        
end

always #50 clk=~clk;

initial
begin
    #0 bist_start = 0;       //0
    #300 bist_start = 1;     //300
    #300 bist_start = 0;
    wait(bist_end) 
    #600
    $finish;      //10300
end

endmodule


