module RegisterFilePipelineIDEX
(
	input clk,
	input reset,
	input [1:0] MemtoReg,
	input RegWrite,
	input BranchNE,
	input BranchEQ,	
	input MemRead,
	input MemWrite,
	input Jump,
	input Jr,
	input [3:0] ALUOp,
	input ALUSrc,	
	input [1:0] RegDst,

	
	output  [2:0] DataOutputWB_IDEX,
	output  [5:0] DataOutputM_IDEX,
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
	.Jump(Jump),
	.Jr(Jr),
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

endmodule