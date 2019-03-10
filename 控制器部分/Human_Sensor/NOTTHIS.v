module NOTTHIS(
input [2:0] c_s_1,
input [2:0] c_s_2,
input con,
input clk,
output reg [2:0] c_s_o
);

always @(posedge clk)
begin
	if(con)
		if(c_s_2 == 3'b010)
			c_s_o <= 3'b010;
		else 
			c_s_o <= c_s_1;		
	else 
		begin
		if(c_s_2 == 3'b001)
			c_s_o <= 3'b001;
		else
			c_s_o <= 3'b000;
		end
end
endmodule 