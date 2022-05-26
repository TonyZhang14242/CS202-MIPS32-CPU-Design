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
	input led_clk,   		    // clock
    input ledrst, 		        // reset
    input ledwrite,		       		// write signal(IOWrite) from controller 
    input ledcs,		      		// chip select signal from memorio   
    input[1:0] ledaddr,	        //  lower 2bits of address  
    input[15:0] ledwdata,	  	//  data want to write to led
    output reg [23:0] ledout		//  output of led
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