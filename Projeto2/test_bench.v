`timescale 1ns / 100ps

module Controlador;

reg clk, rst, bist_start;
wire pass_fail, BIST_END;

main under_test(.CLK(clk),.RST(rst), .bist_start(bist_start), 
                .pass_fail(pass_fail), .bist_end(BIST_END));

initial
begin  
        clk = 0;
        #0 rst = 0;         //0
        #10 rst = 1;        //10
        
end

always #50 clk=~clk;

initial
begin
    #0 bist_start = 0;       //0
    #300 bist_start = 1;     //300
    wait(BIST_END) $finish;      //10300
    $display("%b",main.scan_out );
end

endmodule