`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/21 09:41:55
// Design Name: 
// Module Name: Idecoder_tb
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


module Idecoder_tb(
    );
   reg[31:0]  Instruction = 32'b000000_00010_00011_00111_00000_100000; //add $7,$2,$3
       reg[31:0]  read_data = 32'h00000000;    //from data memory               
       reg[31:0]  ALU_result = 32'h00000005;                  
       reg        Jal = 1'b0; 
       reg        RegWrite = 1'b1;
       reg        MemtoReg = 1'b0;
       reg        RegDst = 1'b1;
       reg         clock = 1'b0 ,reset = 1'b1;
       reg[31:0]  opcplus4 = 32'h00000004;                 
       // output
       wire[31:0] read_data_1;
       wire[31:0] read_data_2;
       wire[31:0] Sign_extend;
       /*
       module Idecoder32(
               input clk,
               input reset, 
               input RegWrite, //from control
                input[31:0]  instruction,               // instruction from instrcution fetch
                 input[31:0]  ram_data,                   // data from DATA RAM
                 input[31:0]  ALU_res,                   // from ALU£¬to be extended to 32-bit
                 input        Jal,               
                 input        MemtoReg,             
                 input        RegDst,      
                 input[31:0]  link_addr,      // from instruction fetch used by jal(pc+4)
                 output[31:0] sign_extend,     // extended 32-bit immediate                     
                output [31:0] rdata1,//output the 1st num
                   output [31:0] rdata2//output the 2nd num
           );
       */
       Idecoder32 Uid(clock,reset,RegWrite,Instruction,read_data,ALU_result, Jal,MemtoReg,RegDst,
      opcplus4, Sign_extend,read_data_1,read_data_2
      );
   
       initial begin
           #200   reset = 1'b0;
           #200   begin Instruction = 32'b001000_00111_00011_1000000000110111;  //addi $3,$7,0X8037
                       read_data = 32'h00000000; 
                       ALU_result = 32'hFFFF803A;
                       Jal = 1'b0;
                       RegWrite = 1'b1;
                       MemtoReg = 1'b0;
                       RegDst = 1'b0;
                       opcplus4 = 32'h00000008; 
                  end
           #200   begin Instruction = 32'b001100_00010_00100_1000000010010111;  //andi $4,$2,0X8097
                              read_data = 32'h00000000; 
                              ALU_result = 32'h00000002;
                              Jal = 1'b0;
                              RegWrite = 1'b1;
                              MemtoReg = 1'b0;
                              RegDst = 1'b0;
                              opcplus4 = 32'h0000000c; 
                   end
           #200   begin Instruction = 32'b000000_00000_00001_00101_00010_000000;  //sll $5,$1,2
                                      read_data = 32'h00000000; 
                                      ALU_result = 32'h00000004;
                                      Jal = 1'b0;
                                      RegWrite = 1'b1;
                                      MemtoReg = 1'b0;
                                      RegDst = 1'b1;
                                      opcplus4 = 32'h00000010; 
                  end
           #200   begin Instruction = 32'b100011_00000_00110_0000000100000000;  //lw $6,256($0)
                                             read_data = 32'h0000007B; 
                                             ALU_result = 32'h00000054;
                                             Jal = 1'b0;
                                             RegWrite = 1'b1;
                                             MemtoReg = 1'b1;
                                             RegDst = 1'b0;
                                             opcplus4 = 32'h00000014; 
                  end
           #200   begin Instruction = 32'b000011_00000000000000000000000000;  //Jal 0
                                             read_data = 32'h00000000; 
                                             ALU_result = 32'h00000004;
                                             Jal = 1'b1;
                                             RegWrite = 1'b1;
                                             MemtoReg = 1'b0;
                                             RegDst = 1'b0;
                                             opcplus4 = 32'h00000018; 
                  end
       end 
       always #50 clock = ~clock;           
endmodule
