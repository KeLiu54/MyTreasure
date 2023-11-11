module fsm(clk50M,rst_n,key,sw,time_remain,object_sel,x0,y0,test,direct_test,point_cnt_en,win_or_lose,gaming,time_dis);
input clk50M,rst_n;
input sw;//start switch:1 to start,0 to pasue
input [3:0] key;//direction control keys:1101=up 1110=down 1011=right 0111=left
input [5:0] time_remain;//剩余时间
output test;
output point_cnt_en;//point_cnt模块计数使能信号，只有当draw_command状态时才绘图，在draw_command状态下置1
output [3:0] direct_test;
output gaming;
reg test_r;
assign test=test_r;
assign direct_test=direction;
output [1:0] object_sel;//选择绘制的对象，0:黑色填充 1:箱子 2：障碍物 3：人物，本质上是选择RAM
output [7:0] x0;
output [6:0] y0;
output [1:0] win_or_lose;//胜负状态:2'b00 or 2'b01=未分输赢 2'b10=输 2'b11=赢
output [5:0] time_dis;//显示在数码管上的时间
parameter up=4'b0010;
parameter down=4'b0001;
parameter left=4'b1000;
parameter right=4'b0100;
parameter idle=3'b000;
parameter position_move=3'b001;
parameter draw_command=3'b011;
parameter win_judge=3'b010;
parameter win_lose=3'b110;
parameter blank=3'b000;
parameter man_exist=3'b100;//格点中有人物
parameter box_exist=3'b001;//格点中有箱子
parameter barrier_exist=3'b010;//格点中有障碍物
wire [3:0] direction;
reg gaming_r;
reg point_cnt_en_r;
reg [3:0] direction_r;
reg k0_r1,k1_r1,k2_r1,k3_r1;//移位寄存法检测下降沿所需的寄存器
reg k0_r2,k1_r2,k2_r2,k3_r2;//移位寄存法检测下降沿所需的寄存器
reg [2:0] equal_cell[19:0];//等效格点，共有5*4个等效格点，每个等效格点占32*30像素，等效格点三位分别表示人物属性、障碍物属性和箱子属性，如3'b100表示此格点要显示人物
reg [2:0] state;
reg [4:0] man_cell_num;//人物的等效格点数
reg [2:0] cell_x,cell_y;//等效格点的x、y坐标
reg [31:0] cell_draw_cnt;//绘制160*120所需的时钟计数器
reg [1:0] object_sel_r;
reg [7:0] x0_r;
reg [6:0] y0_r;
reg [2:0] draw_step;//绘图的步骤：第一步给出准备绘制的等效格点的坐标
reg [2:0] man_cell_x,man_cell_y;//人物所在等效格点的x,y坐标
reg [1:0] win_or_lose_r;
reg [5:0] time_dis_r;//显示在数码管上的时间
wire [4:0] cell_num;//等效格点数
wire flag_k0,flag_k1,flag_k2,flag_k3;//为1代表按键按下
assign flag_k0=(~k0_r1)&&k0_r2;//检测k0下降沿
assign flag_k1=(~k1_r1)&&k1_r2;//检测k1下降沿
assign flag_k2=(~k2_r1)&&k2_r2;//检测k2下降沿
assign flag_k3=(~k3_r1)&&k3_r2;//检测k3下降沿
assign direction={flag_k3,flag_k2,flag_k1,flag_k0};
assign cell_num=cell_x+5*cell_y;
assign object_sel=object_sel_r;
assign x0=x0_r;
assign y0=y0_r;
assign point_cnt_en=point_cnt_en_r;
assign time_dis=time_dis_r;
assign win_or_lose=win_or_lose_r;
assign gaming=gaming_r;
always@(posedge clk50M or negedge rst_n)
begin
if(!rst_n)
    begin
	 k0_r1<=1'b1;
	 k0_r2<=1'b1;
	 k1_r1<=1'b1;
	 k1_r2<=1'b1;
	 k2_r1<=1'b1;
	 k2_r2<=1'b1;
	 k3_r1<=1'b1;
	 k3_r2<=1'b1;
	 cell_x<=3'd4;
	 cell_y<=3'd3;
	 cell_draw_cnt<=0;
	 man_cell_num<=5'd14;
	 
	 equal_cell[0]=blank;
	 equal_cell[1]=blank;
	 equal_cell[2]=blank;
	 equal_cell[3]=blank;
	 equal_cell[4]=blank;
	 equal_cell[5]=blank;
	 equal_cell[6]=box_exist;
	 equal_cell[7]=barrier_exist;
	 equal_cell[8]=box_exist;
	 equal_cell[9]=blank;
	 equal_cell[10]=box_exist;
	 equal_cell[11]=blank;
	 equal_cell[12]=barrier_exist;
	 equal_cell[13]=blank;
	 equal_cell[14]=man_exist;
	 equal_cell[15]=blank;
	 equal_cell[16]=blank;
	 equal_cell[17]=box_exist;
	 equal_cell[18]=blank;
	 equal_cell[19]=blank;
	 test_r<=1'b0;
	 state<=idle;
	 point_cnt_en_r=1'b0;
	 man_cell_x<=3'd4;
	 man_cell_y<=3'd2;
	 win_or_lose_r<=2'b00;
	 time_dis_r<=6'd60;
	 gaming_r<=1'b0;
	 end
