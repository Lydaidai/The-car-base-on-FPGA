module avoid_obstacle_right(clk,echo,right_time);//超声波避障模块,右部分
input clk,echo;	//时钟，回响信号
output reg [19:0]right_time;	//回响时间

reg [19:0]count;
//reg [19:0]count_out;

always@(posedge clk)
begin
	if(echo)
	begin
		count<=count+1;
	end
	else
	begin
		if(count!=0)
		begin
			right_time<=count;//如果在回响信号为0时，计数信号不为0，那么就把计数时间赋值给回想时间
			count<=0;
		end
		else
		begin
//		right_time<=0;	//如果在回响信号为0时，计数信号为0，那么就意味没有计时，所以给一个0信号，在之后的考虑中，不能认为0是接触
		end
	end
end
/*
always@(negedge echo)
begin
	right_time<=count;
end
*/
endmodule