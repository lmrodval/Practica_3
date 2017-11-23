module RegisterFilePipelineMEMWB
(
	input clk,
	input reset,
	input [2:0] DataInputWB_MEMWB,
	
	input [31:0] DataInputReadData_WB,
	input [31:0] DataInputALURes,
	input [4:0] DataInputputWriteRegister,
	input [31:0] DataInputputPC2,
	
	output [31:0] DataOutputReadData_WB,
	output [31:0] DataOutputALURes,
	output [4:0] DataOutputWriteRegister,
	output [31:0] DataOutputputPC2,
	
	output  [2:0] DataOutputWB_MEMWB

	


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
	.MemtoReg(DataInputWB_MEMWB[1:0]),
	.RegWrite(DataInputWB_MEMWB[2]),
	.DataOutputWB(DataOutputWB_MEMWB)
);

Pipeline_Register
#(
	.N(32)
)
RegisterReadData
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputReadData_WB),
	.DataOutput(DataOutputReadData_WB)
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
WriteRegister
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputputWriteRegister),
	.DataOutput(DataOutputWriteRegister)
);


Pipeline_Register
#(
	.N(32)
)
PC
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(DataInputputPC2),
	.DataOutput(DataOutputputPC2)
);



endmodule