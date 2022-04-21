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


module IFetc32(Instruction, branch_base_addr, link_addr,clock, reset,
Addr_result, Read_data_1, Branch, nBranch, Jmp, Jal, Jr, Zero);
output[31:0] Instruction; // the instruction fetched from this module
output[31:0] branch_base_addr; // (pc+4) to ALU which is used by branch type instruction
output[31:0] link_addr; // (pc+4) to Decoder which is used by jal instruction
input clock, reset; // Clock and reset
// from ALU
input[31:0] Addr_result; // the calculated address from ALU
input Zero; // while Zero is 1, it means the ALUresult is zero
// from Decoder
input[31:0] Read_data_1; // the address of instruction used by jr instruction
// from Controller
input Branch; // while Branch is 1,it means current instruction is beq
input nBranch; // while nBranch is 1,it means current instruction is bnq
input Jmp; // while Jmp 1, it means current instruction is jump
input Jal; // while Jal is 1, it means current instruction is jal
input Jr; // while Jr is 1, it means current instruction is jr
reg[31:0] PC, Next_PC;
wire [31:0] PC_plus4;
reg[31:0] link_addr;
 prgrom instmem(
       .clka(clock),         // input wire clka
       .addra(PC[15:2]),     // input wire [13 : 0] addra
       .douta(Instruction)         // output wire [31 : 0] douta
  );
  assign PC_plus4[31:2]=PC[31:2]+1;
  assign PC_plus4[1:0]=PC[1:0];
  assign branch_base_addr=PC_plus4[31:0];
  
  always @ (*)begin
   if(((Branch==1)&&(Zero==1)||(nBranch==1)&&(Zero==0)))//beq bne
          Next_PC = Addr_result<<2;
   else if(Jr==1)     Next_PC = Read_data_1[31:0]<<2;
   else if((Jmp == 1) || (Jal == 1))  Next_PC={PC[31:28],Instruction[27:0]<<2};
   else   Next_PC = PC_plus4[31:0];
   end
   
   
   always @(negedge clock)begin
    if(reset == 1) begin
     PC <= 32'h0000_0000;
    end
   else  if((Jmp == 1) || (Jal == 1)) begin
		link_addr <=PC_plus4[31:0]>>2;
		PC<=Next_PC;
   end
   else PC[31:0]<=Next_PC[31:0];
   end
endmodule
