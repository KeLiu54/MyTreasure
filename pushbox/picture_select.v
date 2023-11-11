module picture_select(clk50M,rst_n,gaming,win_or_lose,x_in,y_in,colour_in,writeEn_in,x_choose,y_choose,colour_choose,writeEn_choose);
input clk50M,rst_n,gaming;//gaming是游戏状态标志，在游戏中为1，不在游戏中为0
input [1:0] win_or_lose;
input [7:0] x_in;
input [6:0] y_in;
input [2:0] colour_in;
input writeEn_in;
output [7:0] x_choose;
output [6:0] y_choose;
output [2:0] colour_choose;
output writeEn_choose;
reg [7:0] x_choose_r;
reg [6:0] y_choose_r;
reg [2:0] colour_choose_r;
reg writeEn_choose_r;
reg [15:0] ram_address_init;//初始画面的RAM地址
reg [15:0] ram_address_win;//胜利画面的RAM地址
reg [15:0] ram_address_lose;//失败画面的RAM地址
wire [2:0] colour_init_w,colour_win_w,colour_lose_w;
assign x_choose=gaming?x_in:x_choose_r;
assign y_choose=gaming?y_in:y_choose_r;
assign colour_choose=gaming?colour_in:colour_choose_r;
assign writeEn_choose=gaming?writeEn_in:writeEn_choose_r;
always@(posedge clk50M or negedge rst_n)
begin
if(!rst_n)
    begin
    x_choose_r<=8'd0;
    y_choose_r<=7'd0;
    colour_choose_r<=3'd0;
    writeEn_choose_r<=1'b0;
	 ram_address_init<=15'd0;
	 ram_address_win<=15'd0;
	 ram_address_lose<=15'd0;
    end
else
    begin
	 
	 
	 //=============选择对应的RAM输出==============================//
	 if(gaming==1'b0 || gaming==1'b1)
	 begin
	 
	 
					 
	 if(win_or_lose==2'b11)
            begin
		      if(x_choose_r>=8'd159)
	             begin
	             x_choose_r<=8'd0;
		          if(y_choose_r>=7'd119)
		              begin
				        y_choose_r<=7'd0;
				        end
		          else
		              begin
				        y_choose_r<=y_choose_r+7'd1;
				        end
	             end
	         else
	             begin
	         	 x_choose_r<=x_choose_r+8'd1;
		          end
	 
	         colour_choose_r<=colour_win_w;
	         writeEn_choose_r<=1'b1;
	             if(ram_address_win>=16'd19199)
					 begin
					 ram_address_win<=15'd0;
					 end
					 else
					 begin
	             ram_address_win<=ram_address_win+16'd1;
					 end
            end
	     else if(win_or_lose==2'b10)
	         begin
		      if(x_choose_r>=8'd159)
	             begin
	             x_choose_r<=8'd0;
		          if(y_choose_r>=7'd119)
		              begin
				        y_choose_r<=7'd0;
				        end
		          else
		              begin
				        y_choose_r<=y_choose_r+7'd1;
				        end
	             end
	         else
	             begin
	         	 x_choose_r<=x_choose_r+8'd1;
		          end
	 
	             colour_choose_r<=colour_lose_w;
	             writeEn_choose_r<=1'b1;
					 if(ram_address_lose>=16'd19199)
					 begin
					 ram_address_lose<=16'd0;
					 end
					 else
					 begin
	             ram_address_lose<=ram_address_lose+16'd1;
					 end
		      end
		  else if(win_or_lose==2'b00)
		  begin
		  if(x_choose_r>=8'd159)
	     begin
	     x_choose_r<=8'd0;
		  if(y_choose_r>=7'd119)
		      begin
				y_choose_r<=7'd0;
				end
		  else
		      begin
				y_choose_r<=y_choose_r+7'd1;
				end
	     end
	 else
	     begin
		  x_choose_r<=x_choose_r+8'd1;
		  end
	 
	 colour_choose_r<=colour_init_w;
	 writeEn_choose_r<=1'b1;
	             if(ram_address_init>=16'd19199)
					 begin
					 ram_address_init<=16'd0;
					 end
					 else
					 begin
	             ram_address_init<=ram_address_init+16'd1;
					 end
		  end
		  else
		      begin
				writeEn_choose_r<=1'b0;
				ram_address_win<=16'd0;
				ram_address_lose<=16'd0;
				x_choose_r<=10'd0;
				y_choose_r<=10'd0;
				end
	 end
	 
        
	 
	 //===========================================//
    end
end
ram_init ram_init_u(
   .address(ram_address_init),
	.clock(clk50M),
	.data(3'd0),
	.wren(1'd0),
	.q(colour_init_w));
ram_win ram_win_u(
   .address(ram_address_win),
	.clock(clk50M),
	.data(3'd0),
	.wren(1'd0),
	.q(colour_win_w));
ram_lose ram_lose_u(
   .address(ram_address_lose),
	.clock(clk50M),
	.data(3'd0),
	.wren(1'd0),
	.q(colour_lose_w));
endmodule 