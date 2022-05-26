`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/27 14:22:40
// Design Name: 
// Module Name: cpuclk_tb
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


module cpuclk_tb( );
reg clkin;
wire clkout;
cpuclk clk1( .clk_in1(clkin), .clk_out1(clkout) );
initial clkin = 1'b0;
always #5 clkin=~clkin;
endmodule
