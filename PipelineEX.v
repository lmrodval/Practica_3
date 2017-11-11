module PipelineEX
(
	input clk,
	input reset,
	input enable,
	input [3:0] ALUOp,
	input ALUSrc,	
	input [1:0] RegDst,
	
	output  [6:0] DataOutputEX
);

Pipeline_Register
#(
	.N(4)
)
RegisterALUOp
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(ALUOp),
	.DataOutput(DataOutputEX[3:0])
);

Pipeline_Register
RegisterALUSrc
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(ALUSrc),
	.DataOutput(DataOutputEX[4])
);

Pipeline_Register
RegisterRegDst
(
	.clk(clk),																						
	.reset(reset),
	.enable(1),
	.DataInput(RegDst),
	.DataOutput(DataOutputEX[6:5])
);


endmodule