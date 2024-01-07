`timescale 1ns / 100ps

module test_bench_normal;

reg clk, rst, bist_start;
wire pass_nfail, bist_end,synced_d,err_d,k, j, en;
integer idx; //index para acesso do vetor
reg [0:2] vetores[0:29];  //Vetor de 30 posicoes com 3 bits cada
assign {k,j,en} = vetores[idx];

main under_test(.CLK(clk),.RST(rst), .bist_start(bist_start),
                .in_k(k),.in_j(j),.in_en(en), .out_synced_d(synced_d),.out_sync_err_d(err_d),
                .pass_fail(pass_nfail), .bist_end(bist_end));

initial
begin  
        $readmemb("circuito05.vec", vetores);
        clk = 0;
        idx = 0;
        bist_start = 0;       
        rst = 1;        
        #600 rst = 0;        
        #10000 $finish;      
        
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


