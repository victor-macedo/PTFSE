`timescale 1ns / 1ps

module main(CLK,RST,bist_start,bist_end,pass_fail,in_k,in_j,in_en,out_synced_d,out_sync_err_d);
input CLK,RST,bist_start,in_k,in_j,in_en;
output reg bist_end, pass_fail,out_synced_d,out_sync_err_d;
reg bist_out; //Registros para o Bist
reg circ_clk,circ_rst,circ_k,circ_j,circ_en,circ_sync,circ_err; //Registros para o circuito
reg in_x0,in_x1,in_x2; //Registro para o LFSR

circuito12 circuito (.clk(circ_clk),.rst(circ_rst),.k(circ_k),.j(circ_j),.rx_en(circ_en),.synced_d(circ_sync),.sync_err_d(circ_err));
LFSR LFSR_in (.CLK(CLK), .RST(RST), .x0(in_x0),.x1(in_x1),.x2(in_x2)); //LFSR na entrada do circuito
Bist_control(.CLK(CLK), .RESET(RST), .START(bist_start), .OUT(bist_out), .BIST_END(bist_end), .RUNNING(),.INIT(),.FINISH());//INit deve reiniciar o scan,Finish é util para saber quando fazer pass_fail

always @(*) //Mux da entrada dos dados
begin   
circ_clk <= CLK;
circ_rst <= RST;
circ_sync <= out_synced_d;
circ_err <= out_sync_err_d;  
    if  (bist_out == 0) //entrada comum do circuito
    begin
        circ_k <= in_k;
        circ_j <= in_j;
        circ_en <= in_en; 
    end    
    else    //Vetor teste como entradas
    begin
        circ_k <= in_x0;
        circ_j <= in_x1;
        circ_en <= in_x2;
    end    
end
endmodule
