`timescale 1ns / 100ps

module main(CLK, RESET, START, OUT, BIST_END, RUNNING);
   input CLK,RESET,START;
   output OUT,BIST_END,RUNNING;
   
   reg enable;
   reg [7:0] count; //deve contar ate 89 = (N+1)*(M+1)-1 = (9+1)*(8+1) 
   reg [3:0] count_N, count_M;
   
   // state flip-flops
   reg out_reg,rst_reg,bist,run,start;
   reg [2:0] state, next_state;
 
   // state coding
   localparam [2:0] IDLE=0, S0=1;
   localparam [4:0] N=9, M=9;
    
    
    always @(posedge CLK or posedge RESET)
       begin
       if (RESET == 1'b1)
            state <= IDLE;
       else
            state <= next_state;
       end
    
    always @(posedge CLK or posedge RESET)
       begin
       if (RESET == 1'b1)
        begin    
          count_N <=0;
          count_M <=0;
        end
           if(run == 1'b1)
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
                if (START == 1)
                begin
                    next_state = S0;
                    bist <= 0;
                
                end
              else
               begin 
                   next_state = IDLE;
                   run <= 0;
                   out_reg <= 0;
               end
            end
        S0:if (count_N==N) 
            begin 
                next_state <= S0;
                enable <= 0; 
                run <= 1;
                bist <= 0;
                out_reg <= 0;
            end
            else if (count_M==M)
            begin
                next_state <= IDLE;
                enable <= 0; 
                run <= 0;
                bist <= 1;
                out_reg <= 0;
            end
            else 
            begin
                 next_state = S0;
                 enable <= 1'b1;
                 run <= 1;
                 bist <= 0;
                 out_reg <= 1;
            end 
        default:   
         begin
             next_state = state;
             enable <= 0;
             run <= 0;
             bist <= 0;
             rst_reg <= 0;
         end 
            
        endcase
    end
    
  assign OUT = out_reg;
  assign BIST_END = bist;
  assign RUNNING = run;

endmodule