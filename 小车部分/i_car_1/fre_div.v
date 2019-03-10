module fre_div(clk_in,clk_out);	//分频，给电机供pwm
input clk_in;
output reg clk_out;

reg[19:0] count;


always@(posedge clk_in)
begin
	if(count==500)
		begin
			clk_out<=~clk_out;
			count<=0;
		end
	else
	begin
		count<=count+1;
	end
end

endmodule
