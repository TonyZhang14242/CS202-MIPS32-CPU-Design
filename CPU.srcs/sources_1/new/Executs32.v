`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/27 14:14:22
// Design Name: 
// Module Name: Executs32
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


module Executs32(Read_data_1,Read_data_2,Sign_extend,Opcode,Function_opcode,Shamt,
PC_plus_4,ALUOp,ALUSrc,I_format,Sftmd,ALU_Result,Zero,Addr_Result);
    // from Decoder
    input[31:0] Read_data_1; //the source of Ainput
    input[31:0] Read_data_2; //one of the sources of Binput
    input[31:0] Sign_extend; //one of the sources of Binput
    // from IFetch
    input[5:0] Opcode; //instruction[31:26]
    input[5:0] Function_opcode; //instructions[5:0]
    input[4:0] Shamt; //instruction[10:6], the amount of shift bits
    input[31:0] PC_plus_4; //pc+4
    // from Controller
    input[1:0] ALUOp; //{ (R_format || I_format) , (Branch || nBranch) }
    input ALUSrc; // 1 means the 2nd operand is an immediate (except beq,bne£©
    input I_format; // 1 means I-Type instruction except beq, bne, LW, SW
    input Sftmd; // 1 means this is a shift instruction
    
    output[31:0]  ALU_Result; // the ALU calculation result
    output Zero; // 1 means the ALU_reslut is zero, 0 otherwise
    output[31:0] Addr_Result; // the calculated instruction address
    reg[31:0] ALU_Result;
    wire[31:0] Ainput,Binput; // two operands for calculation
    wire signed [31:0] Ainput_signed,Binput_signed;
    
    wire[5:0] Exe_code; // use to generate ALU_ctrl. (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] };
    wire[2:0] ALU_ctl; // the control signals which affact operation in ALU directely
    wire[2:0] Sftm; // identify the types of shift instruction, equals to Function_opcode[2:0]
    reg[31:0] Shift_Result; // the result of shift operation
    reg[31:0] ALU_output_mux; // the result of arithmetic or logic calculation
    wire[32:0] Branch_Addr; // the calculated address of the instruction, Addr_Result is Branch_Addr[31:0]
    
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];
    
    assign Exe_code =(I_format==0) ?Function_opcode :{ 3'b000 , Opcode[2:0] };
    
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    assign Sftm = Function_opcode[2:0]; //the code of shift operations
    
    assign Branch_Addr=Sign_extend[31:0]+PC_plus_4[31:2];
    assign Addr_Result=Branch_Addr[31:0];
    assign Zero=(ALU_Result==1'b0)?1'b1:1'b0;
    
    //Determine the output "ALU_Result "
    always @(*) begin
    //set type operation (slt, slti, sltu, sltiu)
    if( ((ALU_ctl==3'b111) && (Exe_code[3]==1)) || (ALU_ctl[2:1]==2'b11&& I_format==1'b1) )
    ALU_Result = (Ainput-Binput<0)?1:0;
    //lui operation
    else if((ALU_ctl==3'b101) && (I_format==1))
    ALU_Result[31:0]= {Binput[15:0],16'b0};/*set higher bits to Binput*/
    //shift operation
    else if(Sftmd==1)
    ALU_Result = Shift_Result ;
    //other types of operation in ALU (arithmatic or logic calculation)
    else
    ALU_Result = ALU_output_mux[31:0];
    end
    
    
    //Arithmatic and Logic calculation
    always @(ALU_ctl,Ainput,Binput)  begin
        case(ALU_ctl) 
            3'b000:ALU_output_mux=Ainput&Binput; //and andi
            3'b001:ALU_output_mux=Ainput|Binput;//or ori
            3'b010:ALU_output_mux=Ainput_signed+Binput_signed;//add addi lw sw
            3'b011:ALU_output_mux=Ainput+Binput;//addu addui
            3'b100:ALU_output_mux=Ainput^Binput;//xor xori
            3'b101:ALU_output_mux=~(Ainput | Binput);//nor lui
            3'b110:ALU_output_mux=Ainput_signed-Binput_signed;//sub slti beq bne
            3'b111:ALU_output_mux=Ainput-Binput;//subu, sltiu slt,sltu
            default:ALU_output_mux=32'h00000000;
        endcase
    end
    
    
    always @* begin // six types of shift instructions
        if(Sftmd)
            case(Sftm[2:0])
            3'b000:Shift_Result = Binput << Shamt; //Sll rd,rt,shamt 00000
            3'b010:Shift_Result = Binput >> Shamt; //Srl rd,rt,shamt 00010
            3'b100:Shift_Result = Binput << Ainput; //Sllv rd,rt,rs 00010
            3'b110:Shift_Result = Binput >> Ainput; //Srlv rd,rt,rs 00110
            3'b011:Shift_Result = Binput >>> Shamt; //Sra rd,rt,shamt 00011
            3'b111:Shift_Result = Binput >>> Ainput; //Srav rd,rt,rs 00111
            default:Shift_Result = Binput;
             endcase
        else
        Shift_Result = Binput;
    end
    
    
endmodule
