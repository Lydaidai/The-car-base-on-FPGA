module MPU6050(  
    clk,  
    scl,  
    sda,  
    rst_n,
	 AX_DATA,
	 AY_DATA,
	 AZ_DATA,
	 //GZ_DATA
    );  
input clk,rst_n;  
output scl;   
inout sda;  
output reg[15:0] AX_DATA;
output reg[15:0] AY_DATA;
output reg[15:0] AZ_DATA;
//output reg[15:0] GZ_DATA;
  
reg [2:0]cnt;//cnt=0，scl上升沿；cnt=1，scl高电平中间；cnt=2，scl下降沿；cnt=3，scl低电平中间  
reg [8:0]cnt_sum;//产生IIC所需要的时钟  
reg scl_r;//产生的时钟脉冲  
  
reg [19:0]cnt_10ms;  
  
always@(posedge clk or negedge rst_n)  
if(!rst_n)   
    cnt_10ms <= 20'd0;  
else  
    cnt_10ms <= cnt_10ms+1'b1;  
  
always@(posedge clk or negedge rst_n)  
begin  
    if(!rst_n)   
        cnt_sum <= 0;  
    else if(cnt_sum ==9'd499)  
        cnt_sum <= 0;  
    else  
        cnt_sum <= cnt_sum+1'b1;  
end  
  
always@(posedge clk or negedge rst_n)  
begin  
    if(!rst_n)  
        cnt <= 3'd5;  
    else   
        begin  
            case(cnt_sum)  
            9'd124: cnt<=3'd1;//高电平  
            9'd249: cnt<=3'd2;//下降沿  
            9'd374: cnt<=3'd3;//低电平  
            9'd499: cnt<=3'd0;//上升沿  
            default: cnt<=3'd5;  
            endcase  
        end  
end  
  
`define SCL_POS (cnt==3'd0)  
`define SCL_HIG (cnt==3'd1)  
`define SCL_NEG (cnt==3'd2)  
`define SCL_LOW (cnt==3'd3)  
  
always@(posedge clk or negedge rst_n)  
begin  
    if(!rst_n)  
        scl_r <= 1'b0;  
    else if(cnt==3'd0)  
        scl_r <= 1'b1;  
    else if(cnt==3'd2)  
        scl_r <= 1'b0;  
end  
  
assign scl = scl_r;//scl时钟信号  
  
`define DEVICE_READ 8'hD1//寻址器件，读操作  
`define DEVICE_WRITE 8'hD0//寻址器件，写操作  
`define ACC_XH 8'h3B//加速度x轴高位地址  
`define ACC_XL 8'h3C//加速度x轴低位地址  
`define ACC_YH 8'h3D//加速度y轴高位地址  
`define ACC_YL 8'h3E//加速度y轴低位地址  
`define ACC_ZH 8'h3F//加速度z轴高位地址  
`define ACC_ZL 8'h40//加速度z轴低位地址  
`define GYRO_XH 8'h43//陀螺仪x轴高位地址  
`define GYRO_XL 8'h44//陀螺仪x轴低位地址  
`define GYRO_YH 8'h45//陀螺仪y轴高位地址  
`define GYRO_YL 8'h46//陀螺仪y轴低位地址 
`define GYRO_ZH 8'h47//陀螺仪y轴低位地址
`define GYRO_ZL 8'h48//陀螺仪z轴低位地址      
  
//陀螺仪初始化寄存器  
`define PWR_MGMT_1 8'h6B  //电源管理寄存器
`define SMPLRT_DIV 8'h19  //采样频率寄存器
`define CONFIG1 8'h1A  		//配置寄存器
`define GYRO_CONFIG 8'h1B  //陀螺仪配置寄存器
`define ACC_CONFIG 8'h1C  	//加速度计配置寄存器

//陀螺仪初始化对应寄存器值配置  
`define PWR_MGMT_1_VAL 8'h00  //使能温度传感器
`define SMPLRT_DIV_VAL 8'h07  //
`define CONFIG1_VAL 8'h06  	//
`define GYRO_CONFIG_VAL 8'h18  //设置灵敏度为16.4LSB/（。/S）
`define ACC_CONFIG_VAL 8'h01   //16384LSB/g
  
parameter IDLE = 4'd0;  
parameter START1 = 4'd1;   
parameter ADD1 = 4'd2;  
parameter ACK1 = 4'd3;  
parameter ADD2 = 4'd4;  
parameter ACK2 = 4'd5;  
parameter START2 = 4'd6;  
parameter ADD3 =4'd7;  
parameter ACK3 = 4'd8;  
parameter DATA = 4'd9;  
parameter ACK4 = 4'd10;  
parameter STOP1 = 4'd11;  
parameter STOP2 = 4'd12;  
parameter ADD_EXT = 4'd13;  
parameter ACK_EXT = 4'd14;  
  
reg [3:0]state;//状态寄存器  
reg sda_r;//输出  
reg sda_link;//sda_link=1,sda输出;sda_link=0,sda高阻态  
reg [3:0]num;  
reg [7:0]db_r;  
reg [7:0]ACC_XH_READ;//存储加速度X轴高八位  
reg [7:0]ACC_XL_READ;//存储加速度X轴低八位  
reg [7:0]ACC_YH_READ;//存储加速度Y轴高八位  
reg [7:0]ACC_YL_READ;//存储加速度Y轴低八位  
reg [7:0]ACC_ZH_READ;//存储加速度Z轴高八位  
reg [7:0]ACC_ZL_READ;//存储加速度Z轴低八位  
reg [7:0]GYRO_XH_READ;//存储陀螺仪X轴高八位  
reg [7:0]GYRO_XL_READ;//存储陀螺仪X轴低八位  
reg [7:0]GYRO_YH_READ;//存储陀螺仪Y轴高八位  
reg [7:0]GYRO_YL_READ;//存储陀螺仪Y轴低八位  
reg [7:0]GYRO_ZH_READ;//存储陀螺仪Z轴高八位  
reg [7:0]GYRO_ZL_READ;//存储陀螺仪Z轴低八位  
reg [4:0]times;//记录已初始化配置的寄存器个数  
  
always@(posedge clk or negedge rst_n)  
begin  
    if(!rst_n)  
    begin  
        state <= IDLE;  
        sda_r <= 1'b1;//拉高数据线  
        sda_link <= 1'b0;//高阻态  
        num <= 4'd0;  
        //初始化寄存器  
        ACC_XH_READ <= 8'h00;  
        ACC_XL_READ <= 8'h00;  
        ACC_YH_READ <= 8'h00;  
        ACC_YL_READ <= 8'h00;  
        ACC_ZH_READ <= 8'h00;  
        ACC_ZL_READ <= 8'h00;  
        GYRO_XH_READ <= 8'h00;  
        GYRO_XL_READ <= 8'h00;  
        GYRO_YH_READ <= 8'h00;  
        GYRO_YL_READ <= 8'h00;  
        GYRO_ZH_READ <= 8'h00;  
        GYRO_ZL_READ <= 8'h00;  
        times <= 5'b0;  
    end  
    else  
        case(state)  
        IDLE: begin  
                    times <= times+1'b1;  
                    sda_link <= 1'b1;//sda为输出  
                    sda_r <= 1'b1;//拉高sda  
                    db_r <= `DEVICE_WRITE;//向从机写入数据地址  
                    state <= START1;  //
                end  
       START1:begin//IIC start  
                    if(`SCL_HIG)//scl为高电平  
                    begin  
                        sda_link <= 1'b1;//sda输出  
                        sda_r <= 1'b0;//拉低sda，产生start信号  
                        state <= ADD1;  
                        num <= 4'd0;  
                    end  
                    else  
                        state <= START1;  
                end  
        ADD1: begin//数据写入  
                    if(`SCL_LOW)//scl为低电平  
                    begin  
                        if(num == 4'd8)//当8位全部输出  
                        begin  
                            num <= 4'd0;//计数清零  
                            sda_r <= 1'b1;  
                            sda_link <= 1'b0;//sda高阻态  
                            state <= ACK1;  
                        end  
                        else  
                        begin  
                            state <= ADD1;  
                            num <= num+1'b1;  
                            sda_r <= db_r[4'd7-num];//按位输出  
                        end  
                    end  
                    else  
                        state <= ADD1;  
                end  
        ACK1: begin//应答  
                    if(`SCL_NEG)  
                    begin  
                        state <= ADD2;  
                        case(times)//选择下一个写入寄存器地址  
                            5'd1: db_r <= `PWR_MGMT_1;  
                            5'd2: db_r <= `SMPLRT_DIV;  
                            5'd3: db_r <= `CONFIG1;  
                            5'd4: db_r <= `GYRO_CONFIG;  
                            5'd5: db_r <= `ACC_CONFIG;  
                            5'd6: db_r <= `ACC_XH;  
                            5'd7: db_r <= `ACC_XL;  
                            5'd8: db_r <= `ACC_YH;  
                            5'd9: db_r <= `ACC_YL;  
                            5'd10: db_r <= `ACC_ZH;  
                            5'd11: db_r <= `ACC_ZL;  
                            5'd12: db_r <= `GYRO_XH;  
                            5'd13: db_r <= `GYRO_XL;  
                            5'd14: db_r <= `GYRO_YH;  
                            5'd15: db_r <= `GYRO_YL;  
                            5'd16: db_r <= `GYRO_ZH;  
                            5'd17: db_r <= `GYRO_ZL;  
                            default: begin  
													db_r <= `PWR_MGMT_1;  
													times <= 5'd1;  
													end  
									endcase  
                    end  
                    else  
                        state <= ACK1;//等待响应  
							end  
        ADD2: begin  
                    if(`SCL_LOW)//scl为低  
                    begin  
                        if(num == 4'd8)  
                        begin  
                            num <= 4'd0;  
                            sda_r <= 1'b1;  
                            sda_link <= 1'b0;  
                            state <= ACK2;  
                        end  
                        else  
                        begin  
                            sda_link <= 1'b1;  
                            state <= ADD2;  
                            num <= num+1'b1;  
                            sda_r <= db_r[4'd7-num];//按位送寄存器地址  
                        end  
                    end  
                    else  
                        state <= ADD2;  
							end  
        ACK2: begin//应答  
                    if(`SCL_NEG)  
                    begin  
                        case(times)//对应寄存器的设定值  
                            3'd1: db_r <= `PWR_MGMT_1_VAL;  
                            3'd2: db_r <= `SMPLRT_DIV_VAL;  
                            3'd3: db_r <= `CONFIG1_VAL;  
                            3'd4: db_r <= `GYRO_CONFIG_VAL;  
                            3'd5: db_r <= `ACC_CONFIG_VAL;  
                            3'd6: db_r <= `DEVICE_READ;  
                            default: db_r <= `DEVICE_READ;  
                        endcase  
                        if(times >= 5'd6)  
                            state <= START2;  
                        else  
                            state <= ADD_EXT;  
                    end  
                    else  
                        state <= ACK2;//等待响应  
                end  
        ADD_EXT:begin//初始化一些设定寄存器  
                    if(`SCL_LOW)  
                    begin  
                        if(num == 4'd8)  
                        begin  
                            num <= 4'd0;  
                            sda_r <= 1'b1;  
                            sda_link <= 1'b0;//sda高阻态  
                            state <= ACK_EXT;  
                        end  
                        else  
                        begin  
                            sda_link <= 1'b1;  
                            state <= ADD_EXT;  
                            num <= num+1'b1;  
                            sda_r <= db_r[4'd7-num];//按位设定寄存器工作方式  
                        end  
                    end  
                    else  
                        state <= ADD_EXT;  
                end  
        ACK_EXT:begin  
                    if(`SCL_NEG)  
                    begin  
                        sda_r <= 1'b1;//拉高sda  
                        state <= STOP1;  
                    end  
                    else  
                        state <= ACK_EXT;//等待响应  
                end  
        START2:begin  
                    if(`SCL_LOW)//scl为低  
                    begin  
                        sda_link <= 1'b1;//sda为输出
                        sda_r <= 1'b1;//拉高sda  
                        state <= START2;  
                    end  
                    else if(`SCL_HIG)//scl为高  
                    begin  
                        sda_r <= 1'b0;//拉低sda，产生start信号 	
                        state <= ADD3;  
                    end  
                    else   
                        state <= START2;  
                end  
        ADD3: begin  
                    if(`SCL_LOW)//scl位低  
                    begin  
                        if(num == 4'd8)  
                        begin  
                            num <= 4'd0;  
                            sda_r <= 1'b1;//拉高sda  
                            sda_link <= 1'b0;//scl高阻态  
                            state <= ACK3;  
                        end  
                        else  
                        begin  
                            num <= num+1'b1;  
                            sda_r <= db_r[4'd7-num];//按位写入读取寄存器地址  
                            state <= ADD3;  
                        end  
                    end  
                    else state <= ADD3;  
                end  
        ACK3: begin  
                    if(`SCL_NEG)  
                    begin  
                        state <= DATA;  
                        sda_link <= 1'b0;//sda高阻态  
                    end  
                    else  
                        state <= ACK3;//等待响应  
                end  
        DATA: begin  
                    if(num <= 4'd7)  
                    begin  
                        state <= DATA;  
                        if(`SCL_HIG)  
                        begin  
                            num <= num+1'b1;  
                            case(times)  
                                5'd6: ACC_XH_READ[4'd7-num] <= sda;  
                                5'd7: ACC_XL_READ[4'd7-num] <= sda;
                                5'd8: ACC_YH_READ[4'd7-num] <= sda;  
                                5'd9: ACC_YL_READ[4'd7-num] <= sda;
                                5'd10:ACC_ZH_READ[4'd7-num] <= sda;  
                                5'd11:ACC_ZL_READ[4'd7-num] <= sda;  
                                5'd12:GYRO_XH_READ[4'd7-num] <= sda;
                                5'd13:GYRO_XL_READ[4'd7-num] <= sda;
                                5'd14:GYRO_YH_READ[4'd7-num] <= sda;  
                                5'd15:GYRO_YL_READ[4'd7-num] <= sda;  
                                5'd16:GYRO_ZH_READ[4'd7-num] <= sda;  
                                5'd17:GYRO_ZL_READ[4'd7-num] <= sda;  
                                default: ;//暂时未考虑，可添加代码提高系统稳定性  
                            endcase  
                        end  
                    end  
                    else if((`SCL_LOW)&&(num == 4'd8))  
                    begin  
                        sda_link <= 1'b1;//sda为输出  
                        num <= 4'd0;//计数清零  
                        state <= ACK4;  
                    end  
                    else  
                        state <= DATA;  
                end  
        ACK4: begin  
                    if(times == 5'd17)  
                        times <= 5'd0;  
                    if(`SCL_NEG)  
                    begin  
                        sda_r <= 1'b1;//拉高sda  
                        state <= STOP1;  
                    end  
                    else  
                        state <= ACK4;//等待响应  
                end  
        STOP1:begin  
                    if(`SCL_LOW)//scl为低  
                    begin  
                        sda_link <= 1'b1;//sda输出  
                        sda_r <= 1'b0;//拉低sda  
                        state <= STOP1;  
                    end  
                    else if(`SCL_HIG)//sda为高  
                    begin  
                        sda_r <= 1'b1;//拉高sda,产生stop信号  
                        state <= STOP2;  
                    end  
                    else  
                        state <= STOP1;  
                end  
        STOP2:begin  
                    if(`SCL_LOW)  
                    sda_r <= 1'b1;  
                    else if(cnt_10ms == 20'hffff0)//约10ms得一个数据  
                        state <= IDLE;  
                    else  
                        state <= STOP2;  
                end  
        default:state <= IDLE;  
        endcase  
end  
  
assign sda = sda_link?sda_r:1'bz;  
  
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		 begin
		 AX_DATA<=0;
		 AY_DATA<=0;
		 AZ_DATA<=0;
		 //GZ_DATA<=0;
		 end
	else 
		begin
		AX_DATA <= {ACC_XH_READ,ACC_XL_READ};
		AY_DATA <= {ACC_YH_READ,ACC_YL_READ};
		AZ_DATA <= {ACC_ZH_READ,ACC_ZL_READ};
		//GZ_DATA <= {GYRO_ZH_READ,GYRO_ZL_READ};
		end
end
endmodule 