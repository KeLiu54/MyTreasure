module HEX(idata,rst,clk,odata0,odata1,odata2,odata3,odata4,odata5,odata6,odata7);
input [31:0] idata ;
input clk,rst;
output [6:0] odata0,odata1,odata2,odata3,odata4,odata5,odata6,odata7;
wire [6:0] d0,d1,d2,d3,d4,d5,d6,d7;
reg [6:0] odata0_r,odata1_r,odata2_r,odata3_r,odata4_r,odata5_r,odata6_r,odata7_r;

assign odata0=odata0_r;
assign odata1=odata1_r;
assign odata2=odata2_r;
assign odata3=odata3_r;
assign odata4=odata4_r;
assign odata5=odata5_r;
assign odata6=odata6_r;
assign odata7=odata7_r;
SHEX SHEX0 (.idata(idata[3:0]),
            .rst(rst),
            .clk(clk),
            .odata(d0));
SHEX SHEX1 (.idata(idata[7:4]),
            .rst(rst),
            .clk(clk),
            .odata(d1));
SHEX SHEX2 (.idata(idata[11:8]),
            .rst(rst),
            .clk(clk),
            .odata(d2));
SHEX SHEX3 (.idata(idata[15:12]),
            .rst(rst),
            .clk(clk),
            .odata(d3));
SHEX SHEX4 (.idata(idata[19:16]),
            .rst(rst),
            .clk(clk),
            .odata(d4));
SHEX SHEX5 (.idata(idata[23:20]),
            .rst(rst),
            .clk(clk),
            .odata(d5));
SHEX SHEX6 (.idata(idata[27:24]),
            .rst(rst),
            .clk(clk),
            .odata(d6));
SHEX SHEX7 (.idata(idata[31:28]),
            .rst(rst),
            .clk(clk),
            .odata(d7)); 
always@(posedge clk or negedge rst)
 begin
  if(rst==1'b0)
   begin
    odata0_r<=7'd0;
    odata1_r<=7'd0;
    odata2_r<=7'd0;
    odata3_r<=7'd0;
    odata4_r<=7'd0;
    odata5_r<=7'd0;
    odata6_r<=7'd0;
    odata7_r<=7'd0;
   end
  else 
   begin
    odata0_r<=d0;
    odata1_r<=d1;
    odata2_r<=d2;
    odata3_r<=d3;
    odata4_r<=d4;
    odata5_r<=d5;
    odata6_r<=d6;
    odata7_r<=d7;
   end
 end
 endmodule           
