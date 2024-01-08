`timescale 1ns / 100ps

module test_bench_normal;

reg clk, rst;
wire synced_d,err_d,k, j, en;
integer idx; //index para acesso do vetor
reg [0:2] vetores[0:29];  //Vetor de 30 posicoes com 3 bits cada
assign {k,j,en} = vetores[idx];

circuito12 under_test(.clk(clk),.rst(rst),.k(k),.j(j),.rx_en(en),
                         .synced_d(synced_d),.sync_err_d(err_d));

initial
begin  
        $readmemb("circuito12.vec", vetores);
        clk = 0;
        idx = 0;      
        rst = 1;        
        #60000 rst = 0;        
    
        
end

always @(posedge clk)
begin
    idx = idx + 1; //Incrementa o index todo clock
end

always #10000 clk=~clk;
initial
begin
  wait(idx > 30)   //Finzaliza ao chegar no ultimo vetor
  $finish;
end
endmodule


