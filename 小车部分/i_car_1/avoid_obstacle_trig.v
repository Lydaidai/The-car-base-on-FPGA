module avoid_obstacle_trig(clk,start,trig);		//给超声波模块触发信号，因为是同时运行，可以把触发信号放到一起
input clk,start;	//时钟，启动信号
output reg trig;	//触发信号

reg [23:0]count;	//计数，在这里依旧用50M的时钟

always@(posedge clk)
begin
	if(!start)
	begin
		count<=0;
		trig<=0;
	end
	else
    begin
        if (4999000==count)
        begin
            trig<= 1;
            count<=count+1;
        end
        else 
        begin
            if (count==5000000)
            begin
                trig<=0;
                count<= 0;
            end
            else
                count<=count+1;
        end
		end
end

endmodule
