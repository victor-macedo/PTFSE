`timescale 1ns / 100ps

module uut;

reg clk, rst, start;
wire OUT, RUNNING, BIST_END;

main under_test(clk, rst, start, OUT, BIST_END, RUNNING);

initial
begin  
        clk = 0;
        #0 rst = 0;         //0
        #10 rst = 1;        //10
        #200 rst = 0;       //210
        #4000 rst = 1;      //4210
        #200 rst = 0;       //4410
        #7500 rst =1;       //11910
        #200 rst =0;        //12110
        
end

always #50 clk=~clk;

initial
begin
    #0 start = 0;       //0
    #300 start = 1;     //300
    #200 start = 0;     //500
    #300 start = 1;     //800
    #200 start = 0;     //1000
    #300 start = 1;     //1300
    #200 start = 0;     //1500
    #300 start = 1;     //1800
    #200 start = 0;     //2000
    #5000 start = 1;    //11000
    #2000 start = 1;     //11200
    #3800 start = 1;   //12000
    #200 start = 0;     //12200
    #1000 start =1;
    #200 start = 0;
    #30000 $finish;      //15200
end

endmodule