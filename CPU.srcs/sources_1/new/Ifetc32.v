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
output reg[31:0] Instruction, // the instruction fetched from this module
output reg[31:0] branch_base_addr, // (pc+4) to ALU which is used by branch type instruction
input[31:0] Addr_result, // the calculated address from ALU
input[31:0] Read_data_1, // the address of instruction used by jr instruction
input Branch, // while Branch is 1,it means current instruction is beq
input nBranch, // while nBranch is 1,it means current instruction is bnq
input Jmp, // while Jmp 1, it means current instruction is jump
input Jal, // while Jal is 1, it means current instruction is jal
input Jr,// while Jr is 1, it means current instruction is jr
input Zero,// while Zero is 1, it means the ALUresult is zero
input clock, reset, // Clock and reset
output[31:0] link_addr // (pc+4) to Decoder which is used by jal instruction
);
// from ALU


// from Decoder

// from Controller


reg[31:0] PC, Next_PC;
reg [31:0] PC_plus4;
reg[31:0] link_addr;
wire[31:0] Jpadr;
 prgrom instmem(
       .clka(clock),         // input wire clka
       .addra(PC[15:2]),     // input wire [13 : 0] addra
       .douta(Jpadr)         // output wire [31 : 0] douta
  );
 
  
  always @ (*)begin
  PC_plus4<=PC+32'd4;
  branch_base_addr<=PC_plus4;
  Instruction<=Jpadr;
   if(((Branch==1)&&(Zero==1)||(nBranch==1)&&(Zero==0)))//beq bne
          Next_PC = Addr_result;
   else if(Jr==1)     Next_PC = Read_data_1[31:0];
   else if((Jmp == 1) || (Jal == 1)) begin 
   Next_PC={4'b0000,Instruction[25:0],2'b00};
   end
   else   Next_PC = PC_plus4[31:0];
   end
   
   always @(negedge clock) begin
		if((Jmp == 1) || (Jal == 1))
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