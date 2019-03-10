module NEW_C(
//input [2:0] c_s_1,
input [2:0] c_s_2,
input [3:0] kb_out,	
input clk,
input reset,
output reg [2:0] c_s_o,
output reg [3:0] DIG3,
output reg [3:0] DIG2,
output reg [3:0] DIG1,
output reg [3:0] DIG0,
output reg loud,
output reg M
//output reset
);

//分频器
reg[19:0] count;

always @ (posedge clk)
		begin
			count<=count+1'b1;
		end

wire key_clk=count[19];				//f=50MHz/2^20=47Hz T=21ms
//分频器结束

/*parameter WORK1=7'b0000001;	
parameter WORK2=7'b0000010;	
parameter NUM1=7'b0000100;
parameter NUM2=7'b0001000;
parameter NUM3=7'b0010000;
parameter NUM4=7'b0100000;
parameter ENSURE=7'b1000000;*/

//reg [6:0] current,next;
reg [3:0] IN_PSWD_0;
reg [3:0] IN_PSWD_1;
reg [3:0] IN_PSWD_2;
reg [3:0] IN_PSWD_3;
reg [3:0] PSWD_0;
reg [3:0] PSWD_1;
reg [3:0] PSWD_2;
reg [3:0] PSWD_3;
reg [3:0] num;
reg [3:0] state;
reg start;
reg GOGO;
reg [31:0]count_1;
reg outclk;

initial
begin
PSWD_0 <= 4'h2;
PSWD_1 <= 4'h0;
PSWD_2 <= 4'h1;
PSWD_3 <= 4'h8;
DIG0 <= 0;
DIG1 <= 0;
DIG2 <= 0;
DIG3 <= 0;
M <= 0;
//current <= WORK1;
//next <= WORK1;
IN_PSWD_0 <= 0;
IN_PSWD_1 <= 0;
IN_PSWD_2 <= 0;
IN_PSWD_3 <= 0;
num <= 0;
loud <= 0;
state <= 0;
start <= 0;
GOGO <= 0;
count_1 <= 0;
end

