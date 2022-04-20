`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/14 13:28:24
// Design Name: 
// Module Name: Idecoder32
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
    reg [31:0] register [31:0];//32 registers from $0 to $31 
    
    reg [4:0] waddr; //address of register want to write
    reg [31:0] wdata;//data want to write into register
    
    wire [4:0] rreg_addr1;//1st reg want to read(rs)
    wire [4:0] rreg_addr2;//2nd reg want to read(rt)
    wire [4:0] wreg_addr1;//reg want to write in R-form instruction(rd) 
    wire [4:0] wreg_addr2;//reg want to writr in I-form instruction(rt)
    wire[5:0] opcode;//opcode
    wire[15:0] Iimm;//immediate in instruction
    
    assign opcode=instruction[31:26];
    assign rreg_addr1=instruction[25:21];//rs
    assign rreg_addr2=instruction[20:16];//rt
    assign wreg_addr1=instruction[15:11];//rd(R-form)
    assign wreg_addr2=instruction[20:16];//rt(I-form)
    assign Iimm=instruction[15:0];//I-form
    
    assign sign=instruction[15];
    assign sign_extend[31:0]=(opcode==6'b001100||opcode==6'b001101)?{16'b0,instruction[15:0]}:{{16{sign}},instruction[15:0]};
    //except andi and ori  otherwise extend sign
    
    assign rdata1=register[rreg_addr1];
    assign rdata2=register[rreg_addr2];
    
    //switch the reg address want to write
    always@(*) begin
     if(RegWrite == 1)begin
         if( RegDst ==1'b1 || opcode==6'b000000  )begin//R-type
                waddr = wreg_addr1;//rd
          end
          else if(opcode ==6'b000011 && Jal==1'b1)begin//jump and link
                waddr = 31; //$ra 
           end
          else begin //i-type instruction
                waddr = wreg_addr2; //rt
           end
       end
    end
    
    //switch what to write.
    always@(*) begin
        if(Jal==1'b1&& opcode==6'b000011) begin
            wdata= link_addr;
        end
        else if(MemtoReg==1'b1) begin
            wdata= ram_data;
        end
        else begin
            wdata=ALU_res;
        end
    end
    
    //write data into register
    always@(posedge clk) begin
        if(reset==1'b1) begin
        register[0]<=32'b0;
        register[1]<=32'b0;
        register[2]<=32'b0;
        register[3]<=32'b0;
        register[4]<=32'b0;
        register[5]<=32'b0;
        register[6]<=32'b0;
        register[7]<=32'b0;
        register[8]<=32'b0;
        register[9]<=32'b0;
        register[10]<=32'b0;
        register[11]<=32'b0;
        register[12]<=32'b0;
        register[13]<=32'b0;
        register[14]<=32'b0;
        register[15]<=32'b0;
        register[16]<=32'b0;
        register[17]<=32'b0;
        register[18]<=32'b0;
        register[19]<=32'b0;
        register[20]<=32'b0;
        register[21]<=32'b0;
        register[22]<=32'b0;
        register[23]<=32'b0;
        register[24]<=32'b0;
        register[25]<=32'b0;
        register[26]<=32'b0;
        register[27]<=32'b0;
        register[28]<=32'b0;
        register[29]<=32'b0;
        register[30]<=32'b0;
        register[31]<=32'b0;       
        end
        else if(RegWrite&&waddr!=5'b00000)//$0 can't be modified
            register[waddr]<=wdata;
    end
endmodule
