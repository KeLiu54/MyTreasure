module SHEX (idata,rst,clk,odata);
input [3:0] idata;
input rst,clk;
output [6:0] odata;
reg [6:0] odata_r;
assign odata=odata_r;
always@(posedge clk or negedge rst)
 begin
   if(rst==1'b0)
    begin
     odata_r<=7'd0;
    end
    else
     begin
      case(idata)
       4'd0:odata_r<=7'b1000000;
       4'd1:odata_r<=7'b1111001;
       4'd2:odata_r<=7'b0100100;
       4'd3:odata_r<=7'b0110000;
       4'd4:odata_r<=7'b0011001;
       4'd5:odata_r<=7'b0010010;
       4'd6:odata_r<=7'b0000010;
       4'd7:odata_r<=7'b1111000;
       4'd8:odata_r<=7'b0000000;
       4'd9:odata_r<=7'b0010000;
       default:odata_r<=7'b0111111;
      endcase
     end
 end
 endmodule
