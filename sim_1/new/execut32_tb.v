`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 19:25:46
// Design Name: 
// Module Name: execut32_tb
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


module execut32_tb(

    );
    // input
       reg[31:0]  Read_data_1 = 32'h80000005;        //r-form rs 1000 0000 0000 .... 0101
       reg[31:0]  Read_data_2 = 32'h80000006;        //r-form rt
       reg[31:0]  Sign_extend = 32'hffffff40;        //i-form
       reg[5:0]   Function_opcode = 6'b100000;      //add 
       reg[5:0]   Exe_opcode = 6'b000000;          //op code
       reg[1:0]   ALUOp = 2'b10;
       reg[4:0]   Shamt = 5'b00000;
       reg        Sftmd = 1'b0;
       reg        ALUSrc = 1'b0;
       reg        I_format = 1'b0;
       reg[31:0]  PC_plus_4 = 32'h00000004;
        // output
       wire       Zero;
       wire[31:0] ALU_Result;
       wire[31:0] Add_Result;        //pc op        
     
        
       executs32 Uexe(
       .Read_data_1(Read_data_1),    // r-form rs �����뵥Ԫ��Read_data_1����
       .Read_data_2(Read_data_2),    // r-form rt �����뵥Ԫ��Read_data_2����
       .Sign_extend(Sign_extend),    // i-form ���뵥Ԫ������չ���������
       .Function_opcode(Function_opcode),  // r-form instructions[5..0] ȡָ��Ԫ����R�͵�Func
       .Exe_opcode(Exe_opcode),    // opcode ȡֵ��Ԫ����Op
       .ALUOp(ALUOp),              // ���Ƶ�Ԫ����ALUOp����һ�����ƣ�LW/SW 00��BEQ/BNE 01��R/I 10��
       .Shamt(Shamt),              // ��λ��
       .Sftmd(Sftmd),              // �Ƿ�����λָ��
       .ALUSrc(ALUSrc),            // ���Կ��Ƶ�Ԫ�������ڶ�������������������beq��bne���⣩
       .I_format(I_format),        // ��ָ���ǳ���beq��bne��lw��sw���������I����ָ��
       .Zero(Zero),                // Zero Flag
       .ALU_Result(ALU_Result),    // ִ�е�Ԫ������������
       .Addr_Result(Add_Result),       // ����ĵ�ַ���       
       .PC_plus_4(PC_plus_4)       // ����ȡָ��Ԫ��PC+4
       );
    
        initial begin
           #200 begin Exe_opcode = 6'b001000;  //addi 
                    Read_data_1 = 32'h00000003;        //r-form rs
                    Read_data_2 = 32'h00000006;        //r-form rt
                    Sign_extend = 32'hffffff40;  
                    Function_opcode = 6'b100000;      //addi 
                    ALUOp = 2'b10;
                    Shamt = 5'b00000;
                    Sftmd = 1'b0;
                    ALUSrc = 1'b1;
                    I_format = 1'b1;
                    PC_plus_4 = 32'h00000008;
                end 
           #200 begin Exe_opcode = 6'b000000;  //and
                    Read_data_1 = 32'h000000ff;        //r-form rs
                    Read_data_2 = 32'h00000ff0;        //r-form rt
                    Sign_extend = 32'hffffff40;  
                    Function_opcode = 6'b100100;      //and 
                    ALUOp = 2'b10;
                    Shamt = 5'b00000;
                    Sftmd = 1'b0;
                    ALUSrc = 1'b0;
                    I_format = 1'b0;
                    PC_plus_4 = 32'h0000000c;
                 end 
           #200 begin Exe_opcode = 6'b000000;  //sll
                    Read_data_1 = 32'h00000001;        //r-form rs
                    Read_data_2 = 32'h00000002;        //r-form rt
                    Sign_extend = 32'hffffff40;  
                    Function_opcode = 6'b000000;      //sll
                    ALUOp = 2'b10;
                    Shamt = 5'b00011;
                    Sftmd = 1'b1;
                    ALUSrc = 1'b0;
                    I_format = 1'b0;
                    PC_plus_4 = 32'h00000010;
               end 
           #200 begin Exe_opcode = 6'b001111;  // LUI
                    Read_data_1 = 32'h00000001;        //r-form rs
                    Read_data_2 = 32'h00000002;        //r-form rt
                    Sign_extend = 32'h00000040;  
                    Function_opcode = 6'b000000;      //LUI
                    ALUOp = 2'b10;
                    Shamt = 5'b00001;
                    Sftmd = 1'b0;
                    ALUSrc = 1'b1;
                    I_format = 1'b1;
                    PC_plus_4 = 32'h00000014;
                end 
           #200 begin Exe_opcode = 6'b000100;  // BEQ
                    Read_data_1 = 32'h00000001;        //r-form rs
                    Read_data_2 = 32'h00000001;        //r-form rt
                    Sign_extend = 32'h00000004;     
                    Function_opcode = 6'b000100;      //LUI
                    ALUOp = 2'b01;
                    Shamt = 5'b00000;
                    Sftmd = 1'b0;
                    ALUSrc = 1'b0;
                    I_format = 1'b0;
                    PC_plus_4 = 32'h00000018;
                end 
          end
endmodule
