module Display									//数码管显示模块
(
	input clk,reset,M,					//输入时钟信号，异步清零信号，灭屏信号
	input [3:0] dig3,dig2,dig1,dig0,		//四个数码管对应的值
	output reg [3:0] scan,					//扫描选通端
	output reg [6:0] display				//译码后显示信号
);

//分频器
reg[15:0] count;

always @ (posedge clk,negedge reset)
	if(!reset)
			count<=0;
	else
			count<=count+1'b1;
	
wire key_clk=count[15];						//f=50MHz/2^16=763Hz T=1.3ms
//分频器结束

//状态机
parameter DIG0 = 4'b0001;
parameter DIG1 = 4'b0010;
parameter DIG2 = 4'b0100;
parameter DIG3 = 4'b1000;
reg [3:0] current,next;							
reg [3:0] number;									//记录数码管输入信号

//状态方程
always @ (posedge key_clk)
	current<=next;

//驱动方程
always @ (current)
	case(current)
		DIG3: next<= DIG2;
		DIG2: next<= DIG1;
		DIG1: next<= DIG0;
		DIG0: next<= DIG3;
	endcase

//输出方程
always @ (current)
	case(current)
		DIG3: scan <= DIG3;
		DIG2: scan <= DIG2;
		DIG1: scan <= DIG1;
		DIG0: scan <= DIG0;
	endcase
//扫描选通电路结束

//显示电路
always @ *
	case(current)
		DIG3:
			begin
				if(M==0)					//灭零信号
					number<=4'b1111;		//控制数码管是否全灭（用16标记全灭）
				else
					number<=dig3;
			end
		DIG2:
			begin
				if(M==0)
					number<=4'b1111;
				else
					number<=dig2;
			end
		DIG1:
			begin
				if(M==0)
					number<=4'b1111;
				else
					number<=dig1;
			end
		DIG0:
			begin
				if(M==0)
					number<=4'b1111;
				else
					number<=dig0;
			end
	endcase

//译码器
always @ (number)
	case(number)
		4'b0000: display <= 7'b1111110;
		4'b0001: display <= 7'b0110000;
		4'b0010: display <= 7'b1101101;
		4'b0011: display <= 7'b1111001;
		4'b0100: display <= 7'b0110011;
		4'b0101: display <= 7'b1011011;
		4'b0110: display <= 7'b1011111;
		4'b0111: display <= 7'b1110000;
		4'b1000: display <= 7'b1111111;
		4'b1001: display <= 7'b1111011;
		4'b1111: display <= 7'b0000000;	
		default: display <= 7'b1111110;	
	endcase
//状态机结束

endmodule
