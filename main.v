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
   
   wire enable;
   reg [7:0] count; //deve contar ate 80 = (N+1)*M = (9+1)*8 
   // state flip-flops
   reg [2:0] state, next_state;
   // state coding
   localparam [2:0] IDLE=0, S0=1, S1=2;
   
   always @(posedge CLK)
    begin
        if (RESET == 1'b1)
         state <= IDLE;
        else
            state <= next_state;
    end
    
    // next state calculations
    always @(*)
    begin
        case (state)
        IDLE: if (START == 1'b1) //consertar isso, so deve passa se for posedge do start
                next_state = S0;
            else next_state = IDLE;
        S0: //enable <= 1'b1;
            if (count == 80)    
                next_state = S1;
            else next_state = S0;
        //S1: 
            //assign RUNNING = 0;    
        default: next_state = state;
        endcase
    end
   always @(posedge CLK or posedge RESET)
   begin
        if (RESET == 1'b1)
            count <= 8'd0;
        else if (enable == 1'b1)
            count <= count + 8'd1;
   end
   
   always @(*)
   begin
        if (count[4:0] ==  5'b10001) // A cada 9 operacoes de count abaixa o out
            //OUT = 0;
        else 
            //OUT = 1;
            
   end
   
endmodule

