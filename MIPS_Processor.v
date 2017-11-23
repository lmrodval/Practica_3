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

wire [31:0] Instruction_wire_IFID;
wire [31:0] PC_wire_IFID;

wire [2:0] WB_IDEX;
wire [5:0] M_IDEX;
wire [6:0] EX_IDEX;

wire [2:0] WB_EXMEM;
wire [5:0] M_EXMEM;

wire [2:0] WB_MEMWB;


wire [31:0] PCValue_wire_IDEX;
wire [31:0] ReadData1_wire_IDEX;
wire [31:0] ReadData2_wire_IDEX;
wire [31:0] SignExtended_wire_IDEX;
wire [31:0] Instruction_wire_IDEX;



wire [31:0] AddRes_wire_EXMEM;
wire  ALUZero_wire_EXMEM;
wire [31:0] ALURes_wire_EXMEM;
wire [31:0] ReadData2_wire_EXMEM;
wire [4:0] MuxItypeRtype_wire_EXMEM;

wire [31:0] PCValue_wire_EXMEM;
wire [31:0] ShiftInstMemory_EXMEM;
wire [31:0] ReadData1_wire_EXMEM;

wire [31:0] ReadDataRAM_wire_WB;
wire [31:0] ALURes_wire_WB;
wire [4:0] WriteRegister_wire_WB;
wire [31:0] PCValue_wire_WB;

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
	.NewPC(BranchANDJump_wire),   //Este valor fue modificado para la tarea 7  PC_4_wire
	.PCValue(PC_wire)
);



Adder32bits
PC_Puls_4
(
	.Data0(PC_wire),
	.Data1(4),
	
	.Result(Adder_to_Ader_wire)
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



//******************************************************************/
//******************************************************************/
/*																									Registro Pipeline Generico, aqui debe de ir IF/ID
Register_Pipeline
*/
RegisterFilePipelineIFID
IFID
(
	.clk(clk),
	.reset(reset),
	.PCValue_IFID(Adder_to_Ader_wire),
	.Instruction_IFID(Instruction_wire),
	
	
	////Datos
	. DataOutputPCValue_IFID(PC_wire_IFID),
	.DataOutputInstruction_IFID(Instruction_wire_IFID)
);


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
	.OP(Instruction_wire_IFID[31:26]),
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
	.WriteRegister(WriteRegister_wire_WB),   ///Se modificará para fines de la tarea   WriteRegister_wire ??
	.ReadRegister1(Instruction_wire_IFID[25:21]),
	.ReadRegister2(Instruction_wire_IFID[20:16]),
	.WriteData(FromMuxToReg_wire), ///
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(Instruction_wire_IFID[15:0]),
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
	///.Jump(Jump_wire),  
	///.Jr(JrControl_wire),
	
	//EX:
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),	
	.RegDst(Reg_Dst_wire),
	
	//Datos
	.DataInputPCValue_IDEX(PC_wire_IFID),
	.DataInputReadData1_IDEX(ReadData1_wire),
	.DataInputReadData2_IDEX(ReadData2_wire),
	.DataInputSignExtended_IDEX(InmmediateExtend_wire),
	.DataInputInstruction_wire_IDEX(Instruction_wire_IFID),
	
	
	//salida

	//Datos
	.DataOutputPCValue_IDEX(PCValue_wire_IDEX),
	.DataOutputReadData1_IDEX(ReadData1_wire_IDEX),
	.DataOutputReadData2_IDEX(ReadData2_wire_IDEX),
	.DataOutputSignExtended_IDEX(SignExtended_wire_IDEX),
	.DataOutputInstruction_wire_IDEX(Instruction_wire_IDEX),
	
	//Control
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
	.Data0(PCValue_wire_IDEX),
	.Data1(ShiftLeft_Add_wire),
	
	.Result(Branch_target_address_wire)
);



 ShiftLeft2
 ShiftLefttoAdd
(   
	 .DataInput(SignExtended_wire_IDEX),
    .DataOutput(ShiftLeft_Add_wire)

);


ALU
ArithmeticLogicUnit 
(
	.Shamt(Instruction_wire_IDEX[10:6]),
	.ALUOperation(ALUOperation_wire),
	.A(ReadData1_wire_IDEX),
	.B(ReadData2OrInmmediate_wire),
	.Zero(Zero_wire),
	.ALUResult(ALUResult_wire)
	
);

