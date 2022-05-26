`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 17:38:55
// Design Name: 
// Module Name: switch
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
module switch(
    input switclk,		//  clock	        
    input switrst,		//  reset	        
    input switchcs,		//switch signal from memorio 	       
    input[1:0] switchaddr,	//  lower 2bits of address from ALU  	    
    input switchread,		 //  IORead from controller	   
    output reg [15:0] switchrdata,	    //  data want go to memorio
    input [23:0] switch_i		    //  data of 24 switches on board
);
   
    always@(negedge switclk or posedge switrst) begin
        if(switrst) begin
            switchrdata <= 0;
        end
		else if(switchcs && switchread) begin
			if(switchaddr==2'b00)//0xfffffC70
				switchrdata[15:0] <= switch_i[15:0];   // data output,lower 16 bits non-extended
			else if(switchaddr==2'b10)//0xfffffC72
				switchrdata[15:0] <= { 8'h00, switch_i[23:16] }; //data output, upper 8 bits extended with zero
			else 
				switchrdata <= switchrdata;
        end
		else begin
            switchrdata <= switchrdata;
        end
    end
endmodule