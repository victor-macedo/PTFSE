`timescale 1ns / 1ps

module main(CLK,RST,bist_start,bist_end,pass_fail,in_k,in_j,in_en,out_synced_d,out_sync_err_d);
input CLK,RST,bist_start,in_k,in_j,in_en;
output reg pass_fail;
output wire bist_end, out_synced_d, out_sync_err_d;
wire bist_out; //Registros para o Bist
reg circ_k,circ_j,circ_en; //Registros para o circuito
wire in_x0,in_x1,in_x2,scan_x; //Registro para o LFSR
wire scan_out,Finish,Seed;
wire [11:0] hf;
//circuito12 circuito (.clk(CLK),.rst(RST),.k(circ_k),.j(circ_j),.rx_en(circ_en),.synced_d(out_synced_d),.sync_err_d(out_sync_err_d));
circuito12 circuito_scan(.clk(CLK),.rst(RST),.k(circ_k),.j(circ_j),.rx_en(circ_en),.synced_d(out_synced_d),.sync_err_d(out_sync_err_d), .scan_en(bist_out),
     .scan_in(scan_x), .scan_out(scan_out));
LFSR LFSR_in (.CLK(CLK), .RST(RST),.Seed(Seed),.x0(in_x0),.x1(in_x1),.x2(in_x2)); //LFSR na entrada do circuito
LFSR LFSR_in2 (.CLK(CLK), .RST(RST),.Seed(!Seed),.x0(scan_x));  //Inverte o o polinomio para ser diferente
Bist_control Bist(.CLK(CLK), .RESET(RST), .START(bist_start), .OUT(bist_out), .BIST_END(bist_end),.Seed(Seed),.FINISH(Finish));//INit deve reiniciar o scan,Finish � util para saber quando fazer pass_fail
MISR MISR(.CLK(CLK), .RST(RST),.bist_end(bist_end),.e0(scan_out),.e1(out_synced_d),.e2(out_sync_err_d),.hf(hf));
Comparador Comp(.CLK(CLK),.Finish(Finish), .hf(hf),.passnfail(pass_fail));
always @(*) //Mux da entrada dos dados
begin    
    if  (bist_out == 0) //entrada comum do circuito
    begin
        circ_k = in_k;
        circ_j = in_j;
        circ_en = in_en; 
    end    
    else    //Vetor teste como entradas
    begin
        circ_k = in_x0;
        circ_j = in_x1;
        circ_en = in_x2;
    end    
end
endmodule
