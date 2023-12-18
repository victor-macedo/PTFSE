`timescale 1ns / 1ps

module main(CLK,RST,bist_start,bist_end,pass_fail,in_k,in_j,in_en,out_synced_d,out_sync_err_d);
input CLK,RST,bist_start,in_k,in_j,in_en;
output reg bist_end, pass_fail,out_synced_d,out_sync_err_d;
reg bist_out; //Registros para o Bist
reg circ_k,circ_j,circ_en; //Registros para o circuito
reg in_x0,in_x1,in_x2; //Registro para o LFSR
reg scan_out;
reg h0,h1,h2; //registros misr
reg [7:0] count; //Conferir contador do pass_fail
reg s2,s1,s0; //Registros do signature
//circuito12 circuito (.clk(CLK),.rst(RST),.k(circ_k),.j(circ_j),.rx_en(circ_en),.synced_d(out_synced_d),.sync_err_d(out_sync_err_d));
circuito12_scan(.clk(CLK),.rst(RST),.k(circ_k),.j(circ_j),.rx_en(circ_en),.synced_d(out_synced_d),.sync_err_d(out_sync_err_d), .scan_en(bist_out),
     .scan_in(x0), .scan_out(scan_out));
LFSR LFSR_in (.CLK(CLK), .RST(RST), .x0(in_x0),.x1(in_x1),.x2(in_x2)); //LFSR na entrada do circuito
Bist_control(.CLK(CLK), .RESET(RST), .START(bist_start), .OUT(bist_out), .BIST_END(bist_end), .RUNNING(),.INIT(),.FINISH());//INit deve reiniciar o scan,Finish é util para saber quando fazer pass_fail
MISR MISR(.CLK(clk),.e0(scan_out),.e1(synced_d),.e2(sync_err_d),.h0(h0),.h1(h1),.h2(h2));
//Falta signature e comparador
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

always @(*) //Comparador da saida
begin
    if (h2 & h1 & h0 != s2 & s1 & s0)
        count = count +1;    
    pass_fail = count;    
end    
endmodule
