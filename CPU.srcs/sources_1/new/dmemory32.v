`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 15:52:20
// Design Name: 
// Module Name: dmemory32
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


module dmemory32(clock,memWrite,address,writeData,readData);
input clock; // Clock signal
/* used to determine to write the memory unit or not,
in the left screenshot its name is 'WE' */
input memWrite;
// the address of memory unit which is tobe read/writen
input[31:0] address;
// data tobe wirten to the memory unit
input[31:0] writeData;
/*data to be read from the memory unit, in the left
screenshot its name is 'MemData' */
output[31:0] readData;
// Part of dmemory32 module
//Create a instance of RAM(IP core), binding the ports
assign clk = !clock;
RAM ram (
.clka(clk), // input wire clka
.wea(memWrite), // input wire [0 : 0] wea
.addra(address[15:2]), // input wire [13 : 0] addra
.dina(writeData), // input wire [31 : 0] dina
.douta(readData) // output wire [31 : 0] douta
);
/*The clock is from CPU-TOP, suppose its one edge has been used at the upstream module of data memory, such as IFetch,
Why Data-Memroy DO NOT use the same edge as other module ? */

endmodule
