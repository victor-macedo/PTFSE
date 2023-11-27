`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2023 11:56:23
// Design Name: 
// Module Name: test_bench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uut;

reg clk, rst, start;
wire OUT, RUNNING, BIST_END;

main under_test(clk, rst, start, OUT, BIST_END, RUNNING);

initial
begin  
        clk = 0;
        #1rst = 1;
        #200 rst = 0;
end

always #50 clk=~clk;

initial
begin
    #200 start = 0;
    #300 start = 1;
    #200 start = 0;
    #300 start = 1;
    #200 start = 0;
    #300 start = 1;
    #200 start = 0;
    #300 start = 1;
    #200 start = 0;
    #10000 start = 1;
    #200 start = 0;
    #3000 $finish;    
end

endmodule
