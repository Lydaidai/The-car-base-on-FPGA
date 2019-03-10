module avoid_obstacle_turn(clk,start,right_time,left_time,turn_right,turn_left,forward,back);//通过比较回响时间进行判断，给出转向信号
input clk,start;
input [19:0]left_time,right_time;
output reg turn_left,turn_right,forward,back;

always@(posedge clk)
begin
if(!start)
begin
	turn_left<=0;
	turn_right<=0;
	forward<=0;
	back<=0;
end

else
begin
/*	if((left_time>=200000)&&(right_time>=200000))
	begin
		turn_left<=0;
		turn_right<=0;
		forward<=1;
		back<=0;
	end
	else if((left_time>right_time)&&(200000>right_time>100000))
	begin
		turn_right<=0;
		turn_left<=1;
		forward<=1;
		back<=0;		
	end
	else if((left_time<=right_time)&&(200000>left_time>100000))
	begin
		turn_right<=1;
		turn_left<=0;
		forward<=1;
		back<=0;
	end
	else if((left_time<=100000)&&(right_time<=100000))
	begin
		forward<=0;
		back<=0;
		turn_left<=0;
		turn_right<=0;
	end
	else
	begin
		turn_right<=0;
		turn_left<=0;
		forward<=1;
		back<=0;
	end*/
	if((right_time>=200000)&&(left_time>=200000))
	begin
		turn_right<=0;
		turn_left<=0;
		forward<=0;
		back<=0;
	end
	else if(right_time<200000)
	begin
		turn_right<=1;
		turn_left<=0;
		forward<=0;
		back<=0;
	end
	else if(left_time<200000)
	begin
		turn_right<=1;
		turn_left<=0;
		forward<=0;
		back<=0;
	end
	else
	begin
		turn_right<=0;
		turn_left<=0;
		forward<=0;
		back<=0;
	end
end


end

endmodule