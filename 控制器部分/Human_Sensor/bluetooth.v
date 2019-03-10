module bluetooth(
input inclk,
input [2:0]c_s,
output reg Tx
);

reg[14:0] count;		//分频计数
reg clk_9600;			//9600Hz分频
reg[3:0] count_1;		//发送数据计数
reg[9:0] TX_DATA_W;		//所发送的数据
reg[9:0] TX_DATA_S;
reg[9:0] TX_DATA_A;
reg[9:0] TX_DATA_D;
reg[9:0] TX_DATA_B;
reg[9:0] TX_DATA_1;
reg[9:0] TX_DATA_2;
reg[9:0] TX_DATA_0;
reg[3:0] state;		//发送数据状态

initial
begin
TX_DATA_W <= 10'b1010101110;
TX_DATA_S <= 10'b1010100110;
TX_DATA_A <= 10'b1010000010;
TX_DATA_D <= 10'b1010001000;
TX_DATA_B <= 10'b1010000100;
TX_DATA_1 <= 10'b1001100010;
TX_DATA_2 <= 10'b1001100100;
TX_DATA_0 <= 10'b1001100000;
clk_9600 <=0;
count <= 0;
count_1<=0;
state<=4'b0000;
end

//分频至9600Hz
always @(posedge inclk)
begin
	if(count == 2603)
		begin
		clk_9600 <= ~clk_9600;
		count<=0;                               
		end
	else
	begin
	count<=count+1;
	end			
end

//发送数据
always @(posedge clk_9600)
begin
	if(c_s == 3'b001 && state == 4'b0000)
	begin
			if(count_1 == 10)
				begin
				count_1 <= 0;
				state <= 4'b0001;
				Tx<=1;
				end
			else 
				begin
				Tx <= TX_DATA_1[count_1];
				count_1 <= count_1+1;
				end
	end
	else if(c_s == 3'b010 && state == 4'b0000)
			begin
				if(count_1 == 10)
				begin
				count_1 <= 0;
				state <= 4'b0010;
				Tx<=1;
				end
			else 
				begin
				Tx <= TX_DATA_2[count_1];
				count_1 <= count_1+1;
				end
			end
			else if(c_s == 3'b011 && state == 4'b0000)
					begin
					if(count_1 == 10)
						begin
						count_1 <= 0;
						state <= 4'b0011;
						Tx<=1;
						end
					else 
						begin
						Tx <= TX_DATA_W[count_1];
						count_1 <= count_1+1;
						end
					end
					else if(c_s == 3'b100 && state == 4'b0000)
							begin
							if(count_1 == 10)
								begin
								count_1 <= 0;
								state <= 4'b0100;
								Tx<=1;
								end
							else 
								begin
								Tx <= TX_DATA_S[count_1];
								count_1 <= count_1+1;
								end
							end
							else if(c_s == 3'b101 && state == 4'b0000)
									begin
									if(count_1 == 10)
										begin
										count_1 <= 0;
										state <= 4'b0101;
										Tx<=1;
										end
									else 
										begin
										Tx <= TX_DATA_A[count_1];
										count_1 <= count_1+1;
										end
									end
									else if(c_s == 3'b110 && state == 4'b0000)
											begin
											if(count_1 == 10)
												begin
												count_1 <= 0;
												state <= 4'b0110;
												Tx<=1;
												end
											else 
												begin
												Tx <= TX_DATA_D[count_1];
												count_1 <= count_1+1;
												end
											end
											else if(c_s == 3'b111 && state == 4'b0000)
													begin
													if(count_1 == 10)
														begin
														count_1 <= 0;
														state <= 4'b0111;
														Tx<=1;
														end
													else 
														begin
														Tx <= TX_DATA_B[count_1];
														count_1 <= count_1+1;
														end
													end
												else if(c_s == 3'b000 && state == 4'b0000)
														begin
														if(count_1 == 10)
														begin
														count_1 <= 0;
														state <= 4'b1000;
														Tx<=1;
														end
														else 
														begin
														Tx <= TX_DATA_0[count_1];
														count_1 <= count_1+1;
														end
													end
													else 
													case(state)
													4'b0000:state<=4'b0000;
													4'b0001:if(c_s == 3'b001)
																	state<=4'b0001;
															 else
																	state<=4'b0000;
													4'b0010:if(c_s == 3'b010)
																	state<=4'b0010;
															 else
																	state<=4'b0000;
													4'b0011:if(c_s == 3'b011)
																	state<=4'b0011;
															 else
																	state<=4'b0000;
													4'b0100:if(c_s == 3'b100)
																	state<=4'b0100;
															 else
																	state<=4'b0000;
													4'b0101:if(c_s == 3'b101)
																	state<=4'b0101;
															 else
																	state<=4'b0000;
													4'b0110:if(c_s == 3'b110)
																	state<=4'b0110;
															 else
																	state<=4'b0000;
													4'b0111:if(c_s == 3'b111)
																	state<=4'b0111;
															 else
																	state<=4'b0000;
													4'b1000:if(c_s == 3'b000)
																	state<=4'b1000;
															 else
																	state<=4'b0000;
													default:;
												endcase
end
endmodule