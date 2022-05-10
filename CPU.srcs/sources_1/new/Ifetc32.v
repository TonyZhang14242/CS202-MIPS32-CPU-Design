`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 17:46:19
// Design Name: 
// Module Name: IFetc32
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


module Ifetc32(
	output [31:0] Instruction, // the instruction fetched from this module
	output [31:0] branch_base_addr, // (pc+4) to ALU which is used by branch type instruction
	input[31:0] Addr_result, // the calculated address from ALU
	input[31:0] Read_data_1, // the address of instruction from Decoder used by jr instruction
	input Branch, // while Branch is 1,it means current instruction is beq
	input nBranch, // while nBranch is 1,it means current instruction is bnq
	input Jmp, // while Jmp 1, it means current instruction is jump
	input Jal, // while Jal is 1, it means current instruction is jal
	input Jr,// while Jr is 1, it means current instruction is jr
	input Zero,// from ALU, while Zero is 1, it means the ALUresult is zero
	input clock, reset, // Clock and reset
	output[31:0] link_addr // (pc+4) to Decoder which is used by jal instruction
);



	reg[31:0] PC, Next_PC;
	reg[31:0] link_addr;
	wire [31:0] PC_plus4;

	prgrom instmem(
       .clka(clock),         // input wire clka
       .addra(PC[15:2]),     // input wire [13 : 0] addra
       .douta(Instruction)         // output wire [31 : 0] douta
	);
 
	assign PC_plus4=PC+4;
	assign branch_base_addr=PC_plus4;
  
	always @ (*)begin
		if(((Branch==1)&&(Zero==1)||(nBranch==1)&&(Zero==0)))//beq bne
			Next_PC = Addr_result;	//the calculated new value for PC
		else if(Jr==1)	Next_PC = Read_data_1[31:0];	//the value of $31 register
		else if((Jmp == 1) || (Jal == 1)) begin 
			Next_PC={4'b0000,Instruction[25:0],2'b00};
		end
		else  Next_PC = PC_plus4[31:0];
	end
   
	always @(negedge clock) begin
		if((Jal == 1))
			link_addr <=PC_plus4[31:0];
		else link_addr<=link_addr;
	end
   
	always @(negedge clock)begin
		if(reset == 1) begin
			PC <= 32'h0000_0000;
		end
		else PC[31:0]<=Next_PC[31:0];
	end
endmodule
