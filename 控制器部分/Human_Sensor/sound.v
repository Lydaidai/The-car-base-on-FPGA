module sound(
input clk,
input sound_in,
input reset,
output reg sound_out
);

//分频器
reg[19:0] count;

always @ (posedge clk,negedge reset)
	if(!reset)
		begin
			count<=0;
		end
	else
		begin
			count<=count+1'b1;
		end

wire key_clk=count[19];				//f=50MHz/2^20=47Hz T=21ms
//分频器结束

always @(posedge key_clk)
begin
	sound_out <= sound_in;
end
endmodule 