`timescale 1ns/1ps

module circuito12 (
   input clk,
   input rst,
   input k,
   input j,
   input rx_en,
   output reg synced_d,
   output reg sync_err_d
);

   reg [2:0] fs_state;
   reg [2:0] fs_next_state;

   localparam [2:0] FS_IDLE = 3'h0;
   localparam [2:0] K1 = 3'h1;
   localparam [2:0] J1 = 3'h2;
   localparam [2:0] K2 = 3'h3;
   localparam [2:0] J2 = 3'h4;
   localparam [2:0] K3 = 3'h5;
   localparam [2:0] J3 = 3'h6;
   localparam [2:0] K4 = 3'h7;

   always @(posedge clk)
      if (rst == 1'b1)
         fs_state <= FS_IDLE;
      else
         fs_state <= fs_next_state;

   always @(*)
   begin
      synced_d = 1'b0;
      sync_err_d = 1'b0;
      fs_next_state = fs_state;
         case(fs_state)
            FS_IDLE:
               begin
                  if (k && rx_en)
                     fs_next_state = K1;
               end
            K1:
               begin
                  if (j && rx_en)
                     fs_next_state = J1;
                  else
                  begin
                     sync_err_d = 1'b1;
                     fs_next_state = FS_IDLE;
                  end
               end
            J1:
               begin
                  if (k && rx_en)
                     fs_next_state = K2;
                  else
                  begin
                     sync_err_d = 1'b1;
                     fs_next_state = FS_IDLE;
                  end
               end
            K2:
               begin
                  if (j && rx_en)
                     fs_next_state = J2;
                  else
                  begin
                     sync_err_d = 1'b1;
                     fs_next_state = FS_IDLE;
                  end
               end
            J2:
               begin
                  if (k && rx_en)
                     fs_next_state = K3;
                  else
                  begin
                     sync_err_d = 1'b1;
                     fs_next_state = FS_IDLE;
                  end
               end
            K3:
               begin
                  if (j && rx_en)
                     fs_next_state = J3;
                  else if (k && rx_en)
                  begin
                     fs_next_state = FS_IDLE;
                     synced_d = 1'b1;
                  end
                  else
                  begin
                     sync_err_d = 1'b1;
                     fs_next_state = FS_IDLE;
                  end
               end
            J3:
               begin
                  if (k && rx_en)
                     fs_next_state = K4;
                  else
                  begin
                     sync_err_d = 1'b1;
                     fs_next_state = FS_IDLE;
                  end
               end
            K4:
               begin
                  if (k)
                     synced_d = 1'b1;
                  fs_next_state = FS_IDLE;
               end
         endcase
   end

endmodule

