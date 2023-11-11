module point_cnt(clk50M,rst_n,point_cnt_en,x,y);//像素点扫描模块，通过逐一扫描每个像素点（即每个显存地址）来实现对某个具体像素点的绘点操作
input clk50M,rst_n;
input point_cnt_en;//计数使能信号
output [7:0] x;//扫描过程中当前像素点的x坐标
output [6:0] y;//扫描过程中当前像素点的y坐标
reg [7:0] x_position;//扫描过程中当前像素点的x坐标(寄存器)
reg [6:0] y_position;//扫描过程中当前像素点的y坐标(寄存器)
assign x=x_position;
assign y=y_position;
always@(posedge clk50M or negedge rst_n)
begin
if(!rst_n)
begin
    x_position<=8'd64;
    y_position<=7'd60;
end
else
begin

if(point_cnt_en==1'b1)
begin
    if(x_position==8'd159)//逐行扫描
    begin
        x_position<=8'd0;
        if(y_position==7'd119)//每扫描完一行，行计数器加1
        y_position<=7'd0;
        else
        y_position<=y_position+7'd1;
    end
    else
        begin
        x_position<=x_position+8'd1;//列计数器一直自增1
        end
end
else
begin
    x_position<=8'd0;
	 y_position<=7'd0;
end

end
end
endmodule 