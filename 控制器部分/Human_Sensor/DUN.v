module DUN(
	input clk,
	input reset,
	input signed [15:0] AX_DATA,
	input signed [15:0] AY_DATA,
	input signed [15:0] AZ_DATA,
	//input signed [15:0] GZ_DATA,
	output reg[7:0] CT_S,
	output reg duns
);

//分频器
reg[18:0] count;

always @ (posedge clk,negedge reset)
	if(!reset)
		begin
			count<=0;
		end
	else
		begin
			count<=count+1'b1;
		end

wire key_clk=count[18];				//f=50MHz/2^20=47Hz T=21ms
//分频器结束

//设定阈值
reg signed [15:0] T_GRAVITY; //z轴重力加速度阈值1
reg [31:0] T_SVM_2;	//SVM阈值
reg signed [15:0] T_AXG;	//x轴重力加速度阈值
reg signed [15:0] T_AZG; //z轴重力加速度阈值2
reg signed [15:0] T_AYG; //z轴重力加速度阈值2

//存储计算值
reg signed [15:0] GRAVITY; 
reg [31:0] SVM_2;	
reg signed [15:0] AXG;
reg signed [15:0] AZG;	
reg signed [15:0] AYG;	

reg [2:0] state;//存储状态
wire time_done;//计时
reg trigger;

initial
	begin
	T_GRAVITY<=18000; 
	//T_GRAVITY<=8200; 
	T_SVM_2<=500000000;	
	T_AXG <= 10000;
	T_AZG <= 3000;
	T_AYG <= 10000;
	GRAVITY<=30; 
	SVM_2<=0;	
	//ANGLE<=0;	
	state<=0;
	duns <= 0;
	/*C_S[0]<=AZ_DATA[8];
	C_S[1]<=AZ_DATA[9];
	C_S[2]<=AZ_DATA[10];
	C_S[3]<=AZ_DATA[11];
	C_S[4]<=AZ_DATA[12];
	C_S[5]<=AZ_DATA[13];
	C_S[6]<=AZ_DATA[14];
	C_S[7]<=AZ_DATA[15];*/
	CT_S<=0;
	//CT_SS <= 0;
	end
	
always @(posedge key_clk,negedge reset)
begin
	if(!reset)
		begin
		GRAVITY<=0; 
		SVM_2<=0;	
		//ANGLE<=0;	
		state<=0;
		//CT_S<=0;
		end
	else if(state == 3'b000)
			begin
			/*C_S[0]<=AZ_DATA[0];
			C_S[1]<=AZ_DATA[1];
			C_S[2]<=AZ_DATA[2];
			C_S[3]<=AZ_DATA[3];
			C_S[4]<=AZ_DATA[4];*/
			CT_S[5]<=0;
			CT_S[6]<=0;
			//CT_S[7]<=0;
			//C_S0 <= 0;
			duns <= 0;
			GRAVITY <= AZ_DATA;
			state <= 3'b001;
			end
			else if(state == 3'b001)
					begin
					if(GRAVITY < T_GRAVITY && GRAVITY > 0)
						begin
						state <= 3'b010;//010
						CT_S[5]<=1;
						end
					else 
					state <= 3'b000;
					end
					else if(state == 3'b010)
							begin
							//C_S[6]<=1;
							SVM_2 <= AX_DATA*AX_DATA+AY_DATA*AY_DATA+AZ_DATA*AZ_DATA;
							state <= 3'b011;
							end
							else if(state == 3'b011)
									begin
									if(SVM_2 > T_SVM_2)
										begin
										state <= 3'b100;
										//C_S[2]<=1;
										CT_S[6] <= 1;
										duns<=1;
										end
									else 
									state <= 3'b000;
									end
									else if(state == 3'b100 && trigger == 0)
											begin
											trigger <= 1;
											
											end
											else if(trigger == 1 && count_done == 1)
												begin
														trigger <= 0;
														state <= 3'b000;
												end
												else
													begin
													end
end

//计时两秒模块
reg [32:0] timer_count;					

always @ (posedge clk)
begin
	if(!trigger)
		timer_count<=0;
	else if(timer_count != 100000000)
				timer_count<=timer_count+1;
			else
				timer_count <= timer_count;
end
			
assign count_done =(timer_count == 100000000);
	
endmodule 