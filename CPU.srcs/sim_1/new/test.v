`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 17:19:47
// Design Name: 
// Module Name: test
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


module test();
reg clk = 1'b0, rst = 1'b0; 
reg [23:0] sw = 22'b1010101;
wire [23:0] led;
wire [31:0] ins;
wire tclk;
wire [31:0] test;
initial #100 rst = 1'b1;
initial #120 rst = 1'b0;
always #5 clk = ~clk;

TopCpu cpu(clk, rst, sw, led);
endmodule
