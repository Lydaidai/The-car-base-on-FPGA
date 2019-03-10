module CPU
(
input mpuin,
input soundin,
input clk,
input reset,
output reg[2:0] c_s
);

//分频器
reg[15:0] count;

always @ (posedge clk,negedge reset)
	if(!reset)
		begin
			count<=0;
		end
	else
		begin
			count<=count+1'b1;
		end

wire key_clk=count[15];		//f=50MHz/2^16=762Hz 	
//分频器结束

parameter INITIAL=3'b001;		
parameter WORK1=3'b010;
parameter WORK2=3'b100;

reg [2:0] current,next;

initial 
begin
	c_s <= 0;
end

//状态方程
always @ (posedge key_clk,negedge reset)
	if(!reset)
		begin
			current<=INITIAL;
		end
	else
		begin
			current<=next;
		end

//驱动方程
always @ *
	begin
	case(current)
		INITIAL:											
			if(mpuin == 1'b1)							
				begin
				next<=WORK1;
				end
			else if(soundin == 1'b1)
					begin 
					next<=WORK2;
					end
					else
						begin
						c_s <= 3'b000;
						next<=INITIAL;
						end
		WORK1:											
			begin
				if(mpuin == 1'b1)
					begin
						c_s <= 3'b001;
						next <= INITIAL;
					end
			end
		WORK2:												
				if(soundin == 1'b1)
					begin
					c_s <= 3'b010;
					next <= INITIAL;
					end
		default:;
	endcase
	end
	
endmodule