else
    begin
	 k0_r1<=key[0];
	 k0_r2<=k0_r1;
	 k1_r1<=key[1];
	 k1_r2<=k1_r1;
	 k2_r1<=key[2];
	 k2_r2<=k2_r1;
	 k3_r1<=key[3];
	 k3_r2<=k3_r1;
	 case(man_cell_num)
	 5'd0:
	     begin
		  man_cell_x<=3'd0;
	     man_cell_y<=3'd0;
		  end
	 5'd1:
	     begin
		  man_cell_x<=3'd1;
	     man_cell_y<=3'd0;
		  end
	 5'd2:
	     begin
		  man_cell_x<=3'd2;
	     man_cell_y<=3'd0;
		  end
	 5'd3:
	     begin
		  man_cell_x<=3'd3;
	     man_cell_y<=3'd0;
		  end
	 5'd4:
	     begin
		  man_cell_x<=3'd4;
	     man_cell_y<=3'd0;
		  end
	 5'd5:
	     begin
		  man_cell_x<=3'd0;
	     man_cell_y<=3'd1;
		  end
	 5'd6:
	     begin
		  man_cell_x<=3'd1;
	     man_cell_y<=3'd1;
		  end
	 5'd7:
	     begin
		  man_cell_x<=3'd2;
	     man_cell_y<=3'd1;
		  end
	 5'd8:
	     begin
		  man_cell_x<=3'd3;
	     man_cell_y<=3'd1;
		  end
	 5'd9:
	     begin
		  man_cell_x<=3'd4;
	     man_cell_y<=3'd1;
		  end
	 5'd10:
	     begin
		  man_cell_x<=3'd0;
	     man_cell_y<=3'd2;
		  end
	 5'd11:
	     begin
		  man_cell_x<=3'd1;
	     man_cell_y<=3'd2;
		  end
	 5'd12:
	     begin
		  man_cell_x<=3'd2;
	     man_cell_y<=3'd2;
		  end
	 5'd13:
	     begin
		  man_cell_x<=3'd3;
	     man_cell_y<=3'd2;
		  end
	 5'd14:
	     begin
		  man_cell_x<=3'd4;
	     man_cell_y<=3'd2;
		  end
	 5'd15:
	     begin
		  man_cell_x<=3'd0;
	     man_cell_y<=3'd3;
		  end
	 5'd16:
	     begin
		  man_cell_x<=3'd1;
	     man_cell_y<=3'd3;
		  end
	 5'd17:
	     begin
		  man_cell_x<=3'd2;
	     man_cell_y<=3'd3;
		  end
	 5'd18:
	     begin
		  man_cell_x<=3'd3;
	     man_cell_y<=3'd3;
		  end
	 5'd19:
	     begin
		  man_cell_x<=3'd4;
	     man_cell_y<=3'd3;
		  end
	 default:
	     begin
		  end
	 endcase
	 
	 
	 
	 
    case(state)
	 idle://-----------------------------------------------------//
	      begin
	          if(sw==1'b1)
				 begin
			    state<=draw_command;
				 win_or_lose_r<=2'b01;
				 gaming_r<=1'b1;
				 end
			    else
			    state<=idle;
				 
				 
			end
	 position_move://-----------------------------------------------------//
	      begin
			    time_dis_r<=time_remain;
				 if(time_remain==6'd0)
				 begin
			    win_or_lose_r<=2'b10;//失败
				 state<=draw_command;
				 end
			    else
			    win_or_lose_r<=win_or_lose_r;
			    case(direction)
				     up:
					      begin
							    if(man_cell_num>=5'd15)//---------------------------man_cell_num>=5'd15---------------------------//
								     begin
									      case(equal_cell[man_cell_num-5'd5])
											blank:
											     begin
												  man_cell_num<=man_cell_num-5'd5;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num-5'd5]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  if(equal_cell[man_cell_num-5'd10]==blank)
												      begin
												      man_cell_num<=man_cell_num-5'd5;
												      equal_cell[man_cell_num]<=blank;
														equal_cell[man_cell_num-5'd5]<=man_exist;
														equal_cell[man_cell_num-5'd10]<=box_exist;
														state<=draw_command;
														end
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
											default:begin
											        end
											endcase
									  end
								 else if(man_cell_num>=5'd10)//---------------------------man_cell_num>=5'd10---------------------------//
								     begin
									      case(equal_cell[man_cell_num-5'd5])
											blank:
											     begin
												  man_cell_num<=man_cell_num-5'd5;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num-5'd5]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  if(equal_cell[man_cell_num-5'd10]==blank)
												      begin
												      man_cell_num<=man_cell_num-5'd5;
												      equal_cell[man_cell_num]<=blank;
														equal_cell[man_cell_num-5'd5]<=man_exist;
														equal_cell[man_cell_num-5'd10]<=box_exist;
														state<=draw_command;
														end
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
											default:begin
											        end
											endcase
									  end
								 else if(man_cell_num>=5'd5)//---------------------------man_cell_num>=5'd5---------------------------//
								     begin
									      case(equal_cell[man_cell_num-5'd5])
											blank:
											     begin
												  man_cell_num<=man_cell_num-5'd5;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num-5'd5]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
											default:begin
											        end
											endcase
									  end
								 else 
							        begin
									  end  
							end
					  down:
					      begin
							    if(man_cell_num<=5'd4)//-------------------------------man_cell_num<=5'd4------------//
								     begin
									      case(equal_cell[man_cell_num+5'd5])
											blank:
											    begin
												 man_cell_num<=man_cell_num+5'd5;
												 equal_cell[man_cell_num]<=blank;
												 equal_cell[man_cell_num+5'd5]<=man_exist;
												 state<=draw_command;
												 end
										   box_exist:
											    begin
												 if(equal_cell[man_cell_num+5'd10]==blank)
												      begin
												      man_cell_num<=man_cell_num+5'd5;
												      equal_cell[man_cell_num]<=blank;
														equal_cell[man_cell_num+5'd5]<=man_exist;
														equal_cell[man_cell_num+5'd10]<=box_exist;
														state<=draw_command;
														end
												 end
										   barrier_exist:
											    begin
												 
												 end
										   man_exist:
											    begin
												 
												 end
											default:begin
											        end
											endcase
									  end
								 else if(man_cell_num<=5'd9)//-------------------------------man_cell_num<=5'd9------------//
								     begin
									      case(equal_cell[man_cell_num+5'd5])
											blank:
											     begin
												  man_cell_num<=man_cell_num+5'd5;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num+5'd5]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  if(equal_cell[man_cell_num+5'd10]==blank)
												      begin
												      man_cell_num<=man_cell_num+5'd5;
												      equal_cell[man_cell_num]<=blank;
														equal_cell[man_cell_num+5'd5]<=man_exist;
														equal_cell[man_cell_num+5'd10]<=box_exist;
														state<=draw_command;
														end
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
											default:begin
											        end
											endcase
									  end
								 else if(man_cell_num<=5'd14)//-------------------------------man_cell_num<=5'd14------------//
								     begin
									      case(equal_cell[man_cell_num+5'd5])
											blank:
											     begin
												  man_cell_num<=man_cell_num+5'd5;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num+5'd5]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
										   default:begin
											        end
											endcase
									  end
								 else
								     begin
									  
									  end
							end
					  left:
					      begin
							    case(man_cell_x)
								 3'd0:
								     begin
									  
									  end
								 3'd1:
								     begin
									      case(equal_cell[man_cell_num-5'd1])
											blank:
											     begin
												  man_cell_num<=man_cell_num-5'd1;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num-5'd1]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
										   default:begin
											        end
											endcase    
									  end
								 3'd2:
								     begin
									      case(equal_cell[man_cell_num-5'd1])
											blank:
											     begin
												  man_cell_num<=man_cell_num-5'd1;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num-5'd1]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  if(equal_cell[man_cell_num-5'd2]==blank)
												      begin
												      man_cell_num<=man_cell_num-5'd1;
												      equal_cell[man_cell_num]<=blank;
												      equal_cell[man_cell_num-5'd1]<=man_exist;
														equal_cell[man_cell_num-5'd2]<=box_exist;
												      state<=draw_command;
														end
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
										   default:begin
											        end
											endcase    
												 
									  end
								 3'd3:
								     begin
									      case(equal_cell[man_cell_num-5'd1])
											blank:
											     begin
												  man_cell_num<=man_cell_num-5'd1;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num-5'd1]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  if(equal_cell[man_cell_num-5'd2]==blank)
												      begin
												      man_cell_num<=man_cell_num-5'd1;
												      equal_cell[man_cell_num]<=blank;
												      equal_cell[man_cell_num-5'd1]<=man_exist;
														equal_cell[man_cell_num-5'd2]<=box_exist;
												      state<=draw_command;
														end
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
										   default:begin
											        end
											endcase 
									  end
								 3'd4:
								     begin
									      case(equal_cell[man_cell_num-5'd1])
											blank:
											     begin
												  man_cell_num<=man_cell_num-5'd1;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num-5'd1]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  if(equal_cell[man_cell_num-5'd2]==blank)
												      begin
												      man_cell_num<=man_cell_num-5'd1;
												      equal_cell[man_cell_num]<=blank;
												      equal_cell[man_cell_num-5'd1]<=man_exist;
														equal_cell[man_cell_num-5'd2]<=box_exist;
												      state<=draw_command;
														end
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
										   default:begin
											        end
											endcase 
									  end
								 default:begin
								         end
								 endcase
							end
					  right://----------------------------------------------------------right-------------////////
					      begin
							    case(man_cell_x)
								 3'd0:
								     begin
									      case(equal_cell[man_cell_num+5'd1])
											blank:
											     begin
												  man_cell_num<=man_cell_num+5'd1;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num+5'd1]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  if(equal_cell[man_cell_num+5'd2]==blank)
												      begin
												      man_cell_num<=man_cell_num+5'd1;
												      equal_cell[man_cell_num]<=blank;
												      equal_cell[man_cell_num+5'd1]<=man_exist;
														equal_cell[man_cell_num+5'd2]<=box_exist;
												      state<=draw_command;
														end
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
										   default:begin
											        end
											endcase
									  end
								 3'd1:
								     begin
									      case(equal_cell[man_cell_num+5'd1])
											blank:
											     begin
												  man_cell_num<=man_cell_num+5'd1;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num+5'd1]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  if(equal_cell[man_cell_num+5'd2]==blank)
												      begin
												      man_cell_num<=man_cell_num+5'd1;
												      equal_cell[man_cell_num]<=blank;
												      equal_cell[man_cell_num+5'd1]<=man_exist;
														equal_cell[man_cell_num+5'd2]<=box_exist;
												      state<=draw_command;
														end
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
										   default:begin
											        end
											endcase     
									  end
								 3'd2:
								     begin
									      case(equal_cell[man_cell_num+5'd1])
											blank:
											     begin
												  man_cell_num<=man_cell_num+5'd1;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num+5'd1]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  if(equal_cell[man_cell_num+5'd2]==blank)
												      begin
												      man_cell_num<=man_cell_num+5'd1;
												      equal_cell[man_cell_num]<=blank;
												      equal_cell[man_cell_num+5'd1]<=man_exist;
														equal_cell[man_cell_num+5'd2]<=box_exist;
												      state<=draw_command;
														end
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
										   default:begin
											        end
											endcase    
												 
									  end
								 3'd3:
								     begin
									      case(equal_cell[man_cell_num+5'd1])
											blank:
											     begin
												  man_cell_num<=man_cell_num+5'd1;
												  equal_cell[man_cell_num]<=blank;
												  equal_cell[man_cell_num+5'd1]<=man_exist;
												  state<=draw_command;
												  end
											box_exist:
											     begin
												  
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
										   default:begin
											        end
											endcase 
									  end
								 3'd4:
								     begin
									      case(equal_cell[man_cell_num+5'd1])
											blank:
											     begin
												  end
											box_exist:
											     begin
												  
												  end
										   barrier_exist:
											     begin
												  
												  end
											man_exist:
											     begin
												  
												  end
										   default:begin
											        end
											endcase 
									  end
								 default:begin
								         end
								 endcase
							end
					  default:
					      begin
							
							end
				 endcase
			end
	 draw_command://-----------------------------------------------------//
	      begin
			test_r<=1'b1;
			time_dis_r<=time_remain;
			if(time_remain==6'd0)
			win_or_lose_r<=2'b10;//失败
			else
			win_or_lose_r<=win_or_lose_r;
			
			/*begin
			    cell_draw_cnt<=10'd0;
			    if(cell_x>=3'd4)
				     begin
					      cell_x<=3'd0;
					      if(cell_y>=3'd3)
							begin
							    cell_y<=3'd0;
								 
							end
							else
							    cell_y<=cell_y+3'd1;
					  end
			    else
				     begin
					      cell_x<=cell_x+3'd1;
					  end
			end
		   else
		   begin
		       cell_draw_cnt<=cell_draw_cnt+10'd1;
		   end*/
			case(draw_step)
			3'd0:
			    begin
				         if(cell_x>=3'd4)
				         begin
					          cell_x<=3'd0;
					          if(cell_y>=3'd3)
							    begin
							        cell_y<=3'd0;
								 
						       end
							    else
							        cell_y<=cell_y+3'd1;
					      end
			            else
				             begin
					              cell_x<=cell_x+3'd1;
					          end  
				 draw_step<=3'd1;
				 
				 end
			3'd1:
			    begin
				      point_cnt_en_r<=1'b1; 
				      if(cell_draw_cnt>=19200)
					       begin
							 cell_draw_cnt<=0;
							 if(cell_num<=5'd18)//绘制20个格点
							 begin
							 draw_step<=3'd0;
							 point_cnt_en_r<=1'b0;
							 end
							 else
							 begin
							 state<=win_judge;//绘制完20个格点进入下一个状态
							 point_cnt_en_r<=1'b0;
							 draw_step<=3'd0;
							 end
							 end
						else
					       begin
							 cell_draw_cnt<=cell_draw_cnt+1;
						    end	
				 end
			default:
			     begin
				  end
			endcase
			
			
			
		   x0_r<=32*cell_x;
			y0_r<=30*cell_y;
			case(equal_cell[cell_num])
			blank:
			    begin
				 object_sel_r<=2'd0;
				 end
			box_exist:
			    begin
				 object_sel_r<=2'd1;
				 end
			barrier_exist:
			    begin
				 object_sel_r<=2'd2;
				 end
			man_exist:
			    begin
				 object_sel_r<=2'd3;
				 end
			default:state<=state;
			endcase
		
			end
	 win_judge://-----------------------------------------------------//
	      begin
			time_dis_r<=time_remain;
			test_r<=1'b0;
			if(time_remain>6'd0)
			begin
			    if((equal_cell[0]==box_exist) && (equal_cell[4]==box_exist) && (equal_cell[15]==box_exist) && (equal_cell[19]==box_exist))
			        begin
				     win_or_lose_r<=2'b11;//胜利
					  state<=win_lose;
				     end
				 else
				     begin
					  state<=position_move;
					  end
			end
			else
			begin
			    win_or_lose_r<=2'b10;//失败
				 state<=win_lose;
			end
			//state<=position_move;
			end
	 win_lose://-----------------------------------------------------//
	      begin
			gaming_r<=1'b0;
			end
	 default:state<=state;
	 endcase
    end
end
endmodule 