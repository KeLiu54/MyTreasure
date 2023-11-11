module picture_draw(clk50M,rst_n,point_cnt_en,x_position,y_position,x0,y0,object_select,colour,writen);
input clk50M,rst_n;
input point_cnt_en;
input [7:0] x_position;//扫描过程中当前像素点的x坐标
input [6:0] y_position;//扫描过程中当前像素点的y坐标
input [7:0] x0;//所需绘制图形的左上角顶点的x坐标
input [6:0] y0;//所需绘制图形的左上角顶点的y坐标
input [1:0] object_select;//选择绘制的对象，0:黑色填充 1:箱子 2：障碍物 3：人物，本质上是选择RAM
output [2:0] colour;//ram输出的像素点颜色数据
output writen;
reg [2:0] colour_blank;
wire [2:0] colour_box;
wire [2:0] colour_barrier;
reg writen_r;//写使能信号寄存器
reg [9:0] ram_address;//每个箱子或者人物用32*30像素图片，因此需要960个存储深度，RAM位宽设为3，深度为1024，所以地址为10位
reg [9:0] ram_address_box;//存储箱子图片数据的ram地址
reg [9:0] ram_address_barrier;//存储障碍图片数据的ram地址
wire [9:0] ram_address_w;
wire [9:0] ram_address_box_w;
wire [9:0] ram_address_barrier_w;
wire [2:0] colour_man;


assign ram_address_w=ram_address;
assign ram_address_box_w=ram_address_box;
assign ram_address_barrier_w=ram_address_barrier;
assign writen=writen_r;
assign colour=object_select[1]?(object_select[0]?colour_man:colour_barrier):(object_select[0]?colour_box:colour_blank);

always@(posedge clk50M or negedge rst_n)
begin
if(!rst_n)
    begin
	 ram_address<=10'd0;
	 writen_r<=1'b0;
	 ram_address_box<=10'd0;
	 ram_address_barrier<=10'd0;
	 end
else
    begin
	 case(object_select)
	 2'd3:
	     begin
		  if(x0>8'd0)
		      begin
	             if(x_position>=x0-8'd1 && x_position<=x0+8'd30 && y_position>=y0 && y_position<=y0+7'd29 && point_cnt_en==1'b1)
	                 begin
		              ////////////////////////////
		              if(ram_address<=10'd958)
		              ram_address<=ram_address+10'd1;
		              else
		              ram_address<=10'd0;
		              ////////////////////////////
		              writen_r<=1'b1;
		              ////////////////////////////
		              end
	             else
	                 begin
		              writen_r<=1'b0;
		              end
		      end
		  else
		      begin
				    if(((x_position>=x0 && x_position<=x0+8'd30)|| x_position==8'd159) && y_position>=y0 && y_position<=y0+7'd29 && point_cnt_en==1'b1)
					     begin
						  if(ram_address<=10'd958)
		              ram_address<=ram_address+10'd1;
		              else
		              ram_address<=10'd0;
		              ////////////////////////////
		              writen_r<=1'b1;
		              ////////////////////////////
						  end
					 else
					     begin
						  writen_r<=1'b0;
						  end
				end
	     end
	 2'd0:
	     begin
		  
		          if(x_position>=x0 && x_position<=x0+8'd31 && y_position>=y0 && y_position<=y0+7'd29 && point_cnt_en==1'b1)
	                 begin
		              ////////////////////////////
		              colour_blank<=3'd0;
		              ////////////////////////////
		              writen_r<=1'b1;
		              ////////////////////////////
		              end
	             else
	                 begin
		              writen_r<=1'b0;
		              end
		      
		  
		  end
	 2'd1:
	     begin
		  
		          if(x_position>=x0 && x_position<=x0+8'd31 && y_position>=y0 && y_position<=y0+7'd29 && point_cnt_en==1'b1)
	                 begin
		              ////////////////////////////
		              if(ram_address_box<=10'd958)
		              ram_address_box<=ram_address_box+10'd1;
		              else
		              ram_address_box<=10'd0;
		              ////////////////////////////
		              writen_r<=1'b1;
		              ////////////////////////////
		              end
	             else
	                 begin
		              writen_r<=1'b0;
		              end
		    
		  
		  end
	 2'd2:
	     begin
		  
		          if(x_position>=x0 && x_position<=x0+8'd31 && y_position>=y0 && y_position<=y0+7'd29 && point_cnt_en==1'b1)
	                 begin
		              ////////////////////////////
		              if(ram_address_barrier<=10'd958)
		              ram_address_barrier<=ram_address_barrier+10'd1;
		              else
		              ram_address_barrier<=10'd0;
		              ////////////////////////////
		              writen_r<=1'b1;
		              ////////////////////////////
		              end
	             else
	                 begin
		              writen_r<=1'b0;
		              end
		     
		        
				
		  end
	 default:colour_blank<=3'd0;
	 endcase
	 end
end

ram_man ram_man_u (
	.address(ram_address_w),
	.clock(clk50M),
	.data(3'd0),
	.wren(1'b0),
	.q(colour_man));
ram_box ram_box_u(
	.address(ram_address_box_w),
	.clock(clk50M),
	.data(3'd0),
	.wren(1'b0),
	.q(colour_box));
ram_barrier ram_barrier_u(
	.address(ram_address_barrier_w),
	.clock(clk50M),
	.data(3'd0),
	.wren(1'b0),
	.q(colour_barrier));
endmodule 