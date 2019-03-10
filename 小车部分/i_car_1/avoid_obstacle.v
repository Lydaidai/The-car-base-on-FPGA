module avoid_obstacle(clk,start,right_echo,left_echo,turn_right,turn_left);//超声波避障模块
input clk,start,right_echo,left_echo;	//时钟，启动信号，右，左回响时间
output reg turn_right,turn_left;	//右转，左转信号

reg [19:0]riht_count;
reg [19:0]left_count;

always@(posedge clk)
begin
	if(!start)
	begin
		turn_left<=0;
		turn_right<=0;
	end
	else
	begin
	
	end



end
endmodule