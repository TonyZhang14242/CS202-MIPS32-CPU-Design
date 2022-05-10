`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/14 11:00:22
// Design Name: 
// Module Name: Control
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


module control32(
input[5:0] Opcode, // instruction[31..26], opcode
input[5:0]  Function_opcode, // instructions[5..0], funct
output Jr , // 1 indicates the instruction is "jr", otherwise it's not "jr" output Jmp; // 1 indicate the instruction is "j", otherwise it's not
output RegDST,// 1 indicate destination register is "rd"(R),otherwise it's "rt"(I)
output ALUSrc,// 1 indicate the 2nd data is immidiate (except "beq","bne")
output MemtoReg, // 1 indicate read data from memory and write it into register
output RegWrite, // 1 indicate write register(R,I(lw)), otherwise it's not
output MemWrite, // 1 indicate write data memory, otherwise it's not
output Branch, // 1 indicate the instruction is "beq" , otherwise it's not
output nBranch, // 1 indicate the instruction is "bne", otherwise it's not
output Jmp,
output Jal, // 1 indicate the instruction is "jal", otherwise it's not
output I_format,
/* 1 indicate the instruction is I-type but isn't "beq","bne","LW" or "SW" */
output Sftmd, // 1 indicate the instruction is shift instruction
output [1:0]  ALUOp
/* if the instruction is R-type or I_format, ALUOpis2'b10;
if the instruction is"beq" or "bne", ALUOpis 2'b01£»if the instruction is"lw" or "sw", ALUOpis 2'b00£»*/
    );
    wire R_format;
   
    assign    Jr =((Opcode==6'b000000)&&(Function_opcode==6'b001000)) ? 1'b1 : 1'b0;
    assign   Jmp= (Opcode==6'b000010) ? 1'b1 : 1'b0;
    assign   Jal= (Opcode==6'b000011) ? 1'b1 : 1'b0;
    assign    Branch= (Opcode==6'b000100) ? 1'b1 : 1'b0;
    assign   nBranch= (Opcode==6'b000101) ? 1'b1 : 1'b0;
    assign   MemtoReg= (Opcode==6'b100011) ? 1'b1 : 1'b0;
    assign   R_format=(Opcode==6'b000000)? 1'b1:1'b0;
    assign   MemWrite= (Opcode==6'b101011) ? 1'b1 : 1'b0;
    assign   I_format = (Opcode[5:3]==3'b001)?1'b1:1'b0;
    assign   Sftmd= (((Function_opcode==6'b000000)||(Function_opcode==6'b000010)||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)||(Function_opcode==6'b000110)||(Function_opcode==6'b000111))&& R_format)? 1'b1:1'b0;

    assign    RegDST=R_format;
    assign   RegWrite = (R_format || MemtoReg || Jal || I_format) &&!(Jr);
    assign   ALUSrc= (I_format||Opcode==6'b100011||Opcode==6'b101011);
    assign  ALUOp = {(R_format || I_format),(Branch || nBranch)};
endmodule
