module PipelineM
(
	input clk,
	input reset,
	input enable,
	input BranchNE,
	input BranchEQ,	
	input MemRead,
	input MemWrite,
	input Jump,
	input Jr,

	
	output  [5:0] DataOutputM
);

Pipeline_Register
RegisterBNE
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(BranchNE),
	.DataOutput(DataOutputM[0])
);

Pipeline_Register
RegisterBEQ
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(BranchEQ),
	.DataOutput(DataOutputM[1])
);

Pipeline_Register
RegisterMemRead
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(MemRead),
	.DataOutput(DataOutputM[2])
);

Pipeline_Register
RegisterMemWrite
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(MemWrite),
	.DataOutput(DataOutputM[3])
);

Pipeline_Register
RegisterJump
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(Jump),
	.DataOutput(DataOutputM[4])
);

Pipeline_Register
RegisterJr
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(Jr),
	.DataOutput(DataOutputM[5])
);

endmodule