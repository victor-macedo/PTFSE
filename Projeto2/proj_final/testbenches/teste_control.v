`timescale 1ns / 100ps

module Teste_Controlador;

reg clk, rst, start;
wire OUT, BIST_END, INIT, FINISH,  Seed, Poly;

Bist_control BIST_Test(clk, rst, start, OUT, BIST_END,Poly, Seed,FINISH);

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
        #25000 rst = 1 ;    //14610
        #200 rst =0;        //14810
        
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
    #5000 start = 1;    //7000
    #2000 start = 1;     //9000
    #3800 start = 1;   //12800
    #200 start = 0;     //13000
    #1000 start =1;     //14000
    #200 start = 0;     //14200
    #10000 start = 1;   //24200
    #200 start = 0;     //24400
    #10000 $finish;      //34400
end

endmodule
