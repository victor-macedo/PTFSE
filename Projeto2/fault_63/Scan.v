`timescale 1ns / 1ps

module Scan(D,Scan_in,Test_control,CLK,Q,NQ);
    input D,Scan_in,Test_control,CLK;
    output reg Q,NQ;
    reg D_ff;
    
    always @(*) //Mux de entrada
    begin
        if (Test_control == 0) 
            D_ff <= D;
        else 
            D_ff <= Scan_in;
    end
    always @(posedge CLK)
    begin
          Q <= D_ff;
          NQ <= ~D_ff;
    end     
endmodule
