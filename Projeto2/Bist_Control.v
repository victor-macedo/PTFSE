`timescale 1ns / 100ps

module Bist_control(CLK, RESET, START, OUT, BIST_END, RUNNING,Seed,FINISH);
   input CLK,RESET,START;
   output reg OUT,BIST_END,RUNNING,Seed,FINISH;
   //É bom adicionar 2 sinais, um antes do running e outro antes do bist_end (Init e fisish)
   reg [7:0] count; //deve contar ate 89 = (N+1)*(M+1)-1 = (9+1)*(8+1) 
   reg [3:0] count_N, count_M;
   
   // state flip-flops;
   reg [2:0] state, next_state;
 
   // state coding
   localparam [2:0] IDLE=0, S0=1, S1=2, S2=3, S3=4, S4=5,S5=6;
   localparam [4:0] N=9, M=9;
    

    always @(posedge CLK or posedge RESET)
       begin
           if (RESET == 1'b1)
            begin    
              state <= IDLE;  
              count_N <=0;
              count_M <=0;
            end
            else begin
               state <= next_state;
               if(count_M==M)
               begin
                    count_M <= 0;
                    count_N <= 0;   
               end               
               else if(count_N==N)
               begin
                        count_M <= count_M + 8'd1;
                        count_N <= 0;
               end
               
               else if(RUNNING == 1'b1)
               begin
                        count_N <= count_N + 8'd1;  
               end
            end  
    end
    always @(*)
    begin
        case (state)
        IDLE:begin  //posicao inicial, para garantir start=0
            if (START == 0)
             next_state = S0;
            else
                next_state = state;
                
            RUNNING = 0;
            BIST_END = 0;
            OUT = 0;
            Seed = 0;
            FINISH = 0;
            end
        S0:begin    // Garantido start=0 espera para start=1
                if (START == 1)
                    next_state = S1;
              else
                   next_state = state;
 
               RUNNING = 0;
               BIST_END = 0;
               OUT = 0;
               Seed = 0;
               FINISH = 0;
            end    
        S1:begin    //Ativa sinal de init antes de comecar a contagem
               next_state = S2;
               RUNNING = 0;
               BIST_END = 0;
               OUT = 0;
               Seed = 0;
               FINISH = 0;
            end
        S2:if (count_N==N) //funcionamento do contador
            begin 
                next_state = state;
                RUNNING = 1;
                BIST_END = 0;
                OUT = 0;
                Seed = 0;
                FINISH = 0;
            end
            else if (count_M==M)
            begin
                next_state = S3;
                RUNNING = 0;
                BIST_END = 1;
                OUT = 0;
                Seed = 0;
                FINISH = 0;
            end
            else 
            begin
                 next_state = state;
                 RUNNING = 1;
                 BIST_END = 0;
                 OUT = 1;
                 FINISH = 0;
                 if (count_M>5)
                    Seed = 1;
                else
                    Seed = 0;   
                 
            end
        S3:begin //Sinal de finish
               next_state = S4;
               RUNNING = 0;
               BIST_END = 1;
               OUT = 0;
               Seed = 0;
               FINISH = 1;
            end     
        S4:begin
        if (START == 0) //Espera zerar o start enquanto mantem o bist alto
            next_state = S5; 
        else   
            next_state = state;
            
        RUNNING = 0;
        OUT = 0;
        BIST_END = 1;
        Seed = 0;
        FINISH = 0;
              
         end
         S5:begin
        if (START == 1) //verifica borda de subida do start antes de recomecar
            next_state = S1; 
        else   
            next_state = state;

        RUNNING = 0;
        OUT = 0;
        BIST_END = 1;
        Seed = 0;
        FINISH = 0;    
        end
        default:   
         begin
             next_state = state;
             RUNNING = 0;
             OUT = 0;
             BIST_END = 0;
             Seed = 0;
             FINISH = 0;
         end 
            
        endcase
    end

endmodule