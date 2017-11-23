module RegisterFilePipelineEXMEM
(
	input clk,
	input reset,
	//Entradas
	//Control
	input [2:0] DataInputWB_EXMEM,
	input [5:0] DataInputM_EXMEM,
	//Datos
	input [31:0] DataInputAddRes,
	input DataInputALUZero,
	input [31:0] DataInputALURes,
	input [31:0] DataInputReadData2,
	input [4:0] DataInputMuxItypeRtype, //5bits
	
	input [31:0] DataInputMUXForBranch,
	input [31:0] DataInputMUXForJump,
	input [31:0] DataInputMUXForJR,
	
	//Salidas
	//Datos
	output [31:0]DataOutputAddRes,
	output DataOutputALUZero,
	output [31:0]DataOutputALURes,
	output[31:0]DataOutputReadData2,
	output[4:0]DataOutputMuxItypeRtype,
	
	output [31:0]DataOutputMUXForBranch,
	output [31:0]DataOutputMUXForJump,
	output [31:0]DataOutputMUXForJR,
	
	//control
	output  [2:0] DataOutputWB_EXMEM,
	output  [5:0] DataOutputM_EXMEM

	


);



/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/

//Control
PipelineWB
WB
(

	.clk(clk),
	.reset(reset),
	.enable(1),
	.MemtoReg(DataInputWB_EXMEM[1:0]),
	.RegWrite(DataInputWB_EXMEM[2]),
	.DataOutputWB(DataOutputWB_EXMEM)
);

PipelineM
M
(

	.clk(clk),
	.reset(reset),
	.enable(1),
	.BranchNE(DataInputM_EXMEM[0]),
	.BranchEQ(DataInputM_EXMEM[1]),	
	.MemRead(DataInputM_EXMEM[2]),
	.MemWrite(DataInputM_EXMEM[3]),
	//.Jump(DataInputM_EXMEM[4]),
	//.Jr(DataInputM_EXMEM[5]),
	.DataOutputM(DataOutputM_EXMEM)
);


//Datos
Pipeline_Register
#(
	.N(32)
)
RegisterInputAddRes
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputAddRes),
	.DataOutput(DataOutputAddRes)
);


Pipeline_Register
#(
	.N(2)
)
RegisterInputALUZero
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputALUZero),
	.DataOutput(DataOutputALUZero)
);


Pipeline_Register
#(
	.N(32)
)
RegisterALURes
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputALURes),
	.DataOutput(DataOutputALURes)
);


Pipeline_Register
#(
	.N(32)
)
RegisterReadData2
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputReadData2),
	.DataOutput(DataOutputReadData2)
);


Pipeline_Register
#(
	.N(32)
)
RegisterMuxItypeRtype
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputMuxItypeRtype),
	.DataOutput(DataOutputMuxItypeRtype)
);


Pipeline_Register
#(
	.N(32)
)
RegisterMuxForBranch
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputMUXForBranch),
	.DataOutput(DataOutputMUXForBranch)
);


Pipeline_Register
#(
	.N(32)
)
RegisterMuxForJump
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputMUXForJump),
	.DataOutput(DataOutputMUXForJump)
);


Pipeline_Register
#(
	.N(32)
)
RegisterMUXForJR
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputMUXForJR),
	.DataOutput(DataOutputMUXForJR)
);





endmodule