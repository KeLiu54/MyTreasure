module bin2dec(clk50M,rst_n,data_in,d0,d1,d2,d3,d4,d5,d6,d7);
input clk50M,rst_n;
input [31:0] data_in;
output [3:0] d0,d1,d2,d3,d4,d5,d6,d7;
reg [31:0] data_in_r;
reg [3:0] state;
reg [3:0] d0_r,d1_r,d2_r,d3_r,d4_r,d5_r,d6_r,d7_r,temp0,temp1,temp2,temp3,temp4,temp5,temp6,temp7;
assign d0=d0_r;
assign d1=d1_r;
assign d2=d2_r;
assign d3=d3_r;
assign d4=d4_r;
assign d5=d5_r;
assign d6=d6_r;
assign d7=d7_r;
always@(posedge clk50M or negedge rst_n)
begin
 if(!rst_n)
  begin
   state<=4'd0;
   d0_r<=4'd0;
   d1_r<=4'd0;
   d2_r<=4'd0;
   d3_r<=4'd0;
   d4_r<=4'd0;
   d5_r<=4'd0;
   d6_r<=4'd0;
   d7_r<=4'd0;
   temp1<=4'd0;
   temp2<=4'd0;
   temp3<=4'd0;
   temp4<=4'd0;
   temp5<=4'd0;
   temp6<=4'd0;
   temp7<=4'd0;
   temp0<=4'd0;
  end
 else
  begin
   case(state)
  4'd0:begin
        data_in_r<=data_in;
        state<=4'd1;
        
        temp1<=4'd0;
        temp2<=4'd0;
        temp3<=4'd0;
        temp4<=4'd0;
        temp5<=4'd0;
        temp6<=4'd0;
        temp7<=4'd0;
        temp0<=4'd0;
       end
  4'd1:begin
        if(data_in_r>=32'd10000000)
         begin
          data_in_r<=data_in_r-32'd10000000;
          temp7<=temp7+4'd1;
         end
        else
         begin
          
          state<=4'd2;
         end
       end
  4'd2:begin
        if(data_in_r>=32'd1000000)
         begin
          data_in_r<=data_in_r-32'd1000000;
          temp6<=temp6+4'd1;
         end
        else
         begin
          
          state<=4'd3;
         end
       end
   4'd3:begin
        if(data_in_r>=32'd100000)
         begin
          data_in_r<=data_in_r-32'd100000;
          temp5<=temp5+4'd1;
         end
        else
         begin
          
          state<=4'd4;
         end
       end
   4'd4:begin
        if(data_in_r>=32'd10000)
         begin
          data_in_r<=data_in_r-32'd10000;
          temp4<=temp4+4'd1;
         end
        else
         begin
          
          state<=4'd5;
         end
       end
   4'd5:begin
        if(data_in_r>=32'd1000)
         begin
          data_in_r<=data_in_r-32'd1000;
          temp3<=temp3+4'd1;
         end
        else
         begin
          
          state<=4'd6;
         end
       end
   4'd6:begin
        if(data_in_r>=32'd100)
         begin
          data_in_r<=data_in_r-32'd100;
          temp2<=temp2+4'd1;
         end
        else
         begin
          
          state<=4'd7;
         end
       end
   4'd7:begin
        if(data_in_r>=32'd10)
         begin
          data_in_r<=data_in_r-32'd10;
          temp1<=temp1+4'd1;
         end
        else
         begin
          
          state<=4'd8;
         end
       end
   4'd8:begin
        if(data_in_r>=32'd1)
         begin
          data_in_r<=data_in_r-32'd1;
          temp0<=temp0+4'd1;
         end
        else
         begin
          d0_r<=temp0;
          d1_r<=temp1;
          d2_r<=temp2;
          d3_r<=temp3;
          d4_r<=temp4;
          d5_r<=temp5;
          d6_r<=temp6;
          d7_r<=temp7;
          state<=4'd0;
         end
       end
   default:state<=4'd0;
   endcase
  end
end
endmodule 