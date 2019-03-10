module buzzer(
input [2:0] cs,
input clk,
output reg M,
output reg [2:0] test
);

reg [1:0]state;
reg trigger;
reg trigger_1;

//分频器
reg[19:0] count;

always @ (posedge clk)
		begin
			count<=count+1'b1;
		end

wire key_clk=count[19];				//f=50MHz/2^20=47Hz T=21ms
//分频器结束

initial
begin
	state <= 2'b00;
	trigger <= 0;
	trigger_1 <= 0;
	M <= 0;
	test <= 0;
end

always @(posedge clk)
begin
	if(cs == 3'b010 && state == 2'b00)
		begin
		state <= 2'b01;
		trigger <= 1;
		M <= 1;
		//test[0] <= 1;
		end
	else if(cs == 3'b010 && count_done == 1 && state == 2'b01)
		begin	
		state <= 2'b10;
		trigger <= 0;
		trigger_1 <= 1;
		M <= 0;
		//test[1] <= 1; 
		end
	else if(cs == 3'b010 && count_done_1 == 1 && state == 2'b10)
	begin	
		state <= 2'b01;
		trigger <= 1;
		trigger_1 <= 0;
		M <= 1;
		//test[2] <= 1; 
	end
	else 
		begin
			
		end
			
		
end

always @(posedge clk)
begin
	test[2] <= state[0];
end
//计时两秒模块1
reg [32:0] timer_count;					

always @ (posedge clk)
begin
	if(!trigger)
		timer_count<=0;
	else if(timer_count != 50000000)
				timer_count<=timer_count+1;
			else
				timer_count <= timer_count;
end
			
assign count_done =(timer_count == 50000000);

//计时两秒模块2
reg [32:0] timer_count_1;					

always @ (posedge clk)
begin
	if(!trigger_1)
		timer_count_1<=0;
	else if(timer_count_1 != 50000000)
				timer_count_1<=timer_count_1+1;
			else
				timer_count_1 <= timer_count_1;
end
			
assign count_done_1 =(timer_count_1 == 50000000);

endmodule 