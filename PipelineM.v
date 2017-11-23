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
#(
	.N(1)
)
RegisterBNE
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(BranchNE),
	.DataOutput(DataOutputM[0])
);

Pipeline_Register
#(
	.N(1)
)
RegisterBEQ
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(BranchEQ),
	.DataOutput(DataOutputM[1])
);

Pipeline_Register
#(
	.N(1)
)
RegisterMemRead
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(MemRead),
	.DataOutput(DataOutputM[2])
);

Pipeline_Register
#(
	.N(1)
)
RegisterMemWrite
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(MemWrite),
	.DataOutput(DataOutputM[3])
);

Pipeline_Register
#(
	.N(1)
)
RegisterJump
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(Jump),
	.DataOutput(DataOutputM[4])
);

Pipeline_Register
#(
	.N(1)
)
RegisterJr
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(Jr),
	.DataOutput(DataOutputM[5])
);

endmodule