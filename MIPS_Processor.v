/******************************************************************
* Description
*	This is the top-level of a MIPS processor that can execute the next set of instructions:
*		add
*		addi
*		sub
*		ori
*		or
*		bne
*		beq
*		and
*		nor
* This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	12/06/2016
******************************************************************/


module MIPS_Processor
#(
	parameter MEMORY_DEPTH = 250
)

(
	// Inputs
	input clk,
	input reset,
	input [7:0] PortIn,
	// Output
	output [31:0] ALUResultOut,
	output [31:0] PortOut
);
//******************************************************************/
//******************************************************************/
assign  PortOut = 0;


//******************************************************************/
//******************************************************************/
// Data types to connect modules
wire BranchEQandNEQ;
wire BranchNE_wire;
wire BranchEQ_wire;
wire RegDst_wire;
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
wire ORForBranch;
wire ALUSrc_wire;
wire RegWrite_wire;
wire BranchANDNEQ;
wire BranchANDEQ;
wire Zero_wire;
wire Jump_wire;

wire JrControl_wire;
wire MemWrite_wire;
wire MemRead_wire;

wire [3:0] ALUOp_wire;

wire [1:0] MemtoReg_wire;
wire [1:0] Reg_Dst_wire;

wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;
wire [31:0] MUX_PC_wire;
wire [31:0] PC_wire;
wire [31:0] Instruction_wire;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData2_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
wire [31:0] InmmediateExtendAnded_wire;
wire [31:0] PCtoBranch_wire;
wire [27:0] ShiftLeft_Jump_wire1;
wire [31:0] ShiftLeft_Add_wire;
wire [31:0] Branch_target_address_wire;
wire [31:0] Adder_to_Ader_wire;
wire [31:0] ReadDataRAM_wire;
wire [31:0] BranchANDJump_wire;

wire [31:0] ShiftInstMemory;
wire [31:0] data1MUXJump;
wire [31:0] MemtoShift;
wire [31:0] RamtoMuxToReg;
wire [31:0] FromMuxToReg_wire;
wire [31:0] FromMuxJumptoJr_wire;
wire [31:0] Address_RAM;

integer ALUStatus;


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
ControlUnit
(
	.OP(Instruction_wire[31:26]),
	.RegDst(Reg_Dst_wire),
	.BranchNE(BranchNE_wire),
	.BranchEQ(BranchEQ_wire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),
	.RegWrite(RegWrite_wire),
	.Jump(Jump_wire),
	//Se usan para el jal
	.MemtoReg(MemtoReg_wire),
	.MemRead(MemRead_wire),
	.MemWrite(MemWrite_wire)
	
	
);

PC_Register
ProgramCounter
(
	.clk(clk),
	.reset(reset),
	.NewPC(PC_4_wire),
	.PCValue(PC_wire)
);


ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
ROMProgramMemory
(
	.Address(PC_wire),
	.Instruction(Instruction_wire)
);

Adder32bits
PC_Puls_4
(
	.Data0(PC_wire),
	.Data1(4),
	
	.Result(Adder_to_Ader_wire)
);

 ShiftLeft2 
 ShiftLefttoJump
(   
	 .DataInput(MemtoShift),
    .DataOutput(ShiftLeft_Jump_wire1)

);



//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
/*Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(RegDst_wire),
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(Instruction_wire[15:11]),
	
	.MUX_Output(WriteRegister_wire)

);*/

Multiplexer3to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(Reg_Dst_wire),
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(Instruction_wire[15:11]),
	.MUX_Data2(31),
	.MUX_Output(WriteRegister_wire)
);


RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_wire),
	.WriteRegister(WriteRegister_wire),
	.ReadRegister1(Instruction_wire[25:21]),
	.ReadRegister2(Instruction_wire[20:16]),
	.WriteData(FromMuxToReg_wire), ///
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(Instruction_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
);


Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(ALUSrc_wire),
	.MUX_Data0(ReadData2_wire),
	.MUX_Data1(InmmediateExtend_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)

);


 ShiftLeft2
 ShiftLefttoAdd
(   
	 .DataInput(InmmediateExtend_wire),
    .DataOutput(ShiftLeft_Add_wire)

);


Adder32bits
Add_ForBranch
(
	.Data0(Adder_to_Ader_wire),
	.Data1(ShiftLeft_Add_wire),
	
	.Result(Branch_target_address_wire)
);


Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForBranchAndJump
(
	.Selector(BranchEQandNEQ),
	.MUX_Data0(Adder_to_Ader_wire),
	.MUX_Data1(Branch_target_address_wire),
	
	.MUX_Output(BranchANDJump_wire)

);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForJump
(
	.Selector(Jump_wire),
	.MUX_Data0(BranchANDJump_wire),
	.MUX_Data1(ShiftInstMemory),
	
	.MUX_Output(FromMuxJumptoJr_wire)//salida al multiplexor selector de jr

);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForJr
(
	.Selector(JrControl_wire),
	.MUX_Data0(FromMuxJumptoJr_wire),
	.MUX_Data1(ReadData1_wire),
	
	.MUX_Output(PC_4_wire)

);


ANDGate
BranchEQ
(
	.A(BranchEQ_wire),
	.B(Zero_wire),
	
	.C(BranchANDEQ)
);

ANDGate
BranchNEQ
(
	.A(BranchNE_wire),
	.B(~Zero_wire),
	
	
	.C(BranchANDNEQ)
);

ORGate
ORGate
(
	.A(BranchANDEQ),
	.B(BranchANDNEQ),
	
	.C(BranchEQandNEQ)
);




ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(ALUOp_wire),
	.ALUFunction(Instruction_wire[5:0]),
	
	.JRControlOut(JrControl_wire),
	.ALUOperation(ALUOperation_wire)
);



ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(ReadData1_wire),
	.B(ReadData2OrInmmediate_wire),
	.Zero(Zero_wire),
	.ALUResult(ALUResult_wire),
	.Shamt(Instruction_wire[10:6])
);

assign ALUResultOut = ALUResult_wire;


RAMAddress												
RAMAdd
(								
	.RAM(ALUResult_wire),			
	.RAMAddress(Address_RAM)
);

DataMemory
RAMDataMemory 
(
	.WriteData(ReadData2_wire),
	.Address(Address_RAM), //??
	.clk(clk),
	.ReadData(ReadDataRAM_wire), //7:0
	.MemRead(MemRead_wire),
	.MemWrite(MemWrite_wire)
);

Multiplexer3to1
#(
	.NBits(32)
)
MUX_ToRegisterFile
(
	.Selector(MemtoReg_wire),
	.MUX_Data0(ALUResult_wire),
	.MUX_Data1(ReadDataRAM_wire), /// RamtoMuxToReg
	.MUX_Data2(Adder_to_Ader_wire),
	.MUX_Output(FromMuxToReg_wire)
);


assign ShiftInstMemory = {{Adder_to_Ader_wire[31:28]},{ShiftLeft_Jump_wire1}};
assign MemtoShift = {{6'b0},{Instruction_wire[25:0]}};	

endmodule