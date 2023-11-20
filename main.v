`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2023 10:47:03
// Design Name: 
// Module Name: main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module main(CLK, RESET, START, OUT, BIST_END, RUNNING);
   input CLK,RESET,START;
   output OUT,BIST_END,RUNNING;
   
   reg enable;
   reg [7:0] count; //deve contar ate 89 = (N+1)*(M+1)-1 = (9+1)*(8+1) 
   // state flip-flops
   reg out_reg,rst_reg,bist,run,start;
   reg [2:0] state, next_state;
   // state coding
   localparam [2:0] IDLE=0, S0=1, S1=2;
   localparam [4:0] N=8, M=9;
     
   always @(posedge CLK)
    begin
        if (RESET == 1'b1)
         state <= IDLE;
        else
            state <= next_state;
    end
    
    always @(posedge START or posedge bist)
        if (START == 1)
            start = 1;
        else if (bist == 1)
            start = 0;    
    // next state calculations
    always @(*)
    begin
        case (state)
        IDLE:begin
                if (start == 1)
                    next_state = S0;
                else next_state = IDLE;
                   enable <= 0; 
                   rst_reg <= 0;
                   run <= 0;
                   bist <= 1;
            end
        S0: if (count == ((N+1)*(M+1)-1))   
            begin 
                next_state <= S1;
                enable <= 0; 
                rst_reg <= 0;
                run <= 0;
                bist <= 1;
            end
            else 
            begin
                 next_state = S0;
                 enable <= 1'b1;
                 run <= 1;
                 bist <= 0;
            end 
        S1: begin
                next_state = S1;
                enable <= 0;
                run <= 0;
                bist <= 1;   
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
   always @(posedge CLK or posedge RESET)
   begin
        if (RESET == 1'b1)      //reset do input
            count <= 8'd0;
        else if (rst_reg == 1)  //reset da maquina de estado
             count <= 8'd0;
        else if (enable == 1'b1)
            count <= count + 8'd1;
   end
   
   always @(*)
   begin
        if (enable == 1'b1)
            if (count[4:0] == (N)) // A cada 9 operacoes de count abaixa o out 
                out_reg <= 1'b0;
            else 
                out_reg <= 1'b1;
       else
           out_reg <= 1'b0;      
   end
   
  assign OUT = out_reg;
  assign BIST_END = bist;
  assign RUNNING = run;

endmodule


