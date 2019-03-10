module beep(clk_50M,rst,speaker);

input clk_50M,rst;

output speaker;

reg speaker;



//分频计数器

parameter wide=15;

reg[7:0] cnt; //音名数

reg[3:0] cnt1; //5MHz基频

reg[23:0] cnt2;//节拍频率5Hz

reg[wide-1:0] origin;//预置数寄存器 

reg[wide-1:0] drive;

reg[1:0] count;

reg carrier;



//分频产生5MHz和5Hz的频率

always @(posedge clk_50M,negedge rst)

begin

if(!rst)

begin

cnt1<=4'd0;

cnt2<=24'd0;

end

else 

begin

cnt1<=cnt1+1'b1;

cnt2<=cnt2+1'b1;

if(cnt1==4'd9)

cnt1<=4'd0;

if(cnt2==24'h98967F)

cnt2<=24'd0;

end

end



always @(posedge clk_50M,negedge rst)

begin

if(!rst)

drive<=15'h0; 

else if(cnt1==4'd9)

begin

if(drive==15'h7fff)

begin

drive<=origin; 

carrier<=1'b1;

end

else begin drive<=drive+1'b1;carrier<=1'b0; end

end

end 



//carrier的频率是每个音阶的频率



always @(posedge carrier)

begin

count<=count+1'b1;

if(count==4'd0)

speaker<=1'b1;

else speaker<=1'b0; 



end

always @(posedge clk_50M,negedge rst)

begin

if(!rst)

begin

origin<=15'h0;

cnt<=8'd0;

end

else if(cnt2==24'h98967F) 

begin

if(cnt==8'd139)

cnt<=8'd0;

else

cnt<=cnt+1'b1;

case (cnt)

8'd0:origin<=15'h625F; //中音3，4个节拍

8'd1:origin<=15'h625F; 

8'd2:origin<=15'h625F; 

8'd3:origin<=15'h625F; 

8'd4:origin<=15'h6715; //中音5,3个节拍 

8'd5:origin<=15'h6715; 

8'd6:origin<=15'h6715; 

8'd7:origin<=15'h69cd;//中音6 

8'd8:origin<=15'h6d55; //高音1，3个节拍

8'd9:origin<=15'h6d55;

8'd10:origin<=15'h6d55; 



8'd11:origin<=15'h6f5f; //高音2 

8'd12:origin<=15'h69cd; //中音6

8'd13:origin<=15'h6d55; //高音1

8'd14:origin<=15'h6715; //中音5

8'd15:origin<=15'h6715; 

8'd16:origin<=15'h738a; //高音5 

8'd17:origin<=15'h738a; 

8'd18:origin<=15'h738a; 

8'd19:origin<=15'h76aa; //倍高音1 

8'd20:origin<=15'h69cd; //高音6



8'd21:origin<=15'h6715;//高音5

8'd22:origin<=15'h712f;//高音3

8'd23:origin<=15'h6715;//高音5

8'd24:origin<=15'h6f5f; //高音2

8'd25:origin<=15'h6f5f;

8'd26:origin<=15'h6f5f; 

8'd27:origin<=15'h6f5f;

8'd28:origin<=15'h6f5f;

8'd29:origin<=15'h6f5f;

8'd30:origin<=15'h6f5f; 

8'd31:origin<=15'h6f5f;

8'd32:origin<=15'h6f5f;

8'd33:origin<=15'h6f5f;

8'd34:origin<=15'h6f5f;

8'd35:origin<=15'h712f;//高音3

8'd36:origin<=15'h6c39; //中音7

8'd37:origin<=15'h6c39;

8'd38:origin<=15'h69cd;//中音6

8'd39:origin<=15'h69cd;

8'd40:origin<=15'h6715; //中音5

8'd41:origin<=15'h6715; 

8'd42:origin<=15'h6715; 

8'd43:origin<=15'h69cd;//中音6

8'd44:origin<=15'h6d55;//高音1 

8'd45:origin<=15'h6d55;

8'd46:origin<=15'h6f5f;//高音2 

8'd47:origin<=15'h6f5f; 

8'd48:origin<=15'h625f;//中音3

8'd49:origin<=15'h625f;

8'd50:origin<=15'h6d55; //高音1

8'd51:origin<=15'h6d55;



8'd52:origin<=15'h69cd;//中音6 

8'd53:origin<=15'h6715;//中音5

8'd54:origin<=15'h69cd; //中音6

8'd55:origin<=15'h6d55;//高音1 

8'd56:origin<=15'h6715;//中音5

8'd57:origin<=15'h6715; 

8'd58:origin<=15'h6715;

8'd59:origin<=15'h6715;

8'd60:origin<=15'h6715; 

8'd61:origin<=15'h6715;

8'd62:origin<=15'h6715;

8'd63:origin<=15'h6715;

8'd64:origin<=15'h712f;//高音3

8'd65:origin<=15'h712f;

8'd66:origin<=15'h712f;

8'd67:origin<=15'h738a;//高音5

8'd68:origin<=15'h6c39;//中音7

8'd69:origin<=15'h6c39;

8'd70:origin<=15'h6f5f;//高音2

8'd71:origin<=15'h6f5f;



8'd72:origin<=15'h69cd; //中音6

8'd73:origin<=15'h6d55;//高音1

8'd74:origin<=15'h6715;//中音5

8'd75:origin<=15'h6715;

8'd76:origin<=15'h6715;

8'd77:origin<=15'h6715;

8'd78:origin<=15'h6715;

8'd79:origin<=15'h6715;

8'd80:origin<=15'h625f; //中音3



8'd81:origin<=15'h6715;//中音5

8'd82:origin<=15'h625f;//中音3

8'd83:origin<=15'h625f;

8'd84:origin<=15'h6715;//中音5

8'd85:origin<=15'h69cd;//中音6

8'd86:origin<=15'h6c39;//中音7

8'd87:origin<=15'h6f5f;//高音2

8'd88:origin<=15'h69cd;//中音6

8'd89:origin<=15'h69cd;

8'd90:origin<=15'h69cd;

8'd91:origin<=15'h69cd;

8'd92:origin<=15'h69cd;

8'd93:origin<=15'h69cd;

8'd94:origin<=15'h6715;//中音5

8'd95:origin<=15'h69cd;//中音6

8'd96:origin<=15'h6d55;//高音1

8'd97:origin<=15'h6d55;

8'd98:origin<=15'h6d55;

8'd99:origin<=15'h6f5f;////高音2

8'd100:origin<=15'h738a; //高音5

8'd101:origin<=15'h738a;

8'd102:origin<=15'h738a;

8'd103:origin<=15'h712f;//高音3

8'd104:origin<=15'h6f5f;//高音2

8'd105:origin<=15'h6f5f;

8'd106:origin<=15'h712f;//高音3

8'd107:origin<=15'h6f5f;//高音2

8'd108:origin<=15'h6d55;//高音1

8'd109:origin<=15'h6d55;

8'd110:origin<=15'h69cd;//中音6



8'd111:origin<=15'h6715;//中音5

8'd112:origin<=15'h625f;//中音3

8'd113:origin<=15'h625f;

8'd114:origin<=15'h625f;

8'd115:origin<=15'h625f;

8'd116:origin<=15'h6d55;//高音1

8'd117:origin<=15'h6d55;

8'd118:origin<=15'h69cd;//中音6

8'd119:origin<=15'h6d55;//高音1

8'd120:origin<=15'h69cd;//中音6



8'd121:origin<=15'h625f;//中音3

8'd122:origin<=15'h625f;

8'd123:origin<=15'h6f5f;//高音2

8'd124:origin<=15'h625f;//中音3

8'd125:origin<=15'h6715;//中音5

8'd126:origin<=15'h69cd;//中音6

8'd127:origin<=15'h6d55;//高音1

8'd128:origin<=15'h6715;//中音5

8'd129:origin<=15'h6715;

8'd130:origin<=15'h6715;

8'd131:origin<=15'h6715;

8'd132:origin<=15'h6715;

8'd133:origin<=15'h6715;

8'd134:origin<=15'h6715;

8'd135:origin<=15'h6715;

8'd136:origin<=15'h3fff; 

8'd137:origin<=15'h3fff;

8'd138:origin<=15'h3fff;

8'd139:origin<=15'h3fff;

default:origin<=15'h3fff;

endcase 

end

end

endmodule