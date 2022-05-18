`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 17:40:22
// Design Name: 
// Module Name: led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module led(
	input led_clk,   		    // 时钟信号
    input ledrst, 		        // 复位信号
    input ledwrite,		       		// 写信号
    input ledcs,		      		// 从memorio来的LED片选信号   !!!!!!!!!!!!!!!!!
    input[1:0] ledaddr,	        //  到LED模块的地址低端  !!!!!!!!!!!!!!!!!!!!
    input[15:0] ledwdata,	  	//  写到LED模块的数据，注意数据线只有16根
    output reg [23:0] ledout		//  向板子上输出的24位LED信号
);
	always@(posedge led_clk or posedge ledrst) begin
        if(ledrst) begin
            ledout <= 24'h000000;
        end
		else if(ledcs && ledwrite) begin
			if(ledaddr == 2'b00)//0xfffffc60
				ledout[23:0] <= { ledout[23:16], ledwdata[15:0] };
			else if(ledaddr == 2'b10 )//0xfffffc62
				ledout[23:0] <= { ledwdata[7:0], ledout[15:0] };
			else
				ledout <= ledout;
        end
		else begin
            ledout <= ledout;
        end
    end
endmodule