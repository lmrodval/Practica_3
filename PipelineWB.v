module PipelineWB
(
	input clk,
	input reset,
	input enable,
	input [1:0] MemtoReg,
	input RegWrite,
	
	
	output  [2:0] DataOutputWB
);

Pipeline_Register
#(
	.N(2)
)
RegisterMemToReg
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(MemtoReg),
	.DataOutput(DataOutputWB[1:0])
);

Pipeline_Register
RegisterRegWrite
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(RegWrite),
	.DataOutput(DataOutputWB[2])
);

endmodule