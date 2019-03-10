module buletooth_data(clk,start1,start2,signal,turn_right,turn_left,forward,back);
//因为根据不同的信号让小车有不同的路径，现在设想是根据不同的信号，先转向，前进一段距离进入不同的轨道
//这里的turn信号都需要设定一定的长度，使得小车可以进入轨道，之后就正常工作
//start应该可以一直给，之后再考虑
//现在有6种信号，当给前后左右的信号时，超声波模块和红外模块都应该不工作，也就是start为0
//电机和舵机的转弯都用或门连接到一起
input [2:0]signal;
input clk;
output reg start1,turn_left,turn_right,forward,back,start2;

reg [19:0]count;
initial
begin
	count<=0;
	start1<=0;
	start2<=0;
	turn_left<=0;
	turn_right<=0;
	forward<=0;
	back<=0;
end


always@(posedge clk)
begin
	if(signal==7)
	begin
		start1<=0;
		start2<=0;
		turn_left<=0;
		turn_right<=0;
		forward<=0;
		back<=0;
	end
	
	else if(signal==1)//通路一，循迹
	begin
		start1<=0;
		start2<=1;
		turn_right<=0;
		turn_left<=0;
	end
	
	else if(signal==2)//通路二，蜂鸣器，音乐
	begin
		start2<=0;
		start1<=0;
		turn_left<=0;
		turn_right<=0;
	end
	
	else if(signal==3)//前进
	begin
		start1<=0;
		start2<=0;
		forward<=1;
		back<=0;
		turn_left<=0;
		turn_right<=0;
	end
	
	else if(signal==4)//后退
	begin
		start1<=0;
		start2<=0;
		forward<=0;
		back<=1;
		turn_left<=0;
		turn_right<=0;
	end
	
	else if(signal==5)//左转
	begin
		start1<=0;
		start2<=0;
		forward<=1;
		back<=0;
		turn_left<=1;
		turn_right<=0;
	end
	else if(signal==6)//右转
	begin
		start1<=0;
		start2<=0;
		forward<=1;
		back<=0;
		turn_left<=0;
		turn_right<=1;
	end
	
	else
	begin
		
	end
	
end




endmodule