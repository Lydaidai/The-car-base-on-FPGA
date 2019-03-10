module CPU_2(
input clk,
input reset,
input signed [15:0] AX_DATA,
input signed [15:0] AY_DATA,
output reg [2:0] c_s
);

//分频器
reg[21:0] count;

always @ (posedge clk,negedge reset)
	if(!reset)
		begin
			count<=0;
		end
	else
		begin
			count<=count+1'b1;
		end

wire key_clk=count[21];				//f=50MHz/2^22=12Hz 
//分频器结束

//设置四个方向加速度阈值
reg signed [15:0] T_AX_W;
reg signed [15:0] T_AX_S;
reg signed [15:0] T_AY_A;
reg signed [15:0]	T_AY_D;

initial 
begin
	T_AX_W <= 16'h2EE0;//12000
	T_AX_S <= 16'hD120;
	T_AY_A <= 16'hC568;
	T_AY_D <= 16'h3A98;
end


always @(posedge key_clk)
begin
	if(AY_DATA > T_AY_D)
		c_s <= 3'b110;
		else if(AY_DATA < T_AY_A)
					c_s <= 3'b101;
				else if(AX_DATA > T_AX_W)
							c_s <= 3'b011;
						else if(AX_DATA < T_AX_S)
									c_s <= 3'b100;
								else 
									begin
										c_s <= 3'b111;
									end
end 
endmodule 