assign ALUResultOut = ALUResult_wire;


Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(EX_IDEX[4]),
	.MUX_Data0(ReadData2_wire_IDEX),
	.MUX_Data1(InmmediateExtend_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)
);


ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(EX_IDEX[3:0]),
	.ALUFunction(SignExtended_wire_IDEX[5:0]),  //.ALUFunction(Instruction_wire[5:0])  !!??
	
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
	.MUX_Data0(Instruction_wire_IDEX[20:16]),
	.MUX_Data1(Instruction_wire_IDEX[15:11]),
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
	
	
	//Entrada
	
	//Control
	.DataInputWB_EXMEM(WB_IDEX),
	.DataInputM_EXMEM(M_IDEX),

	//Datos
	.DataInputAddRes(Branch_target_address_wire),
	.DataInputALUZero(Zero_wire),
	.DataInputALURes(ALUResult_wire),
	.DataInputReadData2(ReadData2_wire_IDEX),
	.DataInputMuxItypeRtype(WriteRegister_wire), 
	
	.DataInputMUXForBranch(PCValue_wire_IDEX),
	.DataInputMUXForJump(ShiftInstMemory),
	.DataInputMUXForJR(ReadData1_wire_IDEX),
	
	
	//Salida
	
	//Datos
	.DataOutputAddRes(AddRes_wire_EXMEM),
	.DataOutputALUZero(ALUZero_wire_EXMEM),
	.DataOutputALURes(ALURes_wire_EXMEM),
	.DataOutputReadData2(ReadData2_wire_EXMEM),
	.DataOutputMuxItypeRtype(MuxItypeRtype_wire_EXMEM),
	
	.DataOutputMUXForBranch(PCValue_wire_EXMEM),
	.DataOutputMUXForJump(ShiftInstMemory_EXMEM),
	.DataOutputMUXForJR(ReadData1_wire_EXMEM),
	
	//Control
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
	.B(ALUZero_wire_EXMEM),
	
	.C(BranchANDEQ)
);

ANDGate
BranchNEQ
(
	.A(M_EXMEM[0]),
	.B(~ALUZero_wire_EXMEM),
	
	
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
MUX_ForBranchAndJump			////Este mux fue modificado con fines de la tarea 
(
	.Selector(BranchEQandNEQ),
	.MUX_Data0(Adder_to_Ader_wire), ////////
	.MUX_Data1(AddRes_wire_EXMEM),
	
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
	.MUX_Data1(ShiftInstMemory_EXMEM), ////////
	
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
	.MUX_Data1(ReadData1_wire_EXMEM),  /////
	
	.MUX_Output(PC_4_wire)

);



RAMAddress												
RAMAdd
(								
	.RAM(ALURes_wire_EXMEM),			
	.RAMAddress(Address_RAM)
);



DataMemory
RAMDataMemory 
(
	.WriteData(ReadData2_wire_EXMEM),
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
	
	//Control
	.DataInputWB_MEMWB(WB_EXMEM),
	
	
	//Datos
	.DataInputReadData_WB(ReadDataRAM_wire),
	.DataInputALURes(ALURes_wire_EXMEM),
	.DataInputputWriteRegister(MuxItypeRtype_wire_EXMEM),
	.DataInputputPC2(PCValue_wire_EXMEM),
	
	//Salida
	.DataOutputReadData_WB(ReadDataRAM_wire_WB),
	.DataOutputALURes(ALURes_wire_WB),
	.DataOutputWriteRegister(WriteRegister_wire_WB),  
	.DataOutputputPC2 (PCValue_wire_WB),
	
	//Control
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
	.MUX_Data0(ALURes_wire_WB),
	.MUX_Data1(ReadDataRAM_wire_WB), /// RamtoMuxToReg
	.MUX_Data2(PCValue_wire_WB),
	.MUX_Output(FromMuxToReg_wire)
);



assign ShiftInstMemory = {{PC_wire_IFID[31:28]},{ShiftLeft_Jump_wire1}};
assign MemtoShift = {{6'b0},{Instruction_wire_IFID[25:0]}};	


endmodule