//状态方程
always @ (posedge key_clk, negedge reset)
		begin
		if(!reset)
			begin
				GOGO <= 0;
			end
		else
			begin
			/*if(kb_out == 4'ha)							
				num<=4'hf;
			else
				num<=kb_out;*/
			case(state)
			3'b000:
				begin
					if(!GOGO)
						state <= 3'b001;
					else
						begin
							//c_s_o <= c_s_2;
							state <= 3'b000;
						end
				end
			3'b001:
				begin
					if(kb_out == 4'ha)
						begin
						state <= 3'b010;
						M <= 1;
						end
					else
						state <= 3'b001;
				end
			3'b010:
				begin
					if(loud ==1 && count_done == 1)
						begin
							loud <= 0;
							start <= 0;
						end
					else if(kb_out != num && num != 4'hf && num>=0 && num<=9)	
							begin
							state <= 3'b011;
							IN_PSWD_0 <= num;
							//IN_PSWD_1 <= 0;
							//IN_PSWD_2 <= 0;
							//IN_PSWD_3 <= 0;
							DIG0 <= num;
							DIG1 <= 0;
							DIG2 <= 0;
							DIG3 <= 0;
							end
							else if(kb_out == 4'hb)
								begin
								state <= 3'b010;
								DIG0 <= 0;
								DIG1 <= 0;
								DIG2 <= 0;
								DIG3 <= 0;
								IN_PSWD_0 <= 0;
								IN_PSWD_1 <= 0;
								IN_PSWD_2 <= 0;
								IN_PSWD_3 <= 0;
								end
							else 
								state <= 3'b010;
				end
			3'b011:
				begin
					if(kb_out != num && num != 4'hf && num>=0 && num<=9)	
						begin
						state <= 3'b100;
						IN_PSWD_1 <= num;
						//IN_PSWD_1 <= 0;
						//IN_PSWD_2 <= 0;
						//IN_PSWD_3 <= 0;
						DIG0 <= num;
						DIG1 <= IN_PSWD_0;
						DIG2 <= 0;
						DIG3 <= 0;
						end
				else if(kb_out == 4'hb)
							begin
							state <= 3'b010;
							DIG0 <= 0;
							DIG1 <= 0;
							DIG2 <= 0;
							DIG3 <= 0;
							IN_PSWD_0 <= 0;
							IN_PSWD_1 <= 0;
							IN_PSWD_2 <= 0;
							IN_PSWD_3 <= 0;
							end
						else 
							state <= 3'b011;
				end
			3'b100:
				begin
					if(kb_out != num && num != 4'hf && num>=0 && num<=9)	
						begin
						state <= 3'b101;
						IN_PSWD_2 <= num;
						//IN_PSWD_1 <= 0;
						//IN_PSWD_2 <= 0;
						//IN_PSWD_3 <= 0;
						DIG0 <= num;
						DIG1 <= IN_PSWD_1;
						DIG2 <= IN_PSWD_0;
						DIG3 <= 0;
						end
				else if(kb_out == 4'hb)
							begin
							state <= 3'b010;
							DIG0 <= 0;
							DIG1 <= 0;
							DIG2 <= 0;
							DIG3 <= 0;
							IN_PSWD_0 <= 0;
							IN_PSWD_1 <= 0;
							IN_PSWD_2 <= 0;
							IN_PSWD_3 <= 0;
							end
						else 
							state <= 3'b100;
				end
			3'b101:
				begin
					if(kb_out != num && num != 4'hf && num>=0 && num<=9)	
						begin
						state <= 3'b110;
						IN_PSWD_3 <= num;
						//IN_PSWD_1 <= 0;
						//IN_PSWD_2 <= 0;
						//IN_PSWD_3 <= 0;
						DIG0 <= num;
						DIG1 <= IN_PSWD_2;
						DIG2 <= IN_PSWD_1;
						DIG3 <= IN_PSWD_0;
						end
				else if(kb_out == 4'hb)
							begin
							state <= 3'b010;
							DIG0 <= 0;
							DIG1 <= 0;
							DIG2 <= 0;
							DIG3 <= 0;
							IN_PSWD_0 <= 0;
							IN_PSWD_1 <= 0;
							IN_PSWD_2 <= 0;
							IN_PSWD_3 <= 0;
							end
						else 
							state <= 3'b101;
				end
			3'b110:
				begin
					if(kb_out == 4'hc)							
						begin
							if(IN_PSWD_3 == PSWD_3 && IN_PSWD_2 == PSWD_2 && IN_PSWD_1 == PSWD_1 && IN_PSWD_0 == PSWD_0)
							begin
							state <= 3'b000;
							GOGO <= 1;
							M <= 0;
							DIG0 <= 0;
							DIG1 <= 0;
							DIG2 <= 0;
							DIG3 <= 0;
							IN_PSWD_0 <= 0;
							IN_PSWD_1 <= 0;
							IN_PSWD_2 <= 0;
							IN_PSWD_3 <= 0;
							end
							else 
								begin
								state <= 3'b010;
								loud <= 1;
								start <= 1;
								M <= 1;
								DIG0 <= 0;
								DIG1 <= 0;
								DIG2 <= 0;
								DIG3 <= 0;
								IN_PSWD_0 <= 0;
								IN_PSWD_1 <= 0;
								IN_PSWD_2 <= 0;
								IN_PSWD_3 <= 0;
								end
							//蜂鸣器响两秒
						end
					else if(kb_out==4'hb)
							begin				
							state <= 3'b010;
							DIG0 <= 0;
							DIG1 <= 0;
							DIG2 <= 0;
							DIG3 <= 0;
							IN_PSWD_0 <= 0;
							IN_PSWD_1 <= 0;
							IN_PSWD_2 <= 0;
							IN_PSWD_3 <= 0;
							end
					else
							state <= 3'b110;
				end
			default:;
			endcase	
			if(kb_out == 4'ha)							
				num<=4'hf;
			else
				num<=kb_out;
			end
		end

		
//计时两秒模块
reg [32:0] timer_count;					

always @ (posedge clk)
begin
	if(!start)
		timer_count<=0;
	else if(timer_count != 100000000)
				timer_count<=timer_count+1;
			else
				timer_count <= timer_count;
end
			
assign count_done =(timer_count == 100000000);


//分频至1000Hz
always @(posedge clk)
begin
	if(count_1 == 10000)
		begin
		outclk <= ~outclk;
		count_1<=0;                               
		end
	else
	begin
	count_1<=count_1+1;
	end			
end

always @ (posedge outclk)
begin
	if(GOGO)
		c_s_o <= c_s_2;
end
/*		
//驱动方程
always @ /
begin
	case(current)
		WORK1:											
			if(c_s_2 == 0)							
				begin
				next<=WORK1;
				//M <= 0;
				end
			else
				next<=WORK2;
		WORK2:											
			begin
				if(kb_out == 4'ha)	
						begin
						next<=NUM1;
						M <= 1;
						//loud <= 0;
						end
				else
					begin
						next<=WORK2;
						//M<=0;
					end
			end
		NUM1:											
			if(kb_out>=0 && kb_out<=9)	
				begin
				next<=NUM2;
				end
				else if(kb_out==4'hb)
							begin
							next<=NUM1;
							end
						else if(kb_out==4'hf)	
								next<=NUM1;	
									else 
										next <= NUM1;
		NUM2:											
			if(kb_out>=0 && kb_out<=9)	
				begin
				next<=NUM3;
				end
				else if(kb_out==4'hb)						
							begin
							next<=NUM1;
							end
						else if(kb_out==4'hf)	
								next<=NUM2;	
								else 
									next <= NUM2;		
		NUM3:											
			if(kb_out>=0 && kb_out<=9)	
				begin
				next<=NUM4;
				end
				else if(kb_out==4'hb)						
							begin
							next<=NUM1;
							end
						else if(kb_out==4'hf)	
								next<=NUM3;	
									else 
									next <= NUM3;		
		NUM4:											
			if(kb_out>=0 && kb_out<=9)	
				begin
				next<=ENSURE;
				end
				else if(kb_out==4'hb)						
							begin
							next<=NUM1;
							end
						else if(kb_out==4'hf)	
								next<=NUM4;
									else 
									next <= NUM4;			
		ENSURE:		
			begin
			if(kb_out == 4'hc)							
				begin
					if(IN_PSWD_3 == PSWD_3 && IN_PSWD_2 == PSWD_2 && IN_PSWD_1 == PSWD_1 && IN_PSWD_0 == PSWD_0)
						begin
						next <= WORK1;
						//M <= 0;
						end
					else 
						begin
						next <= WORK2;
						//loud <= 1;
						//M <= 1;
						end
						//蜂鸣器响一声
				end
			else if(kb_out==4'hb)
					begin				
					next<=NUM1;
					end
					else if(kb_out==4'hf)	
								next<=ENSURE;	
							else
								next<=ENSURE;
			end					
		default:
			next<=WORK1;
	endcase
end

//输出方程

always @(posedge key_clk)
begin
	case(next)//
		WORK1:
			c_s_o <= c_s_1;
		WORK2:
				begin
					if(current == WORK1)
						c_s_o <= c_s_2;
					else 
						begin
						c_s_o <= c_s_2;//
						end
				end
		default:;
	endcase
end

always @(posedge key_clk)
begin
	case(current)//
		WORK1:											
				begin		
					IN_PSWD_0 <= 0;
					IN_PSWD_1 <= 0;
					IN_PSWD_2 <= 0;
					IN_PSWD_3 <= 0;
				end
		WORK2:
				begin
					DIG0 <= 0;
					DIG1 <= 0;
					DIG2 <= 0;
					DIG3 <= 0;
					IN_PSWD_0 <= 0;
					IN_PSWD_1 <= 0;
					IN_PSWD_2 <= 0;
					IN_PSWD_3 <= 0;
				end
		NUM1:											
			if(kb_out!= num && num!=4'hf) //防抖 相同忽数字略 且输入非无效
				begin
					IN_PSWD_0 <= num;
					IN_PSWD_1 <= 0;
					IN_PSWD_2 <= 0;
					IN_PSWD_3 <= 0;
					DIG0 <= num;
					//DIG0 <= IN_PSWD_0;
					DIG1 <= 0;
					DIG2 <= 0;
					DIG3 <= 0;
				end
		NUM2:
			if(kb_out != num && num != 4'hf )				
            begin
					IN_PSWD_1 <= num;
					DIG1 <= DIG0;
					DIG0 <= num;
					//DIG0 <= IN_PSWD_1;
					DIG2 <= 0;
					DIG3 <= 0;
			   end
		NUM3:
			if(kb_out!=num && num!=4'hf) //防抖 相同忽数字略 且输入非无效
				begin
					IN_PSWD_2 <= num;
					DIG2 <= DIG1;
					DIG1 <= DIG0;
					DIG0 <= num;
					//DIG0 <= IN_PSWD_2;
					DIG3 <= 0;
				end
		NUM4:											
			if(kb_out!= num && num!=4'hf) //防抖 相同忽数字略 且输入非无效
				begin
					IN_PSWD_3 <= num;
					DIG3 <= DIG2;
					DIG2 <= DIG1;
					DIG1 <= DIG0;
					DIG0 <= num;
					//DIG0 <= IN_PSWD_3;
				end
		ENSURE:
			begin
				//loud <= 1;
			end
		default:;
		endcase
		if(kb_out == 4'ha)							
			num<=4'hf;
		else
			num<=kb_out;
end
*/
endmodule 
