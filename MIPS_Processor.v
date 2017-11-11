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
	parameter MEMORY_DEPTH = 256
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

wire [2:0] WB_IDEX;
wire [5:0] M_IDEX;
wire [6:0] EX_IDEX;

wire [2:0] WB_EXMEM;
wire [5:0] M_EXMEM;

wire [2:0] WB_MEMWB;

integer ALUStatus;


//******************************************************************/
//******************************************************************/
/*
Etapa de cada instruccion por Control Unit

	.OP(Instruction_wire[31:26]),
	.RegDst(Reg_Dst_wire),
	.BranchNE(BranchNE_wire),
	.BranchEQ(BranchEQ_wire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),
	.RegWrite(RegWrite_wire),
	.Jump(Jump_wire),
	.MemtoReg(MemtoReg_wire),
	.MemRead(MemRead_wire),
	.MemWrite(MemWrite_wire)

ID/EX:

WB:
.MemtoReg(MemtoReg_wire),
.RegWrite(RegWrite_wire),

M:
.BranchNE(BranchNE_wire),
.BranchEQ(BranchEQ_wire),
.MemRead(MemRead_wire),
.MemWrite(MemWrite_wire),
.Jump(Jump_wire),

EX:
.ALUOp(ALUOp_wire),
.ALUSrc(ALUSrc_wire),
.RegDst(Reg_Dst_wire),

***********************************************
***********************************************
EX/MEM:

WB:
.MemtoReg(MemtoReg_wire),
.RegWrite(RegWrite_wire),

M:
.BranchNE(BranchNE_wire),
.BranchEQ(BranchEQ_wire),
.MemRead(MemRead_wire),
.MemWrite(MemWrite_wire),
.Jump(Jump_wire),
.Selector(JrControl_wire),

***********************************************
***********************************************
MEM/WB:

WB:
.MemtoReg(MemtoReg_wire),
.RegWrite(RegWrite_wire),


*/
//******************************************************************/ 
//******************************************************************/
//******************************************************************/

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



//******************************************************************/
//******************************************************************/
/*																									Registro Pipeline Generico, aqui debe de ir IF/ID
Register_Pipeline
Register..
(
	.clk(clk),																						
	.reset(reset),
	.enable(),
	.DataInput(),
	.DataOutput()
);
*/


//******************************************************************/
//******************************************************************/
//******************************************************************/


 ShiftLeft2 
 ShiftLefttoJump
(   
	 .DataInput(MemtoShift),
    .DataOutput(ShiftLeft_Jump_wire1)

);



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
	.MemtoReg(MemtoReg_wire),
	.MemRead(MemRead_wire),
	.MemWrite(MemWrite_wire)
);



RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(WB_MEMWB[2]),
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




//******************************************************************/
//******************************************************************/
/*																									Registro Pipeline Generico, aqui debe de ir ID/EX
Register_Pipeline
*/

RegisterFilePipelineIDEX
IDEX
(
	.clk(clk),
	.reset(reset),
	
	//WB:
	.MemtoReg(MemtoReg_wire),
	.RegWrite(RegWrite_wire),
	
	//M:
	.BranchNE(BranchNE_wire),
	.BranchEQ(BranchEQ_wire),	
	.MemRead(MemRead_wire),
	.MemWrite(MemWrite_wire),
	.Jump(Jump_wire),
	.Jr(JrControl_wire),
	
	//EX:
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),	
	.RegDst(Reg_Dst_wire),

	.DataOutputWB_IDEX(WB_IDEX),
	.DataOutputM_IDEX(M_IDEX),
	.DataOutputEX_IDEX(EX_IDEX)
		
	);
	
	
	//******************************************************************/
	//******************************************************************/
	//******************************************************************/
	
	

Adder32bits
Add_ForBranch
(
	.Data0(Adder_to_Ader_wire),
	.Data1(ShiftLeft_Add_wire),
	
	.Result(Branch_target_address_wire)
);



 ShiftLeft2
 ShiftLefttoAdd
(   
	 .DataInput(InmmediateExtend_wire),
    .DataOutput(ShiftLeft_Add_wire)

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


Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(EX_IDEX[4]),
	.MUX_Data0(ReadData2_wire),
	.MUX_Data1(InmmediateExtend_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)
);


ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(EX_IDEX[3:0]),
	.ALUFunction(Instruction_wire[5:0]),
	
	.JRControlOut(JrControl_wire),
	.ALUOperation(ALUOperation_wire)
);


Multiplexer3to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(EX_IDEX[6:5]),
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(Instruction_wire[15:11]),
	.MUX_Data2(31),
	.MUX_Output(WriteRegister_wire)
);



//******************************************************************/
//******************************************************************/
/*																									Registro Pipeline Generico, aqui debe de ir Ex/Mem
Register_Pipeline

*/
RegisterFilePipelineEXMEM
EXMEM
(
	.clk(clk),
	.reset(reset),
	
	.DataInputWB_EXMEM(WB_IDEX),
	.DataInputM_EXMEM(M_IDEX),

	
	.DataOutputWB_EXMEM(WB_EXMEM),
	.DataOutputM_EXMEM(M_EXMEM)
	
	);
	
//******************************************************************/
//******************************************************************/
//******************************************************************/



ANDGate
BranchEQ
(
	.A(M_EXMEM[1]),
	.B(Zero_wire),
	
	.C(BranchANDEQ)
);

ANDGate
BranchNEQ
(
	.A(M_EXMEM[0]),
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
	.Selector(M_EXMEM[4]),
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
	.Selector(M_EXMEM[5]),
	.MUX_Data0(FromMuxJumptoJr_wire),
	.MUX_Data1(ReadData1_wire),
	
	.MUX_Output(PC_4_wire)

);



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
	.MemRead(M_EXMEM[2]),
	.MemWrite(M_EXMEM[3])
);


//******************************************************************/
//******************************************************************/
/*																									Registro Pipeline Generico, aqui debe de ir MEM/WB
Register_Pipeline
*/
RegisterFilePipelineMEMWB
MEMWB
(
	.clk(clk),
	.reset(reset),
	
	.DataInputWB_MEMWB(WB_EXMEM),

	.DataOutputWB_MEMWB(WB_MEMWB)
	
	);
//******************************************************************/
//******************************************************************/
//******************************************************************/



Multiplexer3to1
#(
	.NBits(32)
)
MUX_ToRegisterFile
(
	.Selector(WB_MEMWB[1:0]),
	.MUX_Data0(ALUResult_wire),
	.MUX_Data1(ReadDataRAM_wire), /// RamtoMuxToReg
	.MUX_Data2(Adder_to_Ader_wire),
	.MUX_Output(FromMuxToReg_wire)
);



assign ShiftInstMemory = {{Adder_to_Ader_wire[31:28]},{ShiftLeft_Jump_wire1}};
assign MemtoShift = {{6'b0},{Instruction_wire[25:0]}};	


endmodule