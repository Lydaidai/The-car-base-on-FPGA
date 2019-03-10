module bluetooth_receive(
input Rx,
input inclk,
output reg [2:0]c_s
);

reg[14:0] count;		//分频计数
reg clk_9600;			//9600Hz分频
reg[3:0] count_1;		//接收数据计数
reg[7:0] RX_DATA;		//所接受的数据
reg[1:0]	state;		//控制接收状态

initial
begin
RX_DATA <= 0;
state	<= 2'b00;
c_s<=2'b00;
end

//分频至9600Hz
always @(posedge inclk)
begin
	if(count==2603)
	begin
		clk_9600<=~clk_9600;
		count<=0;
	end
	else
	begin
	count<=count+1;
	end			
end

//接收数据
always @(posedge clk_9600)
begin
	if(Rx == 0 && state == 2'b00)
	begin
			state <= 2'b01;
	end
	else if(state == 2'b01)
			begin
			if(count_1 == 8)
				begin
				count_1 <= 0;
				state <= 2'b00;
				end
			else 
				begin
				RX_DATA[count_1] <= Rx;
				count_1 <= count_1+1;
				end
			end
end

//输出信号
always @(posedge clk_9600)
begin
	case(RX_DATA)
		8'b01010111:c_s <= 3'b011; //前进
		8'b01010011:c_s <= 3'b100;	//后退
		8'b01000001:c_s <= 3'b101;	//左转
		8'b01000100:c_s <= 3'b110;	//右转
		8'b01000010:c_s <= 3'b111;	//静止
		8'b00110001:c_s <= 3'b001;	//通路一
		8'b00110010:c_s <= 3'b010;	//通路二
		default:;
	endcase
end
endmodule