`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/18 15:42:41
// Design Name: 
// Module Name: cpu
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


module cpu(
input fpga_rst, //Active High
input fpga_clk, 
input[23:0] sw, 
output[23:0] led,
// UART Programmer Pinouts
// start Uart communicate at high l
input start_pg,
input rx,
output tx
    );
    
   
    wire clk;
	
	//
	 wire [1:0]control32_ALUOp;
	wire control32_ALUSrc;
	wire control32_Branch;
	wire control32_IORead;
	wire control32_IOWrite;
	wire control32_I_format;
	wire control32_Jal;
	wire control32_Jmp;
	wire control32_Jr;
	wire control32_MemRead;
	wire control32_MemWrite;
	wire control32_MemorIOtoReg;
	wire control32_RegDST;
	wire control32_RegWrite;
	wire control32_Sftmd;
	wire control32_nBranch;
	
	wire [31:0]Executs32_ALU_Result;
	wire [31:0]Executs32_Addr_Result;
	wire Executs32_Zero;
	wire [31:0]decode32_imme_extend;
	wire [31:0]decode32_read_data_1;
	wire [31:0]decode32_read_data_2;
	wire [5:0]Ifetc32_Funtion_code;
	wire [31:0]Ifetc32_Instruction;
	wire [5:0]Ifetc32_Opcode;
	wire [4:0]Ifetc32_Shamt;
	wire [31:0]Ifetc32_branch_base_addr;
	wire [31:0]Ifetc32_link_addr;
	wire MemOrIO_LEDCtrl;
	wire MemOrIO_SwitchCtrl;
	wire MemOrIO_ScanCtrl;
	wire [31:0]MemOrIO_addr_out;
	wire [31:0]MemOrIO_r_wdata;
	wire [31:0]MemOrIO_write_data;
	wire [31:0]dmemory32_read_data;
    wire [15:0]switchs_switchrdata;
    
    // UART Programmer Pinouts
    wire upg_clk, upg_clk_o;
    wire upg_wen_o; //Uart write out enable
    wire upg_done_o; //Uart rx data have done
    //data to which memory unit of program_rom/dmemory32
    wire [14:0] upg_adr_o;
    //data to program_rom or dmemory32
    wire [31:0] upg_dat_o;
    wire spg_bufg;
    BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter
    // Generate UART Programmer reset signal
    reg upg_rst;
    always @ (posedge fpga_clk) begin
    if (spg_bufg) upg_rst = 0;
    if (fpga_rst) upg_rst = 1;
    end
    //used for other modules which don't relate to UART
    wire rst;
    assign rst = fpga_rst|!upg_rst;
	
	
    cpuclk clock(.clk_in1(fpga_clk),.clk_out1(clk),.clk_out2(upg_clk));
    Ifetc32 fetch(.Addr_result(Executs32_Addr_Result),
            .Branch(control32_Branch),
            .Instruction(Ifetc32_Instruction),
            .Jal(control32_Jal),
            .Jmp(control32_Jmp),
            .Jr(control32_Jr),
            .Read_data_1(decode32_read_data_1),
            .Zero(Executs32_Zero),
            .branch_base_addr(Ifetc32_branch_base_addr),
            .clock(clk),
            .link_addr(Ifetc32_link_addr),
            .nBranch(control32_nBranch),
            .reset(rst),
            .Funtion_code(Ifetc32_Funtion_code),
            .Opcode(Ifetc32_Opcode),
            .Shamt(Ifetc32_Shamt),
            .upg_rst_i(upg_rst),
            .upg_clk_i(upg_clk_o),
            .upg_wen_i(upg_wen_o&(!upg_adr_o[14])),
            .upg_adr_i(upg_adr_o[13:0]),
            .upg_dat_i(upg_dat_o),
            .upg_done_i(upg_done_o)
            );//todo
            
    control32 con(.ALUOp(control32_ALUOp),
        .ALUSrc(control32_ALUSrc),
        .Alu_resultHigh(Executs32_ALU_Result[31:10]),
        .Branch(control32_Branch),
        .Function_opcode(Ifetc32_Funtion_code),
        .IORead(control32_IORead),
        .IOWrite(control32_IOWrite),
        .I_format(control32_I_format),
        .Jal(control32_Jal),
        .Jmp(control32_Jmp),
        .Jr(control32_Jr),
        .MemRead(control32_MemRead),
        .MemWrite(control32_MemWrite),
        .MemorIOtoReg(control32_MemorIOtoReg),
        .Opcode(Ifetc32_Opcode),
        .RegDST(control32_RegDST),
        .RegWrite(control32_RegWrite),
        .Sftmd(control32_Sftmd),
        .nBranch(control32_nBranch)
		);
	executs32 exe(
	           .ALUOp(control32_ALUOp),
            .ALUSrc(control32_ALUSrc),
            .ALU_Result(Executs32_ALU_Result),
            .Addr_Result(Executs32_Addr_Result),
            .Function_opcode(Ifetc32_Funtion_code),
            .I_format(control32_I_format),
            .Sign_extend(decode32_imme_extend),
            .Jr(control32_Jr),
            .PC_plus_4(Ifetc32_branch_base_addr),
            .Read_data_1(decode32_read_data_1),
            .Read_data_2(decode32_read_data_2),
            .Sftmd(control32_Sftmd),
            .Shamt(Ifetc32_Shamt),
            .Zero(Executs32_Zero),
            .Exe_opcode(Ifetc32_Opcode)
	);/* to do*/
	dmemory32 mem(
		.memWrite(control32_MemWrite),
        .address(MemOrIO_addr_out),
        .clock(clk),
        .readData(dmemory32_read_data),
        .writeData(MemOrIO_write_data),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o&upg_adr_o[14]),
        .upg_adr_i(upg_adr_o[13:0]),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
	);
	decode32 dec(
	       .ALU_result(Executs32_ALU_Result),
            .Instruction(Ifetc32_Instruction),
            .Jal(control32_Jal),
            .MemtoReg(control32_MemorIOtoReg),
            .RegDst(control32_RegDST),
            .RegWrite(control32_RegWrite),
            .clock(clk),
            .Sign_extend(decode32_imme_extend),
            .opcplus4(Ifetc32_link_addr),
            .mem_data(MemOrIO_r_wdata),
            .read_data_1(decode32_read_data_1),
            .read_data_2(decode32_read_data_2),
            .reset(rst)
	);//to do
	MemOrIO mio(
		.LEDCtrl(MemOrIO_LEDCtrl),
        .SwitchCtrl(MemOrIO_SwitchCtrl),
        .addr_in(Executs32_ALU_Result),
        .addr_out(MemOrIO_addr_out),
        .ioRead(control32_IORead),
        .ioWrite(control32_IOWrite),
        .io_rdata(switchs_switchrdata[15:0]),
        .mRead(control32_MemRead),
        .mWrite(control32_MemWrite),
        .m_rdata(dmemory32_read_data),
        .r_rdata(decode32_read_data_2),
        .r_wdata(MemOrIO_r_wdata),
        .write_data(MemOrIO_write_data)
		);
	switch swi(
		.switch_i(sw),
        .switchaddr(Executs32_ALU_Result[1:0]),
        .switchcs(MemOrIO_SwitchCtrl),
        .switchrdata(switchs_switchrdata),
        .switchread(control32_IORead),
        .switclk(clk),
        .switrst(rst)
	);
	led light(
		.led_clk(clk),
        .ledaddr(MemOrIO_addr_out[1:0]),
        .ledcs(MemOrIO_LEDCtrl),
        .ledout(led),
        .ledrst(rst),
        .ledwdata(decode32_read_data_2[15:0]),  
        .ledwrite(control32_IOWrite)
	);
	uart_bmpg_0 uart(
	    .upg_clk_i(upg_clk),
	    .upg_rst_i(upg_rst),
	    .upg_rx_i(rx),
	    .upg_clk_o(upg_clk_o),
	    .upg_wen_o(upg_wen_o),
	    .upg_adr_o(upg_adr_o),
	    .upg_dat_o(upg_dat_o),
	    .upg_done_o(upg_done_o),
	    .upg_tx_o(tx)
	);
	
// test Part
	
endmodule
