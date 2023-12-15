`timescale 1ns / 100ps

module main(CLK, RESET, START, OUT, BIST_END, RUNNING);
   input CLK,RESET,START;
   output reg OUT,BIST_END,RUNNING;
   
   reg [7:0] count; //deve contar ate 89 = (N+1)*(M+1)-1 = (9+1)*(8+1) 
   reg [3:0] count_N, count_M;
   
   // state flip-flops;
   reg [2:0] state, next_state;
 
   // state coding
   localparam [2:0] IDLE=0, S0=1, S1=2, S2=3,S3=4;
   localparam [4:0] N=9, M=9;
    
    
    always @(posedge CLK or posedge RESET)
       begin
       if (RESET == 1'b1)
        begin  
          state <= IDLE;  
          count_N <=0;
          count_M <=0;
        end
       else
       begin
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
        IDLE:begin          //posição inicial, para garantir start=0
            if (START == 0)
             next_state = S0;
            else
                next_state = state;
                
            RUNNING = 0;
            BIST_END = 0;
            OUT = 0;
            end
        S0:begin        // Garantido start=0 espera para start=1
                if (START == 1)
                    next_state = S1;
              else
                   next_state = state;

               RUNNING = 0;
               BIST_END = 0;
               OUT = 0;
            end    
        S1:if (count_N==N) //funcionamento apos start
            begin 
                next_state = S1;
                RUNNING = 1;
                BIST_END = 0;
                OUT = 0;
            end
            else if (count_M==M)
            begin
                next_state = S2;
                RUNNING = 0;
                BIST_END = 1;
                OUT = 0;
            end
            else 
            begin
                 next_state = S1;
                 RUNNING = 1;
                 BIST_END = 0;
                 OUT = 1;
            end 
        S2:begin
        if (START == 0)
            next_state = S3;
        else   
            next_state = state;
            
        RUNNING = 0;
        OUT = 0;
        BIST_END = 1;
        
         end    
     S3:begin
    if (START == 1)
        next_state = S1;
    else   
        next_state = state;
        
    RUNNING = 0;
    OUT = 0;
    BIST_END = 1;
    
     end    
        default:   
         begin
             next_state = state;
             RUNNING = 0;
             OUT = 0;
             BIST_END = 0;
         end 
            
        endcase
    end

endmodule