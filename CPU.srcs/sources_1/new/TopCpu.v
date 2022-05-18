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


module TopCpu(input clk, input rst, input [23:0] sw, output [23:0] led);

// clock product
wire clock;
cpuclk clock_produce(.clk_in1(clk), .clk_out1(clock));


// Output of Control
wire Jr, RegDST, ALUSrc,MemorIOtoReg, RegWrite, MemWrite, MemRead, IORead, IOWrite, Branch, nBranch, Jmp, Jal, I_format, Sftmd;
wire [1:0] ALUOp;

// Output of ALU
wire Zero;
wire [31:0] ALU_Result,  Addr_Result;


// Output of MemOrIO
wire [31:0]addr_out, r_wdata, write_data;
wire LEDCtrl, SwitchCtrl;

// Output of decode
wire [31:0]read_data_1, read_data_2, Sign_extend;

// Output of dememory
wire [31:0]readData;

// Outpu of Ifench
wire [31:0] Instruction, branch_base_addr, link_addr;


// Ifench Part
Ifetc32 ifench(.Instruction(Instruction), .branch_base_addr(branch_base_addr), .Addr_result(Addr_Result), .Read_data_1(read_data_1), 
.Branch(Branch),.nBranch(nBranch), .Jmp(Jmp), .Jal(Jal), .Jr(Jr), .Zero(Zero), .link_addr(link_addr), .clock(clock), .reset(rst));

// Control Part
control32 control(.Opcode(Instruction[31:26]), .Function_opcode(Instruction[5:0]), .Alu_resultHigh(ALU_Result[31:10]), .Jr(Jr), .RegDST(RegDST), .ALUSrc(ALUSrc),
.MemorIOtoReg(MemorIOtoReg), .RegWrite(RegWrite), .MemWrite(MemWrite), .MemRead(MemRead), .IORead(IORead), .IOWrite(IOWrite), .Branch(Branch), .nBranch(nBranch),
.Jmp(Jmp), .Jal(Jal), .I_format(I_format), .Sftmd(Sftmd), .ALUOp(ALUOp));

// MemOrIO Part
MemOrIO memOrIO(.mRead(MemRead), .mWrite(MemWrite), .ioRead(IORead), .ioWrite(IOWrite),.addr_in(ALU_Result), 
.addr_out(addr_out), .m_rdata(readData), .io_rdata(sw[15:0]), .r_wdata(r_wdata), .r_rdata(read_data_1), .write_data(write_data), .LEDCtrl(LEDCtrl), .SwitchCtrl(SwitchCtrl));


// Execute Part
executs32 Execute(.Read_data_1(read_data_1),.Read_data_2(read_data_2),.Sign_extend(Sign_extend),.Function_opcode(Instruction[5:0]),
					.Exe_opcode(Instruction[31:26]),.ALUOp(ALUOp),
					.Shamt(Instruction[10:6]),.ALUSrc(ALUSrc),.I_format(I_format),.Zero(Zero),.Jr(Jr),.Sftmd(Sftmd),.ALU_Result(ALU_Result),
					.Addr_Result(Addr_Result),.PC_plus_4(branch_base_addr));
				 
// Decoder Part
decode32 Decoder(.read_data_1(read_data_1),.read_data_2(read_data_2), .Instruction(Instruction), .mem_data(r_wdata), .ALU_result(ALU_Result), .Jal(Jal),
					.RegWrite(RegWrite), .MemtoReg(MemorIOtoReg), .RegDst(RegDST), .Sign_extend(Sign_extend), .clock(clock), 
					.reset(rst), .opcplus4(branch_base_addr));


// DataMemory Part
dmemory32 Memory(.clock(clock), .memWrite(MemWrite), .address(ALU_Result), .writeData(write_data), .readData(readData));


//test part
assign led = read_data_2[23:0];

endmodule