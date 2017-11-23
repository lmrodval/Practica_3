module RegisterFilePipelineIDEX
(
	input clk,
	input reset,
	//Control
	input [1:0] MemtoReg,
	input RegWrite,
	input BranchNE,
	input BranchEQ,	
	input MemRead,
	input MemWrite,
	//input Jump,
	//input Jr,
	input [3:0] ALUOp,
	input ALUSrc,	
	input [1:0] RegDst,
	////Datos
	input [31:0]DataInputPCValue_IDEX,
	input [31:0]DataInputReadData1_IDEX,
	input [31:0]DataInputReadData2_IDEX,
	input [31:0]DataInputSignExtended_IDEX,
	input [31:0]DataInputInstruction_wire_IDEX,
	
	//Salida
	
	//Datos
	output [31:0]DataOutputPCValue_IDEX,
	output[31:0]DataOutputReadData1_IDEX,
	output [31:0]DataOutputReadData2_IDEX,
	output [31:0]DataOutputSignExtended_IDEX,
	output [31:0]DataOutputInstruction_wire_IDEX,
	
	//Control
	output  [2:0] DataOutputWB_IDEX,
	output  [3:0] DataOutputM_IDEX,   //5:0
	output  [6:0] DataOutputEX_IDEX
	


);

/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/


PipelineWB
WB
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.MemtoReg(MemtoReg),
	.RegWrite(RegWrite),
	.DataOutputWB(DataOutputWB_IDEX)
);

PipelineM
M
(

	.clk(clk),
	.reset(reset),
	.enable(1),
	.BranchNE(BranchNE),
	.BranchEQ(BranchEQ),	
	.MemRead(MemRead),
	.MemWrite(MemWrite),
	//.Jump(Jump),
	//.Jr(Jr),
	.DataOutputM(DataOutputM_IDEX)
);

PipelineEX
EX
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.ALUOp(ALUOp),
	.ALUSrc(ALUSrc),	
	.RegDst(RegDst),
	.DataOutputEX(DataOutputEX_IDEX)
);


//*************Registros Para Datos********************************
/****************************************************************/
/****************************************************************/
/****************************************************************/


Pipeline_Register
#(
	.N(32)
)
PC_IDEX
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputPCValue_IDEX),
	.DataOutput(DataOutputPCValue_IDEX)
);

Pipeline_Register
#(
	.N(32)
)
ReadData1_IDEX
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputReadData1_IDEX),
	.DataOutput(DataOutputReadData1_IDEX)
);



Pipeline_Register
#(
	.N(32)
)
ReadData2_IDEX
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputReadData2_IDEX),
	.DataOutput(DataOutputReadData2_IDEX)
);



Pipeline_Register
#(
	.N(32)
)
SignExtended_IDEX
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputSignExtended_IDEX),
	.DataOutput(DataOutputSignExtended_IDEX)
);


Pipeline_Register
#(
	.N(32)
)
InstRegDest_IDEX
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputInstruction_wire_IDEX),
	.DataOutput(DataOutputInstruction_wire_IDEX)
);


endmodule