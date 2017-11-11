module RegisterFilePipelineEXMEM
(
	input clk,
	input reset,
	input [2:0] DataInputWB_EXMEM,
	input [5:0] DataInputM_EXMEM,


	
	output  [2:0] DataOutputWB_EXMEM,
	output  [5:0] DataOutputM_EXMEM

	


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
	.Jump(DataInputM_EXMEM[4]),
	.Jr(DataInputM_EXMEM[5]),
	.DataOutputM(DataOutputM_EXMEM)
);



endmodule