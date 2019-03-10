module follow(clk,start,signal,turn_right,turn_left,forward,back,enable,start11);//循迹模块，根据输入信号的不同，做不同的动作
input clk,start,enable;
input [3:0]signal;	//四对红外对管发出的信号
output reg turn_left,turn_right,forward,back,start11;	//左右转信号

always@(posedge clk)
begin
	if(!start)
	begin
		turn_left<=0;
		turn_right<=0;
		forward<=0;
		back<=0;
		start11<=0;
	end
	else
	begin
		case(signal)
		4'b1111:begin
					turn_left<=0;
					turn_right<=0;
					forward<=1;
					back<=0;
					start11<=0;
				end
		4'b1110:begin
					turn_left<=1;
					turn_right<=0;
					forward<=1;
					back<=0;
					start11<=0;
				end
		4'b0111:begin
					turn_left<=0;
					turn_right<=1;
					forward<=1;
					back<=0;
					start11<=0;
				end
		4'b1100:begin
					turn_left<=1;
					turn_right<=0;
					forward<=1;
					back<=0;
					start11<=0;
				end
		4'b0011:begin
					turn_left<=0;
					turn_right<=1;
					forward<=1;
					back<=0;
				end
		4'b1000:begin
					turn_left<=1;
					turn_right<=0;
					forward<=1;
					back<=0;
					start11<=0;
				end
		4'b0001:begin
					turn_left<=0;
					turn_right<=1;
					forward<=1;
					back<=0;
					start11<=0;
				end
		4'b0000:begin
					if(!enable)
					begin
						turn_left<=0;
						turn_right<=0;
						forward<=0;
						back<=0;
						start11<=0;
					end
					else if(enable)
					begin
						turn_left<=0;
						turn_right<=0;
						forward<=1;
						back<=0;
						start11<=1;
					end
				end
		default:begin
					turn_left<=0;
					turn_right<=0;
					forward<=1;
					back<=0;
				end
		endcase
	end

end

endmodule