`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 20:53:06
// Design Name: 
// Module Name: IFetc32_tb
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


module IFetc32_tb(
    );
     // input
       reg[31:0]  Add_result = 32'h00000000;
       reg[31:0]  Read_data_1 = 32'h00000000;
       reg        Branch = 1'b0;
       reg        nBranch = 1'b0;
       reg        Jmp = 1'b0;
       reg        Jal = 1'b0;
       reg        Jrn = 1'b0;
       reg        Zero = 1'b0;
       reg        clock = 1'b0,reset = 1'b1;
   
       // output
       wire[31:0] Instruction;           
       wire[31:0] PC_plus_4_out;
       wire[31:0] opcplus4;
        //module IFetc32(Instruction, branch_base_addr, link_addr,clock, reset,
       //Addr_result, Read_data_1, Branch, nBranch, Jmp, Jal, Jr, Zero);   
       Ifetc32 Uifetch(Instruction,PC_plus_4_out,opcplus4,clock,reset,
       Add_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jrn,Zero
      );
   
       initial begin
           #100   reset = 1'b0;
           #100   Jal = 1;
           #100   begin Jrn = 1;Jal = 0; Read_data_1 = 32'h0000019c;end
           #100   begin Jrn = 0;Branch = 1'b1; Zero = 1'b1; Add_result = 32'h00000002;end       
           #100   begin Branch = 1'b0; Zero = 1'b0; end 
           #100  $finish;      
       end
       always #50 clock = ~clock;            
endmodule
