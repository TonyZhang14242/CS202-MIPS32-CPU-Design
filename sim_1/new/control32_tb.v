`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/14 11:29:38
// Design Name: 
// Module Name: control32_tb
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


module control32_tb(
    );
    reg [5:0] Opcode,Function_opcode;
    //wire type variables are use for binding with output ports
    wire [1:0] ALUOp;
    wire Jr,RegDST,ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,nBranch,Jmp,Jal,I_format,Sftmd;
    //instance the module "Control", bind the ports
    control32 c32
    (Opcode,Function_opcode, Jr,Jmp,Jal,Branch,nBranch,RegDST,MemtoReg ,RegWrite,MemWrite, ALUSrc,Sftmd,I_format,ALUOp);
    initial begin
    //an example: #0 add $3,$1,$2. get the machine code of 'add $3,$1,$2' // step1: edit the assembly code, add "add $3,$1,$2" // step2: open the assembly code in Minisys1Assembler2.2, do the assembly procession
    // step3: open the "output/prgmips32.coe" file, find the related machine code of 'add $3,$1,$2' //in "0x00221820", 'Opcode' is 6'h00,'Function_opcode' is 6'h20
    Opcode = 6'h03;
    Function_opcode = 6'h08;
    #200 $finish;//... end
    end
endmodule
