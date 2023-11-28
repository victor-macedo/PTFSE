`timescale 1ns / 100ps

module main(CLK, RESET, START, OUT, BIST_END, RUNNING);
   input CLK,RESET,START;
   output reg OUT,BIST_END,RUNNING;
   
   reg enable;
   reg [7:0] count; //deve contar ate 89 = (N+1)*(M+1)-1 = (9+1)*(8+1) 
   reg [3:0] count_N, count_M;
   
   // state flip-flops;
   reg [2:0] state, next_state;
 
   // state coding
   localparam [1:0] IDLE=0, S0=1, S1=2, S2=3;
   localparam [4:0] N=9, M=9;
    
    
    always @(posedge CLK or posedge RESET)
       begin
       if (RESET == 1'b1)
            state = IDLE;
       else
            state = next_state;
       end
    
    always @(posedge CLK)
       begin
       if (RESET == 1'b1)
        begin    
          count_N <=0;
          count_M <=0;
        end
           if(RUNNING == 1'b1)
           begin 
                count_N <= count_N + 8'd1;     
           end
           
           if(count_N==N)
           begin
                    count_M <= count_M + 8'd1;
                    count_N <= 0;
           end
           
           if(count_M==M)
           begin
                    count_M <= 0;
                    count_N <= 0;
           end
       end

    always @(*)
    begin
        case (state)
        IDLE:begin
            if (START == 0)
             next_state = S0;
            else
                next_state = state;
                
            enable = 0;
            RUNNING = 0;
            BIST_END = 0;
            OUT = 0;
            end
        S0:begin
                if (START == 1)
                    next_state = S1;
              else
                   next_state = state;

               enable = 0; 
               RUNNING = 0;
               BIST_END = 0;
               OUT = 0;
            end    
        S1:if (count_N==N) 
            begin 
                next_state = S1;
                enable = 0; 
                RUNNING = 1;
                BIST_END = 0;
                OUT = 0;
            end
            else if (count_M==M)
            begin
                next_state = S2;
                enable = 0; 
                RUNNING = 0;
                BIST_END = 1;
                OUT = 0;
            end
            else 
            begin
                 next_state = S1;
                 enable = 1'b1;
                 RUNNING = 1;
                 BIST_END = 0;
                 OUT = 1;
            end 
        S2:begin
        if (START == 1)
            next_state = S1;
        else   
            next_state = state;
            
        enable = 0;
        RUNNING = 0;
        OUT = 0;
        BIST_END = 1;
        
         end    
        default:   
         begin
             next_state = state;
             enable = 0;
             RUNNING = 0;
             OUT = 0;
             BIST_END = 0;
         end 
            
        endcase
    end

endmodule